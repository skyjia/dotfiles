# dump global Brewfile
brew bundle dump --global --force --describe --no-vscode --no-go --no-cargo

# dump main Brewfile via rcmdnk/file/brew-file
# export HOMEBREW_BREWFILE_ON_REQUEST=1
# brew file init --force
