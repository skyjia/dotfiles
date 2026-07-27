# This file is part of the fish shell configuration for Karabiner-Elements.
# https://karabiner-elements.pqrs.org/docs/manual/misc/command-line-interface/
alias karabiner_cli='/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'

set -l default_profile "Sky"
set -l clear_profile "Sky - Clear"

# karabiner_cli --select-profile 'Sky'
alias karabiner_default_profile="karabiner_cli --select-profile \"$default_profile\""

# karabiner_cli --select-profile 'Sky - Clear'
alias karabiner_clear_profile="karabiner_cli --select-profile \"$clear_profile\""

# karabiner_cli --show-current-profile-name
alias karabiner_current_profile="karabiner_cli --show-current-profile-name"

# karabiner_cli --list-profile-names
alias karabiner_profiles="karabiner_cli --list-profile-names"
