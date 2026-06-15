# Project: .dotfiles

## Project Description
My personal and professional dotfiles repository to sync configuration across all macOS machines.

## Purpose
This repository manages my development environment configuration through symlinks, ensuring consistency across multiple macOS systems while maintaining a single source of truth for all configurations.

## Software Managed
- **1Password CLI (`op`)**: Used by `make mcp` to read MCP secrets from the `Private` vault
- **asdf**: Version manager for programming languages and tools (Node.js, Python, Ruby, etc.)
- **Claude Code**: Anthropic CLI for AI-assisted coding
- **Docker Desktop**: Container runtime
- **Git**: Version control and collaboration
- **Homebrew**: Package manager for macOS software installation
- **iTerm2**: Terminal emulator of choice
- **Neovim**: Modern text editor with Lua configuration
- **Nerd Fonts**: FiraCode, JetBrainsMono, SauceCodePro
- **ngrok**: Secure tunnels to localhost
- **Obsidian**: Note-taking app
- **Rectangle**: Window management utility
- **ripgrep**: Fast recursive search tool
- **Spotify**: Music streaming client
- **tree-sitter CLI**: Parser builder required by nvim-treesitter
- **uv**: Python package runner (used to launch the Docker MCP server via `uvx`)
- **Zsh + Oh-My-Zsh + Spaceship**: Shell environment with custom prompt and plugins

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
4. Select a Nerd Font in iTerm2 (Preferences → Profiles → Text)
5. Register Claude Code MCP servers: `make mcp` (requires 1Password CLI signed in)

### Maintenance Commands
- `make install` - Run installation/update of dotfiles
- `make clean` - Remove all symlinks
- `make asdf` - Setup asdf plugins and tools
- `make asdf-clean` - Remove unused asdf installations
- `make mcp` - Register Claude Code MCP servers (requires 1Password CLI signed in)
- `make help` - Show all available commands

## Folder Structure
- `/asdf/` - asdf configuration and setup scripts
  - `setup.sh` - Script to install all asdf plugins
  - `cleanup.sh` - Script to remove unused plugin versions
  - `tool-versions` - Global tool versions configuration (symlinked to `~/.tool-versions`)
- `/claude/` - Global Claude Code configuration
  - `CLAUDE.md` - Global instructions (symlinked to `~/.claude/CLAUDE.md`)
  - `setup.sh` - Registers MCP servers with `claude mcp add` (run via `make mcp`)
  - `skills/` - Custom skills symlinked into `~/.claude/skills/` (e.g. `daily-notion-log`, `daily-obsidian-log`)
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
  - `zshrc` - Main configuration file (symlinked to `~/.zshrc`)
  - `zprofile` - Login shell profile (symlinked to `~/.zprofile`)
  - `spaceshiprc.zsh` - Spaceship prompt customizations
  - `oh-my-zsh-custom/` - Oh My Zsh custom directory (git submodule providing the Spaceship theme)

## Important Files
- `install.sh` - Main installation script that sets up all symlinks and dependencies
- `cleanup.sh` - Script to safely remove all symlinks created by installation
- `Makefile` - Task runner for common operations
- `README.md` - Public documentation for the repository
- `.editorconfig` - Editor configuration for consistent coding style
- `.gitmodules` - Git submodule definitions (if any)

## Dependencies
The installation script automatically installs:
- 1Password CLI (`op`, for `make mcp`)
- asdf version manager
- Claude Code
- Docker Desktop
- FiraCode Nerd Font
- Git
- Homebrew (if not present)
- iTerm2
- JetBrainsMono Nerd Font
- Neovim
- ngrok
- Obsidian
- Oh My Zsh
- Rectangle
- ripgrep (for fast searching)
- SauceCodePro Nerd Font
- Spotify
- tree-sitter CLI (required by nvim-treesitter to compile parsers)
- uv (Python package runner for `uvx`)

## Notes
- This configuration is macOS-specific and tested only on macOS systems
- Local/private configurations (SSH keys, tokens, etc.) should never be committed
- The repository follows a "convention over configuration" approach for simplicity
- The `/claude/` folder holds the global Claude Code instructions that get symlinked into `~/.claude/`. Treat them as configuration, not as code to analyze or refactor as part of repo work.