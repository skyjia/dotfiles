# ----- Linux -----
if [ "$(uname)" = "Linux" ]; then
  # Linux Brew
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# ----- macOS -----
if [ "$(uname)" = "Darwin" ]; then
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
fi

