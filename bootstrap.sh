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
copy $BASEPATH/bash/aliases ~/.aliases
copy $BASEPATH/bash/bashrc ~/.bashrc
copy $BASEPATH/bash/profile ~/.profile

# git
copy $BASEPATH/git/gitconfig ~/.gitconfig
copy $BASEPATH/git/gitignore ~/.gitignore

# vim
copy $BASEPATH/vim/vimrc ~/.vimrc
copy $BASEPATH/vim/solarized.vim ~/.vim/colors/solarized.vim
copy $BASEPATH/vim/supertab.vim ~/.vim/plugin/supertab.vim
copy $BASEPATH/vim/matchit.vim ~/.vim/plugin/matchit.vim
copy $BASEPATH/vim/searchcomplete.vim ~/.vim/plugin/searchcomplete.vim

# haskell
copy $BASEPATH/haskell/ghci.conf ~/.ghc/ghci.conf
copy $BASEPATH/haskell/cabal_config ~/.cabal/config

# bin
copy $BASEPATH/bin/changeTag ~/bin/changeTag
chmod 744 ~/bin/*

# config
copy $BASEPATH/config/redshift.conf ~/.config/redshift.conf
