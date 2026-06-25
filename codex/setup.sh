#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Registers Codex MCP servers

set -e

if ! command -v codex &> /dev/null; then
    echo "Error: codex is not installed. Run 'make install' first."
    exit 1
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
