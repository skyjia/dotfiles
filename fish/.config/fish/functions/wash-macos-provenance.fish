function wash-macos-provenance -d "Remove macOS quarantine and provenance extended attributes"
    # Usage: wash-macos-provenance <path>
    #
    # Clears all extended attributes (including com.apple.quarantine and
    # com.apple.provenance) recursively from the given path. Safe to run
    # on files/directories without these attributes — xattr -c never fails
    # on missing attributes.
    #
    # Examples:
    #   wash-macos-provenance ~/Downloads
    #   wash-macos-provenance /path/to/app.app

    if test (count $argv) -ne 1
        echo "Usage: wash-macos-provenance <path>" >&2
        return 1
    end

    set -l target $argv[1]

    if not test -e "$target"
        echo "Error: path does not exist: $target" >&2
        return 1
    end

    # -c = clear all attributes, -r = recursive
    # Does not fail on files without attributes (unlike xattr -d)
    # Permission errors on read-only files (e.g., submodule build
    # artifacts, plugin files) are informational only — the final
    # echo ensures the function returns 0 regardless.
    xattr -cr "$target"
    echo "Washed extended attributes from: $target"
end
