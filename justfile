#!/usr/bin/env just --justfile

# https://just.systems/

home_dir := env_var('HOME')
zsh_dir := join(home_dir, '.oh-my-zsh')

set dotenv-load

default:
  @just --list

all: update-misc update-brew update-rust update-lvim

update-misc:
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

update-brew:
  # updating homebrew...
  brew update
  brew upgrade
  @echo
  
  # checking brew casks...
  brew cu --all --yes
  @echo
  
  # cleaning up
  brew cleanup --prune=2

update-rust:
  # Keeping rustup up to date
  rustup self update
  @echo
  
  # Keeping rust up to date
  rustup update
  @echo
  
  # Keeping rust packages to date
  cargo install-update -a

update-lvim:
  # Updating LunarVim.
  lvim +LvimUpdate +q
  #lvim +LvimSyncCorePlugins +q +q
