#!/bin/bash

create_link () {
    if [ ! -f $2 ]; then
        ln -s $1 $2
    fi
}

BASEPATH=`pwd`

# bash
create_link $BASEPATH/bash/bash_aliases ~/.bash_aliases
create_link $BASEPATH/bash/bashrc ~/.bashrc

# git
create_link $BASEPATH/git/gitconfig ~/.gitconfig
create_link $BASEPATH/git/gitignore ~/.gitignore

# vim
create_link $BASEPATH/vim/vimrc ~/.vimrc
