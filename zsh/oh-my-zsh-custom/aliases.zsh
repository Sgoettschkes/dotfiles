# File managed by Sgoettschkes/dotfiles
# Do not change

# Dir navigation
alias ..='cd ..'

# Some ls aliases
alias ll='ls -aFhl'

# Shortcuts
alias dc='docker compose'

# Little helpers
alias cl=clear

# Deps update
alias up_brew='brew update && brew upgrade'
alias up_bun='./_build/bun upgrade && ./_build/bun update'
alias up_yarn='yarn upgrade && yarn outdated'
alias up_mix='mix deps.update --all && mix hex.outdated'
alias up_npm='npm update && npx ncu'

# Advanced system tools

# Rest API stuff
alias myip='curl http://ipecho.net/plain; echo'

# git shortcuts
alias glt='git l `git describe --tags --abbrev=0`..HEAD'
