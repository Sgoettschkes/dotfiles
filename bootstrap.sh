#!/bin/bash

set -o nounset
set -o errexit

readonly Progname=$(basename "$0")
readonly Progdir=$(readlink -m $(dirname "$0"))
readonly Args="$@"

readonly Homepath=`echo ~`

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
for p in $Args; do
    case "$p" in
        "--force") FORCE=true ;;
        *) error "Unkown parameter \"$p\" passed"; exit;;
    esac
done;

#
# Check with user if he really want's to overwrite
#

if ! $FORCE; then
    read -p "This will overwrite stuff in your ~! Ok? [Y/n] " yn
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
copy $Progdir/apollo/apollo $Homepath/.apollo

# asunder
copy $Progdir/asunder/asunder $Homepath/.asunder

# bash
copy $Progdir/bash/aliases $Homepath/.aliases
copy $Progdir/bash/bashrc $Homepath/.bashrc
copy $Progdir/bash/profile $Homepath/.profile
copy $Progdir/bash/inputrc $Homepath/.inputrc
copy $Progdir/bash/functionrc $Homepath/.functionrc

# bin
copy $Progdir/bin/ $Homepath/bin/
chmod 764 $Homepath/bin/*

# git
copy $Progdir/git/gitconfig $Homepath/.gitconfig
copy $Progdir/git/gitignore $Homepath/.gitignore
copy $Progdir/git/git-prompt.sh $Homepath/.git/git-prompt.sh

# gnupg
copy $Progdir/gnupg/gpg.conf $Homepath/.gnupg/gpg.conf

# haskell (Special case for cabal because ~ needs to be replaced)
copy $Progdir/haskell/ghci.conf $Homepath/.ghc/ghci.conf
rm -f $Homepath/.cabal/config
mkdir -p $Homepath/.cabal
cat $Progdir/haskell/cabal.config | sed "s#~#$HOME#" > $Homepath/.cabal/config

# irssi
copy $Progdir/irssi/config $Homepath/.irssi/config
copy $Progdir/irssi/furry.theme $Homepath/.irssi/furry.theme

# ssh
copy $Progdir/ssh/config $Homepath/.ssh/config

# tmux
copy $Progdir/tmux/tmux.conf $Homepath/.tmux.conf

# vim (Create dirs for vim to store stuff)
copy $Progdir/vim/vimrc $Homepath/.vimrc
copy $Progdir/vim/bundle $Homepath/.vim/bundle
mkdir -p $Homepath/.vim/backup/undo
mkdir -p $Homepath/.vim/temp

# xfce
copy $Progdir/xfce/xinitrc $Homepath/.config/xfce4/xinitrc
copy $Progdir/xfce/xfce-applications.menu $Homepath/.config/menus/xfce-applications.menu
copy $Progdir/xfce/Xmodmap $Homepath/.Xmodmap
