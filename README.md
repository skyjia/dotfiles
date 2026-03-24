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
 ░▓ about  ▓ A couple of dotfiles for developers using OS X.
 ░▓ author ▓ Sky Jia <me@skyjia.com>
 ░▓ code   ▓ https://github.com/skyjia/dotfiles
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░

 git                > global git config and aliases
 hg                 > global hg config and aliases
 karabiner          > Karabiner configuration
 less               > less settings
 tmux               > terminal multiplexer with custom status bar
 astro-nvim         > AstroNvim configuration
 zsh                > zshell settings, aliases, and custom prompts
```

## Before Getting Start

It's best to read the following articles before you start:

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

### 1 Install Dependencies

#### Homebrew

If you're an OS X user, the best way to manage software packages is to use Homebrew.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)""
```

> Refer to: <https://brew.sh>

For Linux user, please try [LinuxBrew](http://linuxbrew.sh/) instead.

#### GNU `stow`

I recommend to use GNU `stow` to manage dotfiles, because it's free, portable, and lightweight.

Install stow with homebrew:

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

# License

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
