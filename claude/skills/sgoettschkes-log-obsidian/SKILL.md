---
name: sgoettschkes-log-obsidian
description: Append completed tasks to the running "Daily Log" file in the user's Obsidian vault (at `3 - Resources/Daily Log.md`). This is the source of truth for the daily log — EVERY logged task lands here (work and private). Use when the user asks to log a completed task ("log this", "add to daily log", "log to obsidian"), or after the user confirms a proactive offer following a substantial completed task. For work tasks (AccessOwl-related), also invoke [[sgoettschkes-log-notion]] to mirror the entry to Notion — Notion is never logged without Obsidian.
---

# Daily Obsidian Log

Append a completed task to the Obsidian Daily Log — the source of truth for everything logged, work and private alike.

## Configuration

- **File**: `~/Documents/Second Brain/3 - Resources/Daily Log.md`
- **Date format**: German numeric `DD.MM.YYYY`, derived from the environment's `currentDate`
- **Tools**: `grep`, `tail`, and `printf >>` via Bash — never `Read`/`Edit` (the file is long, and Edit's mid-file anchoring was the historical failure mode) and no Obsidian MCP server

## Workflow

1. Confirm the task is actually done.
2. Draft a short bullet (see style below) and show it for approval; use the user's edit verbatim.
3. Check whether today's heading exists: `grep -q '^## DD.MM.YYYY$' file`.
4. Check the tail: `tail -n 2 file` to see the current last line, and `tail -c 1 file` (empty output = trailing newline present). If the trailing newline is missing, start the appended text with `\n`.
5. Append with `printf '…' >> file` — appending to the end is always correct because today's section, when present, is always the last one:
   - Heading exists → append just the bullet: `printf -- '- Bullet text\n' >> file`
   - Heading missing → append heading + bullet (no blank line before the heading): `printf -- '## DD.MM.YYYY\n- Bullet text\n' >> file`
6. **Work task?** Also invoke [[sgoettschkes-log-notion]] with the same summary — Obsidian first, Notion second. If unsure whether it's work, ask before deciding.
7. Confirm: `Logged: {bullet}` (or `Logged to Obsidian + Notion: {bullet}`).

## File shape

```
---
date: 2026-06-15
---

# Daily Log

## 14.06.2026
- Wrote spec for X
- Fixed nginx config bug
## 15.06.2026
- Installed Claude Code iTerm integration
- Renamed daily-log skill to sgoettschkes-log-notion
```

No blank line between one day's last bullet and the next day's heading.

## Bullet style

- A few words — enough to recognize the task later, no more. Past tense, action-led ("Fixed X", "Shipped Y", "Reviewed Z").
- **The verb must match the actual state of the work.** "Fixed"/"Shipped"/"Merged" only for work that landed; work that stopped at an open, unmerged PR is "Opened PR for X" / "Raised PR to do Y". Unsure of the state → ask, don't assume done.
- Inline links where they exist: `Reviewed [PR #123](https://github.com/...)`. Ask whether anything else should be linked.
- No private commentary that wouldn't make sense on reread.
