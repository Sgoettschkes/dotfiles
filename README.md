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
* tablepro

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

`make mcp` skips MCPs that are already registered (so HTTP/OAuth servers like Nirvana don't re-auth on every run). To force a re-register after editing the config or rotating a token: `claude mcp remove <name> -s user && make mcp`. Verify with `/mcp` in Claude Code.

### Claude Code plugins

Plugin config is split across two files because Claude Code honors the keys differently:

* **`claude/settings.json`** (tracked, symlinked to `~/.claude/settings.json`) holds `enabledPlugins`. This is the only file the enable toggle is read from — `enabledPlugins` in `settings.local.json` is silently ignored.
* **`~/.claude/settings.local.json`** (per machine, untracked) holds `extraKnownMarketplaces`, which registers where a plugin is fetched from.

Neither file fetches plugin code, and enabling a plugin whose files aren't installed is a harmless no-op. On a fresh machine, register the marketplace in `settings.local.json`, then install the files once for each plugin you want. Verify with `claude plugin list`.

#### elixir-phoenix

Elixir/Phoenix support, see [phxagents.dev](https://phxagents.dev/).

```bash
claude plugin marketplace add oliver-kriska/claude-elixir-phoenix
claude plugin install elixir-phoenix@oliver-kriska
```

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
