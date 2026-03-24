# echo "loading .zshrc"
# echo "loading .zshrc" >> ~/dotfiles/logs/zsh.log

# Uncomment the following line to enable profile for ZSH loading.
# zmodload zsh/zprof

# Starship
# https://starship.rs/guide/#%F0%9F%9A%80-installation
eval "$(starship init zsh)"

# Additional preparation for different terminals.
case $TERM_PROGRAM in
"WarpTerminal")
   ;;
"iTerm.app")
   # Load iTerm2 Shell Integration
   iterm2_shell_integration_path="${HOME}/.iterm2_shell_integration.zsh"
   # shellcheck source=/dev/null
   test -e "${iterm2_shell_integration_path}" && source "${iterm2_shell_integration_path}"
   ;;
"vscode")
   # echo "IS VSCode"
   ;;
"waveterm")
   # echo "IS Wave terminal"
   ;;
"Apple_Terminal")
   ;;
*)
    echo "Unknown Terminal: $TERM_PROGRAM ($TERM)"
    ;;
esac

# lazygit
#   https://github.com/jesseduffield/lazygit#changing-directory-on-exit
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Change default editor to vim
export VISUAL="nvim"
export EDITOR="$VISUAL"

# ----- Network Proxy BEGIN -----
get_sys_proxy() {
    # Cache scutil --proxy output for 10 seconds to avoid frequent calls
    local now
    now=$(date +%s)
    if [[ -z "$SCUTIL_PROXY_CACHE" || -z "$SCUTIL_PROXY_CACHE_TIME" || $((now - SCUTIL_PROXY_CACHE_TIME)) -gt 10 ]]; then
        SCUTIL_PROXY_CACHE="$(scutil --proxy)"
        SCUTIL_PROXY_CACHE_TIME="$now"
    fi
    echo "$SCUTIL_PROXY_CACHE"
}

get_sys_proxy_value() {
    local key="$1"
    get_sys_proxy | awk -v k="$key" '$1 == k {print $3}'
}

get_sys_proxy_list() {
    local key="$1"
    get_sys_proxy | awk "/$key/"'{flag=1;next}/}/{flag=0}flag' | awk '{print $3}' | paste -sd ',' -
}

is_sys_proxy_enabled() {
    [[ "$(get_sys_proxy_value HTTPEnable)" == "1" ]]
}

set_proxy() {
    local http_proxy_addr https_proxy_addr socks_proxy_addr socks_proxy_port no_proxy_addr

    http_proxy_addr="http://$(get_sys_proxy_value HTTPProxy):$(get_sys_proxy_value HTTPPort)"
    https_proxy_addr="http://$(get_sys_proxy_value HTTPSProxy):$(get_sys_proxy_value HTTPSPort)"
    socks_proxy_addr="$(get_sys_proxy_value SOCKSProxy)"
    socks_proxy_port="$(get_sys_proxy_value SOCKSPort)"
    no_proxy_addr="$(get_sys_proxy_list ExceptionsList)"

    export NO_PROXY=$no_proxy_addr
    export no_proxy=$no_proxy_addr
    export HTTP_PROXY=$http_proxy_addr
    export http_proxy=$http_proxy_addr
    export HTTPS_PROXY=$https_proxy_addr
    export https_proxy=$https_proxy_addr

    if [[ -n "$socks_proxy_addr" ]]; then
        export ALL_PROXY="socks5h://$socks_proxy_addr:$socks_proxy_port"
        export all_proxy=$ALL_PROXY
    fi

    git config --global https.proxy "$https_proxy_addr"
    git config --global http.proxy "$http_proxy_addr"
}

unset_proxy() {
    unset NO_PROXY no_proxy ALL_PROXY all_proxy HTTP_PROXY http_proxy HTTPS_PROXY https_proxy
    git config --global --unset https.proxy 2>/dev/null
    git config --global --unset http.proxy 2>/dev/null
}

ensure_enable_proxy() {
    if is_sys_proxy_enabled; then
        set_proxy
    else
        echo "System proxy is not enabled."
        unset_proxy
    fi
}

toggle_proxy() {
    if [[ -z "$HTTP_PROXY" && -z "$HTTPS_PROXY" ]]; then
        echo "No proxy is currently set. Enabling system proxy."
        ensure_enable_proxy
    else
        echo "Proxy is currently set. Disabling system proxy."
        unset_proxy
    fi
}

ensure_enable_proxy

alias tp="toggle_proxy"
alias tpe="ensure_enable_proxy"
alias tpd="unset_proxy"

# ----- Network Proxy END -----

# Useful alias
[[ -r ${ZDOTDIR:-$HOME}/.zaliases ]] && source ${ZDOTDIR:-$HOME}/.zaliases

# fix too many open file issues.
ulimit -S -n 2048

# Zoxide
# https://crates.io/crates/zoxide
eval "$(zoxide init zsh)"

# thefuck
# https://github.com/nvbn/thefuck#manual-installation
eval $(thefuck --alias)

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section


# fzf (installed via Homebrew)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The following lines have been added by Docker Desktop to enable Docker LI completions.
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
compinit
# # End of Docker CLI completions

# FIXME: this is too slow.
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
# [[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# VaultWarden / BitWarden completion
# https://bitwarden.com/help/cli/#zsh-shell-completion
# eval "$(bw completion --shell zsh); compdef _bw bw;"

# Uncomment the following line to enable profile for ZSH loading.
# zprof
