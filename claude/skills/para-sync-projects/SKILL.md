---
name: para-sync-projects
description: Reconcile the user's PARA project lists across every location. Nirvana is the master — every active Nirvana project must exist in each reachable mirror location (Obsidian, Google Drive, and the Gmail accounts per scope); create the ones that are missing. Projects that exist in a mirror but NOT in Nirvana are surfaced one at a time and the user decides what to do. Locations Claude can't reach are listed at the end for manual checking. Use when the user asks to "sync projects", "reconcile projects", "check my project lists match", or do a PARA project sweep.
---

# PARA — Sync Projects

Make the project lists across all PARA locations agree, with **Nirvana as the master**:

1. **Nirvana → mirrors** — every active Nirvana project must exist in each reachable mirror; create the missing ones.
2. **Mirror → Nirvana** — a project in a mirror but not in Nirvana is a discrepancy; show it and ask (never auto-create in Nirvana).

Unreachable locations go on a manual-check list at the end.

## Source of truth

Mirror locations live in the Spaces note, section `## Projects`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — never hardcode. As of writing: Gmail privat (full list), Gmail AgileAddicts (AA only), Gmail AccessOwl (AO only), Obsidian (full list), Google Drive privat (full list). Nirvana is the master and isn't in that list.

## Locations

| Location | How to reach it | Reachable? |
|---|---|---|
| **Nirvana** (master) | `mcp__nirvana__get_tasks` with `type=project`, `state=active` | Always. |
| Obsidian | `~/Documents/Second Brain/1 - Projects/` — one `.md` **or** folder per project | Always (local). |
| Google Drive privat | `~/My Drive/1 - Projects/` — one folder per project | Always (local sync). |
| Gmail privat | Project labels via Gmail MCP — **all** projects | Connector — may be unauthenticated. |
| Gmail AgileAddicts | Project labels — **work projects only** (AA/AO areas) | Connector — may be unauthenticated. |
| Gmail AccessOwl | Project labels — **work projects only** (AA/AO areas) | Connector — may be unauthenticated. |

One failed Gmail call → mark that account unreachable and defer to the manual list; don't retry.

## What counts as a project

Master set = **active** Nirvana projects. Completed/logbook/someday projects are out of scope — a mirror whose Nirvana counterpart is completed is a "should be archived" discrepancy, not a sync target.

Match by **exact name**. A Nirvana project is present in:
- Obsidian if `<name>.md` **or** `<name>/` exists in `1 - Projects/`.
- Drive if `<name>/` exists in `~/My Drive/1 - Projects/`.
- A Gmail account if a project label with that name exists (subject to that account's scope).

## Workflow

### Step 0 — Setup

1. Read the `## Projects` section of `Spaces.md`.
2. Pull the master list (active Nirvana projects).
3. Determine reachable mirrors (Obsidian + Drive always; Gmail only if its connector responds).
4. Announce: master project count, which mirrors sync now, which are deferred.

### Step 1 — Nirvana → mirrors (fill gaps)

For each active Nirvana project missing from a reachable mirror:
- **Obsidian**: create a stub `~/Documents/Second Brain/1 - Projects/<name>.md` containing just `# <name>`. A headline-only stub is valid and must never be treated as deletable — every Nirvana project needs at least one Obsidian item.
- **Drive**: create `~/My Drive/1 - Projects/<name>/`.
- **Gmail**: don't create labels — label scoping (which account, personal vs. work) needs judgment. Instead **tell the user which labels to add to which account**: privat gets every project; AgileAddicts and AccessOwl get only work-area (AA/AO) projects. Can't tell work vs. personal → ask.

Report creations tersely (`✓ Obsidian stub: <name>`, `✓ Drive folder: <name>`). Batch the Gmail "labels to add" into one summary.

### Step 2 — Mirror → Nirvana (surface strays)

Collect every project in a reachable mirror with no matching **active** Nirvana project. Show **one at a time**:

```
[stray · found in: <locations>]
<project name>
```

Options:
1. **Add to Nirvana** → create an active Nirvana project (then backfill its other missing mirrors, Step 1 style).
2. **Archive it** → it's done; move the mirror(s) to `4 - Archives/` (Obsidian, Drive) and tell the user the Gmail label step. Follow the archive-project workflow.
3. **Delete it** → junk; remove the stray mirror(s) — only after explicit confirmation.
4. **Skip** → leave for now.

Apply each choice before the next stray.

### Step 3 — Manual hand-off

List unreachable locations for the user to check by hand against the master list:

```
Synced against Nirvana ✓ (Obsidian, Drive)

Check these yourself (no access):
- Gmail privat — connector not authenticated
- Gmail AgileAddicts / AccessOwl — connector not authenticated

Compare each against the active Nirvana project list; add/remove labels to match (work projects only in the AA/AO mailboxes).
```

## Done

Summarize: master count, what was created per mirror, strays resolved and how, manual hand-off list. Don't offer to log this or post EOD — the user will ask.

## Related

- Project naming and project-vs-AoR distinction: `[[Konventionen]]`.
- This is the reconciliation counterpart to the normal create-a-project flow (Nirvana project + Obsidian stub + Drive folder + Gmail labels).
