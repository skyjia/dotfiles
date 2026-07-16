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
| `waveterm/` | Wave terminal configuration with widgets |
| `iTerm/` | iTerm2 configuration (legacy) |

### Terminal Multiplexers
| Package | Description |
|---------|-------------|
| `tmux/` | Terminal multiplexer configuration (via submodule) |
| `zellij/` | Zellij terminal multiplexer configuration |

### Editors
| Package | Description |
|---------|-------------|
| `astro-nvim/` | AstroNvim configuration for Neovim |
| `vscode/` | VSCode settings and extensions |
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
| `anaconda/` | Conda environment configuration |

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

#### tmux

tmux configuration is based on [**gpakosz/.tmux**](https://github.com/gpakosz/.tmux).

```sh
cd ~/dotfiles
stow tmux
```

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
just update-dev         # Update R packages, conda, asdf, rust toolchain
just update-ai          # Update claude, antigravity, and dws CLI tools
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

## Legislation

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
