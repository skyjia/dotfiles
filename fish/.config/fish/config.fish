# This file is sourced on startup of the fish shell.

if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g fish_greeting

    fish_vi_key_bindings

    function fish_user_key_bindings
        # Customize key bindings to retain Emacs shortcuts in insert mode
        bind -M insert \ca beginning-of-line    # Ctrl+A go to the beginning of the line
        bind -M insert \ce end-of-line          # Ctrl+E go to the end of the line
        bind -M insert \cf forward-char         # Ctrl+F move forward a character
        bind -M insert \cb backward-char        # Ctrl+B move backward a character
        bind -M insert \ck kill-line            # Ctrl+K kill the line from the cursor to the end
        bind -M insert \cu backward-kill-line   # Ctrl+U kill the line from the beginning to the cursor
        bind -M insert \cw backward-kill-word   # Ctrl+W kill the word before the cursor
        bind -M insert \cy yank                 # Ctrl+Y yank the last killed text
    end
end
