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
- GitHub CLI (`gh`)
- Google Workspace CLI (`gws`)
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
* codex (OpenAI terminal coding agent)
* docker (Docker Desktop)
* gcloud CLI (needed by `gws auth setup`)
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

### Personal scripts

Executable scripts in `bin/` are symlinked into `~/.local/bin` (already on PATH) by `install.sh`. To add a command, drop an executable file in `bin/` and run `make install` — the symlink name matches the filename.

### Claude Code setup

`make install` no longer touches Claude — run `make claude` per machine. It symlinks the Claude config (`CLAUDE.md`, `statusline.sh`, skills) into `~/.claude`, then registers MCP servers.

**`settings.json` is copied, not symlinked.** Claude Code rewrites `~/.claude/settings.json` whenever config changes in-app (`/config`, `/model`, theme, plugin toggles), and it writes atomically — temp file plus `rename()`. That replaces the symlink with a regular file, so the link silently breaks the first time you change a setting and the two copies then drift apart unnoticed. `CLAUDE.md` stays symlinked because Claude never writes it.

So `make claude` seeds `~/.claude/settings.json` from `claude/settings.json` only when the file doesn't exist yet, and never touches an existing one. Treat the tracked copy as the bootstrap seed and reconcile it by hand after changing settings in-app — `diff <(jq -S . ~/.claude/settings.json) <(jq -S . claude/settings.json)` shows the drift with key ordering normalised.

The statusline is a single command slot, so `claude/statusline.sh` renders everything: working directory, git branch and model (parsed from the context JSON Claude pipes to it on stdin), then the caveman mode badge appended by calling the plugin's own badge script. That call hardcodes the plugin's cache path, which changes when the plugin updates — fix the path in `claude/statusline.sh` if the badge disappears.

Each MCP is a `register` call in `claude/setup.sh`. Currently configured:

* **Nirvana** — HTTP transport at `mcp.nirvanahq.com`
* **Chrome DevTools** — `chrome-devtools-mcp@1.4.0` for browser automation (requires Chrome installed separately)

`make claude` skips MCPs that are already registered (so HTTP/OAuth servers like Nirvana don't re-auth on every run). To force a re-register after editing the config or rotating a token: `claude mcp remove <name> -s user && make claude`. Verify with `/mcp` in Claude Code.

### Claude Code plugins

Plugin config lives in **`claude/settings.json`** (tracked, copied to `~/.claude/settings.json` — see the note above): `enabledPlugins` holds the enable toggles and `extraKnownMarketplaces` registers where each plugin is fetched from.

Neither key fetches plugin code, and enabling a plugin whose files aren't installed is a harmless no-op. On a fresh machine, install the files once for each plugin you want (commands below). Verify with `claude plugin list`.

#### caveman

Ultra-compressed agent output (~65% fewer output tokens), see [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman). Auto-activates per session via plugin hooks; toggle with `/caveman` or "normal mode".

```bash
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman
```

The default compression level lives in **`caveman/config.json`** (tracked, symlinked by `install.sh` to `~/.config/caveman/config.json`), currently `ultra`. Valid modes: `off`, `lite`, `full`, `ultra`, `wenyan-lite`, `wenyan`, `wenyan-full`, `wenyan-ultra`. The plugin resolves the default from `CAVEMAN_DEFAULT_MODE`, then a repo-local `.caveman/config.json` or `.caveman.json`, then this file, then `full` — so a per-project file overrides it. `/caveman <mode>` still switches the running session.

The statusline badge showing the active mode is wired via `claude/statusline.sh`, see [Claude Code setup](#claude-code-setup).

#### elixir-phoenix

Elixir/Phoenix support, see [phxagents.dev](https://phxagents.dev/).

```bash
claude plugin marketplace add oliver-kriska/claude-elixir-phoenix
claude plugin install elixir-phoenix@oliver-kriska
```

### Codex setup

Run `make codex` per machine. It symlinks `AGENTS.md` into `~/.codex`, then registers MCP servers via `codex mcp add` (none configured yet — add `register` calls in `codex/setup.sh`). Like `make claude`, it skips MCPs that are already registered; verify with `codex mcp list`.

Codex rewrites `config.toml` at runtime and won't load plugins/MCP from a shareable overlay, so we can't sync it — it stays machine-local at `~/.codex/config.toml`, edited by hand per machine.

### Codex plugins

Install these plugins by hand on each machine (`make codex` doesn't); verify with `codex plugin list`.

#### superpowers

A composable, skill-based software-development methodology, see [github.com/obra/superpowers](https://github.com/obra/superpowers). Built-in `openai-curated` marketplace:

```bash
codex plugin add superpowers@openai-curated
```

#### ECC

An agent-harness "operating system" — skills, instincts, memory, and security rules for coding agents, see [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC). Git-sourced marketplace, so register it before installing:

```bash
codex plugin marketplace add affaan-m/ECC
codex plugin add ecc@ecc
```

#### ponytail

Pushes the agent toward minimal code — reuse and built-ins before writing anything new, see [github.com/DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail). Git-sourced marketplace, so register it before installing:

```bash
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
```

Ponytail ships two lifecycle hooks; review and trust them via `/hooks` in Codex, then start a new thread.

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
