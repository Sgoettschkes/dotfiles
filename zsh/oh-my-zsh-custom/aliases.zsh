# File managed by Sgoettschkes/dotfiles
# Do not change

# Dir navigation
alias ..='cd ..'

# Some ls aliases
alias l='ls -CF'
alias la='ls -A'
alias lg='ls -alF | grep'
alias ll='ls -aFhl'

# Shortcuts
alias d=docker
alias dc='docker compose'
alias g=git

# Little helpers
alias cl=clear
alias cle='clear && pwd && ls -AFG'

# Advanced system tools
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias free='free -mt'
alias psx='ps aux | grep'
alias lef='less +F'

# Rest API stuff
alias myip='curl http://ipecho.net/plain; echo'

# git shortcuts
alias glt='git l `git describe --tags --abbrev=0`..HEAD'
