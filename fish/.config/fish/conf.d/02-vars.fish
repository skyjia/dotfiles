# Environment variables for fish shell
# loaded very before any other config files

# Language locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Golang
set -gx GOPATH $HOME/Codes/go

# Dotnet
set -gx DOTNET_ROOT $HOME/.dotnet

# GPG
set -gx GPG_TTY (tty)

# Change default editor to nvim
set -gx VISUAL nvim
set -gx EDITOR $VISUAL
