#!/bin/bash

set -o nounset
set -o errexit

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEPATH=`echo ~`

# Helpers for printing stuff
success () { printf "\e[32m$1\e[39m\n"; }
warning () { printf "\e[33m$1\e[39m\n"; }
error () { printf "\e[31m$1\e[39m\n"; }

#
# Main functions to handle copying
#

copy () {
    if [ "$#" -ne 2 ]; then
        error "Src and/or Dest missing"
        return
    fi
    local readonly Src=$1
    local readonly Dest=$2
    local readonly Dir=`dirname $Dest`
    if [ ! -d $Dir ]; then
        mkdir -p $Dir
        success "Folder $Dir created"
    fi
    
    rm -rf $Dest
    cp -r $Src $Dest
    success "Source $Src copied to Destination $Dest"
}

#
# Read the parameters
#

FORCE=false
for p in $*; do
    case "$p" in
        "--force") FORCE=true ;;
        *) error "Unkown parameter \"$p\" passed"; exit ;;
    esac
done;

#
# Check with user if he really want's to overwrite
#

if ! $FORCE; then
    read -p "This will overwrite stuff in your ~! Ok? [Y/n]" yn
    if [ "$yn" != "Y" ]; then
        error "Didn't get permission to overwrite stuff. Aborting"
        exit
    fi
fi
warning "Will start to overwrite files now!"

#
# Let's do some magic 
#

# apollo
copy $BASEPATH/apollo/apollo $HOMEPATH/.apollo

# asunder
copy $BASEPATH/asunder/asunder $HOMEPATH/.asunder

# bash
copy $BASEPATH/bash/aliases $HOMEPATH/.aliases
copy $BASEPATH/bash/bashrc $HOMEPATH/.bashrc
copy $BASEPATH/bash/profile $HOMEPATH/.profile
copy $BASEPATH/bash/inputrc $HOMEPATH/.inputrc
copy $BASEPATH/bash/functionrc $HOMEPATH/.functionrc

# bin
copy $BASEPATH/bin/ $HOMEPATH/bin/
chmod 764 $HOMEPATH/bin/*

# git
copy $BASEPATH/git/gitconfig $HOMEPATH/.gitconfig
copy $BASEPATH/git/gitignore $HOMEPATH/.gitignore
copy $BASEPATH/git/git-prompt.sh $HOMEPATH/.git/git-prompt.sh

# gnupg
copy $BASEPATH/gnupg/gpg.conf $HOMEPATH/.gnupg/gpg.conf

# haskell (Special case for cabal because ~ needs to be replaced)
copy $BASEPATH/haskell/ghci.conf $HOMEPATH/.ghc/ghci.conf
rm -f $HOMEPATH/.cabal/config
cat $BASEPATH/haskell/cabal.config | sed "s#~#$HOME#" > $HOMEPATH/.cabal/config

# irssi
copy $BASEPATH/irssi/config $HOMEPATH/.irssi/config
copy $BASEPATH/irssi/furry.theme $HOMEPATH/.irssi/furry.theme

# ssh
copy $BASEPATH/ssh/config $HOMEPATH/.ssh/config

# tmux
copy $BASEPATH/tmux/tmux.conf $HOMEPATH/.tmux.conf

# vim (Create dirs for vim to store stuff)
copy $BASEPATH/vim/vimrc $HOMEPATH/.vimrc
copy $BASEPATH/vim/bundle $HOMEPATH/.vim/bundle
mkdir -p $HOMEPATH/.vim/backup/undo
mkdir -p $HOMEPATH/.vim/temp

# xfce
copy $BASEPATH/xfce/xinitrc $HOMEPATH/.config/xfce4/xinitrc
copy $BASEPATH/xfce/xfce-applications.menu $HOMEPATH/.config/menus/xfce-applications.menu
copy $BASEPATH/xfce/Xmodmap $HOMEPATH/.Xmodmap
