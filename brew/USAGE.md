# Usage

## `brew bundle`

You can use `brew bundle` to install and update all dependencies listed in your global Brewfile by running:

```sh
$ brew bundle --global
```

## `brew bundle check`
You can check if a brew bundle install will do anything by running:

```sh
$ brew bundle check --global
The Brewfile's dependencies are satisfied.
```

You can use this behaviour in scripts like so:

```sh
brew bundle check --global || brew bundle install --global
```


## `brew bundle cleanup`

You can use `brew bundle cleanup` to uninstall any dependencies not listed in your global Brewfile by running:

```sh
$ brew bundle cleanup --global --force
```

## `brew bundle dump`

You can use `brew bundle dump` to generate a Brewfile from your currently installed Homebrew dependencies by running:

```sh
$ brew bundle dump --global --force --describe --no-vscode --no-go --no-cargo
```

This will create or overwrite the Brewfile in your home directory with a list of all currently installed Homebrew packages, casks, and taps, excluding VSCode extensions, Go packages, and Cargo packages. The `--describe` flag adds comments to each entry in the Brewfile describing what it is.

## `brew bundle add` and `brew bundle remove`

You can add and remove entries to your Brewfile by running brew bundle add or brew bundle remove:

```sh
$ brew bundle add wget --global
$ brew bundle remove wget --global
```
