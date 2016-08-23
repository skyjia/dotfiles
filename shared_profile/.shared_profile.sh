# Language locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Configuration for GNU Emacs
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias emacs-debug='emacs --debug-init'
alias emacsdaemon='emacs --daemon'
alias emd='emacsdaemon'
#alias emacsdaemon-stop="emacsclient -e '(kill-emacs)'"
alias em='emacsclient --no-wait'
alias emn='emacsclient -c --no-wait'
export EDITOR="emacsclient -c"

# Docker Quick Start
#   Ref: https://github.com/docker/toolbox/issues/81#issuecomment-135588012
alias docker-init="source /Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh"

# use the assemblies from other formulae
export MONO_GAC_PREFIX="/usr/local"

# Add color support for 'less' command
if [ -f ~/.LESS_TERMCAP ] ; then
  source ~/.LESS_TERMCAP
fi

# Hub command
# https://github.com/github/hub#aliasing
eval "$(hub alias -s)"

alias cat="ccat"
alias vi="vim"
alias lla="ll -a"
alias rm='rm -i'

if [ -d "$HOME/.opam/opam-init/init.zsh" ];then
  $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

