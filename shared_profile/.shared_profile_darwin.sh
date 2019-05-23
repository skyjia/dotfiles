# Change default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"
alias vim="nvim"

# Proxy on Shadowsocks
alias setproxy="ALL_PROXY=socks5://127.0.0.1:1086 http_proxy=http://127.0.0.1:1087 https_proxy=http://127.0.0.1:1087"
alias unsetproxy="unset ALL_PROXY && unset http_proxy && unset https_proxy"
alias gitproxy="git config --global http.proxy http://127.0.0.1:1087"
alias unsetgitproxy="git config --global --unset http.proxy"
alias myip="curl -i http://ip.cn"
# GOPROXY 
#   https://github.com/goproxy/goproxy.cn
#export GOPROXY=https://goproxy.cn

# Configuration for GNU Emacs
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias emacs-debug='emacs --debug-init'
alias emacsdaemon='emacs --daemon'
alias emd='emacsdaemon'
#alias emacsdaemon-stop="emacsclient -e '(kill-emacs)'"
alias em='emacsclient --no-wait'
alias emn='emacsclient -c --no-wait'

# Useful alias
alias tasks='grep --exclude-dir=.git -rEI "TODO:|FIXME:" . 2>/dev/null'

# Export LaTex tools
#  http://tex.stackexchange.com/questions/249966/install-latex-on-mac-os-x-el-capitan-10-11
export PATH=$PATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin

# Export local npm bin
export PATH=./node_modules/.bin:$PATH

# Qt (installed via Homebrew)
export PATH=/usr/local/opt/qt/bin:$PATH

# Android SDK path
#   https://spring.io/guides/gs/android/
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# use the assemblies from other formulae
export MONO_GAC_PREFIX="/usr/local"

# pyenv and pyenv-virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Configure gtags for SpaceVim
# https://spacevim.org/layers/tags/
export GTAGSLABEL=pygments

if [ -d "$HOME/.opam/opam-init/init.zsh" ];then
  $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

# OpenSSL 1.1
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# Lua - LuaRocks
#  https://github.com/mpeterv/luacheck
eval `luarocks path`

