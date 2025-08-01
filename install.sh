#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Installation script for dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Installing dotfiles from ${DOTFILES_DIR}"
echo

# Function to create symlink with backup
create_symlink() {
    local source=$1
    local target=$2
    
    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}⚠️  Backing up existing $target to $target.backup${NC}"
        mv "$target" "$target.backup"
    fi
    
    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create the symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Linked $source -> $target${NC}"
}

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew is not installed. Please install it first:${NC}"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}❌ Oh My Zsh is not installed. Please install it first:${NC}"
    echo "   sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites met${NC}"
echo

# SSH configuration
echo "Setting up SSH configuration..."
mkdir -p ~/.ssh
create_symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
echo

# Zsh configuration
echo "Setting up Zsh configuration..."
create_symlink "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
echo

# Git configuration
echo "Setting up Git configuration..."
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/gitconfig_agileaddicts" "$HOME/.gitconfig_agileaddicts"
create_symlink "$DOTFILES_DIR/git/gitconfig_mateogrando" "$HOME/.gitconfig_mateogrando"
create_symlink "$DOTFILES_DIR/git/gitconfig_workera" "$HOME/.gitconfig_workera"
create_symlink "$DOTFILES_DIR/git/gitignore" "$HOME/.gitignore"

# Create git attributes directory and symlink
mkdir -p ~/.config/git
create_symlink "$DOTFILES_DIR/git/gitattributes" "$HOME/.config/git/attributes"
echo

# asdf configuration
echo "Setting up asdf configuration..."
create_symlink "$DOTFILES_DIR/asdf/tool-versions" "$HOME/.tool-versions"
echo

# Final instructions
echo -e "${GREEN}✨ Dotfiles installation complete!${NC}"
echo
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Install asdf plugins by running: ./asdf/setup.sh"
echo "3. Import Rectangle settings from: $DOTFILES_DIR/rectangle/config.json"
echo
echo -e "${YELLOW}Note: If any existing files were backed up, they have .backup extension${NC}"