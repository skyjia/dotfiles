# echo "loading .zshrc"
# echo "loading .zshrc" >> ~/dotfiles/logs/zsh.log

# Uncomment the following line to enable profile for ZSH loading.
# zmodload zsh/zprof

# TODO: use oh-my-zsh alternative instead.
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    asdf
    you-should-use
    zsh-autosuggestions
    command-not-found
    encode64
    extract
    direnv
    docker
    # kubectl
    tmux
    vscode 
    # vi-mode
    git
    fzf
    )

source $ZSH/oh-my-zsh.sh

# User configuration

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

# TODO: already use oh-my-zsh fzf plugin instead. disable following lines.
# fzf (installed via Homebrew)
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TODO: already use oh-my-zsh docker plugin instead. disable following lines.
# # The following lines have been added by Docker Desktop to enable Docker CLI completions.
# fpath=(~/.docker/completions $fpath)
# autoload -Uz compinit
# compinit
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
