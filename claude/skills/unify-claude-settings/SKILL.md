---
name: unify-claude-settings
description: Sweep every project's Claude Code settings (.claude/settings.json and .claude/settings.local.json in .dotfiles and all git repos under ~/workspace) and, item by item, decide whether each belongs in the global config instead. For each item the user chooses: move to global shared (~/.dotfiles/claude/settings.json), move to global local (~/.claude/settings.local.json), keep in the project, or delete it. Use when the user asks to "unify claude settings", "consolidate claude settings", "clean up project claude settings", or reconcile per-project Claude config against the global one.
---

# Unify Claude Settings

Reconcile per-project Claude Code settings against the global config. Walk every project's `.claude/settings.json` and `.claude/settings.local.json`, and for **each item** ask the user where it belongs.

## The four settings locations

| Location | Path | Scope | Tracked? |
|---|---|---|---|
| **Global shared** | `~/.dotfiles/claude/settings.json` | All the user's machines | Versioned (symlinked to `~/.claude/settings.json`) |
| **Global local** | `~/.claude/settings.local.json` | This machine only | Untracked |
| **Project shared** | `<repo>/.claude/settings.json` | Everyone who clones that repo (team) | Committed in the project repo |
| **Project local** | `<repo>/.claude/settings.local.json` | This machine only | Gitignored |

**Always edit the real file, never through a symlink.** The global shared target is `~/.dotfiles/claude/settings.json` (its `~/.claude/settings.json` form is just a symlink). The global local target is `~/.claude/settings.local.json`.

Project **shared** settings are committed to that project's repo, so they exist for the whole team. Moving an item out of one is a change to a shared repo — flag that to the user (see [[#After each project]]). Project **local** settings are personal to this machine.

## Discovery

Scan these roots: `~/.dotfiles` and every git repo under `~/workspace` (repos can be nested, e.g. `~/workspace/accessowl/access_owl`, and may include git worktrees). Find every `.claude/settings.json` and `.claude/settings.local.json` under them.

```bash
find ~/.dotfiles ~/workspace \
  -type d \( -name node_modules -o -name deps -o -name _build -o -name .git \) -prune -o \
  -path '*/.claude/settings.json' -print -o \
  -path '*/.claude/settings.local.json' -print
```

- **Never** touch `~/.claude/settings.json` or `~/.claude/settings.local.json` as *sources* — those are the global destinations, not projects to sweep.
- If a project has neither file, skip it silently.
- Announce the plan up front: which projects have settings files, and how many items total.

## What counts as an item

Go finer than top-level keys so each decision is meaningful:

- **Each permission entry** in `permissions.allow` / `permissions.deny` / `permissions.ask` — one item per string (e.g. `"WebSearch"`, `"Bash(mix test:*)"`).
- **Each plugin key** in `enabledPlugins` — one item per plugin.
- **Each top-level scalar** (e.g. `theme`, `model`, `alwaysThinkingEnabled`) — one item.
- **Each hook group**, keyed by event (`PreToolUse`, `Stop`, …) — one item per event.
- Anything else: present the smallest self-contained unit you can.

## The decision (per item)

Show each item with its source (which project, which file — shared or local), then ask for one of:

1. **Global shared** → `~/.dotfiles/claude/settings.json` — syncs to all the user's machines via dotfiles.
2. **Global local** → `~/.claude/settings.local.json` — this machine only, untracked.
3. **Keep in project** → leave it where it is.
4. **Delete** → remove it from the project file.

Use the `AskUserQuestion` tool. When several items share an obvious destination, you may batch them into one question with multiple items, but never auto-decide — every item the user hasn't explicitly placed stays put.

## Merge semantics (when moving to a global destination)

Read the destination file first, then merge by type:

- **Permission entry** → add to the matching `permissions.allow/deny/ask` array; **dedupe** (union). If it's already there identically, it's redundant — just remove it from the project (no-op add).
- **Plugin key** → set the key under `enabledPlugins`.
- **Scalar** → set the key.
- **Hook group** → add under `hooks.<Event>`; if that event already has hooks, append rather than replace.

After a successful move, **remove the item from the project file**.

### Conflicts

If the destination already has that key with a **different** value (e.g. `theme` differs, or a hook event already defined differently), stop and ask the user which value wins. Never silently overwrite a global value.

### Redundancy

If an item already exists identically in the destination, treat it as already-global: drop it from the project file and tell the user it was redundant (no global change needed).

## Workflow

1. **Discover** all project settings files (see above) and announce the plan.
2. For each project, for each file (`settings.json` then `settings.local.json`):
   1. Read and parse it.
   2. Break it into items.
   3. For each item, ask the decision and apply it immediately (merge into destination + remove from project, keep, or delete).
3. **After each project** — see below.
4. **Done** — summarize.

## After each project

- If a project's settings file is now empty (`{}` or only empty containers), offer to delete the file.
- If you changed a **project shared** file (`<repo>/.claude/settings.json`, committed to that repo), do **not** commit it. Tell the user it's a change to a team-shared repo they'll need to review/commit/PR themselves.
- Project **local** files (`settings.local.json`) are gitignored — just edit, nothing to commit.

## Committing the global changes

- Changes to **global shared** (`~/.dotfiles/claude/settings.json`) are in the dotfiles repo. Do **not** auto-commit — report what changed and let the user ask to commit (per their global convention).
- Changes to **global local** (`~/.claude/settings.local.json`) are untracked; nothing to commit.

## Done

Summarize as a short table or list:
- Items moved to global shared / global local.
- Items kept in projects (and where).
- Items deleted.
- Project files emptied/removed.
- Which **team-shared** project repos were modified and still need the user to commit.

Don't offer to log this or post EOD — the user will ask.
