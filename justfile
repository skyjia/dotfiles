#!/usr/bin/env just --justfile

# https://just.systems/

home_dir := env_var('HOME')
zsh_dir := join(home_dir, '.oh-my-zsh')

set dotenv-load

default:
  @just --list

update-all: misc-update brew-update rust-update

misc-update:
  # Pulling latest changes
  git pull
  @echo

  # Pull all changes for the submodules
  git submodule update --remote
  @echo

  # Updating zsh
  git -C {{zsh_dir}} pull
  @echo

  # Updating powerlevel10k
  git -C "{{zsh_dir}}/custom/themes/powerlevel10k" pull
  @echo

  # Updating asdf plugin repositories
  asdf plugin update --all

brew-update:
  # updating homebrew...
  brew update
  brew upgrade
  @echo
  
  # checking brew casks...
  brew cu --all --yes
  @echo
  
  # cleaning up
  brew cleanup --prune=2

rust-update:
  # Keeping rustup up to date
  rustup self update
  @echo
  
  # Keeping rust up to date
  rustup update
  @echo
  
  # Keeping rust packages to date"
  cargo install-update -a
