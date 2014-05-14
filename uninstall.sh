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
rm -rf ~/.vimrc
rm -rf ~/.vim

# haskell
rm -rf ~/.ghc
rm -rf ~/.cabal

# bin
rm -rf ~/bin

rm -rf ~/.config
rm -f ~/.tmux.conf

rm -rf ~/.irssi

echo "--- STOPPING ---"
