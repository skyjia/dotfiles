#!/usr/bin/env bash
set -eo pipefail

function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

brew upgrade
echo

# You Should Use
# https://github.com/MichaelAquilina/zsh-you-should-use
info "Installing You-Should-Use"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM}/plugins/you-should-use
