---
name: sgoettschkes-claude-unify-settings
description: Sweep every project's Claude Code settings (.claude/settings.json and .claude/settings.local.json in .dotfiles and all git repos under ~/workspace) and, item by item, decide whether each belongs in the global config instead. For each item the user chooses: move to global (~/.dotfiles/claude/settings.json), keep in the project, or delete it. Use when the user asks to "unify claude settings", "consolidate claude settings", "clean up project claude settings", or reconcile per-project Claude config against the global one.
---

# Unify Claude Settings

Reconcile per-project Claude Code settings against the global config: walk every project's `.claude/settings.json` and `.claude/settings.local.json` and ask the user where **each item** belongs.

## The three settings locations

| Location | Path | Scope | Tracked? |
|---|---|---|---|
| **Global** | `~/.dotfiles/claude/settings.json` | All the user's machines | Versioned (symlinked to `~/.claude/settings.json`) |
| **Project shared** | `<repo>/.claude/settings.json` | Everyone who clones the repo (team) | Committed in that repo |
| **Project local** | `<repo>/.claude/settings.local.json` | This machine only | Gitignored |

**There is no user-level local file.** Claude Code silently ignores `~/.claude/settings.local.json` — it is not a settings location (confirmed 2026-07-15; see the `claude-no-user-level-settings-local` memory). Machine-only settings can only live in a project's `settings.local.json`; a global item is always all-machines.

**Always edit the real file, never through a symlink** — the global target is `~/.dotfiles/claude/settings.json` (`~/.claude/settings.json` is just the symlink). If `~/.claude/settings.json` has become a detached regular file (Claude Code sometimes replaces the symlink when it writes settings itself), merge its extra content into the dotfiles file and restore the symlink before sweeping.

## Discovery

Scan `~/.dotfiles` and every git repo under `~/workspace` (repos may be nested, e.g. `~/workspace/accessowl/access_owl`, and include worktrees):

```bash
find ~/.dotfiles ~/workspace \
  -type d \( -name node_modules -o -name deps -o -name _build -o -name .git \) -prune -o \
  -path '*/.claude/settings.json' -print -o \
  -path '*/.claude/settings.local.json' -print
```

- **Never** sweep `~/.claude/settings.json` as a source — that's the symlink to the global destination.
- If `~/.claude/settings.local.json` exists, it's a dead file Claude Code never reads: sweep its items like a project file's, then delete it.
- Projects with neither file: skip silently.
- Announce the plan up front: which projects have settings files, how many items total.

## What counts as an item

Go finer than top-level keys so each decision is meaningful:

- Each permission entry in `permissions.allow` / `deny` / `ask` — one item per string (e.g. `"Bash(mix test:*)"`).
- Each plugin key in `enabledPlugins`.
- Each top-level scalar (`theme`, `model`, `alwaysThinkingEnabled`, …).
- Each hook group, keyed by event (`PreToolUse`, `Stop`, …).
- Anything else: the smallest self-contained unit.

## The decision (per item)

Show each item with its source (project + file, shared or local), then ask via `AskUserQuestion`:

1. **Global** → `~/.dotfiles/claude/settings.json` — all machines, via dotfiles.
2. **Keep in project** → leave it.
3. **Delete** → remove from the project file.

Items sharing an obvious destination may be batched into one question — but never auto-decide; anything the user hasn't explicitly placed stays put.

**Never group read-only operations with mutating ones.** Read-only (read, list, get, search, fetch — anything that only observes) must be asked separately from anything that can mutate state (write, update, create, delete, comment, arbitrary SQL). Can't tell? Treat it as mutating. This prevents accidentally auto-allowing a destructive action inside a batch of harmless ones.

## Merge semantics (moving to a global destination)

Read the destination first, then merge by type:

- **Permission entry** → union into the matching `permissions.*` array (dedupe).
- **Plugin key / scalar** → set the key.
- **Hook group** → add under `hooks.<Event>`; append to existing hooks for that event, never replace.

After a successful move, remove the item from the project file.

- **Conflict** (destination has the key with a *different* value) → stop and ask which wins. Never silently overwrite a global value.
- **Redundant** (identical value already global) → just drop it from the project file and say it was redundant.

## Workflow

1. Discover all project settings files; announce the plan.
2. Per project, per file (`settings.json` then `settings.local.json`): read, break into items, ask each decision, apply immediately.
3. After each project:
   - File now empty (`{}` or only empty containers) → offer to delete it.
   - Changed a **project shared** file → do **not** commit; tell the user it's a team-shared change they must review/commit/PR themselves. (Project local files are gitignored — nothing to do.)
4. Prune redundant local rules (below).
5. Done.

## Prune redundant local rules

Claude Code merges a project's `settings.local.json` on top of its `settings.json`, so anything present identically in both is dead weight in the local file. Check each `<repo>/.claude/settings.local.json` against its sibling `settings.json` (and against the global file): drop duplicated items from the local file; delete the local file if it ends up empty.

## Committing

- **Global** changes live in the dotfiles repo — do **not** auto-commit; the user asks when they want a commit.

## Done

Apply the decisions and stop — no report or summary of what changed. Don't offer to log this or post EOD — the user will ask.
