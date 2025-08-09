#!/bin/bash

# File managed by Sgoettschkes/dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Installing dotfiles from ${DOTFILES_DIR}"
echo

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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Checking for Homebrew..."
if ! command_exists brew; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    # Using main branch instead of HEAD for more stability
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/main/install.sh)"

    # Add brew to PATH for the current session
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        # Linux
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    echo -e "${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

echo
echo "Installing git..."
if ! command_exists git; then
    echo -e "${YELLOW}Installing git via Homebrew...${NC}"
    brew install git
    echo -e "${GREEN}✓ git installed${NC}"
else
    echo -e "${GREEN}✓ git already installed${NC}"
fi

echo
echo "Installing asdf..."
if ! command_exists asdf; then
    echo -e "${YELLOW}Installing asdf via Homebrew...${NC}"
    brew install asdf
    echo -e "${GREEN}✓ asdf installed${NC}"
else
    echo -e "${GREEN}✓ asdf already installed${NC}"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo
    echo "Installing iTerm2..."
    if ! ls /Applications/iTerm.app >/dev/null 2>&1; then
        echo -e "${YELLOW}Installing iTerm2 via Homebrew...${NC}"
        brew install --cask iterm2
        echo -e "${GREEN}✓ iTerm2 installed${NC}"
    else
        echo -e "${GREEN}✓ iTerm2 already installed${NC}"
    fi
fi

echo
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
else
    echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
fi

echo
echo "Setting up Spaceship theme..."
echo -e "${YELLOW}Initializing git submodules...${NC}"
git -C "$DOTFILES_DIR" submodule update --init --recursive
echo -e "${GREEN}✓ Git submodules initialized${NC}"
create_symlink "$DOTFILES_DIR/zsh/spaceshiprc.zsh" "$HOME/.spaceshiprc.zsh"

echo
echo "Installing neovim..."
if ! command_exists nvim; then
    echo -e "${YELLOW}Installing neovim via Homebrew...${NC}"
    brew install neovim
    echo -e "${GREEN}✓ neovim installed${NC}"
else
    echo -e "${GREEN}✓ neovim already installed${NC}"
fi

echo
echo "Installing ripgrep..."
if ! command_exists rg; then
    echo -e "${YELLOW}Installing ripgrep via Homebrew...${NC}"
    brew install ripgrep
    echo -e "${GREEN}✓ ripgrep installed${NC}"
else
    echo -e "${GREEN}✓ ripgrep already installed${NC}"
fi

echo

echo "Setting up SSH configuration..."
mkdir -p ~/.ssh
create_symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
echo

echo "Setting up Zsh configuration..."
create_symlink "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
echo

echo "Setting up Git configuration..."

# Dynamically link all git files (except gitattributes which goes to .config/git)
for file in "$DOTFILES_DIR"/git/*; do
    filename=$(basename "$file")

    if [ "$filename" = "gitattributes" ]; then
        # Special case: gitattributes goes to .config/git/attributes
        mkdir -p ~/.config/git
        create_symlink "$file" "$HOME/.config/git/attributes"
    else
        # All other git files get a dot prefix in home directory
        create_symlink "$file" "$HOME/.${filename}"
    fi
done
echo

echo "Setting up neovim configuration..."
mkdir -p $HOME/.config/nvim
create_symlink "$DOTFILES_DIR/neovim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/neovim/lua" "$HOME/.config/nvim/lua"
echo

echo "Setting up asdf configuration..."
create_symlink "$DOTFILES_DIR/asdf/tool-versions" "$HOME/.tool-versions"
echo

# Final instructions
echo -e "${GREEN}✨ Dotfiles installation complete!${NC}"
echo
echo "Next steps:"
echo "2. Install asdf plugins by running: make asdf"
echo "3. Import Rectangle settings from: $DOTFILES_DIR/rectangle/config.json"
echo
echo -e "${YELLOW}Note: If any existing files were backed up, they have .backup extension${NC}"
