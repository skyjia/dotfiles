# Language locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# The Fuck
#   https://github.com/nvbn/thefuck#installation
eval "$(thefuck --alias)"

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

if [ "$(uname)" = "Darwin" ]; then
    source ~/.shared_profile_darwin.sh
fi

if [ "$(uname)" = "Linux" ]; then
    source ~/.shared_profile_linux.sh
fi
