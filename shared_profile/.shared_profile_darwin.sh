# Proxy on Shadowsocks
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1086"
alias onceproxy="ALL_PROXY=socks5://127.0.0.1:1086"
alias httpproxy="http_proxy=http://127.0.0.1:1087 https_proxy=http://127.0.0.1:1087"
alias unsetproxy="unset ALL_PROXY"
alias myip="curl -i http://ip.cn"

# Configuration for GNU Emacs
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias emacs-debug='emacs --debug-init'
alias emacsdaemon='emacs --daemon'
alias emd='emacsdaemon'
#alias emacsdaemon-stop="emacsclient -e '(kill-emacs)'"
alias em='emacsclient --no-wait'
alias emn='emacsclient -c --no-wait'
export EDITOR="emacsclient -c"

# Export LaTex tools
#  http://tex.stackexchange.com/questions/249966/install-latex-on-mac-os-x-el-capitan-10-11
export PATH=$PATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin

# Export local npm bin
export PATH=./node_modules/.bin:$PATH

# Qt (installed via Homebrew)
export PATH=/usr/local/opt/qt/bin:$PATH

# use the assemblies from other formulae
export MONO_GAC_PREFIX="/usr/local"

if [ -d "$HOME/.opam/opam-init/init.zsh" ];then
  $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi
