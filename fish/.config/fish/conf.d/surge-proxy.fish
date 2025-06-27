# ----- Network Proxy BEGIN -----

function get_sys_proxy --description 'Cache scutil --proxy output for 10 seconds'
    set -l now (date +%s)
    if not set -q SCUTIL_PROXY_CACHE_TIME; or test (math "$now - $SCUTIL_PROXY_CACHE_TIME") -gt 10
        set -g SCUTIL_PROXY_CACHE (scutil --proxy | string collect -N)
        set -g SCUTIL_PROXY_CACHE_TIME $now
    end
    echo $SCUTIL_PROXY_CACHE
end

function get_sys_proxy_value --argument key
    get_sys_proxy | awk -v k="$key" '$1 == k {print $3}'
end

function get_sys_proxy_list --argument key
    get_sys_proxy | awk "/$key/"'{flag=1;next}/}/{flag=0}flag' | awk '{print $3}' | paste -sd ',' -
end

function is_sys_proxy_enabled
    test (get_sys_proxy_value HTTPEnable) = 1
end

function set_proxy
    set -l http (get_sys_proxy_value HTTPProxy):(get_sys_proxy_value HTTPPort)
    set -l https (get_sys_proxy_value HTTPSProxy):(get_sys_proxy_value HTTPSPort)
    set -l socks (get_sys_proxy_value SOCKSProxy)
    set -l socks_port (get_sys_proxy_value SOCKSPort)
    set -l no_proxy (get_sys_proxy_list ExceptionsList)

    set -gx HTTP_PROXY http://$http
    set -gx HTTPS_PROXY http://$https
    set -gx NO_PROXY $no_proxy
    set -gx http_proxy $HTTP_PROXY
    set -gx https_proxy $HTTPS_PROXY
    set -gx no_proxy $NO_PROXY

    if test -n "$socks"
        set -gx ALL_PROXY socks5h://$socks:$socks_port
        set -gx all_proxy $ALL_PROXY
    end

    git config --global http.proxy $HTTP_PROXY
    git config --global https.proxy $HTTPS_PROXY
end

function unset_proxy
    set -e HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy ALL_PROXY all_proxy
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null
end

function ensure_enable_proxy
    if is_sys_proxy_enabled
        set_proxy
    else
        echo "System proxy is not enabled."
        unset_proxy
    end
end

function toggle_proxy
    if not set -q HTTP_PROXY; and not set -q HTTPS_PROXY
        echo "No proxy is currently set. Enabling system proxy."
        ensure_enable_proxy
    else
        echo "Proxy is currently set. Disabling system proxy."
        unset_proxy
    end
end

ensure_enable_proxy

alias tp="toggle_proxy"
alias tpe="ensure_enable_proxy"
alias tpd="unset_proxy"

# ----- Network Proxy END -----
