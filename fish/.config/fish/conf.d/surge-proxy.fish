# surge-proxy.fish — System proxy integration for fish shell
#
# Reads proxy configuration from macOS System Preferences (via `scutil --proxy`)
# and applies it to:
#   - Shell environment variables (HTTP_PROXY, HTTPS_PROXY, NO_PROXY, ALL_PROXY,
#     plus lowercase forms — tools disagree on which case they read)
#   - Git's http.proxy / https.proxy config
#   - Static config files: ~/.wgetrc, ~/.Renviron, ~/.npmrc
#
# Commands (aliases defined at the bottom of this file):
#   tpe   Enable proxy: read from System Preferences, apply to shell + git.
#         Does NOT touch static config files.
#   tpd   Disable proxy: clear shell env vars + remove git config.
#   tp    Toggle proxy: flip between enabled and disabled.
#   tpu   Update static config files with current proxy address.
#         Use when the Surge port changes, or on new machine setup.
#         GUI tools like RStudio read these files directly (not shell env).

# ============================================================
# Internal: scutil cache (universal variables persist across sessions)
# ============================================================

# Cache scutil --proxy output to avoid spawning scutil on every call.
# Refreshed at most every SCUTIL_PROXY_CACHE_TTL seconds.
set -U SCUTIL_PROXY_CACHE_TTL 10

# Return cached `scutil --proxy` output; refresh if stale.
function get_sys_proxy --description 'Return scutil --proxy output, cached'
    set -l now (date +%s)
    if not set -q SCUTIL_PROXY_CACHE_TIME; or test (math "$now - $SCUTIL_PROXY_CACHE_TIME") -gt $SCUTIL_PROXY_CACHE_TTL
        set -U SCUTIL_PROXY_CACHE_VALUE (scutil --proxy | string collect -N)
        set -U SCUTIL_PROXY_CACHE_TIME $now
    end
    echo $SCUTIL_PROXY_CACHE_VALUE
end

# Read a single scalar field (e.g. HTTPProxy, HTTPPort) from cached output.
function get_sys_proxy_value --argument key --description 'Read one field from cached scutil output'
    get_sys_proxy | awk -v k=$key '$1 == k { print $3 }'
end

# Read a list field (e.g. ExceptionsList) and return as a CSV string.
# scutil formats lists as:
#     ExceptionsList : <array> {
#       0 : localhost
#       1 : *.local
#       ...
#     }
# Awk pipeline: locate the line containing $key, then emit subsequent lines
# until the closing `}`, extract column 3 (the value), join with commas.
function get_sys_proxy_list --argument key --description 'Read a list field from cached scutil output as CSV'
    get_sys_proxy | awk "/$key/"'{f=1;next}/}/{f=0}f' | awk '{print $3}' | paste -sd ',' -
end

# Return 0 (success) if the system HTTP proxy is enabled.
# Quotes the substitution so an empty result becomes "" instead of a
# missing argument (which would crash `test`).
function is_sys_proxy_enabled --description 'Return 0 if system HTTP proxy is enabled'
    set -l enabled (get_sys_proxy_value HTTPEnable)
    test "$enabled" = 1
end

# ============================================================
# Apply / clear proxy for current shell + git
# ============================================================

# Enable proxy: set shell env vars and update git config.
function set_proxy --description 'Enable proxy: set shell env vars + update git config'
    set -l http_host (get_sys_proxy_value HTTPProxy)
    set -l http_port (get_sys_proxy_value HTTPPort)
    set -l https_host (get_sys_proxy_value HTTPSProxy)
    set -l https_port (get_sys_proxy_value HTTPSPort)
    set -l socks (get_sys_proxy_value SOCKSProxy)
    set -l socks_port (get_sys_proxy_value SOCKSPort)
    set -l no_proxy (get_sys_proxy_list ExceptionsList)

    # Defensive guard: refuse to set malformed proxy (e.g. when scutil
    # reports no HTTP proxy). When called via ensure_enable_proxy, this
    # shouldn't trigger because is_sys_proxy_enabled is checked first.
    # Added to protect against direct calls to set_proxy.
    #
    # Note: we check host and port separately instead of the concatenated
    # URL because fish treats `(empty_cmd):(empty_cmd)` as an empty list,
    # not as ":".
    if test -z "$http_host" -o -z "$http_port"
        echo "Warning: HTTP proxy host/port is empty; not setting proxy env." >&2
        return 1
    end

    set -l http "$http_host:$http_port"
    set -l https "$https_host:$https_port"

    # Set both uppercase and lowercase forms. Tools disagree on which case
    # they read — e.g. curl honors HTTP_PROXY, wget reads http_proxy.
    set -gx HTTP_PROXY http://$http
    set -gx http_proxy $HTTP_PROXY
    set -gx HTTPS_PROXY http://$https
    set -gx https_proxy $HTTPS_PROXY
    set -gx NO_PROXY $no_proxy
    set -gx no_proxy $NO_PROXY

    if test -n "$socks"
        set -gx ALL_PROXY socks5h://$socks:$socks_port
        set -gx all_proxy $ALL_PROXY
    end

    # Git: only write when the value actually differs, to avoid concurrent
    # write races when multiple fish sessions start up simultaneously.
    set -l cur_http (git config --global http.proxy 2>/dev/null)
    set -l cur_https (git config --global https.proxy 2>/dev/null)
    test "$cur_http" != "$HTTP_PROXY"; and git config --global http.proxy $HTTP_PROXY 2>/dev/null
    test "$cur_https" != "$HTTPS_PROXY"; and git config --global https.proxy $HTTPS_PROXY 2>/dev/null
end

# Disable proxy: clear shell env vars and remove git config.
function unset_proxy --description 'Disable proxy: clear shell env vars + remove git config'
    set -e HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy ALL_PROXY all_proxy
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null
end

# ============================================================
# Orchestration: auto-enable at startup, toggle on demand
# ============================================================

# If system proxy is enabled, apply it; otherwise clear any stale state
# (e.g. from a previous session where proxy was on but is now off).
function ensure_enable_proxy --description 'Apply system proxy if enabled; otherwise clear stale state'
    if is_sys_proxy_enabled
        set_proxy
    else
        echo "System proxy is not enabled."
        unset_proxy
    end
end

# Flip proxy state: enable if off, disable if on.
function toggle_proxy --description 'Flip proxy: enable if off, disable if on'
    if not set -q HTTP_PROXY; and not set -q HTTPS_PROXY
        echo "No proxy is currently set. Enabling system proxy."
        ensure_enable_proxy
    else
        echo "Proxy is currently set. Disabling system proxy."
        unset_proxy
    end
end

# ============================================================
# Static config sync (low-frequency): rewrite proxy in dotfiles
# ============================================================

# Internal helper: replace a `key=...` line in $file with `key=$value`,
# or append the line if the key doesn't yet exist. Used by
# update_proxy_config to keep each per-tool section short.
function _update_config_line --argument file key value
    if grep -q "^$key=" "$file"
        sed -i '' "s|^$key=.*|$key=$value|" "$file"
    else
        echo "$key=$value" >>"$file"
    end
end

# Sync proxy address in static config files (wget, R, npm, git).
#
# Complements tpe/tpd (which only touch shell env + git). GUI tools like
# RStudio read these config files directly — they don't see shell env vars.
# Run this when the proxy address/port changes, or when setting up a new
# machine.
#
# Target files are stow symlinks into ~/dotfiles. Resolved via `realpath`
# because `sed -i` refuses to edit symlinks in place.
function update_proxy_config --description 'Sync static proxy config files with current system proxy'
    if not is_sys_proxy_enabled
        echo "Error: System proxy is not enabled in macOS System Settings." >&2
        echo "Enable it first, then re-run this function." >&2
        return 1
    end

    set -l http_host (get_sys_proxy_value HTTPProxy)
    set -l http_port (get_sys_proxy_value HTTPPort)
    set -l https_host (get_sys_proxy_value HTTPSProxy)
    set -l https_port (get_sys_proxy_value HTTPSPort)

    if test -z "$http_host" -o -z "$http_port"
        echo "Error: Could not read HTTP proxy host/port from scutil." >&2
        return 1
    end

    # Each tool expects a different URL format.
    set -l http_bare $http_host:$http_port           # wget
    set -l http_url http://$http_host:$http_port     # R, npm, git
    set -l https_bare $https_host:$https_port
    set -l https_url http://$https_host:$https_port

    echo "Updating static proxy config to:"
    echo "  HTTP:  $http_url"
    echo "  HTTPS: $https_url"
    echo ""

    # Resolve stow symlinks to the real paths under ~/dotfiles.
    set -l wgetrc (realpath ~/.wgetrc 2>/dev/null)
    set -l renviron (realpath ~/.Renviron 2>/dev/null)
    set -l npmrc (realpath ~/.npmrc 2>/dev/null)

    # git — `git config` works through symlinks, no realpath needed.
    if command -qs git
        git config --global http.proxy $http_url
        git config --global https.proxy $https_url
        echo "  ✓ ~/.gitconfig"
    else
        echo "  ⚠ git not found; skipping"
    end

    # wget — HOST:PORT, no scheme.
    if test -n "$wgetrc" -a -f "$wgetrc"
        _update_config_line $wgetrc http_proxy $http_bare
        _update_config_line $wgetrc https_proxy $https_bare
        echo "  ✓ ~/.wgetrc"
    else
        echo "  ⚠ ~/.wgetrc not found; skipping"
    end

    # R — http://HOST:PORT.
    if test -n "$renviron" -a -f "$renviron"
        _update_config_line $renviron http_proxy $http_url
        _update_config_line $renviron https_proxy $https_url
        echo "  ✓ ~/.Renviron"
    else
        echo "  ⚠ ~/.Renviron not found; skipping"
    end

    # npm — http://HOST:PORT.
    if test -n "$npmrc" -a -f "$npmrc"
        _update_config_line $npmrc proxy $http_url
        _update_config_line $npmrc https-proxy $https_url
        echo "  ✓ ~/.npmrc"
    else
        echo "  ⚠ ~/.npmrc not found; skipping"
    end

    echo ""
    echo "Done. Run 'tpe' to enable proxy in the current shell session."
    echo "Review changes with 'git diff' in ~/dotfiles and commit when ready."
end

# ============================================================
# Startup + aliases
# ============================================================

# Apply current system proxy state at shell startup.
ensure_enable_proxy

alias tp 'toggle_proxy'
alias tpe 'ensure_enable_proxy'
alias tpd 'unset_proxy'
alias tpu 'update_proxy_config'
