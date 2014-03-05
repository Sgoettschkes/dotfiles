#!/bin/bash

copy () {
    # Check if file exists; if so, delete
    if [ -f $2 ]; then
        echo "File $2 exists; Will be deleted"
        rm -f $2
    fi
    # Check if folder exists; if not, create it
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        echo "Folder $DIR does not exist; creating"
        mkdir -p $DIR
    fi
    # Copy file
    cp $1 $2
}

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
ENV=`uname -o`

echo "--- STARTING ---"
echo "Detected ENV: $ENV"

# bash
symlink $BASEPATH/bash/aliases ~/.aliases
symlink $BASEPATH/bash/bashrc ~/.bashrc
symlink $BASEPATH/bash/profile ~/.profile
source ~/.profile

# git
if [ $ENV == "Cygwin" ]; then
    copy $BASEPATH/git/gitconfig ~/.gitconfig
    copy $BASEPATH/git/gitignore ~/.gitignore
else
    symlink $BASEPATH/git/gitconfig ~/.gitconfig
    symlink $BASEPATH/git/gitignore ~/.gitignore
fi

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
