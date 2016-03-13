
# Configuration for GNU Emacs
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias emacs-debug='emacs --debug-init'
alias emacsdaemon='emacs --daemon'
alias emd='emacsdaemon'
#alias emacsdaemon-stop="emacsclient -e '(kill-emacs)'"
alias em='emacsclient --no-wait'
alias emn='emacsclient -c --no-wait'
export EDITOR="emacsclient -c"

# Add color support for 'less' command
if [ -f ~/.LESS_TERMCAP ] ; then
  source ~/.LESS_TERMCAP
fi

alias cat="ccat"
alias vi="vim"
alias lla="ll -a"
alias rm='rm -i'

eval `opam config env`
if [ -d "$HOME/.opam/opam-init/init.zsh" ];then
  $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

