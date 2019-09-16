# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/

# Config POWERLEVEL9K theme
#
POWERLEVEL9K_MODE='awesome-fontconfig'
DEFAULT_USER='skyjia'
# Customise the Powerlevel9k prompts
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  vi_mode
  context
  dir_writable
  dir
  vcs
  ip
  # proxy_check
  proxy
  newline
  status
  root_indicator
  background_jobs
)
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# proxy_check
# prompt_proxy_check() {
#     if [[ -n $http_proxy ]]; then
#         p10k segment -b cyan2 -f black -i $'\ue78c' -t "$http_proxy"
#     fi
# }
POWERLEVEL9K_PROXY_BACKGROUND='magenta'
POWERLEVEL9K_PROXY_FOREGROUND='black'

# Vi-Mode
KEYTIMEOUT=1
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='darkcyan'
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='black'
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='magenta'
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='black'
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-completions git gitfast git-flow-avh git-extras osx encode64 docker kubectl tmux vscode vi-mode)
autoload -U compinit && compinit

# User configuration

# 
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Load $HOME/.shared_profile if exists
if [ -f ~/.shared_profile.sh ]; then
    source ~/.shared_profile.sh
fi

# Fix shell layer error in Spacemacs
#   https://github.com/syl20bnr/spacemacs/issues/3035
# if [ -n "$INSIDE_EMACS" ]; then
#     export EDITOR=emacsclient
#     unset zle_bracketed_paste  # This line
# fi

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/opt/qt/bin:$PATH"
