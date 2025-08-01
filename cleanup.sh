#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Cleanup script to remove dotfile symlinks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🧹 Dotfiles cleanup script"
echo
echo -e "${RED}WARNING: This will remove all dotfile symlinks!${NC}"
echo "This will NOT delete your dotfiles repository."
echo
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo
echo "Removing symlinks..."

# Function to safely remove symlink
remove_symlink() {
    local target=$1
    local name=$2
    
    if [ -L "$target" ]; then
        rm -f "$target"
        echo -e "${GREEN}✓ Removed ${name}${NC}"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}⚠️  ${name} exists but is not a symlink, skipping${NC}"
    else
        echo -e "  ${name} not found, skipping"
    fi
}

# SSH configuration
echo "Cleaning SSH configuration..."
remove_symlink "$HOME/.ssh/config" "SSH config"
echo

# Zsh configuration
echo "Cleaning Zsh configuration..."
remove_symlink "$HOME/.zprofile" ".zprofile"
remove_symlink "$HOME/.zshrc" ".zshrc"
echo

# Git configuration
echo "Cleaning Git configuration..."
# Remove all .gitconfig* files that are symlinks
for file in ~/.gitconfig*; do
    if [ -L "$file" ]; then
        filename=$(basename "$file")
        remove_symlink "$file" "$filename"
    fi
done
remove_symlink "$HOME/.gitignore" ".gitignore"
remove_symlink "$HOME/.config/git/attributes" "git attributes"
echo

# asdf configuration
echo "Cleaning asdf configuration..."
remove_symlink "$HOME/.tool-versions" ".tool-versions"
echo

echo -e "${GREEN}✨ Cleanup complete!${NC}"
echo
echo "Your dotfiles repository at ~/.dotfiles is still intact."
echo "To reinstall, run: make install"