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

BASEPATH=`pwd`

echo "--- STARTING ---"

# bash
symlink $BASEPATH/bash/aliases ~/.aliases
symlink $BASEPATH/bash/bashrc ~/.bashrc
symlink $BASEPATH/bash/profile ~/.profile
source ~/.profile

# git
symlink $BASEPATH/git/gitconfig ~/.gitconfig
symlink $BASEPATH/git/gitignore ~/.gitignore

# vim
symlink $BASEPATH/vim/vimrc ~/.vimrc
symlink $BASEPATH/vim/bundle ~/.vim/bundle

# haskell
symlink $BASEPATH/haskell/ghci.conf ~/.ghc/ghci.conf
symlink $BASEPATH/haskell/cabal_config ~/.cabal/config

# bin
symlink $BASEPATH/bin/changeTag ~/bin/changeTag
chmod 744 $BASEPATH/bin/*

# config
symlink $BASEPATH/config/redshift.conf ~/.config/redshift.conf

echo "--- STOPPING ---"
