export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Homebrew - bin PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"
