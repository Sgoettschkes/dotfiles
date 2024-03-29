Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles; A list of the software I use; A set of instructions used to setup my environment

## Installation

First, install homebrew according to https://docs.brew.sh/Installation. Use homebrew to install git: `brew install git`.

Checkout this repo into `~/.dotfiles`.

Currently, I don't use any install scripts as I trimmed my dotfiles and the few files remaining can be symlinked manually as outlined below.

### SSH configuration

Run `mkdir -p ~/.ssh && ln -s ~/.dotfiles/ssh/config ~/.ssh/config` to symlink the SSH configuration.

You can put local ssh config (which should not be in git) in `~.ssh/config.local`.

### zsh configuration

Install oh-my-zsh (https://ohmyz.sh/#install) and symlink the following files:

* `rm ~/.zprofile && ln -s ~/.dotfiles/zsh/zprofile ~/.zprofile`
* `rm ~/.zshrc && ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc`

## Additional software

I install the following tools with homebrew:

* asdf
* awscli
* exercism
* docker
* docker-compose
* dvc
* flyctl
* git
* gnupg
* (k6)
* libpq

The following software is installed as cask with homebrew:

* docker
* freac
* iterm2
* (loom)
* meld
* musicbrainz-picard
* obsidian
* rectangle
* spotify
* stay
* tableplus
* visual-studio-code

The following tools are installed manually:

* 1password
* Adobe Digital Editions
* Chrome
* Google Drive
* Nirvana
* Zoom

### Docker

After installing docker and docker-compose via brew, run:

```
mkdir -p ~/.docker/cli-plugins
ln -sfn $HOMEBREW_PREFIX/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

### git configuration

Symlink all git config files:

* `ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig`
* `ln -s ~/.dotfiles/git/gitconfig_agileaddicts ~/.gitconfig_agileaddicts`
* `ln -s ~/.dotfiles/git/gitconfig_mateogrando ~/.gitconfig_mateogrando`
* `ln -s ~/.dotfiles/git/gitconfig_workera ~/.gitconfig_workera`
* `ln -s ~/.dotfiles/git/gitignore ~/.gitignore`
* `mkdir -p ~/.config/git && ln -s ~/.dotfiles/git/gitattributes ~/.config/git/attributes`

### iterm2 configuration

The config for iterm2 can be found in the `iterm2/` folder. In iTerm2, go to Settings -> General -> Preferences and select this file to be the place where the config should be loaded from and saved to.

### rectangle configuration

The rectangle configuration is stored in the `rectangle/` folder. It can be imported through the settings.

### Visual Studio Code configuration

The following symlinks should be put in place:

* `rm ~/Library/Application\ Support/Code/User/settings.json && ln -s ~/.dotfiles/vsc/settings.json ~/Library/Application\ Support/Code/User/settings.json`
* `rm ~/Library/Application\ Support/Code/User/keybindings.json && ln -s ~/.dotfiles/vsc/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json`
`rm -rf ~/Library/Application\ Support/Code/User/snippets && ln -s ~/.dotfiles/vsc/snippets ~/Library/Application\ Support/Code/User/snippets`

Also install all extensions by running `./.dotfiles/vsc/install-extensions.sh`.

### Fonts

For Visual Studio Code and iTerm, I am using [JetBrains Mono](https://www.jetbrains.com/lp/mono). The font can be found in the `fonts/` folder.

## Development environment

### asdf

Symlink the asdf tool-versions file:

`rm ~/.tool-versions && ln -s ~/.dotfiles/asdf/tool-versions ~/.tool-versions`
#### Elixir

Check [Before asdf install](https://github.com/asdf-vm/asdf-erlang#before-asdf-install) to see prerequisites. Then install Erlang:

```
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx"
export KERL_BUILD_DOCS=yes
```

And install elixir:

```
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
```

#### Node

Install node:

```
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add yarn https://github.com/twuni/asdf-yarn.git
```

#### PHP

Install PHP:

```
brew install autoconf automake bison freetype gd gettext icu4c krb5 libedit libiconv libjpeg libpng libsodium libxml2 libzip oniguruma pkg-config re2c zlib
asdf plugin-add php https://github.com/asdf-community/asdf-php.git
```

#### Python

Install python:

```
asdf plugin-add python https://github.com/danhper/asdf-python.git
```

Install poetry:

```
asdf plugin-add poetry https://github.com/asdf-community/asdf-poetry.git
```

#### Terraform

Install terraform:

```
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
```

#### Install all

Run

```
asdf install
```

## License

MIT. Please see [LICENSE](LICENSE).
