#!/usr/bin/env bash
set -eo pipefail


function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

info "🍭 [1/6] Pulling latest changes"
git pull
echo

info "🍭 [2/6] Synchronising submodules urls"
git submodule sync
echo

info "🍭 [3/6] Updating the submodules"
git submodule update --init
git submodule update --recursive
echo

info "🍭 [4/6] Updating zsh"
git -C $ZSH pull
echo

info "🍭 [5/6] Updating powerlevel10k"
ZSH_CUSTOM=${ZSH}/custom
git -C "${ZSH_CUSTOM}/themes/powerlevel10k" pull
echo

info "🍭 [6/6] Updating SpaceVim"
git -C "${HOME}/.SpaceVim" pull
