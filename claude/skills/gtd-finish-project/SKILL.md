---
name: gtd-finish-project
description: Close out a finished GTD project end to end. Finds the exact project in Nirvana; if it still has un-logged (incomplete) tasks, warns and asks what to do instead of completing; once all tasks are logged, marks the project done. Then walks every app that holds projects (Obsidian, Drive, Gmail), surfaces each artifact one at a time, and asks where it goes — most into that app's Archive, but some into an AoR or Resource. Unreachable locations are listed at the end for manual handling. Use when the user asks to "finish project X", "close out project X", "complete project X", or "archive project X" with a full close-out.
---

# GTD — Finish Project

Close a completed project everywhere: complete it in Nirvana (the master), then file each artifact to its final home. Most artifacts go to **Archive**; pull out the ones that are really reference material (→ Resources) or ongoing area material (→ AoR) before archiving the rest.

**GTD and PARA:** the user runs both methodologies side by side — GTD for stuff to do, PARA for filing — and projects exist in both, so this skill spans the two. Closing out the project — resolving its open loops in Nirvana and getting it off the active list — is the GTD half; filing the artifacts is the PARA half: material lives in `1 - Projects/` while active and lands in AoR / Resources / Archives when done.

## Source of truth

Project mirror locations live in the Spaces note, section `## Projects`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — never hardcode. As of writing: Gmail privat (full), Gmail AgileAddicts (AA only), Gmail AccessOwl (AO only), Obsidian (full), Google Drive privat (full). Nirvana is the master.

## Step 1 — Find the project in Nirvana

`mcp__nirvana__get_tasks` with `type=project`; find the **exact** name match.
- No match → tell the user, stop.
- Multiple plausible matches → list them and ask. Never guess.

## Step 2 — Check tasks before completing

Retrieve the project's tasks and check for any not logged (not completed).

- **Un-logged tasks exist** → warn with a count and list, and **ask what to do** before anything else. Per task: complete now, move out (other project / standalone next / someday), or delete. Never mark the project done while open tasks remain unresolved.
- **All logged** → mark the project done (`completed: true`). Leave tasks in their current list; collect to logbook only if explicitly asked.

Confirm: `✓ Nirvana: project "<name>" completed` (or report the open tasks and pause).

## Step 3 — Walk each app's artifacts

For each reachable mirror location from `Spaces.md`, gather the project's artifacts and go through them **one at a time**. Default destination is that app's Archive; the point of one-by-one is catching artifacts that should live on as reference or area material.

**Empty containers and stubs are deleted, not archived.** An empty project folder or headline-only stub (e.g. an Obsidian note that is just `# <name>`) gets deleted outright, no per-artifact question — nothing is worth keeping findable. This deliberately overrides the usual "preserve project stubs in `1 - Projects/`" rule: that rule protects *active* projects, and this one is finished. Still confirm before deleting anything that turns out to hold real content.

Reachability:
- **Obsidian** — always (local). `~/Documents/Second Brain/1 - Projects/<name>` — a single `<name>.md` **or** a `<name>/` folder.
- **Google Drive privat** — always (local sync). `~/My Drive/1 - Projects/<name>/`.
- **Gmail privat** — always via the `gws` CLI, never the Gmail MCP; if gws auth has expired, defer to Step 4.
- **Gmail AccessOwl** — Gmail MCP connector; if unauthenticated, defer to Step 4.
- **Gmail AgileAddicts** — never accessed (Claude touches no Gmail account beyond privat and AccessOwl); always Step 4.

Present each artifact as `[<app> · artifact N/total] <name/title> — <one-line of what it is>` and ask:

1. **Archive** *(default)* → `4 - Archives/`.
2. **AoR** → `2 - AoR/<area>/` — ongoing area material. Ask which area if unclear.
3. **Resource** → `3 - Resources/...` — reference worth keeping findable.
4. **Delete** → only after explicit confirmation.
5. **Skip** → leave for now.

Apply each move before the next artifact. Moves are filesystem `mv` (no Obsidian MCP):
- Obsidian: `~/Documents/Second Brain/{2 - AoR | 3 - Resources | 4 - Archives}/`. After moving, fix links: `grep -rl` the vault for the old basename/path and rewrite explicit-path markdown links/embeds (plain `[[wikilinks]]` resolve by name and usually survive).
- Drive: `~/My Drive/{2 - AoR | 3 - Resources | 4 - Archives}/`.

Then the leftover **project container**:
- Single-file Obsidian project → it was the artifact; already moved (or deleted if a stub).
- Folder → move what remains into `4 - Archives/` as the project folder; if empty (started empty, or everything went to AoR/Resources) → delete it rather than archiving an empty folder.

### Gmail

Label moves aren't automated. Tell the user which project label to move from `1 - Projects` to `4 - Archives` in each account where it exists, respecting scope (privat = all; AgileAddicts/AccessOwl = work projects only). If an artifact went to an AoR/Resource, mention the matching label move too.

## Step 4 — Manual hand-off

List unreachable locations (any unauthenticated Gmail account) for the user to handle by hand.

## Done

Report the close-out: Nirvana completion (or the open-tasks pause), and per app what was archived vs. AoR/Resource vs. deleted, plus Gmail/manual steps. **Only mention apps where the project actually existed.** Don't offer to log this or post EOD — the user will ask.

## Related

- Naming and project-vs-AoR/Resource distinction: `[[Konventionen]]`.
- This is the deliberate, artifact-by-artifact counterpart to the quick "archive project X" whole-folder move.
