# Project: .dotfiles

## Project Description
Personal + work dotfiles repo. Sync config across all macOS machines.

## Purpose
Manage dev environment config via symlinks. Consistency across many macOS systems, single source of truth.

## Software Managed

See `README.md` for full software inventory; `install.sh` is canonical list. Items below shape how work happen in this repo:

- **1Password CLI (`op`)**: `make claude` read MCP secrets from `Private` vault
- **asdf**: Version manager for languages + tools (Node.js, Python, Ruby, etc.)
- **Claude Code**: Anthropic CLI for AI coding
- **Codex**: OpenAI terminal coding agent
- **Neovim**: Editor, Lua config
- **uv**: Python package runner (launch Docker MCP server via `uvx`)
- **Zsh + Oh-My-Zsh + Spaceship**: Shell env, custom prompt + plugins

## Conventions
- **Opinionated**: Personal repo, specific workflow preferences
- **Automated setup**: Make commands do all install + config
- **Symlink-based**: All configs symlinked from repo to expected locations
  - Repo change hit system instantly
  - No copying, no manual sync
- **Version controlled**: All config in Git. History + rollback.

## Setup Instructions

### Initial Installation
```bash
git clone https://github.com/Sgoettschkes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

### Post-Installation
1. Install asdf plugins + tools: `make asdf`
2. Import Rectangle settings from `rectangle/` folder manually
3. Set local SSH config in `~/.ssh/config.local` (not in Git)
4. Pick Nerd Font in iTerm2 (Preferences → Profiles → Text)
5. Set up Claude Code (symlinks + MCP servers): `make claude` (need 1Password CLI signed in)
6. Set up Codex (symlinks + MCP servers): `make codex`

### Maintenance Commands
- `make install` - Install/update dotfiles
- `make clean` - Remove all symlinks
- `make asdf` - Setup asdf plugins + tools
- `make asdf-clean` - Remove unused asdf installs
- `make claude` - Set up Claude Code: symlinks + MCP servers (need 1Password CLI signed in)
- `make codex` - Set up Codex: symlinks + MCP servers
- `make help` - Show all commands

## Folder Structure
- `/bin/` - Personal scripts, each symlinked into `~/.local/bin` (already on PATH) by `install.sh`. Drop new executable here, re-run `make install` — no per-script edit.
- `/asdf/` - asdf config + setup scripts
  - `setup.sh` - Install all asdf plugins
  - `cleanup.sh` - Remove unused plugin versions
  - `tool-versions` - Global tool versions (symlinked to `~/.tool-versions`)
- `/claude/` - Global Claude Code config
  - `CLAUDE.md` - Global instructions (symlinked to `~/.claude/CLAUDE.md`)
  - `setup.sh` - Symlink config + skills into `~/.claude`, register MCP servers (run via `make claude`)
  - `skills/` - Custom skills symlinked into `~/.claude/skills/`, all namespaced `sgoettschkes-<domain>-<action>`: `sgoettschkes-claude-unify-settings`, `sgoettschkes-cleft-process`, `sgoettschkes-dev-start-work`, `sgoettschkes-gtd-clear-inboxes`, `sgoettschkes-gtd-create-project`, `sgoettschkes-gtd-finish-project`, `sgoettschkes-gtd-sync-projects`, `sgoettschkes-gtd-weekly-review`, `sgoettschkes-log-post-eod`, `sgoettschkes-log-task`
- `/codex/` - Global Codex config
  - `AGENTS.md` - Global instructions (symlinked to `~/.codex/AGENTS.md`)
  - `setup.sh` - Symlink `AGENTS.md` into `~/.codex`, register MCP servers (run via `make codex`). `config.toml` machine-local (not tracked); Codex rewrite it at runtime.
- `/git/` - Git configs for different contexts
  - Includes org-specific gitconfig files
- `/neovim/` - Neovim config in Lua
- `/rectangle/` - Rectangle window manager settings
  - Must import manually through app
- `/ssh/` - SSH configs for various systems
  - Symlinked to `~/.ssh/config`
  - Local overrides via `~/.ssh/config.local`
- `/wallpapers/` - Desktop wallpapers (optional)
- `/zsh/` - Zsh config
  - `zshrc` - Main config (symlinked to `~/.zshrc`)
  - `zprofile` - Login shell profile (symlinked to `~/.zprofile`)
  - `spaceshiprc.zsh` - Spaceship prompt tweaks
  - `oh-my-zsh-custom/` - Oh My Zsh custom dir (git submodule, provide Spaceship theme)

## Important Files
- `install.sh` - Main install script. Sets up all symlinks + deps.
- `cleanup.sh` - Safely remove all symlinks made by install
- `Makefile` - Task runner
- `README.md` - Public repo docs
- `AGENTS.md` - Tool-agnostic instructions for any AI coding agent in this repo
- `CLAUDE.md` - Claude-specific instructions; defer to `AGENTS.md` for shared rules
- `.editorconfig` - Editor config for consistent style
- `.gitmodules` - Git submodule definitions (if any)

## Notes
- macOS-only. Tested only on macOS.
- Never commit local/private config (SSH keys, tokens, etc.)
- Repo follow "convention over configuration"