#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Sets up Codex: symlinks config and AGENTS.md into ~/.codex

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

create_symlink() {
    local source=$1
    local target=$2

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}⚠️  Backing up existing $target to $target.backup${NC}"
        mv "$target" "$target.backup"
    fi
    if [ -L "$target" ]; then
        rm "$target"
    fi
    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Linked $source -> $target${NC}"
}

echo "Setting up Codex configuration..."
mkdir -p "$HOME/.codex"
create_symlink "$DOTFILES_DIR/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
create_symlink "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/config.toml"
echo

echo -e "${GREEN}Codex setup complete.${NC}"
