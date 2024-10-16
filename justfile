#!/usr/bin/env just --justfile

# https://just.systems/

home_dir := env_var('HOME')
zsh_dir := join(home_dir, '.oh-my-zsh')

set dotenv-load

default:
  @just --list

all: update-misc update-vscode update-nvim update-lvim update-rust update-mojo update-brew

update-misc: pull-latest update-submodules update-oh-my-zsh update-asdf-plugins update-r-packages update-conda

pull-latest:
  # Pulling latest changes
  git pull
  @echo

update-submodules:
  # Pull all changes for the submodules
  git submodule update --remote
  @echo

update-oh-my-zsh:
  # Updating oh-my-zsh
  git -C {{zsh_dir}} pull
  @echo

update-asdf-plugins:
  # Updating asdf plugin repositories
  asdf plugin update --all
  @echo

update-r-packages:
  # Updating R packages
  Rscript -e 'update.packages(ask = FALSE)'
  @echo

update-conda:
  # update Anaconda
  # Update the conda package manager to the latest version in your base environment
  conda update -n base conda
  @echo

update-mojo:
  # update mojo
  magic self-update
  @echo

update-vscode:
  # update vscode
  code --update-extensions
  @echo

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

update-nvim:
  # Updating AstroNvim.
  nvim +AstroUpdate +q +q

