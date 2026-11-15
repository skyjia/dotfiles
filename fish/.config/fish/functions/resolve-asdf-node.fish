function resolve-asdf-node --description 'Print the active asdf Node.js install directory, or fail'
    # 不要给 asdf where 加 stderr 重定向：brew 的 asdf 包装脚本一旦被 ^/dev/null 或 ^&1
    # 就会报 "Version not installed" 且不返回路径，不重定向则正常（实测）。
    set -l dir (asdf where nodejs)

    if test -z "$dir"
        # 兜底：asdf set -u 写入的全局 ~/.tool-versions 就是权威版本来源
        set -l ver (awk '$1 == "nodejs" { print $2 }' "$HOME/.tool-versions" ^/dev/null)
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
