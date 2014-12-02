Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles. Includes standard stuff like bash/git/tmux/vim
and some fancy stuff like asunder/haskell.

Should work anywhere. Started on Ubuntu 12.10, made better on Mint 15 and is
currently in use on Debian Wheezy and Debian Jessie.

Installation
------------

* cd ~ && git clone https://github.com/Sgoettschkes/dotfiles .dotfiles
* cd .dotfiles && ./bootstrap.sh

It's important that dotfiles live inside the `.dotfiles` directory, because
that's where the `dotfiles` command will look for them.

What's inside
-------------

See the different directories for the stuff that's inside. dotfiles installes
the `dotfiles` command which will automatically update dotfiles to the newest
version using `git fetch`, `git reset` and the `bootstrap.sh` file.
