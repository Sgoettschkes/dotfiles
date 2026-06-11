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

register() {
    local name=$1
    shift
    echo "Registering MCP: $name"
    claude mcp remove "$name" -s user 2>/dev/null || true
    claude mcp add "$name" -s user "$@"
}

register github \
    --env "GITHUB_PERSONAL_ACCESS_TOKEN=$(op read 'op://Private/GitHub/mcp')" \
    -- npx -y @modelcontextprotocol/server-github

echo "MCP setup complete."
