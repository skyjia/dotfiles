#!/usr/bin/env bash
set -e
CUR=`dirname $0`

cd $CUR
rake

echo "Updating additional dependencies"

echo "Updating zsh"
git -C $ZSH pull

echo "Updating powerlevel10k"
ZSH_CUSTOM=$ZSH/custom
git -C $ZSH_CUSTOM/themes/powerlevel10k pull

echo "Updating SpaceVim"
git -C $HOME/.SpaceVim pull

