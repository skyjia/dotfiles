# echo "loading .zshrc"
# echo "loading .zshrc" >> ~/dotfiles/logs/zsh.log

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
    kubectl
    tmux
    vscode 
    vi-mode
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

# Add color support for 'less' command
if [ -f ~/.LESS_TERMCAP ]; then
    # shellcheck disable=SC1090
    source ~/.LESS_TERMCAP
fi

# Change default editor to vim
export VISUAL="nvim"
export EDITOR="$VISUAL"

# ----- Network Proxy BEGIN -----

get_sys_http_proxy() {
    local HTTP_PROXY_ADDR
    HTTP_PROXY_ADDR=$(scutil --proxy | grep "HTTPProxy" | awk '{print $3}')
    local HTTP_PROXY_PORT
    HTTP_PROXY_PORT=$(scutil --proxy | grep "HTTPPort" | awk '{print $3}')

    echo "http://$HTTP_PROXY_ADDR:$HTTP_PROXY_PORT"
}

get_sys_secure_http_proxy() {
    local HTTP_PROXY_ADDR
    HTTP_PROXY_ADDR=$(scutil --proxy | grep "HTTPSProxy" | awk '{print $3}')
    local HTTP_PROXY_PORT
    HTTP_PROXY_PORT=$(scutil --proxy | grep "HTTPSPort" | awk '{print $3}')

    echo "http://$HTTP_PROXY_ADDR:$HTTP_PROXY_PORT"
}

get_sys_sock_proxy() {
    local SOCKS_PROXY_ADDR
    SOCKS_PROXY_ADDR=$(scutil --proxy | grep "SOCKSProxy" | awk '{print $3}')
    local SOCKS_PROXY_PORT
    SOCKS_PROXY_PORT=$(scutil --proxy | grep "SOCKSPort" | awk '{print $3}')

    if [[ -z "$SOCKS_PROXY_ADDR" ]]; then
        return
    fi

    echo "socks5h://$SOCKS_PROXY_ADDR:$SOCKS_PROXY_PORT"
}

get_sys_bypass_proxy() {
    local BYPASS_PROXY_ADDR
    BYPASS_PROXY_ADDR=$(scutil --proxy | awk '/ExceptionsList/{flag=1;next}/}/{flag=0}flag' | awk '{print $3}' | paste -sd ',' -)
    echo "$BYPASS_PROXY_ADDR"
}

is_sys_proxy_enabled() {
    # check if system proxy is enabled
    local HTTP_ENABLED
    HTTP_ENABLED=$(scutil --proxy | grep "HTTPEnable" | awk '{print $3}')
    if [ "$HTTP_ENABLED" != "1" ]; then
        echo "No"
        return
    fi
    echo "Yes"
}

enable_proxy() {
    # check if system proxy is enabled
    local sys_proxy_enabled
    sys_proxy_enabled=$(is_sys_proxy_enabled)
    if [ "$sys_proxy_enabled" != "Yes" ]; then
        echo "System proxy is not enabled."
        return
    fi
    
    # get system proxy settings
    local HTTP_PROXY_ADDR
    HTTP_PROXY_ADDR=$(get_sys_http_proxy)
    local HTTPS_PROXY_ADDR
    HTTPS_PROXY_ADDR=$(get_sys_secure_http_proxy)
    # local SOCKS_PROXY_ADDR
    SOCKS_PROXY_ADDR=$(get_sys_sock_proxy)
    local NO_PROXY_ADDR
    NO_PROXY_ADDR=$(get_sys_bypass_proxy)

    # export network proxy related environment variables
    export NO_PROXY=$NO_PROXY_ADDR
    export no_proxy=${NO_PROXY}
    export HTTP_PROXY=$HTTP_PROXY_ADDR
    export http_proxy=${HTTP_PROXY}
    export HTTPS_PROXY=$HTTPS_PROXY_ADDR
    export https_proxy=${HTTPS_PROXY}
        
    # ALL_PROXY via SOCKS proxy
    if [[ -n "$SOCKS_PROXY_ADDR" ]]; then
        export ALL_PROXY=$SOCKS_PROXY_ADDR
        export all_proxy=${ALL_PROXY}
    fi

    # ALL_PROXY via HTTP proxy
    # if [[ -n "$HTTP_PROXY_ADDR" ]]; then
    #     export ALL_PROXY=$HTTP_PROXY_ADDR
    #     export all_proxy=${ALL_PROXY}
    # fi
    #
    # set global git-conifg. Check before setting to avoid git-config lock.
    # https.proxy
    if [ "${HTTPS_PROXY_ADDR}" != "$(git config --global --get https.proxy)" ]; then
        git config --global https.proxy "${HTTPS_PROXY_ADDR}"
    fi
    # http.proxy
    if [ "${HTTP_PROXY_ADDR}" != "$(git config --global --get http.proxy)" ]; then
        git config --global http.proxy "${HTTP_PROXY_ADDR}"
    fi

    # echo "Enabled network proxy at ${HTTP_PROXY_ADDR}"
}

disable_proxy() {
    # unset network proxy related environment variables
    unset NO_PROXY
    unset no_proxy
    unset ALL_PROXY
    unset all_proxy
    unset HTTP_PROXY
    unset http_proxy
    unset HTTPS_PROXY
    unset https_proxy
    
    # unset global git-config
    git config --global --unset https.proxy
    git config --global --unset http.proxy

    # echo "Disabled network proxy."
}

toggle_proxy() {
    local sys_proxy_enabled
    sys_proxy_enabled=$(is_sys_proxy_enabled)

    if [ "$sys_proxy_enabled" != "Yes" ]; then
        disable_proxy
    else
        enable_proxy
    fi
}

# Default to enable proxy for new shell
proxy_enabled=$(is_sys_proxy_enabled)
if [ "$proxy_enabled" = "Yes" ]; then
    enable_proxy
else
    disable_proxy
fi

alias tp="toggle_proxy"
alias tpe="enable_proxy"
alias tpd="disable_proxy"

# ----- Network Proxy END -----

# Useful alias
[[ -r ${ZDOTDIR:-$HOME}/.zaliases ]] && source ${ZDOTDIR:-$HOME}/.zaliases

# fix too many open file issues.
ulimit -S -n 2048

# fzf (installed via Homebrew)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# thefuck
# https://github.com/nvbn/thefuck#manual-installation
eval $(thefuck --alias)

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
# [[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# mojo
# https://docs.modular.com/magic#enable-auto-completion
# eval "$(magic completion --shell zsh)"

# VaultWarden / BitWarden completion
# https://bitwarden.com/help/cli/#zsh-shell-completion
# eval "$(bw completion --shell zsh); compdef _bw bw;"
