#!/usr/bin/env bash
set -e
CUR=`dirname $0`

cd $CUR
rake

echo "Updating additional dependencies"
git -C $ZSH pull
ZSH_CUSTOM=$ZSH/custom
git -C $ZSH_CUSTOM/themes/powerlevel10k pull
git -C $HOME/.SpaceVim pull

