#!/usr/bin/env bash
set -eo pipefail

function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

brew update
brew upgrade
echo

# using homebrew-cask-upgrade to upgrade all casks
# https://github.com/buo/homebrew-cask-upgrade
info "Checking brew casks..."
brew cu --all --yes

info "Cleaning-up Homebrew..."
brew cleanup --prune=2

