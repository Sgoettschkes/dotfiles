---
name: daily-obsidian-log
description: Append completed tasks to the running "Daily Log" file in the user's Obsidian vault (at `3 - Resources/Daily Log.md`). This is the source of truth for the daily log — EVERY logged task lands here (work and private). Use when the user asks to log a completed task ("log this", "add to daily log", "log to obsidian"), or after the user confirms a proactive offer following a substantial completed task. For work tasks (AccessOwl-related), also invoke [[daily-notion-log]] to mirror the entry to Notion — Notion is never logged without Obsidian.
---

# Daily Obsidian Log

Appends completed tasks to the user's Obsidian Daily Log file. This is the **source of truth** for the daily log.

## Scope

Both work and private tasks. Anything substantial the user wants to remember they did today — AccessOwl work, dotfiles changes, side projects, personal admin, anything.

## Pairing with Notion

Whenever the task is work-related (AccessOwl repos, Linear tickets, internal Notion/Slack threads, meetings with colleagues), the [[daily-notion-log]] skill must also be invoked to mirror the entry to Notion (Notion drives the EOD Slack post). Obsidian comes first, Notion second — never Notion alone.

If you're unsure whether a task is work-related, ASK the user before logging. Don't guess.

## Configuration

- **Vault path** (on disk): `~/Documents/Second Brain`
- **Daily Log file** (absolute): `~/Documents/Second Brain/3 - Resources/Daily Log.md`
- **Date format**: German numeric `DD.MM.YYYY` (e.g. `15.06.2026`)
- **Tools**: Direct file access — `Read` and `Edit`. The vault is a local directory, so editing the markdown file directly is simpler and more reliable than routing through the Obsidian MCP server.

Today's date comes from the conversation environment's `currentDate` value, formatted as `DD.MM.YYYY`.

## Workflow

Triggers: "log this", "add to daily log", "log to obsidian", "I'm done with X", or after the user confirms a proactive offer.

1. Confirm the task is actually done.
2. Draft a **short bullet** (a few words) summarizing what was completed. Show it to the user for approval; use their edit verbatim if they tweak it.
3. Include relevant links inline using markdown link syntax `[label](url)`: GitHub PRs, Notion pages, Linear tickets, Slack threads, etc. Ask the user whether anything else should be linked.
4. `Read` the Daily Log file at `~/Documents/Second Brain/3 - Resources/Daily Log.md` to see current content (frontmatter and existing day sections).
5. Check whether a heading `## DD.MM.YYYY` for today already exists in the content:
   - **Exists** → append the new bullet directly under the existing bullets for that day (anchor the `Edit` on the day's current last bullet).
   - **Missing** → add the new heading at the end of the file, directly after the previous day's last bullet (no blank line between them), followed by the new bullet.
6. Apply the change with `Edit`, leaving the existing frontmatter untouched.
7. **If the task is work-related**, also invoke [[daily-notion-log]] with the same summary (Obsidian first, Notion second). If unsure whether it's work, ask the user before deciding.
8. Confirm to the user: `Logged: {bullet text}` (mention both destinations when applicable: `Logged to Obsidian + Notion: {bullet text}`).

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

**No empty line** between the last bullet of one day and the next day's `## DD.MM.YYYY` heading — the new heading must follow the previous day's final bullet directly.

## Bullet style

- A few words — enough to recognize the task later, no more.
- Past tense, action-led ("Fixed X", "Shipped Y", "Reviewed Z", "Installed N").
- Inline links where they exist: `Reviewed [PR #123](https://github.com/...)`.
- No internal commentary or private notes that wouldn't make sense rereading later.
