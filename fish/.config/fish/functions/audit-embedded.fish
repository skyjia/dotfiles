function audit-embedded --description 'Read-only ESP toolchain status, built solely from eim/pio official commands'
    # 这个函数刻意**不碰** eim 的内部布局，也不做任何删除：
    #   - 不解析 ~/.espressif/tools/<tool>/<version>（那是 eim 的私有实现，随版本变化）
    #   - 不 rm 任何目录（退役版本用 eim remove，状态修复用 eim fix）
    #   - 不 grep 人类可读输出当判据（要用机器接口就 eim help-json）
    # 所有结论都直接来自工具自己，判据不来自我的推断。

    echo "== ESP-IDF 安装状态（eim list）=="
    eim list 2>&1 | grep -v "INFO -"
    echo ""

    # 只对 eim 自己确认已安装的版本逐项询问，不猜版本列表
    for v in (eim list 2>/dev/null | string match -r '^\s*-\s+\S+' | string split -f2 ' ')
        echo "== eim list-tools $v =="
        set -l out (eim list-tools $v 2>/dev/null)
        printf '%s\n' $out | grep -E "^\S.*:" | sed 's/^/  /'
        set -l installed (printf '%s\n' $out | grep -c "\[installed:")
        set -l missing (printf '%s\n' $out | grep -c "\[not installed\]")
        echo "  → 已安装 $installed 项；未安装 $missing 项"
        echo ""
    end

    # pio 侧只取它自己算出来的回收量，绝不替它判断哪个包属于哪个平台
    echo "== PlatformIO 自查（pio system prune --dry-run，只读）=="
    echo "   注意：该命令会触发 pio 的联网升级检查。"
    # 必须用单引号：双引号里以 $ 结尾会触发 fish 的 $"..." 本地化字符串语法
    pio system prune --dry-run 2>&1 | grep -vE '^\s*$' | sed 's/^/  /'
end
