---
name: para-sync-projects
description: Reconcile the user's PARA project lists across every location. Nirvana is the master — every active Nirvana project must exist in each reachable mirror location (Obsidian, Google Drive, and the Gmail accounts per scope); create the ones that are missing. Projects that exist in a mirror but NOT in Nirvana are surfaced one at a time and the user decides what to do. Locations Claude can't reach are listed at the end for manual checking. Use when the user asks to "sync projects", "reconcile projects", "check my project lists match", or do a PARA project sweep.
---

# PARA — Sync Projects

Make the project lists across all PARA locations agree, using **Nirvana as the master**. Two directions:

1. **Nirvana → mirrors** — every active Nirvana project must exist in each reachable mirror location. Create the missing ones.
2. **Mirror → Nirvana** — any project in a mirror that is *not* in Nirvana is a discrepancy. Show it and ask the user what to do (never auto-create in Nirvana).

Locations Claude can't reach get listed at the end for the user to check manually.

## Source of truth for the location list

The mirror locations live in the **Spaces** note, section `## Projects`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — don't hardcode it. As of writing it lists: Gmail privat (full list), Gmail AgileAddicts (AA only), Gmail AccessOwl (AO only), Obsidian (full list), Google Drive privat (full list). Nirvana is the master and isn't in that list.

## Locations and how to reach them

| Location | How to reach it | Reachable? |
|---|---|---|
| **Nirvana** (master) | `mcp__nirvana__get_tasks` with `type=project`, `state=active` | Always. |
| Obsidian | `1 - Projects/` folder: `~/Documents/Second Brain/1 - Projects/` — one `.md` **or** folder per project | Always (local). |
| Google Drive privat | `~/My Drive/1 - Projects/` — one folder per project | Always (local sync). |
| Gmail privat | Project labels via the Gmail MCP — **all** projects | Connector — may be unauthenticated. |
| Gmail AgileAddicts | Project labels — **work projects only** (AA/AO areas, no personal SG) | Connector — may be unauthenticated. |
| Gmail AccessOwl | Project labels — **work projects only** (AA/AO areas, no personal SG) | Connector — may be unauthenticated. |

Connectors (Gmail) may not be authenticated in a CLI session. If a tool call fails or the connector is absent, mark that location **unreachable** and defer it to the manual list — don't keep retrying.

## What counts as a project

Master set = **active** Nirvana projects (`state=active`). Completed/logbook/someday projects are out of scope — a mirror whose Nirvana counterpart is completed is a "should be archived" discrepancy, not a sync target.

Match projects across locations by **exact name**. A Nirvana project is considered present in:
- Obsidian if a `<name>.md` file **or** a `<name>/` folder exists in `1 - Projects/`.
- Drive if a `<name>/` folder exists in `~/My Drive/1 - Projects/`.
- A Gmail account if a project label with that name exists (subject to that account's scope).

## Workflow

### Step 0 — Setup
1. Read the `## Projects` section of `Spaces.md` for the current mirror locations.
2. Pull the master list: active Nirvana projects.
3. Determine which mirrors are reachable (Obsidian + Drive always; Gmail only if its connector responds).
4. Announce the plan: master project count, which mirrors will be synced now, which are deferred.

### Step 1 — Nirvana → mirrors (fill gaps)
For each active Nirvana project, check each **reachable** mirror. Where it's missing, create it:
- **Obsidian**: create a stub `~/Documents/Second Brain/1 - Projects/<name>.md` containing just `# <name>`. A headline-only stub is fine and must never be treated as deletable — every Nirvana project needs at least one Obsidian item.
- **Drive**: create the folder `~/My Drive/1 - Projects/<name>/`.
- **Gmail**: label management needs judgment (which account, and personal-vs-work scope) and isn't reliably automatable. Don't silently create labels — instead **tell the user which labels to add to which account**, respecting scope: privat gets every project; AgileAddicts and AccessOwl get only work-area (AA/AO) projects. If you can't tell whether a project is work or personal, ask.

Report each creation tersely (`✓ Obsidian stub: <name>`, `✓ Drive folder: <name>`). Batch the Gmail "labels to add" into one summary rather than per-project prompts.

### Step 2 — Mirror → Nirvana (surface strays)
Collect every project that exists in a **reachable** mirror but has no matching **active** Nirvana project. Show them **one at a time** and ask what to do. Present each as:

```
[stray · found in: <locations>]
<project name>
```

Options:
1. **Add to Nirvana** → create an active Nirvana project with that name (then it's mastered; backfill any other missing mirrors in Step 1 style).
2. **Archive it** → it's actually done; move the mirror(s) to Archives (Obsidian `4 - Archives/`, Drive `4 - Archives/`) and tell the user the Gmail label step. Follow the archive-project workflow.
3. **Delete it** → it's junk; remove the stray mirror(s). Only after explicit confirmation.
4. **Skip** → leave it for now.

Apply the choice before moving to the next stray.

### Step 3 — Manual hand-off
List the locations that could **not** be reached (any Gmail account whose connector wasn't available) and tell the user to check those by hand against the master list. For example:

```
Synced against Nirvana ✓ (Obsidian, Drive)

Check these yourself (no access):
- Gmail privat — connector not authenticated
- Gmail AgileAddicts / AccessOwl — connector not authenticated

Compare each against the active Nirvana project list; add/remove labels to match (work projects only in the AA/AO mailboxes).
```

## Done

Summarize: master project count, what was created in each mirror, strays resolved and how, and the manual hand-off list. Don't offer to log this or post EOD — the user will ask.

## Related conventions
- Project naming and the project-vs-AoR distinction live in `[[Konventionen]]`.
- This is the reconciliation counterpart to the normal create-a-project flow (Nirvana project + Obsidian stub + Drive folder + Gmail labels).
