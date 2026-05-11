# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS/Linux developers that uses GNU `stow` for symlink management. The repository contains configuration files for various development tools and shells, with a focus on modern terminal-based workflows.

## Common Commands

### Update All Configurations
```bash
# Update all components (dotfiles, brew, shells, apps, editors, dev tools, AI tools)
just all

# Update specific categories
just update-dotfiles    # Pull latest changes and update submodules
just update-brew        # Update Homebrew packages and casks (from brew/.Brewfile)
just update-shells      # Update fish plugins
just update-apps        # Check outdated App Store apps (mas)
just update-editors     # Update nvim (AstroNvim), vscode, yazi
just update-dev         # Update R packages, conda, asdf, rust toolchain
just update-ai          # Update claude and dws (DingTalk Workspace CLI)
```

### Package Management with Stow
```bash
# Apply a configuration package
cd ~/dotfiles
stow package_name

# Examples:
stow zsh           # Apply zsh configuration
stow fish          # Apply fish shell configuration
stow nushell       # Apply nushell configuration
stow tmux          # Apply tmux configuration
stow git           # Apply git configuration
stow karabiner     # Apply Karabiner-Elements configuration
stow yazi          # Apply yazi file manager configuration
stow bat           # Apply bat (cat clone) configuration
```

The `--target=$HOME` option is configured in `.stowrc` for global symlink application.

### Editor Updates
```bash
# Update AstroNvim
nvim +AstroUpdate +MasonUpdate +q +q

# Update yazi plugins
just update-yazi
```

## Architecture and Structure

### Shell Configuration Strategy
- **Multi-shell support**: Configurations for zsh, fish, and nushell
- **Terminal detection**: Shell configs detect terminal type and adjust behavior
- **Proxy management**: Automatic system proxy detection and configuration (zsh)
- **macOS utilities**: Fish includes `reset_app_permissions` function for managing app permissions

### Package Organization
Each top-level directory represents a stowable package:
- `git/` - Global git configuration and aliases
- `zsh/` - Zsh shell with oh-my-zsh, starship prompt, and plugins
- `fish/` - Fish shell configuration with utility functions
- `nushell/` - Nushell with autoloaded modules and vendor scripts
- `astro-nvim/` - AstroNvim configuration for Neovim
- `tmux/` - Terminal multiplexer configuration (via submodule)
- `vscode/` - VSCode settings and extensions
- `zed/` - Zed editor settings
- `raycast/` - Raycast script commands (via submodules)
- `warp/` - Warp terminal settings, themes, and tab configurations (via submodule)
- `waveterm/` - Wave terminal configuration with widgets
- `ghostty/` - Ghostty terminal configuration
- `zellij/` - Zellij terminal multiplexer configuration
- `karabiner/` - Karabiner-Elements configuration
- `yazi/` - Yazi file manager with plugins and themes
- `bat/` - Bat (cat clone) configuration
- `starship/` - Starship prompt configuration
- `cmux/` - Cmux configuration
- `brew/.Brewfile` - Homebrew packages and casks
- `asdf/` - asdf version manager configuration
- `R/` - R package configuration
- `rust/` - Rust/cargo configuration
- `anaconda/` - Conda environment configuration
- `aria2/` - aria2 download manager configuration
- `npm/` - npm configuration
- `odbc/` - ODBC database configuration
- `wget/` - wget configuration
- `iTerm/` - iTerm2 configuration (legacy)
- `ruby/` - Ruby configuration
- `hg/` - Mercurial configuration

### Git Submodules
- `tmux/.tmux` - gpakosz/.tmux
- `raycast/.config/raycast/script-commands` - Official Raycast script commands
- `raycast/raycast-script-commands` - Personal Raycast script commands
- `warp/.warp/official-themes` - Warp terminal themes
- `nushell/nu_scripts` - Community nushell scripts

### Key Configuration Files
- `justfile` - Just task runner with comprehensive update commands (uses fish shell)
- `brew/.Brewfile` - Homebrew package definitions
- `nushell/autoload/` - Modular nushell configuration with environment setup
- `zsh/.zshrc` - Main zsh configuration with oh-my-zsh integration
- `fish/.config/fish/config.fish` - Fish shell startup configuration
- `warp/.warp/settings.toml` - Warp terminal settings
- `waveterm/.config/waveterm/settings.json` - Wave terminal settings
- `yazi/.config/yazi/package.toml` - Yazi plugin packages
- `.stowrc` - Stow configuration with `--target=$HOME`

### Development Environment
- **Version managers**: asdf for multiple language runtimes
- **Package managers**: Homebrew (macOS), conda (Python), cargo (Rust)
- **Editor ecosystem**: Neovim with AstroNvim, VSCode, Zed, yazi
- **Terminal tools**: starship prompt, zoxide, fzf, lazygit, ghostty, zellij
- **Scripting**: Raycast script commands, nushell modules

### Proxy and Network Configuration
The zsh configuration includes sophisticated proxy management:
- Automatic detection of system proxy settings
- Environment variable configuration for HTTP/HTTPS/SOCKS proxies
- Git proxy configuration synchronization
- Toggle commands: `tp` (toggle), `tpe` (enable), `tpd` (disable)

### Update Strategy
The repository uses a multi-layered update approach via `just all`:
1. Git operations (pull, submodule updates)
2. System packages (Homebrew via brew/.Brewfile)
3. Shell environments (fish plugins)
4. Applications (App Store apps via mas)
5. Editors (Neovim plugins, VSCode extensions, yazi plugins)
6. Development tools (R packages, conda, asdf plugins, Rust toolchain)
7. AI tools (claude, dws)

### macOS Provenance
Run `just wash-macos-provenance` to clear quarantine and provenance attributes
from downloaded files.

This dotfiles setup prioritizes automation and consistency across development environments while supporting multiple shell preferences and terminal applications.
