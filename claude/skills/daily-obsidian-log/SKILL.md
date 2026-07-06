---
name: daily-obsidian-log
description: Append completed tasks to the running "Daily Log" file in the user's Obsidian vault (at `3 - Resources/Daily Log.md`). This is the source of truth for the daily log — EVERY logged task lands here (work and private). Use when the user asks to log a completed task ("log this", "add to daily log", "log to obsidian"), or after the user confirms a proactive offer following a substantial completed task. For work tasks (AccessOwl-related), also invoke [[daily-notion-log]] to mirror the entry to Notion — Notion is never logged without Obsidian.
---

# Daily Obsidian Log

Append a completed task to the Obsidian Daily Log — the source of truth for everything logged, work and private alike.

## Configuration

- **File**: `~/Documents/Second Brain/3 - Resources/Daily Log.md`
- **Date format**: German numeric `DD.MM.YYYY`, derived from the environment's `currentDate`
- **Tools**: plain `Read`/`Edit` — the vault is a local directory; don't route through an Obsidian MCP server

## Workflow

1. Confirm the task is actually done.
2. Draft a short bullet (see style below) and show it for approval; use the user's edit verbatim.
3. `Read` the file and make sure you see its **true final line**. The file is long and grows daily — anchoring an edit mid-file (from a partial or stale read) is the main failure mode. Re-read the tail right before editing if in doubt.
4. Append at the very end of the file — never insert mid-file. Today's `## DD.MM.YYYY` heading, when present, is always the last heading, so "end of today's section" and "end of file" are the same place:
   - Heading exists → add the bullet as the new last line.
   - Heading missing → add `## DD.MM.YYYY` directly after the current final bullet (no blank line), then the bullet.
5. Apply with `Edit`, anchoring `old_string` on the file's actual last non-empty line. Leave the frontmatter untouched.
6. **Work task?** Also invoke [[daily-notion-log]] with the same summary — Obsidian first, Notion second. If unsure whether it's work, ask before deciding.
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
- Renamed daily-log skill to daily-notion-log
```

No blank line between one day's last bullet and the next day's heading.

## Bullet style

- A few words — enough to recognize the task later, no more. Past tense, action-led ("Fixed X", "Shipped Y", "Reviewed Z").
- **The verb must match the actual state of the work.** "Fixed"/"Shipped"/"Merged" only for work that landed; work that stopped at an open, unmerged PR is "Opened PR for X" / "Raised PR to do Y". Unsure of the state → ask, don't assume done.
- Inline links where they exist: `Reviewed [PR #123](https://github.com/...)`. Ask whether anything else should be linked.
- No private commentary that wouldn't make sense on reread.
