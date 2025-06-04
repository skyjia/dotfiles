# echo "loading .shared-env.zsh"
# echo "loading .shared-env.zsh" >> ~/dotfiles/logs/zsh.log

# Language locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# make Homebrew use brewed curl
# https://github.com/orgs/Homebrew/discussions/1752
export HOMEBREW_FORCE_BREWED_CURL=1

# shellcheck disable=SC1091
. "$HOME/.cargo/env"

# Golang
export GOPATH=$HOME/Codes/go
export PATH="$GOPATH/bin:$PATH"

# dotnet
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"

# openjdk
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# For compilers to find openjdk you may need to set:
#   export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# asdf
#   https://github.com/halcyon/asdf-java
# shellcheck disable=SC1090
. ~/.asdf/plugins/java/set-java-home.zsh

# Export local npm bin
export PATH=./node_modules/.bin:$PATH

# OpenSSL 3.0
#   $ brew info openssl
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include $CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"

# curl (via Homebrew)
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# PostgreSQL 15
#   $ brew info postgresql@15
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Script Kit
export PATH="$PATH:$HOME/.kit/bin"
export PATH="$PATH:$HOME/.kenv/bin"

# Android SDK Home
# https://developer.android.com/tools
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Flutter bin
# fvm default flutter version. (stable)
export PATH="$PATH:$HOME/fvm/default/bin"
# aliases: https://fvm.app/docs/guides/running_flutter
alias fvm-flutter="fvm flutter"
alias fvm-dart="fvm dart"

# cocoapods
# https://guides.cocoapods.org/using/getting-started.html#sudo-less-installation
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Rust
# https://rsproxy.cn/
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# mojo
# https://docs.modular.com/mojo/manual/get-started/#install-mojo
export PATH="$PATH:$HOME/.modular/bin"

# add ~/.emacs.d/bin to PATH
# https://github.com/doomemacs/doomemacs#install
export PATH="$HOME/.emacs.d/bin:$PATH"

# Export HOME local bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
