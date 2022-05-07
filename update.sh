#!/usr/bin/env bash
set -eo pipefail

function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

info "🍭 [1/5] Pulling latest changes"
git pull
echo

info "🍭 [2/5] pull all changes for the submodules"
git submodule update --remote
echo

info "🍭 [3/5] Updating zsh"
git -C $ZSH pull
echo

info "🍭 [4/5] Updating powerlevel10k"
ZSH_CUSTOM=${ZSH}/custom
git -C "${ZSH_CUSTOM}/themes/powerlevel10k" pull
echo

info "🍭 [5/5] Updating asdf plugin repositories"
asdf plugin update --all

# info "🍭 [5/5] Updating SpaceVim"
# git -C "${HOME}/.SpaceVim" pull
