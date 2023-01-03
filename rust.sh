#!/usr/bin/env bash
set -eo pipefail

function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

info "🍭 [1/3] Keeping rustup up to date"
rustup self update
echo

info "🍭 [2/3] Keeping rust up to date"
rustup update
echo

info "🍭 [3/3] Keeping rust packages to date"
# https://github.com/nabijaczleweli/cargo-update
cargo install-update -a
echo

