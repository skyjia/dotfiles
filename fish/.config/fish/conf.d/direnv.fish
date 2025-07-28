if not status is-interactive
    exit
end

# For direnv to work properly it needs to be hooked into the shell.
direnv hook fish | source
