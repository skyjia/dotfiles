# This file is sourced on startup of the fish shell.

if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g fish_greeting

    switch $TERM_PROGRAM
        case "WarpTerminal"
            # Do nothing for WarpTerminal
        case "iTerm.app"
            # Do nothing for iTerm
        case "waveterm"
            # Do nothing for wave terminal
        case "vscode"
            # Do nothing for VSCode
        case "codebuddy"
            # Do nothing for CodeBuddy
        case Apple_Terminal
            # Do nothing for Apple_Terminal
        case "ghostty"
            # Fix eza colors in ghostty
            set -x EZA_COLORS "da=37:xx=37:ur=36:su=37:sf=36"
        case '*'
            echo "Unknown Terminal: $TERM_PROGRAM ($TERM)"
    end
end
