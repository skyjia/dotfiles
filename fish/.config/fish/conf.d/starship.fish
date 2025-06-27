# Init starship prompt
#
# doc: https://starship.rs

if status --is-interactive
    if type -q starship
        # https://starship.rs/guide/#%F0%9F%9A%80-installation
        starship init fish | source
    end
end
