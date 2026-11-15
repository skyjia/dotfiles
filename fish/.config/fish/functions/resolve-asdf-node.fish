function resolve-asdf-node --description 'Print the active asdf Node.js install directory, or fail'
    # 不要给 asdf where 加 stderr 重定向：brew 的 asdf 包装脚本一旦被 ^/dev/null 或 ^&1
    # 就会报 "Version not installed" 且不返回路径，不重定向则正常（实测）。
    set -l dir (asdf where nodejs)

    if test -z "$dir"; and test -f "$HOME/.tool-versions"
        # 兜底：asdf set -u 写入的全局 ~/.tool-versions 就是权威版本来源。
        # 这里不要用 `^/dev/null` 静音 awk —— 实测该位置上 fish 会把它当成 awk 的输入
        # 文件名而非重定向；改用 test -f 前置判断。
        set -l ver (awk '$1 == "nodejs" { print $2 }' "$HOME/.tool-versions")
        if test -n "$ver"; and test -d "$HOME/.asdf/installs/nodejs/$ver"
            set dir "$HOME/.asdf/installs/nodejs/$ver"
        end
    end

    if test -z "$dir"
        echo "Cannot resolve active Node.js — check: asdf current nodejs" >&2
        return 1
    end

    echo "$dir"
end
