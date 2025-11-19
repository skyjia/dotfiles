# Google Antygravity CLI (agy) path configuration for fish shell

if not status is-interactive
    exit
end

set --local agy_bin $HOME/.antigravity/antigravity/bin
# ensure_add_to_fish_user_paths "$agy_bin"
set -Ux fish_user_paths $agy_bin