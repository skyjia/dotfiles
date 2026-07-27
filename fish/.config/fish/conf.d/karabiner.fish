# This file is part of the fish shell configuration for Karabiner-Elements.
# https://karabiner-elements.pqrs.org/docs/manual/misc/command-line-interface/
alias karabiner_cli='/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'

alias karabiner_current_profile="karabiner_cli --show-current-profile-name"
alias karabiner_profiles="karabiner_cli --list-profile-names"

set -l personal_profile "Sky"
set -l clean_profile "Default Clean"

alias karabiner_profile_personal="karabiner_cli --select-profile \"$personal_profile\""
alias karabiner_profile_clean="karabiner_cli --select-profile \"$clean_profile\""
