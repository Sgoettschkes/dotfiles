#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Registers Claude Code MCP servers, pulling secrets from 1Password

set -e

if ! command -v claude &> /dev/null; then
    echo "Error: claude is not installed. Run 'make install' first."
    exit 1
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1Password signin is deferred until an op-using MCP actually needs to register.
# This keeps steady-state runs free of macOS TCC prompts triggered by op<->1Password XPC.
ensure_op_signed_in() {
    if ! command -v op &> /dev/null; then
        echo "Error: 1Password CLI (op) is not installed. Run 'make install' first."
        exit 1
    fi
    if ! op whoami &> /dev/null; then
        echo "Signing in to 1Password..."
        eval "$(op signin)"
    fi
}

register() {
    local name=$1
    shift
    printf "  %s ... " "$name"
    if claude mcp get "$name" &> /dev/null; then
        printf "${GREEN}kept (already registered)${NC}\n"
        return 0
    fi
    if claude mcp add "$name" -s user "$@" &> /dev/null; then
        printf "${GREEN}registered${NC}\n"
    else
        printf "${RED}failed${NC}\n"
        return 1
    fi
}

if claude mcp get github &> /dev/null; then
    printf "  github ... ${GREEN}kept (already registered)${NC}\n"
else
    ensure_op_signed_in
    register github \
        --env "GITHUB_PERSONAL_ACCESS_TOKEN=$(op read 'op://Private/GitHub/mcp')" \
        -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
fi

register docker -- uvx mcp-server-docker

register nirvana --transport http https://mcp.nirvanahq.com/mcp

register obsidian -- npx @bitbonsai/mcpvault@latest "$HOME/Documents/Second Brain"

register chrome-devtools -- npx chrome-devtools-mcp@latest

echo ""
echo -e "${GREEN}MCP setup complete.${NC}"
echo -e "${YELLOW}Restart Claude Code for the MCP servers to take effect.${NC}"
echo -e "${YELLOW}To force a re-register (after editing config or rotating secrets):${NC}"
echo -e "${YELLOW}  claude mcp remove <name> -s user && make claude${NC}"
