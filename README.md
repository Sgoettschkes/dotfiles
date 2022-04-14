Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles. 

## Installation

Checkout this repo into `~/.dotfiles`.

Currently, I don't use any install scripts as I trimmed my dotfiles and the few files remaining can be symlinked manually. Here is the list of files and where they need to be placed:

* git
  * Install git (using brew)
  * `ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig`
  * `ln -s ~/.dotfiles/git/gitconfig_agileaddicts ~/.gitconfig_agileaddicts`
  * `ln -s ~/.dotfiles/git/gitconfig_workera ~/.gitconfig_workera`
  * `ln -s ~/.dotfiles/git/gitignore ~/.gitignore`
  * `mkdir -p ~/.config/git && ln -s ~/.dotfiles/git/gitattributes ~/.config/git/attributes`
* ssh
  * `mkdir -p ~/.ssh && ln -s ~/.dotfiles/ssh/config ~/.ssh/config`
  * You can put local ssh config (which should not be in git) in `~.ssh/config.local`
* zsh
  * Make zsh your shell and install oh-my-zsh
  * `ln -s ~/.dotfiles/zsh/zprofile ~/.zprofile`
  * `ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc`

## License

MIT. Please see [LICENSE](LICENSE).
