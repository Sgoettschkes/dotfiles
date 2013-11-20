#!/bin/bash

copy () {
    # Check if file exists; if so, backup it
    if [ -f $2 ]; then
        echo "File $2 exists; creating backup"
        mkdir -p ~/.dotfiles/backup/
        cp -f $2 ~/.dotfiles/backup/
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

BASEPATH=`pwd`

# bash
copy $BASEPATH/bash/bash_aliases ~/.bash_aliases
copy $BASEPATH/bash/bashrc ~/.bashrc

# git
copy $BASEPATH/git/gitconfig ~/.gitconfig
copy $BASEPATH/git/gitignore ~/.gitignore

# screen
copy $BASEPATH/screen/screenrc ~/.screenrc

# vim
copy $BASEPATH/vim/vimrc ~/.vimrc

# ghci
copy $BASEPATH/ghc/ghci.conf ~/.ghc/ghci.conf

# bin
copy $BASEPATH/bin/backup ~/bin/backup
copy $BASEPATH/bin/changeTag ~/bin/changeTag
chmod 744 ~/bin/*
