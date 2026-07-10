---
name: gtd-create-project
description: Create a new GTD project everywhere it needs to live, not just Nirvana. Creates the active project in Nirvana (the master), then mirrors it — an Obsidian stub, a Google Drive folder — and tells the user which Gmail labels to add per account (label scoping needs judgment, so it's never automated). Use when the user asks to "create a project", "new project X", "start a project", "set up a project", or "spin up a project", and whenever another flow needs a brand-new active project to exist across all stores.
---

# GTD — Create Project

A project must exist in **all relevant stores**, not Nirvana alone. Create it in Nirvana (the master), mirror it locally (Obsidian + Drive), and hand the user the Gmail label steps.

**GTD and PARA:** the user runs both methodologies side by side — GTD for stuff to do, PARA for filing — and projects are exactly where they overlap: every project lives in both. Creating the active project in Nirvana is the GTD half; giving it a home under each location's `1 - Projects/` is the PARA half. This is the create-time counterpart to `gtd-sync-projects` (reconcile after the fact) and `gtd-finish-project` (close out and file away).

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

## Step 4 — Gmail (manual — tell the user)

**Don't create labels** — scoping (which account, personal vs. work) needs judgment. Instead tell the user which `1 - Projects/<name>` label to add, per account, by the project's area:

- **Private** (tag `private`) → Gmail privat only.
- **AgileAddicts** (tag `AgileAddicts`) → Gmail AgileAddicts only — also privat if it generates personal email.
- **AccessOwl** (tag `AccessOwl`) → Gmail AccessOwl only — also privat if personal email is involved.
- **Meta / self-referential** (tag `professional`, e.g. PARA umsetzen) → no Gmail expected.

Can't tell work vs. personal → ask.

## Batching

If the user creates several projects in one turn: one `create_tasks` call for all of them, parallel Obsidian writes + Drive mkdirs, and a single consolidated Gmail "labels to add" list at the end.

## Done

Report per store what was created (Nirvana ✓, Obsidian stub, Drive folder) and the consolidated Gmail label to-do list. Don't offer to log this or post EOD — the user will ask.

## Related

- Naming and the project-vs-AoR/Resource distinction: `[[Konventionen]]`.
- Reconcile existing projects across stores: `gtd-sync-projects`. Close one out: `gtd-finish-project`.
