# ----- Linux -----
if [ "$(uname)" = "Linux" ]; then
    # TODO
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

    # .local bin
    export PATH="$HOME/.local/bin:$PATH"

    # OPAM
    eval $(opam config env)

    # pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi
