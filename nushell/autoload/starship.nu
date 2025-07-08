# Configure the prompt with starship.
# https://www.nushell.sh/book/3rdpartyprompts.html#starship
# https://starship.rs/#nushell

if $nu.is-interactive {
    # check if the starship command is available
    if (command -v starship | is-not-empty) {
        starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
    }
}
