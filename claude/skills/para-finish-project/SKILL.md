---
name: para-finish-project
description: Close out a finished PARA project end to end. Finds the exact project in Nirvana; if it still has un-logged (incomplete) tasks, warns and asks what to do instead of completing; once all tasks are logged, marks the project done. Then walks every app that holds projects (Obsidian, Drive, Gmail), surfaces each artifact one at a time, and asks where it goes — most into that app's Archive, but some into an AoR or Resource. Unreachable locations are listed at the end for manual handling. Use when the user asks to "finish project X", "close out project X", "complete project X", or "archive project X" with a full close-out.
---

# PARA — Finish Project

Take a completed project and close it everywhere: complete it in Nirvana (the master), then file each of its artifacts to its final home. Most artifacts go to **Archive**, but watch for the ones that are really reference material (→ Resources) or belong to an ongoing area (→ AoR) — those should be pulled out before the rest is archived.

## Source of truth for the location list

The project mirror locations live in the **Spaces** note, section `## Projects`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — don't hardcode it. As of writing: Gmail privat (full), Gmail AgileAddicts (AA only), Gmail AccessOwl (AO only), Obsidian (full), Google Drive privat (full). Nirvana is the master.

## Step 1 — Find the project in Nirvana (master)

1. Get the user's projects (`mcp__nirvana__get_tasks`, `type=project`) and find the one whose name **exactly** matches the request.
   - No match → tell the user, stop.
   - Multiple plausible matches → list them and ask which one. Never guess.

## Step 2 — Check its tasks before completing

Retrieve the tasks belonging to that project and check for any that are **not logged** (not completed).

- **Un-logged tasks exist** → **warn**: list them with a count, and **ask what to do** before doing anything else. Typical choices per task: complete it now, move it out (to another project / standalone next / someday), or delete it. Do **not** mark the project done while open tasks remain unresolved.
- **All tasks logged** → mark the **project** done in Nirvana (`completed: true`). Leave tasks in their current list; only collect to logbook if the user explicitly asks.

Confirm: `✓ Nirvana: project "<name>" completed` (or report the open tasks and pause).

## Step 3 — Walk each app's artifacts

For each project mirror location from `Spaces.md` that is **reachable**, gather the project's artifacts and go through them **one at a time**. Default destination is that app's Archive; the point of going one-by-one is to catch the artifacts that should instead live on as reference or area material.

Reachability:
- **Obsidian** — always (local). Project at `~/Documents/Second Brain/1 - Projects/<name>` — a single `<name>.md` **or** a `<name>/` folder of notes.
- **Google Drive privat** — always (local sync). Project folder at `~/My Drive/1 - Projects/<name>/`.
- **Gmail** (privat / AgileAddicts / AccessOwl) — connector; may be unauthenticated → defer to manual list (Step 4).

For each artifact present `[<app> · artifact N/total] <name/title> — <one-line of what it is>` and ask where it goes:

1. **Archive** *(default for most)* → move to that app's `4 - Archives/`.
2. **AoR** → move to `2 - AoR/<area>/` — it's ongoing area material, not project-specific. Ask which area if unclear.
3. **Resource** → move to `3 - Resources/...` — it's reference/knowledge worth keeping findable.
4. **Delete** → only after explicit confirmation.
5. **Skip** → leave it for now.

Apply each move before the next artifact. Paths:
- Obsidian: `~/Documents/Second Brain/{2 - AoR | 3 - Resources | 4 - Archives}/` — use `mcp__obsidian__move_note` so links update.
- Drive: `~/My Drive/{2 - AoR | 3 - Resources | 4 - Archives}/` — filesystem move.

After the artifacts are distributed, deal with the leftover **project container**:
- Single-file Obsidian project → it was the artifact; it's already moved.
- Folder → move whatever remains (the archived artifacts) as the project folder into `4 - Archives/`; if the folder ended up empty because everything was pulled into AoR/Resources, remove it.

### Gmail (reachable or not)
Gmail label moves aren't automated. Tell the user explicitly which project label to move from `1 - Projects` to `4 - Archives` in each account where it exists, respecting scope (privat = all; AgileAddicts/AccessOwl = work projects only). If an artifact-level decision sent something to an AoR/Resource, mention the matching label move too.

## Step 4 — Manual hand-off

List locations that could **not** be reached (any Gmail account whose connector was unavailable) and tell the user to handle the label move there by hand.

## Done

Report the close-out: Nirvana completion (or the open-tasks pause), and per app what was archived vs. pulled into an AoR/Resource vs. deleted, plus the Gmail/manual steps. **Only mention apps where the project actually existed** — don't list stores that had nothing. Don't offer to log this or post EOD — the user will ask.

## Related
- Naming and the project-vs-AoR/Resource distinction: `[[Konventionen]]`.
- This is the deliberate, artifact-by-artifact counterpart to the quick "archive project X" whole-folder move.
