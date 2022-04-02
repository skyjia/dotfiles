# Language locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Export HOME local bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH=$HOME/Codes/go

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Add color support for 'less' command
if [ -f ~/.LESS_TERMCAP ]; then
    source ~/.LESS_TERMCAP
fi

# Change default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"
alias vim="lvim"
alias vi="vim"

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
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# useful alias
alias lla='ll -a'
alias rm='rm -i'

if [ -f ~/.zprofile_secure.sh ]; then
    source ~/.zprofile_secure.sh
fi
