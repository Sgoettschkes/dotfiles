#!/bin/bash

set -o nounset
set -o errexit

success () {
    printf "\e[32m$1\e[39m\n"
}

warning () {
    printf "\e[33m$1\e[39m\n"
}

error () {
    printf "\e[31m$1\e[39m\n"
}

copy () {
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        warning "Folder $DIR created"
        mkdir -p $DIR
    fi
    
    cp -f $1 $2
    success "File $1 copied to $2"
}

copyDir () {
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        warning "Folder $DIR created"
        mkdir -p $DIR
    fi
    
    cp -rf $1 $2
    success "Folder $1 copied to $2"
}

THISENV=`expr substr $(uname -s) 1 6`
warning "Environment $THISENV detected"

if [ "$#" -ne 1 ] || [ "$1" != "--force" ]; then
    read -p "This will overwrite stuff in your ~! Ok? [Y/n]" yn
    if [ "$yn" != "Y" ]; then
        error "Didn't get permission to overwrite stuff. Aborting"
        exit
    fi
fi
warning "Will start to overwrite files now!"

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEPATH=`echo ~`

# bash
copy $BASEPATH/bash/aliases $HOMEPATH/.aliases
copy $BASEPATH/bash/bashrc $HOMEPATH/.bashrc
copy $BASEPATH/bash/profile $HOMEPATH/.profile
copy $BASEPATH/bash/inputrc $HOMEPATH/.inputrc
copy $BASEPATH/bash/functionrc $HOMEPATH/.functionrc

# ssh
copy $BASEPATH/ssh/config $HOMEPATH/.ssh/config

# xfce
copy $BASEPATH/xfce/xinitrc $HOMEPATH/.config/xfce4/xinitrc
copy $BASEPATH/xfce/xfce-applications.menu $HOMEPATH/.config/menus/xfce-applications.menu

# gnupg
copy $BASEPATH/gnupg/gpg.conf $HOMEPATH/.gnupg/gpg.conf

# git
copy $BASEPATH/git/gitconfig $HOMEPATH/.gitconfig
copy $BASEPATH/git/gitignore $HOMEPATH/.gitignore
copy $BASEPATH/git/git-prompt.sh $HOMEPATH/.git/git-prompt.sh

# vim
copy $BASEPATH/vim/vimrc $HOMEPATH/.vimrc
copyDir $BASEPATH/vim/bundle $HOMEPATH/.vim/
mkdir -p $HOMEPATH/.vim/backup/undo
mkdir -p $HOMEPATH/.vim/temp

# haskell
copy $BASEPATH/haskell/ghci.conf $HOMEPATH/.ghc/ghci.conf
# Special case for cabal because ~ needs to be replaced
rm $HOMEPATH/.cabal/config
cat $BASEPATH/haskell/cabal.config | sed "s#~#$HOME#" > $HOMEPATH/.cabal/config

# bin
copyDir $BASEPATH/bin/ $HOMEPATH/bin/
chmod 764 $BASEPATH/bin/*

# tmux
copy $BASEPATH/tmux/tmux.conf $HOMEPATH/.tmux.conf

# irssi
copy $BASEPATH/irssi/config $HOMEPATH/.irssi/config
copy $BASEPATH/irssi/furry.theme $HOMEPATH/.irssi/furry.theme

# asunder
copy $BASEPATH/asunder/asunder $HOMEPATH/.asunder

# apollo
copy $BASEPATH/apollo/apollo $HOMEPATH/.apollo