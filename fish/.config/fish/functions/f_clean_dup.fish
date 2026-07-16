function f_clean_dup -d "Clean up duplicate files in a specified directory using fdupes."
    # Require an explicit target directory argument
    set -l target_dir $argv[1]
    if test -z "$target_dir"
        echo "Error: target directory must be specified." >&2
        echo "Usage: f_clean_dup <target_dir>" >&2
        return 1
    end

    # Resolve to an absolute path for safe validation
    set -l abs_dir (realpath -- "$target_dir" 2>/dev/null)
    if test -z "$abs_dir"
        echo "Error: directory does not exist: $target_dir" >&2
        return 1
    end
    if not test -d "$abs_dir"
        echo "Error: not a directory: $target_dir" >&2
        return 1
    end

    # Restrict operations to the current user's home folder to avoid
    # accidentally damaging system directories
    set -l home_dir (realpath -- "$HOME" 2>/dev/null)
    if test -z "$home_dir"
        echo "Error: failed to resolve home directory." >&2
        return 1
    end
    # Match either the home directory itself or a path nested beneath it.
    # The trailing slash on the pattern prevents sibling-prefix matches
    # (e.g. /Users/skyjiaevil being mistaken for inside /Users/skyjia).
    if not string match -q -- "$home_dir" "$abs_dir"; and not string match -q -- "$home_dir/*" "$abs_dir/"
        echo "Error: target directory must be inside the user home directory ($home_dir)." >&2
        echo "Refusing to operate outside the home folder to prevent system damage." >&2
        return 1
    end

    echo "Cleaning duplicated files at: \"$abs_dir\""

    # Run the core command on the validated, resolved path (not the raw
    # user input) — prevents symlink-based bypass of the home-directory
    # containment check above.
    fdupes --recurse --delete --noprompt $abs_dir
end
