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

THISENV=`expr substr $(uname -s) 1 6`
warning "Environment $THISENV detected"

manage () {
    if [ "$THISENV" == "CYGWIN" ]; then
        copy $1 $2
    else 
        symlink $1 $2
    fi
}

copy () {
    if [ -e $2 ]; then
        error "Target $2 exists; Aborting"
        return
    fi
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        warning "Folder $DIR does not exist; creating"
        mkdir -p $DIR
    fi
    cp -r $1 $2
    success "Copy $2 for target $1 created"
}

symlink () {
    # Check if target exists
    if [ -e $2 ]; then
        if [ "$(readlink $2)" == "$1" ]; then
            success "Target $2 already in place"
        else
            error "Target $2 exists; Aborting"
        fi
        return
    fi
    DIR=`dirname $2`
    if [ ! -d $DIR ]; then
        warning "Folder $DIR does not exist; creating"
        mkdir -p $DIR
    fi
    ln -s $1 $2
    success "Symlink $2 for target $1 created"
}

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
manage $BASEPATH/bash/aliases ~/.aliases
manage $BASEPATH/bash/bashrc ~/.bashrc
manage $BASEPATH/bash/profile ~/.profile
manage $BASEPATH/bash/inputrc ~/.inputrc
manage $BASEPATH/bash/functionrc ~/.functionrc

# ssh
manage $BASEPATH/ssh/config ~/.ssh/config

# xfce
manage $BASEPATH/xfce/xinitrc ~/.config/xfce4/xinitrc
manage $BASEPATH/xfce/xfce-applications.menu ~/.config/menus/xfce-applications.menu

# gnupg
manage $BASEPATH/gnupg/gpg.conf ~/.gnupg/gpg.conf

# git
manage $BASEPATH/git/gitconfig ~/.gitconfig
manage $BASEPATH/git/gitignore ~/.gitignore
manage $BASEPATH/git/git-prompt.sh ~/.git/git-prompt.sh

# vim
manage $BASEPATH/vim/vimrc ~/.vimrc
manage $BASEPATH/vim/bundle ~/.vim/bundle
mkdir -p ~/.vim/backup/undo
mkdir -p ~/.vim/temp

# haskell
manage $BASEPATH/haskell/ghci.conf ~/.ghc/ghci.conf
# Special case for cabal because ~ needs to be replaced
rm ~/.cabal/config
cat $BASEPATH/haskell/cabal_config | sed "s#~#$HOME#" > ~/.cabal/config

# bin
manage $BASEPATH/bin/backup ~/bin/backup
manage $BASEPATH/bin/changeTag ~/bin/changeTag
manage $BASEPATH/bin/convertImages ~/bin/convertImages
manage $BASEPATH/bin/gitHelper ~/bin/gitHelper
manage $BASEPATH/bin/mon ~/bin/mon
manage $BASEPATH/bin/moveTmpMusic ~/bin/moveTmpMusic
manage $BASEPATH/bin/organizeImages ~/bin/organizeImages
chmod 764 $BASEPATH/bin/*

# tmux
manage $BASEPATH/tmux/tmux.conf ~/.tmux.conf

# irssi
manage $BASEPATH/irssi/config ~/.irssi/config
manage $BASEPATH/irssi/furry.theme ~/.irssi/furry.theme

# asunder
manage $BASEPATH/asunder/asunder ~/.asunder

# apollo
manage $BASEPATH/apollo/apollo ~/.apollo
