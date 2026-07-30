Sgoettschkes/dotfiles
=====================

[@Sgoettschkes](https://twitter.com/Sgoettschkes) on dotfiles

My dotfiles; software me use; setup instructions for my environment.

## Installation

Clone repo into `~/.dotfiles`, run install:

```bash
git clone https://github.com/Sgoettschkes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

Or run script direct: `./install.sh`

Install script auto-install:
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

Remove all symlinks: `make clean`

## Additional Software

Auto-installed via Homebrew (macOS only):

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

Auto-installed via Homebrew (macOS only):

* [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip)
* [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
* [SauceCodePro Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/SourceCodePro.zip)

## rectangle configuration

Config in `rectangle/` folder. Import through settings.

## Development environment

Install script symlink SSH, Zsh, Git, asdf configs.

### Local SSH configuration

Local ssh config (must not be in git) go in `~/.ssh/config.local`.

### Personal scripts

`install.sh` symlink executables in `bin/` into `~/.local/bin` (already on PATH). Add command: drop executable in `bin/`, run `make install`. Symlink name match filename.

### Claude Code setup

`make install` not touch Claude. Run `make claude` per machine. Symlink Claude config (`CLAUDE.md`, `statusline.sh`, skills) into `~/.claude`, then register MCP servers.

**`settings.json` copied, not symlinked.** Claude Code rewrite `~/.claude/settings.json` whenever config change in-app (`/config`, `/model`, theme, plugin toggles), and write atomic — temp file plus `rename()`. That replace symlink with regular file, so link break silent on first setting change, and two copies drift apart unnoticed. `CLAUDE.md` stay symlinked because Claude never write it.

So `make claude` seed `~/.claude/settings.json` from `claude/settings.json` only when file not exist yet, never touch existing one. Tracked copy = bootstrap seed. Reconcile by hand after in-app settings change — `diff <(jq -S . ~/.claude/settings.json) <(jq -S . claude/settings.json)` show drift with key order normalised.

Statusline = one command slot, so `claude/statusline.sh` render everything: working directory, git branch, model (parsed from context JSON Claude pipe on stdin), then caveman mode badge appended by calling plugin's own badge script. That call hardcode plugin cache path, which change when plugin update. Badge disappear: fix path in `claude/statusline.sh`.

Each MCP = one `register` call in `claude/setup.sh`. Configured now:

* **Nirvana** — HTTP transport at `mcp.nirvanahq.com`
* **Chrome DevTools** — `chrome-devtools-mcp@1.4.0` for browser automation (need Chrome installed separate)

`make claude` skip MCPs already registered (so HTTP/OAuth servers like Nirvana not re-auth every run). Force re-register after config edit or token rotate: `claude mcp remove <name> -s user && make claude`. Verify with `/mcp` in Claude Code.

### Claude Code plugins

Plugin config in **`claude/settings.json`** (tracked, copied to `~/.claude/settings.json` — see note above): `enabledPlugins` hold enable toggles, `extraKnownMarketplaces` register where each plugin fetched from.

Neither key fetch plugin code. Enable plugin whose files not installed = harmless no-op. Fresh machine: install files once for each plugin you want (commands below). Verify with `claude plugin list`.

#### caveman

Ultra-compressed agent output (~65% fewer output tokens), see [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman). Auto-activate per session via plugin hooks. Toggle with `/caveman` or "normal mode".

```bash
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman
```

Default compression level in **`caveman/config.json`** (tracked, symlinked by `install.sh` to `~/.config/caveman/config.json`), now `ultra`. Valid modes: `off`, `lite`, `full`, `ultra`, `wenyan-lite`, `wenyan`, `wenyan-full`, `wenyan-ultra`. Plugin resolve default in order: `CAVEMAN_DEFAULT_MODE`, then repo-local `.caveman/config.json` or `.caveman.json`, then this file, then `full` — so per-project file override it. `/caveman <mode>` still switch running session.

Statusline badge show active mode, wired via `claude/statusline.sh`, see [Claude Code setup](#claude-code-setup).

#### elixir-phoenix

Elixir/Phoenix support, see [phxagents.dev](https://phxagents.dev/).

```bash
claude plugin marketplace add oliver-kriska/claude-elixir-phoenix
claude plugin install elixir-phoenix@oliver-kriska
```

### Codex setup

Run `make codex` per machine. Symlink `AGENTS.md` into `~/.codex`, then register MCP servers via `codex mcp add` (none configured yet — add `register` calls in `codex/setup.sh`). Like `make claude`, skip MCPs already registered. Verify with `codex mcp list`.

Codex rewrite `config.toml` at runtime and not load plugins/MCP from shareable overlay, so no sync possible. Stay machine-local at `~/.codex/config.toml`, hand-edited per machine.

### Codex plugins

Install these plugins by hand on each machine (`make codex` not do it). Verify with `codex plugin list`.

#### superpowers

Composable skill-based software-development methodology, see [github.com/obra/superpowers](https://github.com/obra/superpowers). Built-in `openai-curated` marketplace:

```bash
codex plugin add superpowers@openai-curated
```

#### ECC

Agent-harness "operating system": skills, instincts, memory, security rules for coding agents, see [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC). Git-sourced marketplace, so register before install:

```bash
codex plugin marketplace add affaan-m/ECC
codex plugin add ecc@ecc
```

#### ponytail

Push agent toward minimal code — reuse and built-ins before write anything new, see [github.com/DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail). Git-sourced marketplace, so register before install:

```bash
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
```

Ponytail ship two lifecycle hooks. Review and trust them via `/hooks` in Codex, then start new thread.

### asdf

After install script, install all asdf plugins and tools:

```bash
make asdf
```

**Note:** Erlang/Elixir: check [prerequisites](https://github.com/asdf-vm/asdf-erlang#before-asdf-install) before run.

**Note:** PHP: check [prerequisites](https://github.com/asdf-vm/asdf-php#before-asdf-install) before run.

**Note:** Lua 5.1 used because lazy neovim plugin manager need it.

## License

MIT. See [LICENSE](LICENSE).