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

    if [ ! -e $Target ]; then
        error "Target does not exist"
        return
    fi

    if [ -e $Target ]; then
        rm -r $Target
        success "Dir $Target removed"
    else
        rm $Target
        success "File $Target removed"
    fi
}

# bash
remove ~/.aliases
rm -f ~/.bashrc
rm -f ~/.profile
rm -f ~/.inputrc
rm -f ~/.functionrc

# ssh
rm -f ~/.ssh/config

# xfce
rm -f ~/.config/xfce4/xinitrc
rm -f ~/.config/menus/xfce-applications.menu

# gnupg
rm -f ~/.gnupg/gpg.conf

# git
rm -f ~/.gitconfig
rm -f ~/.gitignore
rm -f ~/.git/git-prompt.sh

# vim
rm -f ~/.vimrc
rm -rf ~/.vim/bundle
rm -rf ~/.vim/backup
rm -rf ~/.vim/temp

# haskell
rm -f ~/.ghc/ghci.conf
rm -f ~/.cabal/config

# bin
rm -f ~/bin/backup
rm -f ~/bin/changeTag
rm -f ~/bin/convertImages
rm -f ~/bin/gitHelper
rm -f ~/bin/mon
rm -f ~/bin/moveTmpMusic
rm -f ~/bin/organizeImages

# tmux
rm -f ~/.tmux.conf

# irssi
rm -f ~/.irssi/config
rm -f ~/.irssi/furry.theme

# asunder
rm -f ~/.asunder

# apollo
rm -f ~/.apollo
