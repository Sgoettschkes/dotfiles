#!/bin/bash

BASEPATH=`pwd`

echo "--- STARTING ---"

# bash
rm -f ~/.aliases
rm -f ~/.bashrc
rm -f ~/.profile

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
chmod 764 $BASEPATH/bin/*

rm -f ~/.config/redshift.conf

echo "--- STOPPING ---"
