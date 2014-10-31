#!/bin/bash

symlink () {
    # Check if target exists
    if [ -e $2 ]; then
        if [ "$(readlink $2)" == "$1" ]; then
            echo "Target $2 already in place"
        else
            echo "Target $2 exists; Aborting"
        fi
        return
    fi
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        echo "Folder $DIR does not exist; creating"
        mkdir -p $DIR
    fi
    ln -s $1 $2
    echo "Symlink $2 for target $1 created"
}

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "--- STARTING ---"

# bash
symlink $BASEPATH/bash/aliases ~/.aliases
symlink $BASEPATH/bash/bashrc ~/.bashrc
symlink $BASEPATH/bash/profile ~/.profile
symlink $BASEPATH/bash/inputrc ~/.inputrc
symlink $BASEPATH/bash/functionrc ~/.functionrc

# ssh
symlink $BASEPATH/ssh/config ~/.ssh/config

# xfce
symlink $BASEPATH/xfce/xinitrc ~/.config/xfce4/xinitrc

# gnupg
symlink $BASEPATH/gnupg/gpg.conf ~/.gnupg/gpg.conf

# git
symlink $BASEPATH/git/gitconfig ~/.gitconfig
symlink $BASEPATH/git/gitignore ~/.gitignore
symlink $BASEPATH/git/git-prompt.sh ~/.git/git-prompt.sh

# vim
symlink $BASEPATH/vim/vimrc ~/.vimrc
symlink $BASEPATH/vim/bundle ~/.vim/bundle
mkdir -p ~/.vim/backup/undo
mkdir -p ~/.vim/temp

# haskell
symlink $BASEPATH/haskell/ghci.conf ~/.ghc/ghci.conf
symlink $BASEPATH/haskell/cabal_config ~/.cabal/config

# bin
symlink $BASEPATH/bin/backup ~/bin/backup
symlink $BASEPATH/bin/changeTag ~/bin/changeTag
symlink $BASEPATH/bin/convertImages ~/bin/convertImages
symlink $BASEPATH/bin/gitHelper ~/bin/gitHelper
symlink $BASEPATH/bin/moveTmpMusic ~/bin/moveTmpMusic
symlink $BASEPATH/bin/organizeImages ~/bin/organizeImages
chmod 764 $BASEPATH/bin/*

# tmux
symlink $BASEPATH/tmux/tmux.conf ~/.tmux.conf

# irssi
symlink $BASEPATH/irssi/config ~/.irssi/config
symlink $BASEPATH/irssi/furry.theme ~/.irssi/furry.theme

# asunder
symlink $BASEPATH/asunder/asunder ~/.asunder

echo "--- STOPPING ---"
