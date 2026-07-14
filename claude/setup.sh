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
# Claude state (history, sessions, projects) is owner-only sensitive
chmod 700 "$HOME/.claude"
create_symlink "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
create_symlink "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude/skills"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-log-notion" "$HOME/.claude/skills/sgoettschkes-log-notion"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-log-obsidian" "$HOME/.claude/skills/sgoettschkes-log-obsidian"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-dev-start-work" "$HOME/.claude/skills/sgoettschkes-dev-start-work"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-log-eod-slack" "$HOME/.claude/skills/sgoettschkes-log-eod-slack"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-gtd-clear-inboxes" "$HOME/.claude/skills/sgoettschkes-gtd-clear-inboxes"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-gtd-create-project" "$HOME/.claude/skills/sgoettschkes-gtd-create-project"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-gtd-finish-project" "$HOME/.claude/skills/sgoettschkes-gtd-finish-project"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-gtd-sync-projects" "$HOME/.claude/skills/sgoettschkes-gtd-sync-projects"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-gtd-weekly-review" "$HOME/.claude/skills/sgoettschkes-gtd-weekly-review"
create_symlink "$DOTFILES_DIR/claude/skills/sgoettschkes-claude-unify-settings" "$HOME/.claude/skills/sgoettschkes-claude-unify-settings"
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

register chrome-devtools -- npx chrome-devtools-mcp@1.4.0

echo ""
echo -e "${GREEN}MCP setup complete.${NC}"
echo -e "${YELLOW}Restart Claude Code for the MCP servers to take effect.${NC}"
echo -e "${YELLOW}To force a re-register (after editing config or rotating secrets):${NC}"
echo -e "${YELLOW}  claude mcp remove <name> -s user && make claude${NC}"
echo
echo "Install plugins by hand if not already installed (see README → Claude Code plugins):"
echo "  claude plugin marketplace add oliver-kriska/claude-elixir-phoenix"
echo "  claude plugin install elixir-phoenix@oliver-kriska"
