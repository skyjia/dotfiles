function with-asdf-node --description 'Run a command with the active asdf Node.js first in PATH'
    # brew may ship the same Node version, whose npm resolves global root to
    # /opt/homebrew. Without pinning, global npm writes land there instead, and the
    # outcome depends on the caller's PATH.
    set -l node_dir (resolve-asdf-node)
    or return 1

    set -l joined (string join : -- $PATH)
    env PATH="$node_dir/bin:$joined" $argv
end
