#!/bin/bash
set -o nounset
set -o errexit

# Helpers for printing stuff
success () { printf "\e[32m$1\e[39m\n"; }
warning () { printf "\e[33m$1\e[39m\n"; }
error () { printf "\e[31m$1\e[39m\n"; }

remove () {
    if [ "$#" -ne 1 ]; then
        error "Target not given"
        return
    fi
    
    local readonly Target=$1

    if [ ! -e "$Target" ]; then
        error "Target $Target does not exist"
        return
    fi

    rm -rf $Target
    success "Target $Target removed"
}

# apollo
remove ~/.apollo

# asunder
remove ~/.asunder

# bash
remove ~/.aliases
remove ~/.bashrc
remove ~/.profile
remove ~/.inputrc
remove ~/.functionrc

# bin
remove ~/bin

# git
remove ~/.gitconfig
remove ~/.gitignore
remove ~/.git/git-prompt.sh

# gnupg
remove ~/.gnupg/gpg.conf

# haskell
remove ~/.ghc/ghci.conf
remove ~/.cabal/config

# irssi
remove ~/.irssi/config
remove ~/.irssi/furry.theme

# ssh
remove ~/.ssh/config

# tmux
remove ~/.tmux.conf

# vim
remove ~/.vimrc
remove ~/.vim/bundle
remove ~/.vim/backup
remove ~/.vim/temp

# xfce
remove ~/.config/xfce4/xinitrc
remove ~/.config/menus/xfce-applications.menu