# Init Homebrew
#
# source shell environment for Fish installed via Homebrew.
/opt/homebrew/bin/brew shellenv | source

if status is-interactive
    # -- Configuring Completions in fish --
    # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
    if test -d "$HOMEBREW_PREFIX/share/fish/completions"
        set -p fish_complete_path $HOMEBREW_PREFIX/share/fish/completions
    end
    if test -d "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
        set -p fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d
    end
end

# Useful aliases for Homebrew for Brewfile management
alias brew-add='brew bundle add --global'
alias brew-remove='brew bundle remove --global'
alias brew-cask-add='brew bundle add --global --cask'
alias brew-cask-remove='brew bundle remove --global --cask'
alias brew-sync='brew bundle --global --verbose'
