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

remove () {
    Target=$1
    if [ -z "$Target" ]; then
        error "Target not given"
        return
    fi

    if [ ! -e "$Target" ]; then
        error "Target does not exist"
        return
    fi

    if [ -d "$Target" ]; then
        rm -r $Target
        success "Dir $Target removed"
    else
        rm $Target
        success "File $Target removed"
    fi
}

# bash
remove ~/.aliases
remove ~/.bashrc
remove ~/.profile
remove ~/.inputrc
remove ~/.functionrc

# ssh
remove ~/.ssh/config

# xfce
remove ~/.config/xfce4/xinitrc
remove ~/.config/menus/xfce-applications.menu

# gnupg
remove ~/.gnupg/gpg.conf

# git
remove ~/.gitconfig
remove ~/.gitignore
remove ~/.git/git-prompt.sh

# vim
remove ~/.vimrc
rm -rf ~/.vim/bundle
rm -rf ~/.vim/backup
rm -rf ~/.vim/temp

# haskell
remove ~/.ghc/ghci.conf
remove ~/.cabal/config

# bin
remove ~/bin/backup
remove ~/bin/changeTag
remove ~/bin/convertImages
remove ~/bin/gitHelper
remove ~/bin/mon
remove ~/bin/moveTmpMusic
remove ~/bin/organizeImages

# tmux
remove ~/.tmux.conf

# irssi
remove ~/.irssi/config
remove ~/.irssi/furry.theme

# asunder
remove ~/.asunder

# apollo
remove ~/.apollo
