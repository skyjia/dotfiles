# AGENTS.md

Compact guidance for agents working in this dotfiles repository.

## Repository Type

Personal dotfiles for macOS using GNU `stow` for symlink management. Not a build-and-test codebase—focus on file operations, configuration edits, and task automation.

## Key Commands

**Never use plain bash/sh.** The justfile is configured to use `fish` shell:

```bash
just all              # Update everything (dotfiles, brew, shells, apps, editors, dev tools, AI tools)
just update-dotfiles  # Pull latest and update git submodules
just update-brew      # Run `brew bundle --global` from brew/.Brewfile
just update-shells    # fisher update (fish plugins)
just update-apps      # mas outdated (App Store apps)
just update-editors   # Update nvim (AstroUpdate + MasonUpdate), vscode, yazi
just update-dev       # Update R packages, conda, asdf, rust
just update-ai        # Update claude CLI + dws (DingTalk Workspace CLI)
just wash-macos-provenance  # Clear quarantine/provenance xattrs (for downloaded files)
```

See `justfile` for the full task list.

## Stow Package Structure

Top-level directories are stowable packages applied via `stow package_name`. All symlinks target `$HOME` (configured in `.stowrc`).

Major packages:
- `git/`, `zsh/`, `fish/`, `nushell/` – Shell and VCS config
- `astro-nvim/` – Neovim config (AstroNvim)
- `vscode/`, `zed/` – Editor settings
- `tmux/`, `karabiner/`, `ghostty/`, `warp/`, `waveterm/`, `zellij/` – Terminal/CLI tools
- `bat/`, `yazi/`, `starship/` – CLI utilities
- `raycast/` – Raycast script commands
- `brew/.Brewfile` – Homebrew packages (global managed)
- `asdf/`, `R/`, `rust/`, `anaconda/` – Version managers and runtime config
- `aria2/`, `npm/`, `odbc/`, `wget/` – Network/download tools
- `cmux/` – cmux configuration
- `iTerm/`, `ruby/`, `hg/` – Legacy/specific tools

Non-stowable working directory:
- `logs/` – BPMN diagrams and log files (not a stow package)

## Git Submodules

Repository contains submodules that must be updated together:
- `tmux/.tmux` – gpakosz/.tmux
- `raycast/.config/raycast/script-commands` – Official Raycast script commands
- `raycast/raycast-script-commands` – Personal Raycast script commands
- `warp/.warp/official-themes` – Warp terminal themes
- `nushell/nu_scripts` – Community nushell scripts

Running `just update-dotfiles` or `just all` automatically updates them.

## Configuration Entry Points

**Shells:**
- zsh: `zsh/.zshrc` – Oh-my-zsh integration, proxy management (tp/tpe/tpd toggle commands)
- fish: `fish/.config/fish/config.fish` – Includes `reset_app_permissions` function
- nushell: `nushell/autoload/` – Modular environment setup

**Neovim:** `astro-nvim/` follows AstroNvim structure; update via `nvim +AstroUpdate +MasonUpdate +q +q`

**VSCode:** `vscode/` settings; extensions list in `vscode/vscode-extensions.txt` (auto-maintained by `just update-vscode`)

**Terminal Emulators:**
- Warp: `warp/.warp/settings.toml` (settings) + `warp/.warp/tab_configs/` (tab layouts)
- WaveTerm: `waveterm/.config/waveterm/settings.json` + `widgets.json`
- Ghostty: `ghostty/.config/ghostty/`

**File Manager:** yazi: `yazi/.config/yazi/` – plugins in `plugins/`, theme in `theme.toml`

## Important Notes

- **Multi-shell environment:** Fish is the justfile shell; zsh/fish/nushell all coexist. Edits must respect each shell's syntax.
- **Proxy config (zsh only):** Automatic detection; includes git proxy sync. Not in other shells.
- **No tests or CI:** This is personal config, not a tested package. No build artifacts to worry about.
- **asdf pinning:** Check `asdf/check-tools-version.nu` after running `just update-asdf`; it validates tool versions.
- **Brew globals:** Using `brew bundle --global` (not local to repo). Extensions managed in `vscode-extensions.txt`.
- **AI tools:** `update-ai` now includes both `claude update` and `dws upgrade` (DingTalk Workspace CLI).
