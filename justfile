#!/usr/bin/env just --justfile
# https://just.systems/

set shell := ['fish', '-c']
set dotenv-load := true

# List all available recipes
default:
    @just --list

# Update all components (dotfiles, brew, shells, apps, editors, dev tools, AI tools)
all: update-dotfiles update-brew update-shells update-dev update-apps update-editors update-ai

# Pull latest changes and update submodules
update-dotfiles: pull-latest update-submodules

# Update Homebrew packages and casks according to global Brewfile, upgrade all installed packages, then cleanup
update-brew: brew-update brew-upgrade brew-cleanup

# Update fish shell plugins and completions
update-shells: update-fish

# Update nvim, vscode, and yazi plugins
update-editors: update-nvim update-vscode update-yazi

# Update R packages, asdf plugins, and rust toolchain
update-dev: update-r-packages update-asdf update-rust

# Update npm packages globally in the active asdf Node
update-npm:
    # Update npm packages globally in the active asdf Node
    with-asdf-node npm update -g
    asdf reshim nodejs
    @echo

# Check for outdated npm packages globally
check-npm-outdated:
    #!/usr/bin/env fish
    # npm outdated exits 1 just for finding something outdated, so a non-zero status
    # alone is not failure. Fail only when it printed nothing. stderr stays visible.
    set -l out (with-asdf-node npm outdated -g)
    set -l code $status

    if test -z "$out"
        if test $code -ne 0
            echo "npm outdated failed (exit $code)" >&2
            exit $code
        end
        echo "All global npm packages are up to date"
        exit 0
    end

    printf '%s\n' $out
    echo ""
    echo (count $out)" lines outdated. Upgrade with: just update-npm"

# List all globally installed npm packages
npm-list:
    # List globally installed npm packages of the active asdf Node
    with-asdf-node npm list -g --depth=0
    @echo

# Install packages listed in ~/.default-npm-packages that the active Node is missing
sync-npm-defaults:
    #!/usr/bin/env fish
    set -l pkgs_file $HOME/.default-npm-packages
    if not test -e $pkgs_file
        echo "No package file: $pkgs_file" >&2
        exit 1
    end

    # Pin the target env: brew may ship the same Node version, whose npm resolves
    # global root to /opt/homebrew. Without pinning, installs land there instead.
    set -l node_dir (resolve-asdf-node)
    or exit 1
    set -lx PATH $node_dir/bin $PATH

    npm --version >/dev/null
    or begin
        echo "npm is not usable in $node_dir" >&2
        exit 1
    end

    # One spec per line, first token only; blanks and # comments skipped.
    # Limitation: trailing npm flags per line are not forwarded.
    set -l specs (awk 'NF && $1 !~ /^#/ { printf "%s\n", $1 }' $pkgs_file)
    if test (count $specs) -eq 0
        echo "$pkgs_file lists no packages" >&2
        exit 1
    end

    # npm ls exits 1 on an unsatisfied tree; we only read its JSON, stderr stays visible.
    set -l installed (npm ls --global --depth=0 --json | jq -r '.dependencies // {} | keys[]')

    set -l inst_file (mktemp)
    printf '%s\n' $installed >$inst_file
    # Compare by name: strip a trailing @version/@tag but keep a leading @scope.
    set -l missing (awk -v ins=$inst_file '
        BEGIN { while ((getline n < ins) > 0) I[n] = 1 }
        NF && $1 !~ /^#/ {
            spec = $1
            name = spec
            if (substr(name, 1, 1) == "@") {
                if (match(substr(name, 2), /@/)) name = substr(name, 1, RSTART)
            } else if (match(name, /@/)) {
                name = substr(name, 1, RSTART - 1)
            }
            if (!(name in I)) printf "%s\n", spec
        }' $pkgs_file)
    rm -f $inst_file

    echo "Node:    $node_dir"
    echo "Wanted:  "(count $specs)"  Installed: "(count $installed)
    if test (count $missing) -eq 0
        echo "Nothing missing; no changes made"
        exit 0
    end

    # No @echo here: the @ prefix is just's per-line syntax and would become a
    # literal command named `@echo` once the body runs as one fish script.
    echo "Missing: $missing"
    npm install --global $missing
    asdf reshim nodejs


# Show ESP-IDF / PlatformIO status from their own commands. Never parses internals,
# never deletes.
audit-embedded:
    #!/usr/bin/env fish
    audit-embedded

# Same report, plus the official commands to prune. Deletes nothing itself: pruning
# belongs to eim/pio, run by hand. No parameterised wrapper because just hands
# shebang recipes neither $args nor $argv, so a `force` branch would never fire.
prune-embedded:
    #!/usr/bin/env fish
    audit-embedded
    echo ""
    echo "== Retire an IDF version (eim also removes its activation scripts) =="
    echo "   eim remove <ver>        # e.g. eim remove v5.4.2"
    echo "   eim select <ver>        # switch the selected version"
    echo ""
    echo "== Repair tool state officially; never add/remove dirs under tools/ by hand =="
    echo "   eim fix                 # reinstall tools and dependencies"
    echo ""
    echo "== PlatformIO: let pio decide package ownership =="
    echo "   pio system prune --dry-run      # see what pio itself would reclaim"
    echo "   pio system prune                # reclaim after confirmation"
    echo "   pio pkg uninstall -g -p <spec>  # retire a platform; then its packages become prunable"


# Update dws, bailian, claude, and skillshare CLI tools
update-ai: update-dws update-bailian update-claude update-skillshare

# Wash macOS provenance attributes from the project root
wash-macos-provenance:
    # Washing macOS provenance attributes from project root
    wash-macos-provenance {{ justfile_directory() }}

# Pull latest changes from remote repository
pull-latest:
    # Pulling latest changes
    git pull
    @echo

# Pull all changes for the submodules
update-submodules:
    # Pull all changes for the submodules
    git submodule update --remote
    # Record submodule SHAs for review
    git submodule status | awk '{print $1, $2}' > .submodule-versions
    git add .submodule-versions
    @echo "Run 'git diff --cached .submodule-versions' to review, then commit"

# Update fish plugins and generate completions
update-fish:
    # Updating fish plugins
    fisher update
    fish_update_completions
    @echo

# Update asdf plugin repositories and check tool versions
update-asdf:
    # Updating asdf plugin repositories
    asdf plugin update --all
    {{ justfile_directory() }}/asdf/check-tools-version.nu
    @echo

# Update R packages (without prompting)
update-r-packages:
    # Updating R packages
    Rscript -e 'update.packages(ask = FALSE)'
    @echo

# Update vscode extensions and export list to file
update-vscode:
    # Update vscode extensions
    code --update-extensions
    # Export vscode extension list to file
    code --list-extensions > {{ justfile_directory() }}/backups/vscode/vscode-extensions.txt
    @echo

export-vscode-extensions:
    # Export vscode extension list to file
    code --list-extensions > {{ justfile_directory() }}/backups/vscode/vscode-extensions.txt
    @echo

# Update Homebrew formula lists
brew-update:
    # Update Homebrew formula lists
    brew update
    @echo

# Upgrade Homebrew packages and casks according to global Brewfile, then upgrade all installed packages
brew-upgrade:
    # Install packages missing from Brewfile
    brew bundle --global -v
    # Upgrade all installed packages
    brew upgrade --yes
    echo "run `just brew-upgrade-greedy` to upgrade all installed packages (including :latest casks and greedy-outdated ones)"
    @echo

# Upgrade Homebrew packages and casks according to global Brewfile, then upgrade all installed packages (greedy: also refresh :latest casks and greedy-outdated ones)
brew-upgrade-greedy:
    # Install packages missing from Brewfile
    brew bundle --global -v
    # Upgrade all installed packages (greedy: also refresh :latest casks and greedy-outdated ones)
    brew upgrade --yes --greedy
    @echo

# Cleanup Homebrew packages and casks according to global Brewfile, then remove unused dependencies and clean up old versions and cache
brew-cleanup:
    # Remove packages not in Brewfile
    brew bundle cleanup --global --force
    # Remove unused dependencies
    brew autoremove
    # Clean up old versions and cache
    brew cleanup
    @echo

# Dump current Homebrew packages to global Brewfile, keeping only intentional tools
dump-brew:
    #!/usr/bin/env fish
    set -l brewfile {{ justfile_directory() }}/brew/.Brewfile
    set -l keep /tmp/brewfile-keep-block
    set -l leaves /tmp/brewfile-leaves

    # 1) Stash the hand-authored @keep block (marker line to EOF) before dumping,
    #    since brew bundle dump rewrites the whole file.
    set -l marker_line (grep -n -m 1 '@keep' $brewfile | cut -d: -f1)
    if test -n "$marker_line"
        sed -n "$marker_line,\$p" $brewfile > $keep
    else
        printf '' > $keep
    end

    # 2) Re-dump: at this point the Brewfile mirrors installed_on_request, noise included.
    brew bundle dump --global --force --no-vscode --no-go --no-cargo --no-npm --no-mas

    # 3) Prune to brew leaves (installed AND not a dependency of anything installed).
    #    installed_on_request is never cleared by Homebrew, so dependencies accumulate
    #    one-way; a leaves predicate self-heals. Consume each entry's description comment
    #    too, or orphan comments are left behind.
    brew leaves | sort > $leaves
    awk -v LEAVES=$leaves '
        BEGIN { while ((getline l < LEAVES) > 0) L[l] = 1 }
        /^# / { c = c $0 "\n"; next }
        /^brew "/ {
            n = $0; sub(/^brew "/, "", n); sub(/".*$/, "", n)
            if (n in L) { printf "%s", c; c = ""; print } else { c = "" }
            next
        }
        { if (c != "") { printf "%s", c; c = "" }; print }
        END { if (c != "") printf "%s", c }
    ' $brewfile > $brewfile.new

    # 4) Reassemble: header + top-level intent + the hand-authored block.
    #    A kept entry that has since become a leaf needs no exception, so drop it from
    #    the block; otherwise it is emitted twice (seen with graphviz after plantuml left).
    set -l tmp $brewfile.tmp
    echo "# AUTO-GENERATED by `just dump-brew`. Do not edit manually." > $tmp
    cat $brewfile.new >> $tmp
    if test -s $keep
        echo >> $tmp
        awk -v LEAVES=$leaves '
            BEGIN { while ((getline l < LEAVES) > 0) L[l] = 1 }
            /^brew "/ { n = $0; sub(/^brew "/, "", n); sub(/".*$/, "", n); if (n in L) next }
            { print }
        ' $keep >> $tmp
    end
    mv $tmp $brewfile
    rm -f $brewfile.new $leaves $keep

    # 5) Report and self-check. Count alone hides duplication, so assert uniqueness too.
    set -l n_brew (grep -c '^brew ' $brewfile); or set n_brew 0
    set -l n_uniq (grep '^brew ' $brewfile | sort -u | wc -l | tr -d ' ')
    set -l n_top (brew leaves | wc -l | tr -d ' ')
    set -l n_keep (math $n_brew - $n_top)
    if test $n_brew -ne $n_uniq
        echo "Duplicate Brewfile entries: "(grep '^brew ' $brewfile | sort | uniq -d | string join ', ') >&2
    end
    if test $n_keep -lt 0
        echo "Prune anomaly: Brewfile has $n_brew entries but leaves has $n_top" >&2
    end
    echo "Brewfile: $n_brew entries = $n_top top-level + $n_keep hand-kept"

# Update rustup, rust toolchain, and cargo packages
update-rust:
    # Keeping rustup up to date
    rustup self update
    @echo

    # Keeping rust up to date
    rustup update
    @echo

    # Keeping rust packages up to date.
    cargo install-update -a
    @echo


# Install cargo packages from crates.txt manifest (for new machine setup)
install-cargo-crates:
    # Installing cargo packages from manifest
    grep -v '^#' {{ justfile_directory() }}/rust/.cargo/crates.txt | grep -v '^$$' | xargs -I {} cargo install {}
    @echo

# Install a cargo package and sync it to crates.txt
cargo-install pkg:
    # Installing cargo package: {{ pkg }}
    cargo install {{ pkg }}
    # Append package to crates.txt if not already present
    grep -qx '{{ pkg }}' {{ justfile_directory() }}/rust/.cargo/crates.txt || echo '{{ pkg }}' >> {{ justfile_directory() }}/rust/.cargo/crates.txt
    @echo

# Update AstroNvim and Mason packages
update-nvim:
    #!/usr/bin/env fish
    # Updating AstroNvim (skipped if nvim is not installed)
    if command -v nvim >/dev/null 2>&1
    nvim --headless "+AstroUpdate" "+MasonToolsUpdateSync" "+qa!" 2>&1 || echo "nvim/AstroNvim update failed (non-fatal)"
    else
    echo "nvim not installed; skipping"
    end

# Check outdated applications from App Store
update-apps:
    #!/usr/bin/env fish
    # Checking outdated applications from AppStore
    if test (uname) = Darwin
    mas outdated || true
    mas upgrade || echo "mas upgrade failed or nothing to update"
    else
    echo "App Store updates are macOS-only; skipping"
    end

# Update yazi plugins
update-yazi:
    # Update yazi plugins
    ya pkg upgrade
    @echo

# Update claude CLI
update-claude:
    # Update claude
    claude update
    @echo

# Update DingTalk Workspace CLI (dws)
update-dws:
    # Update DingTalk Workspace CLI (dws)
    dws upgrade -y
    @echo

# Update Bailian CLI & its plugins
update-bailian:
    # Update Bailian CLI
    bailian update
    @echo

# Update Skillshare CLI
update-skillshare:
    # Update Skillshare CLI
    skillshare upgrade --force
    @echo

# Clean package manager caches using each tool's native command.
# No manual `rm` — only tool-managed cache cleanup.
# Aggressive (requires re-download on next use): `go clean -modcache`, `brew cleanup --prune=all`
# Safe (keeps current project deps): all others
clean-tools-cache:
    cargo cache --autoclean
    npm cache clean --force
    dotnet nuget locals all --clear
    uv cache prune
    gem cleanup
    go clean -cache
    go clean -modcache
    brew cleanup --prune=all
    @echo