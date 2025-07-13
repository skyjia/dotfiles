# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS/Linux developers that uses GNU `stow` for symlink management. The repository contains configuration files for various development tools and shells, with a focus on modern terminal-based workflows.

## Common Commands

### Update All Configurations
```bash
# Update all components (dotfiles, brew, shells, apps, editors, dev tools)
just all

# Update specific categories
just update-dotfiles    # Pull latest changes and update submodules
just update-brew        # Update Homebrew packages and casks
just update-shells      # Update oh-my-zsh and fish plugins
just update-editors     # Update nvim (AstroNvim), lvim, vscode, helix
just update-dev         # Update R packages, conda, asdf, rust toolchain
```

### Package Management with Stow
```bash
# Apply a configuration package
cd ~/dotfiles
stow package_name

# Examples:
stow zsh           # Apply zsh configuration
stow git           # Apply git configuration  
stow tmux          # Apply tmux configuration
stow fish          # Apply fish shell configuration
stow nushell       # Apply nushell configuration
```

### Editor Updates
```bash
# Update AstroNvim
nvim +AstroUpdate +MasonUpdate +q +q

# Update LunarVim  
lvim +LvimUpdate +q

# Update Helix grammars
hx --grammar fetch
hx --grammar build
```

## Architecture and Structure

### Shell Configuration Strategy
- **Multi-shell support**: Configurations for zsh, fish, and nushell
- **Terminal detection**: Shell configs detect terminal type (iTerm, Warp, VSCode, etc.) and adjust behavior
- **Proxy management**: Automatic system proxy detection and configuration (zsh)

### Package Organization
Each top-level directory represents a stowable package:
- `git/` - Global git configuration and aliases
- `zsh/` - Zsh shell with oh-my-zsh, starship prompt, and extensive plugin setup
- `fish/` - Fish shell with minimal configuration
- `nushell/` - Nushell with autoloaded modules and vendor scripts
- `astro-nvim/` - AstroNvim configuration for Neovim
- `lunar-vim/` - LunarVim configuration
- `tmux/` - Terminal multiplexer configuration
- `helix/` - Helix editor configuration

### Key Configuration Files
- `justfile` - Just task runner with comprehensive update commands
- `nushell/autoload/` - Modular nushell configuration with environment setup
- `zsh/.zshrc` - Main zsh configuration with oh-my-zsh integration
- `fish/.config/fish/config.fish` - Fish shell startup configuration

### Development Environment
- **Version managers**: asdf for multiple language runtimes
- **Package managers**: Homebrew (macOS), conda (Python), cargo (Rust)
- **Editor ecosystem**: Neovim with AstroNvim, LunarVim, Helix, VSCode
- **Terminal tools**: starship prompt, zoxide, fzf, lazygit

### Proxy and Network Configuration
The zsh configuration includes sophisticated proxy management:
- Automatic detection of system proxy settings
- Environment variable configuration for HTTP/HTTPS/SOCKS proxies
- Git proxy configuration synchronization
- Toggle commands: `tp` (toggle), `tpe` (enable), `tpd` (disable)

### Update Strategy
The repository uses a multi-layered update approach via `just all`:
1. Git operations (pull, submodule updates)
2. System packages (Homebrew)
3. Shell environments (oh-my-zsh, fish plugins)
4. Applications (App Store apps, VSCode extensions)
5. Editors (Neovim plugins, LunarVim, Helix grammars)
6. Development tools (R packages, conda, asdf plugins, Rust toolchain)

This dotfiles setup prioritizes automation and consistency across development environments while supporting multiple shell preferences and terminal applications.