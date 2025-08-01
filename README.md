Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles; A list of the software I use; A set of instructions used to setup my environment

## Installation

First, install homebrew according to https://docs.brew.sh/Installation. Use homebrew to install git: `brew install git`.

Checkout this repo into `~/.dotfiles`.

Currently, I don't use any install scripts as I trimmed my dotfiles and the few files remaining can be symlinked manually as outlined below.

## Software installation

I install the following tools with homebrew:

* asdf
* docker
* git
* iterm2
* rectangle

## Fonts

* [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip)
* [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
* [SauceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/SourceCodePro.zip)

### rectangle configuration

The rectangle configuration is stored in the `rectangle/` folder. It can be imported through the settings.

## Development environment

### SSH configuration

Run `mkdir -p ~/.ssh && ln -s ~/.dotfiles/ssh/config ~/.ssh/config` to symlink the SSH configuration.

You can put local ssh config (which should not be in git) in `~/.ssh/config.local`.

### zsh configuration

Install oh-my-zsh (https://ohmyz.sh/#install) and symlink the following files:

* `rm ~/.zprofile && ln -s ~/.dotfiles/zsh/zprofile ~/.zprofile`
* `rm ~/.zshrc && ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc`

### git configuration

Symlink all git config files:

* `ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig`
* `ln -s ~/.dotfiles/git/gitconfig_agileaddicts ~/.gitconfig_agileaddicts`
* `ln -s ~/.dotfiles/git/gitconfig_mateogrando ~/.gitconfig_mateogrando`
* `ln -s ~/.dotfiles/git/gitconfig_workera ~/.gitconfig_workera`
* `ln -s ~/.dotfiles/git/gitignore ~/.gitignore`
* `mkdir -p ~/.config/git && ln -s ~/.dotfiles/git/gitattributes ~/.config/git/attributes`

### asdf

Symlink the asdf tool-versions file:

`rm ~/.tool-versions && ln -s ~/.dotfiles/asdf/tool-versions ~/.tool-versions`

Install all asdf plugins and tools:

```
./asdf/setup.sh
```

**Note:** For Erlang/Elixir, check [prerequisites](https://github.com/asdf-vm/asdf-erlang#before-asdf-install) before running the script.

**Note:** For PHP, check [prerequisites](https://github.com/asdf-vm/asdf-php#before-asdf-install) before running the script.

## License

MIT. Please see [LICENSE](LICENSE).
