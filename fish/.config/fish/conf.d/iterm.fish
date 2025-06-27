# iterm.fish is only meant to be used in interactive mode. If not in interactive mode, skip the config to speed up shell startup
if not status is-interactive
    exit
end

# test $TERM_PROGRAM equals 'iTerm.app'
if test "$TERM_PROGRAM" = 'iTerm.app'
    # Load iTerm2 Shell Integration
    set iterm2_shell_integration_path "$HOME/.iterm2_shell_integration.fish"
    if test -e "$iterm2_shell_integration_path"
        source "$iterm2_shell_integration_path"
    end
end
