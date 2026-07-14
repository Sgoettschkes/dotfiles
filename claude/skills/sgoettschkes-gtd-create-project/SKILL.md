---
name: sgoettschkes-gtd-create-project
description: Create a new GTD project everywhere it needs to live, not just Nirvana. Creates the active project in Nirvana (the master), then mirrors it — an Obsidian stub, a Google Drive folder, and the Gmail label (auto for private via gws and AccessOwl via MCP; other accounts handed to the user). Use when the user asks to "create a project", "new project X", "start a project", "set up a project", or "spin up a project", and whenever another flow needs a brand-new active project to exist across all stores.
---

# GTD — Create Project

A project must exist in **all relevant stores**, not Nirvana alone. Create it in Nirvana (the master), mirror it locally (Obsidian + Drive), and create the Gmail label (auto for private and AccessOwl; other accounts handed to the user).

**GTD and PARA:** the user runs both methodologies side by side — GTD for stuff to do, PARA for filing — and projects are exactly where they overlap: every project lives in both. Creating the active project in Nirvana is the GTD half; giving it a home under each location's `1 - Projects/` is the PARA half. This is the create-time counterpart to `sgoettschkes-gtd-sync-projects` (reconcile after the fact) and `sgoettschkes-gtd-finish-project` (close out and file away).

## Source of truth

Project mirror locations live in the Spaces note, section `## Projects`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — never hardcode. As of writing: Gmail privat (full list), Gmail AgileAddicts (AA only), Gmail AccessOwl (AO only), Obsidian (full list), Google Drive privat (full list). Nirvana is the master and isn't in that list.

## Step 1 — Nirvana (auto)

Create the project via `mcp__nirvana__create_tasks` with `type: "project"`, `state: "active"`, and the appropriate area tag (`private`, `AccessOwl`, `AgileAddicts`, `professional`, …). The area belongs on the **project**; any child tasks inherit it, so don't repeat the area tag on them.

Use the **exact** project name — every mirror matches by exact name.

## Step 2 — Obsidian (auto)

Write a stub note at `~/Documents/Second Brain/1 - Projects/<exact name>.md` containing just `# <name>`. A headline-only stub is the minimum valid Obsidian presence and is **exempt from the delete-empty rule** — every active Nirvana project needs at least one Obsidian item. (A folder is equally valid if the project already warrants one.)

Confirm tersely: `✓ Obsidian stub: <name>`.

## Step 3 — Drive (auto)

Create an empty folder at `~/My Drive/1 - Projects/<exact name>/`.

Confirm: `✓ Drive folder: <name>`.

## Step 4 — Gmail label

Create the `1 - Projects/<name>` label in the account matching the project's area. **If the account is unclear (e.g. work-vs-personal ambiguous), ask which account before creating** — don't guess.

- **Private** (tag `private`) → create in Gmail privat via `gws`:
  `gws gmail users labels create --params '{"userId": "me"}' --json '{"name": "1 - Projects/<name>"}'`
- **AccessOwl** (tag `AccessOwl`) → create in Gmail AccessOwl via the Gmail MCP `create_label` tool.
- **Any other account** (tag `AgileAddicts`, `professional`, meta/self-referential, etc.) → **don't create it** — post a note telling the user to add the `1 - Projects/<name>` label themselves.

A project may warrant the label in more than one account (e.g. an AA or AO project that also generates personal email → also privat). Apply the per-account rule above to each: auto-create for private/AccessOwl, hand off the rest.

Confirm what was created (`✓ Gmail privat label` / `✓ Gmail AccessOwl label`) and list any accounts left for the user.

## Batching

If the user creates several projects in one turn: one `create_tasks` call for all of them, parallel Obsidian writes + Drive mkdirs, and batch the Gmail labels too — create each private/AccessOwl label, and give a single consolidated "labels to add" list for the accounts left to the user.

## Done

Report per store what was created (Nirvana ✓, Obsidian stub, Drive folder, Gmail label(s) ✓) and the consolidated to-do list for any Gmail accounts left to the user. Don't offer to log this or post EOD — the user will ask.

## Related

- Naming and the project-vs-AoR/Resource distinction: `[[Konventionen]]`.
- Reconcile existing projects across stores: `sgoettschkes-gtd-sync-projects`. Close one out: `sgoettschkes-gtd-finish-project`.
