---
name: sgoettschkes-log-archive-month
description: Archive past months out of the Daily Log in Obsidian and Notion. Moves every day section not in the current month into a per-month "YYYY MM Log" (e.g. "2026 10 Log") — a file next to "Daily Log.md" in Obsidian, a child page of "Daily Log Archive" in Notion — so both Daily Logs only ever hold the current month. Use when the user asks to "archive the daily log", "split the daily log by month", "clean up the daily log", or "move old log entries". [[sgoettschkes-log-task]] and [[sgoettschkes-log-post-eod]] only ever touch the Daily Log itself and know nothing about the monthly files.
---

# Archive Daily Log by Month

Two independent halves, same month naming (`YYYY MM Log`, zero-padded month). Run the dry run of both, confirm once, then apply both.

## Obsidian

- **Folder**: `~/Documents/Second Brain/3 - Resources/Daily Log/`
- **Live file**: `Daily Log.md` — current month only after a run
- **Archive files**: `YYYY MM Log.md`, zero-padded month (`2026 10 Log.md`), created with frontmatter `date` + `# YYYY MM Log` title when missing, appended to when present
- **Script**: `scripts/archive.sh` in this skill's directory — does all parsing and moving. Never move sections by hand with `Read`/`Edit`; the file is long and day headings are the only reliable anchors.

The current month comes from the environment's `currentDate`; day headings are `## DD.MM.YYYY` (see [[sgoettschkes-log-task]]).

### Workflow

1. Dry run — prints which archive files get created or appended to and the day range per month, writes nothing:
   ```bash
   ~/.claude/skills/sgoettschkes-log-archive-month/scripts/archive.sh \
     ~/Documents/"Second Brain"/"3 - Resources"/"Daily Log" YYYY-MM-DD
   ```
   - `nothing to archive` → skip the Obsidian apply; Notion may still need archiving.
   - `abort: … already in …` → a day exists in both the Daily Log and its archive file (e.g. a half-finished earlier run). Show the user and stop; don't resolve it yourself.
2. Do the Notion dry run (below), then show both plans and confirm once via `AskUserQuestion` (**Archive** / **Cancel**).
3. Same command with `--apply` as third argument. The script writes the archive files first and rewrites `Daily Log.md` last, so a failure midway leaves no entry lost (worst case duplicated, which the next dry run reports).

## Notion

- **Live page**: `Daily Log` under `Scratchpad`
- **Archive container**: `Daily Log Archive` under `Scratchpad` — a sibling, not a child of `Daily Log`, because child pages render as blocks and [[sgoettschkes-log-task]] appends to the end of `Daily Log`
- **Month pages**: `YYYY MM Log`, children of `Daily Log Archive`, same `## DD.MM.YYYY` headings + bullets as the live page
- Resolve both page IDs each session via `mcp__claude_ai_Notion__notion-search` (pick results whose ancestor is `Scratchpad`); cache for the session only.

### Dry run

1. `notion-fetch` `Daily Log`; collect the `## DD.MM.YYYY` sections not in the current month, grouped by month.
2. `notion-fetch` `Daily Log Archive`; note which `YYYY MM Log` child pages exist. For existing ones, fetch them and check none of the days to archive is already there — if one is, report it and leave that month alone.
3. Plan line per month: create/append, day count, day range.

### Apply (after the shared confirmation)

1. Per month, copy the sections **verbatim from the fetched markdown**, with `preserve_internal_links: true` (otherwise Notion turns labelled internal links into bare page mentions and the label is lost):
   - Page missing → `notion-create-pages` with parent `Daily Log Archive`, title `YYYY MM Log`, content = the sections.
   - Page exists → `notion-update-page` `insert_content`, position end.
2. `notion-fetch` each month page and verify every archived heading is there. Any month that failed or doesn't verify stays in `Daily Log`.
3. Rewrite `Daily Log` via `notion-update-page` `replace_content` with only what stays: the current-month sections plus any month that wasn't archived, exactly as fetched. Never `update_content` with the old sections as `old_str`.

### Cloudflare WAF

Notion writes are blocked when the body contains file-disclosure strings like `/etc/hosts` (see [[sgoettschkes-log-task]]); retrying never helps. Copying old bullets is exactly where this bites. Before the shared confirmation, scan the sections for such paths (`/etc/`, `/proc/`, `../`) and list the hits in the plan; the user decides per hit: reword in the Notion copy only (e.g. `<code>/etc/hosts</code>` step → hosts-file step; Obsidian keeps the exact text) or skip that month. A month that still gets blocked stays in `Daily Log`; tell the user which bullet likely triggered it. The `replace_content` step only re-sends current-month bullets, which already passed the WAF when they were logged.

## Report

One line per Obsidian file and Notion page touched, plus anything skipped and why.
