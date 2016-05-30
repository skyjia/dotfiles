export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Homebrew - bin PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# Golang
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$GOROOT/bin

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Home bin
export PATH=$HOME/bin:$PATH

# OPAM
eval `opam config env`

