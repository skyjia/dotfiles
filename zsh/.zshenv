export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export ZSH=/Users/skyjia/.oh-my-zsh

# Homebrew - bin PATH
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Golang
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# rbenv
eval "$(rbenv init -)"
