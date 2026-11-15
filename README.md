# Overview

```text
      ██            ██     ████ ██  ██
     ░██           ░██    ░██░ ░░  ░██
     ░██  ██████  ██████ ██████ ██ ░██  █████   ██████
  ██████ ██░░░░██░░░██░ ░░░██░ ░██ ░██ ██░░░██ ██░░░░
 ██░░░██░██   ░██  ░██    ░██  ░██ ░██░███████░░█████
░██  ░██░██   ░██  ░██    ░██  ░██ ░██░██░░░░  ░░░░░██
░░██████░░██████   ░░██   ░██  ░██ ███░░██████ ██████
 ░░░░░░  ░░░░░░     ░░    ░░   ░░ ░░░  ░░░░░░ ░░░░░░

  ▓▓▓▓▓▓▓▓▓▓
 ░▓ about  ▓ A comprehensive dotfiles collection for developers using macOS/Linux.
 ░▓ author ▓ Sky Jia <me@skyjia.com>
 ░▓ code   ▓ https://github.com/skyjia/dotfiles
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░
```

## Packages

### Shells
| Package | Description |
|---------|-------------|
| `zsh/` | Zsh with oh-my-zsh, starship prompt, and plugins |
| `fish/` | Fish shell configuration with utility functions |
| `nushell/` | Nushell with autoloaded modules and vendor scripts |

### Terminal Emulators
| Package | Description |
|---------|-------------|
| `ghostty/` | Ghostty terminal configuration |
| `warp/` | Warp terminal settings, themes, and tab configurations (via submodule) |

### Terminal Multiplexers
| Package | Description |
|---------|-------------|
| `zellij/` | Zellij terminal multiplexer configuration |

### Editors
| Package | Description |
|---------|-------------|
| `astro-nvim/` | AstroNvim configuration for Neovim |
| `zed/` | Zed editor settings |

### Prompt & CLI Tools
| Package | Description |
|---------|-------------|
| `starship/` | Starship prompt configuration |
| `yazi/` | Yazi file manager with plugins and themes |
| `bat/` | Bat (cat clone) configuration |

### Version & Package Managers
| Package | Description |
|---------|-------------|
| `brew/` | Homebrew packages and casks (`brew/.Brewfile`) |
| `asdf/` | asdf version manager configuration |
| `uv/` | uv configuration — Python interpreter policy (`uv/.config/uv/uv.toml`) |

### Language Configurations
| Package | Description |
|---------|-------------|
| `R/` | R package configuration |
| `ruby/` | Ruby configuration |
| `rust/` | Rust/cargo configuration (includes `crates.txt` manifest) |
| `npm/` | npm configuration |

### Network & Download
| Package | Description |
|---------|-------------|
| `aria2/` | aria2 download manager configuration |
| `wget/` | wget configuration |
| `odbc/` | ODBC database configuration |

### Keyboard & Utilities
| Package | Description |
|---------|-------------|
| `karabiner/` | Karabiner-Elements configuration |
| `cmux/` | Cmux configuration |
| `git/` | Global git configuration and aliases |
| `hg/` | Mercurial configuration |

### Scripting
| Package | Description |
|---------|-------------|
| `raycast/` | Raycast script commands (via submodules) |

## Before Getting Started

It's best to read the following articles before you start:

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

### 1 Install Dependencies

#### Homebrew

If you're a macOS user, the best way to manage software packages is to use Homebrew.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> Refer to: <https://brew.sh>

For Linux users, please try [LinuxBrew](http://linuxbrew.sh/) instead.

#### GNU `stow`

I recommend using GNU `stow` to manage dotfiles, because it's free, portable, and lightweight.

Install stow with Homebrew:

```shell
brew install stow
```

### 2 Clone and Apply `dotfiles`

```sh
git clone https://github.com/skyjia/dotfiles.git ~/dotfiles
```

If you want to apply a configuration package, try to execute following commands:

```shell
cd ~/dotfiles
stow package_dir_name
```

For example, apply **zsh** configuration package:

```sh
cd ~/dotfiles
stow zsh
```

### 3 Package Configuration

#### vim

Vim configuration is based on [**AstroNvim**](https://astronvim.com/).

### 4 Keep Updated

```sh
cd ~/dotfiles
just all
```

## Just Commands

### Update All Configurations

```bash
just all   # Update all components (dotfiles, brew, shells, apps, editors, dev tools, AI tools)
```

### Update Specific Categories

```bash
just update-dotfiles    # Pull latest changes and update submodules
just update-brew        # Update Homebrew packages and casks
just update-shells      # Update fish plugins
just update-apps        # Check outdated App Store apps (mas)
just update-editors     # Update nvim (AstroNvim), vscode, yazi
just update-dev         # Update R packages, asdf plugins, rust toolchain
just update-ai          # Update dws, bailian, claude, and skillshare CLI tools
```

### Cargo Package Management

```bash
just install-cargo-crates    # Install all cargo packages from crates.txt (new machine setup)
just cargo-install <pkg>     # Install a single cargo package and sync to crates.txt
```

### macOS Utilities

```bash
just wash-macos-provenance   # Clear quarantine and provenance attributes
```

## Daily Maintenance

Project-specific actions for the four package ecosystems. Two rules explain most of the
surprises you can create here:

1. **Re-dump after every Homebrew change.** `brew/.Brewfile` is the source of truth and
   `just update-brew` runs `brew bundle --global`, which *reinstalls* anything listed
   there. Uninstall without `just dump-brew`, and the next update brings it straight back.
2. **asdf and uv own the language runtimes; Homebrew's copies are dependencies only.**
   In a login fish, asdf shims are prepended so bare commands are correct. In GUI-spawned
   shells (VSCode tasks, Claude Code, launchd) `/opt/homebrew/bin` comes first, and a bare
   `npm`/`pip3`/`gem` writes into that dependency prefix.

### Homebrew

| Action | Command |
| --- | --- |
| Add a formula | `brew install <f>` then `just dump-brew` |
| Add a cask | `brew install --cask <c>` then `just dump-brew` |
| Upgrade everything | `just update-brew` |
| What is outdated | `brew outdated` — this, not `--greedy` (see below) |
| Remove | `brew uninstall <f>` then `just dump-brew` |
| Remove a cask | `brew uninstall --cask <c>` then check for leftovers (see below) |
| Reclaim deps + cache | `just brew-cleanup` |
| Audit | `brew doctor`; `brew leaves`; `brew uses --installed <f>` |

**Use `brew outdated`, not `--greedy`, as your to-do list.** Greedy always reports casks
pinned to `version: "latest"` (fonts, `sdrplusplus`) and self-updating apps — that output
carries no information. `brew bundle check` prints "needs to be installed or updated" for
merely *outdated* entries, so read it as "stale", not "missing".

**Some casks leave their data behind.** A pkg-based cask may declare no `uninstall`
stanza, and then `brew uninstall --cask` clears only the bookkeeping:

```bash
brew info --json=v2 --cask <c> | jq '.casks[0].uninstall'   # null → manual cleanup needed
```

**Never upgrade a privileged cask from an automated or agent session.** `macfuse` is
pkg + kernel/system extension + LaunchDaemon and its upgrade needs `sudo`, which cannot
prompt without a TTY. The run stops half-way: services get booted out while files and
receipts stay on the old version. Do those in a real terminal.

**`@keep`** — `just dump-brew` prunes to `brew leaves` (installed *and* not a dependency
of anything installed), so Homebrew never records its own dependency tree as intent.
Packages you want kept even though they are currently someone's dependency belong in the
`@keep` block at the end of `brew/.Brewfile`. That block is the only hand-edited part of
the file; entries that later become top-level leaves are dropped from it automatically.

### Python

There is deliberately **no global package environment**. Interpreters come from
Homebrew (as dependencies); `uv` owns environments, locking and tool installs.

| Action | Command |
| --- | --- |
| Add a dependency to a project | `uv add <pkg>` / `uv add --dev <pkg>` |
| Remove one | `uv remove <pkg>` |
| Sync a project to its lockfile | `uv sync` |
| Upgrade pinned deps | `uv lock --upgrade && uv sync` |
| One-off script needing packages | `uv run --with pandas,matplotlib script.py` |
| Jupyter for a project | `uv add --dev ipykernel`, then pick `./.venv` in the editor |
| Choose an interpreter | `uv python install <ver>`; `uv python pin <ver>` per project |
| Clean | `uv cache prune` (stale) / `uv cache clean` (everything) |

Do **not** run bare `pip` or `pip3 install`: `pip3` belongs to Homebrew's `python@3.15`
and writing into its prefix gets discarded on the next `brew upgrade`. `uv pip install`
inside an active project venv is fine.

### npm

Global npm tools are manifest-driven, like Python projects:

```bash
cat ~/dotfiles/asdf/.default-npm-packages   # symlinked as ~/.default-npm-packages
```

| Action | Command |
| --- | --- |
| Add a global tool | add a line to `asdf/.default-npm-packages`, then `just sync-npm-defaults` |
| Remove a global tool | `with-asdf-node npm uninstall -g <p>` and delete its line |
| Upgrade global tools | `just update-npm` |
| What is outdated | `just check-npm-outdated` |
| What is installed | `just npm-list` |

Two specifics: `asdf-nodejs` reads `.default-npm-packages` **only when installing a Node
version**, which is exactly what `just sync-npm-defaults` covers; and every global npm
command must go through `with-asdf-node`, because Homebrew may ship the *same* Node
version whose `npm` resolves `global root` to `/opt/homebrew`.

### Ruby gems

Ruby itself is asdf-managed (Homebrew's `ruby` exists only as `asciidoctor`'s dependency).
`GEM_HOME` is set to `~/.gem` in both `zsh/.shared-env.zsh` and
`fish/conf.d/cocoapods.fish`, and `~/.gem/bin` is on `PATH`.

| Action | Command |
| --- | --- |
| Install a gem | `gem install <g>` (installs into `~/.gem`) |
| Per-project gems | `bundle install` in the project |
| Upgrade | `gem update` / `bundle update` |
| Remove | `gem uninstall <g>` |
| Clean | `gem cleanup` (drops stale versions); `~/.gem/specs` is re-fetchable metadata |

Because `~/.gem` is shared, the hazard here is *not* the install prefix but **which Ruby
compiled a native extension**: a gem built by Homebrew's `ruby` can fail under asdf's
`ruby` and vice versa. Run `ruby -v` and `gem env | head -3` before installing anything
with a C extension, and prefer `bundle` (project-local) over global gems for that case.

### Cargo

| Action | Command |
| --- | --- |
| Install and record | `just cargo-install <crate>` (appends to `rust/.cargo/crates.txt`) |
| Install everything | `just install-cargo-crates` (new machine) |
| Upgrade | `just update-rust` → `cargo install-update -a` |
| Remove | `cargo uninstall <crate>` and delete its line from `crates.txt` |

Caveat worth knowing before pruning a `@keep` entry: cargo-built binaries link Homebrew
libraries **by absolute path**, which is invisible to `brew leaves`. Check with
`otool -L ~/.cargo/bin/<bin> | grep -i ssl`.

### Embedded (eim / PlatformIO)

Stay inside each tool's own commands; never delete inside their state directories.

| Action | Command |
| --- | --- |
| Status | `just audit-embedded` |
| What is reclaimable, and how | `just prune-embedded` — reports and prints commands, deletes nothing |
| Retire an IDF version | `eim remove <ver>` (also removes its activation scripts) |
| Repair tool state | `eim fix` |
| PlatformIO reclaim | `pio system prune --dry-run`, then `pio system prune` |
| Retire a PIO platform | `pio pkg uninstall -g -p <spec>` — its packages become prunable after |

Keeping one toolchain at two versions because two retained IDF releases each require one
is normal, not waste. Judge by what a retained version declares, never by size or version
recency.

### Caches at a glance

| Where | Command | Note |
| --- | --- | --- |
| Homebrew downloads | `brew cleanup -s --prune=all` | plain `brew cleanup` keeps current-version files |
| uv | `uv cache prune` / `uv cache clean` | |
| npm | `with-asdf-node npm cache clean --force` | |
| gem | `gem cleanup` | `~/.gem/specs` is regenerable |
| PlatformIO | `pio system prune --cache` | `dist/` + `.cache/` are download caches |
| eim | `eim install/fix --cleanup` | this flag means *temp files*, not old tool versions |

## Legislation

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
