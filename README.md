Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles; A list of the software I use; A set of instructions used to setup my environment

## Installation

First, install homebrew according to https://docs.brew.sh/Installation. Use homebrew to install git: `brew install git`.

Checkout this repo into `~/.dotfiles`.

Currently, I don't use any install scripts as I trimmed my dotfiles and the few files remaining can be symlinked manually. Here is the list of files and where they need to be placed:

* git
  * `ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig`
  * `ln -s ~/.dotfiles/git/gitconfig_agileaddicts ~/.gitconfig_agileaddicts`
  * `ln -s ~/.dotfiles/git/gitconfig_workera ~/.gitconfig_workera`
  * `ln -s ~/.dotfiles/git/gitignore ~/.gitignore`
  * `mkdir -p ~/.config/git && ln -s ~/.dotfiles/git/gitattributes ~/.config/git/attributes`
* ssh
  * `mkdir -p ~/.ssh && ln -s ~/.dotfiles/ssh/config ~/.ssh/config`
* zsh
  * Make zsh your shell and install oh-my-zsh (https://ohmyz.sh/#install)
  * `rm ~/.zprofile && ln -s ~/.dotfiles/zsh/zprofile ~/.zprofile`
  * `rm ~/.zshrc && ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc`
* Visual Studio Code
  * Install vscode: `brew install --cask visual-studio-code`
  * `rm ~/Library/Application\ Support/Code/User/settings.json && ln -s ~/.dotfiles/vsc/settings.json ~/Library/Application\ Support/Code/User/settings.json`
  * `rm ~/Library/Application\ Support/Code/User/keybindings.json && ln -s ~/.dotfiles/vsc/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json`
  * `./.dotfiles/vsc/install-extensions.sh`

## SSH configuration

You can put local ssh config (which should not be in git) in `~.ssh/config.local`.

## Additional software

I install the following tools with homebrew:

* asdf
* awscli
* git
* libpq

The following software is installed as cask with homebrew:

* docker
* iterm2
* loom
* meld
* obsidian
* rectangle
* spotify
* stay
* tableplus
* visual-studio-code

## Fonts

For Visual Studio Code and iTerm, I am using [Cascadia Code](https://github.com/microsoft/cascadia-code).

## Development environment

### Elixir



## License

MIT. Please see [LICENSE](LICENSE).
