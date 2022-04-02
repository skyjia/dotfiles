#!/usr/bin/env bash
set -eo pipefail

function info() {
    local LIGHT_GREEN='\033[1;32m'
    local NC='\033[0m' # No Color

    printf "${LIGHT_GREEN}$1${NC}\n"
}

CUR=$(dirname "$0")
cd "${CUR}"

info "🍭 [1/2] Keeping rustup up to date"
rustup self update
echo

info "🍭 [2/2] Keeping rust up to date"
rustup update
echo

