function audit-embedded --description 'Read-only ESP toolchain status, built from eim/pio official commands'
    # Deliberately stays out of eim/pio internals:
    #   - no parsing of ~/.espressif/tools/<tool>/<version> (private layout, changes across versions)
    #   - no deletion (retire via `eim remove`, repair via `eim fix`)
    #   - no grepping human output for decisions (use `eim help-json` when machine input is needed)
    # Everything reported here comes from the tools themselves.

    echo "== Installed IDF versions (eim list) =="
    eim list 2>&1 | grep -v "INFO -"
    echo ""

    # Ask only about versions eim itself reports as installed; never assume the list.
    for v in (eim list 2>/dev/null | string match -r '^\s*-\s+\S+' | string split -f2 ' ')
        echo "== eim list-tools $v =="
        set -l out (eim list-tools $v 2>/dev/null)
        printf '%s\n' $out | grep -E "^\S.*:" | sed 's/^/  /'
        set -l installed (printf '%s\n' $out | grep -c "\[installed:")
        set -l missing (printf '%s\n' $out | grep -c "\[not installed\]")
        echo "  → installed: $installed, not installed: $missing"
        echo ""
    end

    # Report only what pio computes itself; never infer which package belongs where.
    echo "== PlatformIO self-report (pio system prune --dry-run, read-only) =="
    echo "   Note: this triggers pio's online upgrade check."
    # Single quotes required: a pattern ending in $ inside double quotes starts fish's $"..." locale string.
    pio system prune --dry-run 2>&1 | grep -vE '^\s*$' | sed 's/^/  /'
end
