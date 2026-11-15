function resolve-asdf-node --description 'Print the active asdf Node.js install directory, or fail'
    # Do not redirect asdf's stderr: brew's asdf wrapper reports "Version not
    # installed" and returns no path once stderr is redirected. Unredirected it works.
    set -l dir (asdf where nodejs)

    if test -z "$dir"; and test -f "$HOME/.tool-versions"
        # Fallback: `asdf set -u` writes the authoritative global version here.
        # Avoid `^/dev/null` on awk — in this position fish treats it as an input
        # filename, not a redirect; guard with test -f instead.
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
