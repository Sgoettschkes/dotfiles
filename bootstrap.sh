#!/bin/bash

create_link () {
    if [ ! -f $2 ]; then
        ln -s $1 $2
    fi
}

BASEPATH=`pwd`

create_link $BASEPATH/git/gitconfig ~/.gitconfig
create_link $BASEPATH/git/gitignore ~/.gitignore
