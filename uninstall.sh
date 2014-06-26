#!/bin/bash

echo "--- STARTING ---"

# bash
rm -f ~/.aliases
rm -f ~/.bashrc
rm -f ~/.profile
rm -f ~/.inputrc
rm -f ~/.functionrc

# ssh
rm -f ~/.ssh/config

# gnupg
rm -f ~/.gnupg/gpg.conf

# git
rm -f ~/.gitconfig
rm -f ~/.gitignore

# vim
rm -f ~/.vimrc
rm -f ~/.vim/bundle
rm -rf ~/.vim/backup
rm -rf ~/.vim/temp

# haskell
rm -f ~/.ghc/ghci.conf
rm -f ~/.cabal/config

# bin
rm -f ~/bin/backup
rm -f ~/bin/changeTag
rm -f ~/bin/convertImages
rm -f ~/bin/gitHelper
rm -f ~/bin/moveTmpMusic
rm -f ~/bin/organizeImages

rm -f ~/.config/redshift.conf
rm -f ~/.tmux.conf

rm -f ~/.irssi/config
rm -f ~/.irssi/furry.theme

echo "--- STOPPING ---"
