Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

A collection of my dotfiles; A list of the software I use; A set of instructions used to setup my environment

## Installation

Clone this repo into `~/.dotfiles` and run the installation:

```bash
git clone https://github.com/Sgoettschkes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

Or use the script directly: `./install.sh`

The installation script will automatically install:
- asdf
- Git
- Homebrew
- iTerm2 (macOS only)
- Neovim
- Oh My Zsh
- ripgrep
- tree-sitter CLI
- uv (Python package runner for `uvx`)

To remove all symlinks: `make clean`

## Additional Software

Also installed automatically via Homebrew (macOS only):

* 1Password CLI (`op`)
* claude-code
* docker (Docker Desktop)
* ngrok
* obsidian
* rectangle
* spotify

## Fonts

Also installed automatically via Homebrew (macOS only):

* [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip)
* [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
* [SauceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/SourceCodePro.zip)

## rectangle configuration

The rectangle configuration is stored in the `rectangle/` folder. It can be imported through the settings.

## Development environment

The installation script sets up symlinks for SSH, Zsh, Git, and asdf configurations.

### Local SSH configuration

You can put local ssh config (which should not be in git) in `~/.ssh/config.local`.

### Claude Code MCP servers

Register per machine with `make mcp`. Secrets are read from the `Private` 1Password vault via `op read`. Enable the 1Password app → Settings → Developer → **Integrate with 1Password CLI**, then `op whoami` to verify.

Each MCP is a `register` call in `claude/setup.sh`. Currently configured:

* **GitHub** — reads `Private / GitHub / mcp`
* **Docker** — `uvx mcp-server-docker`
* **Nirvana** — HTTP transport at `mcp.nirvanahq.com`
* **Obsidian** — `mcpvault` against the `~/Documents/Second Brain` vault
* **Chrome DevTools** — `chrome-devtools-mcp` for browser automation (requires Chrome installed separately)

Re-run `make mcp` after editing the script, rotating a token, or pulling new MCPs. Verify with `/mcp` in Claude Code.

### asdf

After running the installation script, install all asdf plugins and tools:

```bash
make asdf
```

**Note:** For Erlang/Elixir, check [prerequisites](https://github.com/asdf-vm/asdf-erlang#before-asdf-install) before running.

**Note:** For PHP, check [prerequisites](https://github.com/asdf-vm/asdf-php#before-asdf-install) before running.

**Note:** Lua 5.1 is used because it's the one needed by lazy neovim plugin manager

## License

MIT. Please see [LICENSE](LICENSE).
