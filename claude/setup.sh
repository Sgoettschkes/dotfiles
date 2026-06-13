#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Registers Claude Code MCP servers, pulling secrets from 1Password

set -e

if ! command -v claude &> /dev/null; then
    echo "Error: claude is not installed. Run 'make install' first."
    exit 1
fi

if ! command -v op &> /dev/null; then
    echo "Error: 1Password CLI (op) is not installed. Run 'make install' first."
    exit 1
fi

if ! op whoami &> /dev/null; then
    echo "Signing in to 1Password..."
    eval "$(op signin)"
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

register() {
    local name=$1
    shift
    printf "  %s ... " "$name"
    claude mcp remove "$name" -s user &> /dev/null || true
    if claude mcp add "$name" -s user "$@" &> /dev/null; then
        printf "${GREEN}registered${NC}\n"
    else
        printf "${RED}failed${NC}\n"
        return 1
    fi
}

register github \
    --env "GITHUB_PERSONAL_ACCESS_TOKEN=$(op read 'op://Private/GitHub/mcp')" \
    -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

register docker -- uvx mcp-server-docker

register nirvana --transport http https://mcp.nirvanahq.com/mcp

echo ""
echo -e "${GREEN}MCP setup complete.${NC}"
echo -e "${YELLOW}Restart Claude Code for the MCP servers to take effect.${NC}"
