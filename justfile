#!/usr/bin/env just --justfile

# https://just.systems/

set dotenv-load

default:
  @just --list

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


