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
| `go/` | Go env file (`GOPROXY` module mirror) |
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

### Two scopes — never mix them

Every ecosystem below is documented as **Global** (machine-wide, survives projects, must be
reproduced on a new machine) or **Project** (declared inside the project's own manifest).
Some have a third scope, **Ephemeral**: resolved on demand for one command, recorded nowhere.

| Ecosystem | Global | Project | Ephemeral | Global manifest that must be committed |
| --- | --- | --- | --- | --- |
| Homebrew | yes (the only scope it has) | — | — | `brew/.Brewfile` |
| Python (uv) | `uv tool install` | `uv add` / `uv sync` | `uv run --with` | none yet — `uv tool list` is empty by choice |
| npm | `npm -g` | `npm install` / `package.json` | `npx` | `asdf/.default-npm-packages` |
| Ruby gems | `gem install` → `~/.gem` | `bundle install` / `Gemfile` | — | none yet (see Gems) |
| cargo | `cargo install` | `cargo add` / `Cargo.toml` | `cargo install --git` one-offs | `rust/.cargo/crates.txt` |
| Go | `go install` → `$GOPATH/bin` | `go get` / `go.mod` | `go run pkg@version` | **none — known gap** |
| Homebrew casks | yes | — | — | `brew/.Brewfile` |

The Python row is worth reading twice: `uv add` never touches the machine, `uv tool install`
never touches the project, and `uv run --with` leaves no trace at all. Reinstalling a machine
means replaying the *manifest* column only — anything you installed "globally" without a
manifest entry is lost.

### Homebrew

Homebrew is **global-only**. There is no project scope: it installs into
`/opt/homebrew` for the whole machine, and the repo tracks exactly one global manifest.
(`brew bundle` can read a repo-local `--file`, but this project always uses `--global`.)

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

There is deliberately **no global package environment** — "global Python" here means
interpreters and CLI tools, never shared libraries. Interpreters come from Homebrew (as
dependencies); `uv` owns environments, locking and tool installs.

**Global — CLI tools only (`uv tool`)**

| Action | Command |
| --- | --- |
| Install a Python CLI as a tool | `uv tool install <pkg>` |
| Run it | `<cmd>` (entry points land in `~/.local/bin`) |
| One-off run without installing | `uvx <pkg>@latest --help` / `uv tool run <pkg>` |
| Upgrade all tools | `uv tool upgrade --all` |
| List / audit / remove | `uv tool list`; `uv tool audit`; `uv tool uninstall <pkg>` |
| Where things live | `uv tool dir` → `~/.local/share/uv/tools`; scripts → `~/.local/bin` |
| PATH safety net | `uv tool update-shell` |

Each tool gets its own isolated venv, so two tools needing different versions of one
library do not conflict. Nothing is installed into `~/.local/lib/python…`.

This project currently has **no** uv tools (`uv tool list` → empty). That is a decision, not
an omission: the machine deliberately has no global `jupyter`, no global `ruff`. Note
`~/.local/bin` also holds the `python` symlink into Homebrew's `python3`, so the directory is
shared by two mechanisms — don't read it as "uv owns it".

**Project — libraries (`uv add`, in the project directory)**

| Action | Command |
| --- | --- |
| Add a dependency | `uv add <pkg>` / `uv add --dev <pkg>` |
| Remove a dependency | `uv remove <pkg>` |
| Apply the lockfile | `uv sync` |
| Upgrade pinned deps | `uv lock --upgrade && uv sync` |
| Run a project command | `uv run <cmd>` (uses the project's `.venv`) |
| Jupyter for a project | `uv add --dev ipykernel`, then pick `./.venv` in the editor |
| Pin the interpreter for this project | `uv python pin <ver>` (writes `.python-version`) |
| Migrate a legacy `requirements.txt` | `uv add -r requirements.txt` or `uv pip install -r …` inside the venv |

`uv add` writes `pyproject.toml` + `uv.lock` and cannot affect any other project. Existing
projects to follow: `ai/learn-claude-code`, `skyjia@GitHub/print-cards`,
`skyjia@GitHub/fapiao-extractor` (all with `uv.lock`, all pinned to `3.14`).

**Ephemeral — neither scope (`uv run --with`)**

| Action | Command |
| --- | --- |
| One-off script needing libraries | `uv run --with pandas,matplotlib script.py` |
| Ad-hoc REPL with packages | `uv run --with numpy python -i -c '…'` |

Resolved into a throwaway environment on each run; nothing is recorded, so it does not help
on a new machine. Use this instead of polluting either real scope.

**Interpreters**: `uv python install <ver>` / `uv python list`. Because
`uv/.config/uv/uv.toml` sets `python-preference = "system"`, uv uses Homebrew's interpreter
when it has one and only downloads otherwise — `brew` stays the primary source.

Do **not** run bare `pip` or `pip3 install`: `pip3` belongs to Homebrew's `python@3.15`
and writing into its prefix gets discarded on the next `brew upgrade`. `uv pip install`
inside an active project venv is fine.

### npm

**Global — CLI tools, manifest-driven**

The manifest is `asdf/.default-npm-packages` (symlinked as `~/.default-npm-packages`):

```bash
cat ~/dotfiles/asdf/.default-npm-packages   # typescript, eslint, bailian-cli
```

| Action | Command |
| --- | --- |
| Add a global tool | add a line to `asdf/.default-npm-packages`, then `just sync-npm-defaults` |
| Remove a global tool | `with-asdf-node npm uninstall -g <p>` **and** delete its line |
| Upgrade global tools | `just update-npm` |
| What is outdated | `just check-npm-outdated` |
| What is installed | `just npm-list` |

Two traps here, both verified on this machine:

- `asdf-nodejs` reads `.default-npm-packages` **only when installing a Node version**. Editing
  the file alone does nothing to the active Node — that gap is what `just sync-npm-defaults`
  exists to close.
- Every global npm command must go through `with-asdf-node`. Homebrew may ship the *same*
  Node version number, and its `npm` resolves `global root` to `/opt/homebrew`; without
  pinning, globals silently land in the dependency prefix and vanish on `brew upgrade`.
  The helper pins PATH the same way the asdf plugin does.

**Project — libraries (`package.json`)**

| Action | Command |
| --- | --- |
| Add a dependency | `npm install <p>` / `npm install -D <p>` (dev) |
| Reproducible install | `npm ci` (installs exactly from `package-lock.json`) |
| Upgrade | `npm update` / `npm outdated` |
| Pin the Node version for this project | `.node-version` (read by asdf) or `.tool-versions` |
| Run a project-local binary | `npx <cmd>` (prefers the local `node_modules/.bin`) |

15 projects in `~/Codes` carry a `package.json`; `quartz` and `quartz-skyjia` pin Node via
`.node-version`. `npm install <p>` without `-g` is project-scoped and is the default — never
reach for `-g` to make a library available to one app.

**Ephemeral**

| Action | Command |
| --- | --- |
| Run a tool without installing | `npx <pkg>@<version> [args]` |

Downloads into the npm cache and runs; nothing is added to the machine or the project.

### Ruby gems

Ruby itself is asdf-managed (Homebrew's `ruby` exists only as `asciidoctor`'s dependency).
`GEM_HOME` is set to `~/.gem` in both `zsh/.shared-env.zsh:71` and
`fish/conf.d/cocoapods.fish:3`, and `~/.gem/bin` is on `PATH`.

**Global**

| Action | Command |
| --- | --- |
| Install a gem | `gem install <g>` → `~/.gem` (`gem env` → INSTALLATION DIRECTORY) |
| Upgrade | `gem update` |
| Remove | `gem uninstall <g>` |
| Clean | `gem cleanup` (drops stale versions); `~/.gem/specs` is re-fetchable metadata |

**Project**

| Action | Command |
| --- | --- |
| Declare deps | `Gemfile` + `bundle install` |
| Run against the bundle | `bundle exec <cmd>` |
| Upgrade | `bundle update` |
| Reproducible install | `bundle install` reads `Gemfile.lock` |

In practice this machine uses **only the global scope for gems**: `find ~/Codes ~/Documents
-name Gemfile` returns 0, and there is no `~/.default-gems` even though asdf-ruby supports
one (`ASDF_GEM_DEFAULT_PACKAGES_FILE`, read at Ruby-version install time, exactly like the
npm file). Consequences worth knowing:

- Global gems have **no committed manifest**, so they are not reproduced on a new machine.
  If you want that, create `ruby/.default-gems`, `stow ruby`, and list the gems — the
  plugin will then install them on every new Ruby version.
- Because `~/.gem` is shared, the hazard is *not* the install prefix but **which Ruby
  compiled a native extension**: a gem built by Homebrew's `ruby` can fail under asdf's
  `ruby` and vice versa. Before installing anything with a C extension, check
  `ruby -v && gem env | head -3`, and prefer `bundle` for that case.

### Cargo

**Global — installed binaries**

| Action | Command |
| --- | --- |
| Install and record | `just cargo-install <crate>` (appends to `rust/.cargo/crates.txt`) |
| Install everything | `just install-cargo-crates` (new machine) |
| Upgrade | `just update-rust` → `cargo install-update -a` |
| Remove | `cargo uninstall <crate>` and delete its line from `crates.txt` |

**Project — libraries**: declared in `Cargo.toml`, `cargo add <crate>`, `cargo update`,
checked-in `Cargo.lock`. One example in `~/Codes` (`rust-wasm-demo`).

Caveat worth knowing before pruning a `@keep` entry: cargo-built binaries link Homebrew
libraries **by absolute path**, which is invisible to `brew leaves` — `openssl@3` survives
in `@keep` precisely because three cargo binaries hard-link it. Check with
`otool -L ~/.cargo/bin/<bin> | grep -i ssl`.

### Go

**Go is the exception to the "Homebrew runtimes are dependencies only" rule.** asdf has
only `java`, `nodejs` and `ruby` plugins; the Go toolchain here is Homebrew's
(`go` → `/opt/homebrew/opt/go/libexec/bin/go`), and `brew "go"` is held in `@keep` on
purpose because it is a user-facing toolchain, not a stray dependency.

`GOPATH=~/Codes/go` is set independently in each shell — `fish/conf.d/02-vars.fish:9`,
`zsh/.shared-env.zsh:21`, `nushell/autoload/02-vars.nu:6` — so global tool binaries land in
`~/Codes/go/bin`. (`golang.fish` itself only derives `GOROOT` from `brew --prefix golang`.)

**Module mirror**: `GOPROXY=https://goproxy.cn,direct` is set in the Go env file, which is
stowed from `go/Library/Application Support/go/env`. That location is deliberate: unlike a
shell variable it also covers editor-spawned `gopls` and any GUI-launched build, and it keeps
one source of truth instead of repeating the value in three shell configs. Verified with
`go list -m -versions golang.org/x/tools`.

```bash
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct   # to switch mirror
cat ~/dotfiles/go/Library/Application\ Support/go/env           # what is tracked
```

Because `go env -w` writes *through* the symlink (verified), editing via `go env -w` keeps
the repo file in sync rather than silently replacing it — but the change then shows up as an
uncommitted edit, so commit it.

**Global — installed commands**

| Action | Command |
| --- | --- |
| Install a tool | `go install <module>/cmd/<tool>@latest` |
| Upgrade | re-run with `@latest` (there is no `go install-update`) |
| Remove | `rm ~/Codes/go/bin/<tool>` |
| Inspect what a binary came from | `go version -m ~/Codes/go/bin/<tool>` |
| Where they are | `$GOPATH/bin` → `~/Codes/go/bin`, already on `PATH` |

There is **no manifest** for global Go tools, so nothing here is reproducible on a fresh
machine — and the debt is not theoretical: `~/Codes/go/bin` currently holds **53 binaries
tracing back to only 11 modules**, most of them one ancient `golang.org/x/tools@v0.1.10`
install spree. To see the real inventory:

```bash
for f in ~/Codes/go/bin/*; do go version -m "$f" 2>/dev/null | awk -F'\t' -v n="$(basename "$f")" '$2=="mod"{print n"\t"$3"@"$4; exit}'; done | sort -k2
```

Worth cleaning up or recording in a `go/.global-tools.txt` the same way cargo uses
`crates.txt`; until then, treat `~/Codes/go/bin` as unmanaged.

**Project**

| Action | Command |
| --- | --- |
| Add a dependency | `go get <pkg>@<ver>` (edits `go.mod`) |
| Tidy | `go mod tidy` |
| Reproduce exactly | `go mod download` + `go build` (go.mod/go.sum are the lock) |
| Pin the toolchain | `toolchain` directive in `go.mod` |

28 of your projects carry a `go.mod`, so this is the most-used project scope in the repo —
`go get`/`go mod` is the working path, and `go install` is only for standalone commands.

**Ephemeral**: `go run <module>@latest` runs a module without adding it anywhere.

### Embedded (eim / PlatformIO)

Stay inside each tool's own commands; never delete inside their state directories.

**Machine scope — toolchains (eim)**

| Action | Command |
| --- | --- |
| Status | `just audit-embedded` |
| Reclaim candidates + the commands to use | `just prune-embedded` — reports only, deletes nothing |
| Retire an IDF version | `eim remove <ver>` (also removes its activation scripts) |
| Repair tool state | `eim fix` |
| Run in a version's context | `eim run <cmd> <ver>` / `eim shell <ver>` |

**PlatformIO — two scopes**

| Scope | Action | Command |
| --- | --- | --- |
| Global | List installed platforms & tools | `pio pkg list -g` |
| Global | Add a platform / tool | `pio pkg install -g -p <spec>` / `-t <spec>` (no `-a` flag exists) |
| Global | Remove | `pio pkg uninstall -g -p <spec>` |
| Global | What pio itself can reclaim | `pio system prune --dry-run`, then `pio system prune` |
| Project | Declare libraries for one project | `lib_deps` in `platformio.ini`, resolved by `pio pkg install -e <env>` in that directory |
| Project | Stale check | `pio pkg outdated -d <project>` — project-scoped; there is no `-g`, and no `pio pkg check` subcommand |

Retiring a **global** platform (`pio pkg uninstall -g -p espressif32@6.7.0`) is the only way
its packages become prunable — but that exact version is what
`Codes/PlatformIO/Projects/Cardputer_Adv_Demo/platformio.ini` pins, so check project
`platform =` lines before retiring anything.

Keeping one toolchain at two versions because two retained IDF releases each require one
is normal, not waste. Judge by what a retained version declares, never by size or version
recency.

### Caches at a glance

Caches belong to no scope — they are safe to clear and simply refill.

| Where | Command | Size now | Note |
| --- | --- | --- | --- |
| Go build cache | `go clean -cache` | 5.0 G | `~/Library/Caches/go-build` |
| Go module cache | `go clean -modcache` | 4.7 G | `~/Codes/go/pkg/mod`; every module re-downloads |
| Homebrew downloads | `brew cleanup -s --prune=all` | 5.7 G | plain `brew cleanup` keeps current-version files |
| uv | `uv cache prune` / `uv cache clean` | — | |
| npm | `with-asdf-node npm cache clean --force` | — | |
| gem | `gem cleanup` | — | `~/.gem/specs` is regenerable |
| PlatformIO | `pio system prune --cache` | — | `dist/` + `.cache/` are download caches |
| eim | `eim install/fix --cleanup` | — | this flag means *temp files*, not old tool versions |

The Go entry is the largest single reclaimable pool on this machine and is invisible to
`brew cleanup`, `uv cache` and `pio system prune` — clear it with Go's own command or not
at all.

## Legislation

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
