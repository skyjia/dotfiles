function with-asdf-node --description 'Run a command with the active asdf Node.js first in PATH'
    # brew 也可能装有一个同版本号的 node，其 npm 的 global root 指向 /opt/homebrew。
    # 不显式锁定就会让全局 npm 操作落进 brew 前缀，落点取决于调用者的 PATH。
    set -l node_dir (resolve-asdf-node)
    or return 1

    set -l joined (string join : -- $PATH)
    env PATH="$node_dir/bin:$joined" $argv
end
