if status is-interactive
    switch $TERM_PROGRAM
        case "WarpTerminal"
            # Do nothing for WarpTerminal
        case "iTerm.app"
            # Do nothing for iTerm
        case "vscode"
            # Do nothing for VSCode
        case "Apple_Terminal"
            # Do nothing for Apple_Terminal
        case "ghostty"
            # Fix eza colors in ghostty
            set -x EZA_COLORS "da=37:xx=37:ur=36:su=37:sf=36"
        case '*'
            echo "Unknown Terminal: $TERM_PROGRAM ($TERM)"
    end
end
