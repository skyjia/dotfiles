#!/usr/bin/env just --justfile

# https://just.systems/

home_dir := env_var('HOME')
zsh_dir := join(home_dir, '.oh-my-zsh')

set dotenv-load

default:
  @just --list

all: update-misc update-lvim update-rust update-mojo update-brew

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
  @echo

  # Updating R packages
  Rscript -e 'update.packages(ask = FALSE)'

update-ide:
  # update Android Studio and packages
  sdkmanager --update
  sdkmanager --licenses
  @echo

  # update vscode extensions
  # code --list-extensions | xargs -L 1 code --force --install-extension

update-conda:
  # update Anaconda
  # Update the conda package manager to the latest version in your base environment
  conda update -n base conda
  @echo

update-mojo:
  # update mojo
  modular update mojo
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
