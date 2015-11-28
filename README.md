```
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

 bash				> bash settings
 fish				> fish settings
 git				> global git config and aliases
 hg					> global hg config and aliases
 httpie			> httpie settings
 janus				> janus for vim configurations
 less				> less settings
 omf				> oh-my-fish settings
 shared_profile	> shared shell settings, alias, and custom prompts
 spacemacs		> spacemacs initialization setting and custom layers for Emacs.
 tmux				> terminal multiplexer with custom status bar
 vim				> vim settings
 zsh				> zshell settings, aliases, and custom prompts
```

**Quick Install**

```shell
git clone https://github.com/skyjia/dotfiles.git ~/dotfiles
```

##Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Preparation](#preparation)
  - [1. How to manage dotfiles?](#1-how-to-manage-dotfiles)
  - [2. Homebrew & Cask](#2-homebrew-&-cask)
- [Apply Configuration](#apply-configuration)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# Preparation

## 1. How to manage dotfiles?

It's best to read the follwing articles before you start:

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## 2. Homebrew & Cask

If you're an OS X user, the best way to manage software pacakges is to use Homebrew & Cask.

**1. Install Homebrew**

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

**2. Install brew cask**

```shell
brew install caskroom/cask/brew-cask
```

> Refer to:  
> - http://brew.sh/  
> - http://caskroom.io/  

# Apply Configuration

I recommend to use GNU `stow` to manage dotfiles, because it's free, portable, and lightweight.

Install stow with homebrew:

```shell
brew install stow
```

If you want to apply a configuration package, try to execute following commands:

```shell
cd ~/dotfiles
stow package_name
```


# License

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
