# Init starship prompt
#
# doc: https://starship.rs

if not status is-interactive
    exit
end

if type -q starship
    # https://starship.rs/guide/#%F0%9F%9A%80-installation
    command starship init fish | source
end
