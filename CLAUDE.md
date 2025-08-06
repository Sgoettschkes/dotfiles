# Project: .dotfiles

## Project Description
My personal and professional dotfiles repository to sync configuration across all macOS machines.

## Purpose
This repository manages my development environment configuration through symlinks, ensuring consistency across multiple macOS systems while maintaining a single source of truth for all configurations.

## Software Managed
- **Homebrew**: Package manager for macOS software installation
- **Git**: Version control and collaboration
- **asdf**: Version manager for programming languages and tools (Node.js, Python, Ruby, etc.)
- **iTerm2**: Terminal emulator of choice
- **Zsh + Oh-My-Zsh + Spaceship**: Shell environment with custom prompt and plugins
- **Neovim**: Modern text editor with Lua configuration
- **Rectangle**: Window management utility

## Conventions
- **Opinionated**: This is my personal dotfiles repository with specific workflow preferences
- **Automated setup**: Make commands handle all installation and configuration steps
- **Symlink-based**: All configurations are symlinked from this repository to their expected locations
  - Changes in the repo are immediately reflected in the system
  - No file copying or manual synchronization needed
- **Version controlled**: All configurations tracked in Git for history and rollback capability

## Setup Instructions

### Initial Installation
```bash
git clone https://github.com/Sgoettschkes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

### Post-Installation
1. Install asdf plugins and tools: `make asdf`
2. Import Rectangle settings from `rectangle/` folder manually
3. Configure local SSH settings in `~/.ssh/config.local` (not tracked in Git)

### Maintenance Commands
- `make install` - Run installation/update of dotfiles
- `make clean` - Remove all symlinks
- `make asdf` - Setup asdf plugins and tools
- `make asdf-clean` - Remove unused asdf installations
- `make help` - Show all available commands

## Folder Structure
- `/asdf/` - asdf configuration and setup scripts
  - `setup.sh` - Script to install all asdf plugins
  - `cleanup.sh` - Script to remove unused plugin versions
  - `.tool-versions` - Global tool versions configuration
- `/git/` - Git configurations for different contexts
  - Includes organization-specific gitconfig files
- `/neovim/` - Neovim configuration using Lua
- `/rectangle/` - Rectangle window manager settings
  - Configuration must be imported manually through the app
- `/ssh/` - SSH configurations for various systems
  - Symlinked to `~/.ssh/config`
  - Supports local overrides via `~/.ssh/config.local`
- `/wallpapers/` - Desktop wallpaper images (optional)
- `/zsh/` - Zsh shell configuration
  - `.zshrc` - Main configuration file
  - Custom functions and aliases
  - Spaceship prompt customizations

## Important Files
- `install.sh` - Main installation script that sets up all symlinks and dependencies
- `cleanup.sh` - Script to safely remove all symlinks created by installation
- `Makefile` - Task runner for common operations
- `README.md` - Public documentation for the repository
- `.editorconfig` - Editor configuration for consistent coding style
- `.gitmodules` - Git submodule definitions (if any)

## Dependencies
The installation script automatically installs:
- Homebrew (if not present)
- Git
- asdf version manager
- iTerm2
- Oh My Zsh
- Neovim
- ripgrep (for fast searching)

Additional software can be installed via Homebrew as needed (e.g., Docker, Rectangle).

## Notes
- This configuration is macOS-specific and tested only on macOS systems
- Local/private configurations (SSH keys, tokens, etc.) should never be committed
- The repository follows a "convention over configuration" approach for simplicity