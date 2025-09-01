# BetterTouchTool CLI (bttcli) path configuration for fish shell

if not status is-interactive
    exit
end

set --local btt_bin /Applications/BetterTouchTool.app/Contents/SharedSupport/bin
ensure_add_to_fish_user_paths "$btt_bin"
