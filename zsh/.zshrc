# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME=""

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

#### Warp Terminal Known Issues
####     https://docs.warp.dev/help/known-issues
if [[ $TERM_PROGRAM != "WarpTerminal2" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

    # iTerm2 Shell Integration
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# fzf (installed via Homebrew)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Export PATH for anaconda installed via Homebrew
# export PATH="/opt/homebrew/anaconda3/bin:$PATH"  # commented out by conda initialize

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

# The Fuck
#   https://github.com/nvbn/thefuck#installation
eval "$(thefuck --alias)"

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

# Language locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Export HOME local bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH=$HOME/Codes/go
export PATH="$GOPATH/bin:$PATH"

# dotnet
export DOTNET_ROOT="/usr/local/share/dotnet"
export PATH="$DOTNET_ROOT:$PATH"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# openjdk
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# For compilers to find openjdk you may need to set:
#   export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# asdf
#   https://github.com/halcyon/asdf-java
# shellcheck disable=SC1090
. ~/.asdf/plugins/java/set-java-home.zsh

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Add color support for 'less' command
if [ -f ~/.LESS_TERMCAP ]; then
    # shellcheck disable=SC1090
    source ~/.LESS_TERMCAP
fi

# Change default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"
alias vim="lvim"
alias vi="lvim"
alias v="lvim"

# add ~/.emacs.d/bin to PATH
# https://github.com/doomemacs/doomemacs#install
export PATH="$HOME/.emacs.d/bin:$PATH"

# Proxy on Shadowsocks
export SS_HTTP_PROXY="http://127.0.0.1:6152"
export SS_SOCKS_PROXY="socks5://127.0.0.1:6153"
export NO_PROXY=localhost,127.0.0.1

alias setproxy='export ALL_PROXY=$SS_SOCKS_PROXY; export http_proxy=$SS_HTTP_PROXY; export https_proxy=$SS_HTTP_PROXY'
alias unsetproxy='unset ALL_PROXY && unset http_proxy && unset https_proxy'

toggle_proxy() {
    if [ -z ${http_proxy+x} ]; then
        setproxy
        echo "Enabled SS proxy at ${SS_HTTP_PROXY}"
    else
        unsetproxy
        echo "Disabled SS proxy."
    fi
}
alias tp="toggle_proxy"
# Default to enable proxy for new shell
setproxy

# Obsidian alias
alias obs='open -a /Applications/Obsidian.app'

# Export local npm bin
export PATH=./node_modules/.bin:$PATH

# OpenSSL 3.0
#   $ brew info openssl
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include $CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"

# PostgreSQL 15
#   $ brew info postgresql@15
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Useful alias
[ -f "$HOME/useful-alias.zsh" ] && source "$HOME/useful-alias.zsh"


