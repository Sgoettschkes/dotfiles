# File managed by Sgoettschkes/dotfiles
# Do not change

# Development tools
alias dc='docker compose'
alias k=kubectl
alias m=mix

# File system
alias ..='cd ..'
alias ll='ls -aFhl'

# Git shortcuts

# Network utilities
alias myip='curl http://ipecho.net/plain; echo'

# Package updates
alias up_brew='brew update && brew upgrade'
alias up_bun='./_build/bun upgrade && ./_build/bun update'
alias up_mix='mix deps.update --all && mix hex.outdated'
alias up_npm='npm update && npx ncu'
alias up_yarn='yarn upgrade && yarn outdated'

# System utilities
alias cl=clear
