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
 gdb				> GDB init
 git				> global git config and aliases
 hg					> global hg config and aliases
 httpie			    > httpie settings
 karabiner			> Karabiner configuration
 less				> less settings
 omf				> oh-my-fish settings
 opam				> opam init
 shared_profile	    > shared shell settings, alias, and custom prompts
 spacemacs		    > spacemacs initialization setting and custom layers for Emacs.
 tmux				> terminal multiplexer with custom status bar
 vim				> vim settings
 zsh				> zshell settings, aliases, and custom prompts
```


## Before Getting Start

It's best to read the follwing articles before you start:

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## Installation

### 1 Install Dependencies

#### Homebrew & Cask

If you're an OS X user, the best way to manage software pacakges is to use Homebrew & Cask.

**a) Install Homebrew**

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

**b) Install brew cask**

```shell
brew tap caskroom/cask
```

> Refer to:  
>
> - http://brew.sh/  
> - https://caskroom.github.io/

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
cd ~/dotfiles && rake
```

If you want to apply a configuration package, try to execute following commands:

```shell
cd ~/dotfiles
stow package_dir_name
```

For example, apply **httpie** configuration package:

```sh
cd ~/dotfiles
stow httpie
```

### 3 Package Configuration

#### vim

Vim configuration is based on [**Janus**]( https://github.com/carlhuda/janus). Install MacVim and Janus as followed:

```sh
brew cask install macvim

# install janus
# https://github.com/carlhuda/janus#installation
cd
curl -L https://bit.ly/janus-bootstrap | bash

# install fonts
# https://github.com/powerline/fonts
git clone https://github.com/powerline/fonts.git
cd fonts && ./install.sh

cd ~/dotfiles
stow vim
```

#### tmux

tmux configuration is based on [**gpakosz/.tmux**](https://github.com/gpakosz/.tmux).

```sh
cd ~/dotfiles
stow tmux
```

#### spacemacs

```sh
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/dotfiles
stow spacemacs
```

# License

The license is GPLv3 for all parts specific to [**dotfiles**](https://github.com/skyjia/dotfiles)
