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

# make Homebrew use brewed curl
# https://github.com/orgs/Homebrew/discussions/1752
set -gx  HOMEBREW_FORCE_BREWED_CURL 1
