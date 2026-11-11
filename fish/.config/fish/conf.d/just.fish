if not status is-interactive
    exit
end

function ja -w "just all" -d "`just all` command"
  just all $argv
end
