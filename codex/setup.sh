#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Sets up Codex: symlinks config, then registers MCP servers

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

GREEN='\033[0;32m'
RED='\033[0;31m'
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

if ! command -v codex &> /dev/null; then
    echo "Error: codex is not installed. Run 'make install' first."
    exit 1
fi

register() {
    local name=$1
    shift
    printf "  %s ... " "$name"
    if codex mcp get "$name" &> /dev/null; then
        printf "${GREEN}kept (already registered)${NC}\n"
        return 0
    fi
    if codex mcp add "$name" "$@" &> /dev/null; then
        printf "${GREEN}registered${NC}\n"
    else
        printf "${RED}failed${NC}\n"
        return 1
    fi
}

# No MCP servers configured yet. Add registrations below, e.g.:
#   register docker -- uvx mcp-server-docker
#   register nirvana --url https://mcp.nirvanahq.com/mcp

echo ""
echo -e "${GREEN}MCP setup complete.${NC}"
echo -e "${YELLOW}Restart Codex for the MCP servers to take effect.${NC}"
