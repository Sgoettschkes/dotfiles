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

# xfce
rm -f ~/.config/xfce4/xinitrc
rm -f ~/.config/menus/xfce-applications.menu

# gnupg
rm -f ~/.gnupg/gpg.conf

# git
rm -f ~/.gitconfig
rm -f ~/.gitignore
rm -f ~/.git/git-prompt.sh

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
rm -f ~/bin/mon
rm -f ~/bin/moveTmpMusic
rm -f ~/bin/organizeImages

rm -f ~/.tmux.conf

rm -f ~/.irssi/config
rm -f ~/.irssi/furry.theme

rm -f ~/.asunder

echo "--- STOPPING ---"
