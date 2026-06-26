#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Sets up Claude Code: symlinks config + skills, then registers MCP servers

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

echo "Setting up Claude configuration..."
mkdir -p "$HOME/.claude"
create_symlink "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
create_symlink "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude/skills"
create_symlink "$DOTFILES_DIR/claude/skills/daily-notion-log" "$HOME/.claude/skills/daily-notion-log"
create_symlink "$DOTFILES_DIR/claude/skills/daily-obsidian-log" "$HOME/.claude/skills/daily-obsidian-log"
create_symlink "$DOTFILES_DIR/claude/skills/do-dev-work" "$HOME/.claude/skills/do-dev-work"
create_symlink "$DOTFILES_DIR/claude/skills/eod-slack-post" "$HOME/.claude/skills/eod-slack-post"
create_symlink "$DOTFILES_DIR/claude/skills/para-clear-inboxes" "$HOME/.claude/skills/para-clear-inboxes"
create_symlink "$DOTFILES_DIR/claude/skills/para-finish-project" "$HOME/.claude/skills/para-finish-project"
create_symlink "$DOTFILES_DIR/claude/skills/para-sync-projects" "$HOME/.claude/skills/para-sync-projects"
create_symlink "$DOTFILES_DIR/claude/skills/unify-claude-settings" "$HOME/.claude/skills/unify-claude-settings"
echo

if ! command -v claude &> /dev/null; then
    echo "Error: claude is not installed. Run 'make install' first."
    exit 1
fi

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

register nirvana --transport http https://mcp.nirvanahq.com/mcp

register chrome-devtools -- npx chrome-devtools-mcp@latest

echo ""
echo -e "${GREEN}MCP setup complete.${NC}"
echo -e "${YELLOW}Restart Claude Code for the MCP servers to take effect.${NC}"
echo -e "${YELLOW}To force a re-register (after editing config or rotating secrets):${NC}"
echo -e "${YELLOW}  claude mcp remove <name> -s user && make claude${NC}"
