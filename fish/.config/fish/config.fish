# This file is sourced on startup of the fish shell.

if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g fish_greeting

    switch $TERM_PROGRAM
        case WarpTerminal
            # Do nothing for WarpTerminal
        case "iTerm.app"
            # Do nothing for iTerm
        case vscode
            # Do nothing for VSCode
        case Apple_Terminal
            # Do nothing for Apple_Terminal
        case '*'
            echo "Unknown Terminal: $TERM_PROGRAM ($TERM)"
    end
end
