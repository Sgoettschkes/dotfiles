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

# git
rm -f ~/.gitconfig
rm -f ~/.gitignore

# vim
rm -f ~/.vimrc
rm -f ~/.vim/bundle

# haskell
rm -f ~/.ghc/ghci.conf
rm -f ~/.cabal/config

# bin
rm -f ~/bin/changeTag
rm -f ~/bin/gitHelper

rm -f ~/.config/redshift.conf
rm -f ~/.tmux.conf

rm -f ~/.irssi/config
rm -f ~/.irssi/furry.theme

echo "--- STOPPING ---"
