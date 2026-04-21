#!/usr/bin/env just --justfile
# https://just.systems/

set shell := ['fish', '-c']
set dotenv-load := true

default:
    @just --list

all: update-dotfiles update-brew update-shells update-apps update-editors update-dev update-ai

update-dotfiles: pull-latest update-submodules

update-shells: update-fish

update-editors: update-nvim update-vscode update-yazi

update-dev: update-r-packages update-conda update-asdf update-rust

update-ai: update-claude update-dws

wash-macos-provenance:
    # Wash macOS provenance
    xattr -d com.apple.quarantine -r .
    xattr -d com.apple.provenance -r .

pull-latest:
    # Pulling latest changes
    git pull
    @echo

update-submodules:
    # Pull all changes for the submodules
    git submodule update --remote
    @echo

update-fish:
    # Updating fish plugins
    fisher update
    fish_update_completions
    @echo

update-asdf:
    # Updating asdf plugin repositories
    asdf plugin update --all
    {{ justfile_directory() }}/asdf/check-tools-version.nu
    @echo

update-r-packages:
    # Updating R packages
    Rscript -e 'update.packages(ask = FALSE)'
    @echo

update-conda:
    # update Anaconda
    # Update the conda package manager to the latest version in your base environment
    -conda update -y -n base conda
    -conda update --all -y
    @echo

update-vscode:
    # update vscode
    code --update-extensions
    code --list-extensions > {{ justfile_directory() }}/vscode/vscode-extensions.txt
    @echo

update-brew:
    # update according to Brewfile
    brew bundle --global -v
    brew bundle cleanup --global --force
    brew autoremove

dump-brew:
    # Dumping Brewfile
    brew bundle dump --global --force --describe --no-vscode --no-go --no-cargo 
    @echo

update-rust:
    # Keeping rustup up to date
    rustup self update
    @echo

    # Keeping rust up to date
    rustup update
    @echo

    # Keeping rust packages to date
    cargo install-update --list | tee /dev/tty | awk '$4 == "Yes" {print $1}' | xargs -I {} cargo install {} --force
    @echo

update-nvim:
    # Updating AstroNvim.
    -nvim +AstroUpdate +MasonUpdate +q +q 
    @echo

update-apps:
    # Checking outdated applications from AppStore.
    mas outdated
    @echo

update-yazi:
    # Update yazi plugins
    ya pkg upgrade
    @echo

update-claude:
    # Update claude
    claude update
    @echo

update-dws:
    # Update DingTalk Workspace CLI (dws)
    dws upgrade -y
    @echo