---
name: daily-notion-log
description: Mirror a completed WORK task to the user's "Daily Log" Notion page (in addition to Obsidian). Use ONLY for tasks tied to the user's job at AccessOwl, and ALWAYS pair with [[daily-obsidian-log]] — Notion is never logged in isolation. Use when the user asks to log a completed work task ("log this", "log to daily log"). Also offer proactively after the user finishes a substantial work task — ask whether to log it. Do NOT use for personal projects, dotfiles changes, side projects, or anything outside the user's job. For end-of-day Slack summaries, see [[eod-slack-post]].
---

# Daily Notion Log

Mirrors a completed work task to the user's running Daily Log Notion page. The Obsidian Daily Log is the source of truth; Notion is the work-only mirror.

## Scope: work only — AND never alone

This log is exclusively for the user's job at AccessOwl. Do not use it for:
- Personal projects (dotfiles, side projects, hobby code)
- Personal tasks (errands, life admin, notes)
- Anything not tied to the user's paid work

**Notion is never logged on its own.** Every Notion entry must also exist in Obsidian — invoke [[daily-obsidian-log]] for the same task, either before this skill or right after. If the user only asks to log to Notion, proactively also log to Obsidian (or ask if they want both, but default is both). If you find yourself about to log to Notion without an Obsidian counterpart, stop and add the Obsidian entry too.

When offering proactively, only do so if the completed task is clearly job-related (e.g., changes in an AccessOwl repo, a Linear ticket, an AccessOwl Notion/Slack thread). Skip the offer for work in this `.dotfiles` repo or other personal contexts. If you're unsure whether a task qualifies as work, ask before logging.

## Configuration

Names — these are the canonical references. Resolve to IDs at runtime via MCP.

- **Notion page name**: `Daily Log` (lives under the user's personal `Scratchpad` page)
- **Date format**: German numeric `DD.MM.YYYY` (e.g. `12.06.2026`)

ID resolution (do not persist these — re-resolve each session):
- Notion: `mcp__claude_ai_Notion__notion-search` with query `"Daily Log"`, pick the result titled `Daily Log` whose ancestor is `Scratchpad`.

You may cache the resolved ID in your working context for the duration of the session.

Today's date comes from the conversation environment's `currentDate` value, formatted as `DD.MM.YYYY`.

## Workflow

Triggers: "log this", "log to daily log", "add to daily log", "I'm done with X", or after the user confirms a proactive offer.

Steps:

1. Confirm the task is actually done before doing anything else.
2. Draft a **one-sentence summary** of what was accomplished and show it to the user for approval. Use their edit verbatim if they tweak it.
3. Identify resources to link:
   - Notion tickets / pages: find by name with `notion-search`, include the URL.
   - GitHub PRs, Linear tickets, Slack threads, other URLs: include directly.
   - Ask the user whether anything else should be linked.
4. Resolve the Daily Log page ID via `notion-search` if not already known.
5. `notion-fetch` the page and check whether a heading `## DD.MM.YYYY` for today already exists.
6. **Preview the change as a fenced ` ```diff ` block in chat** before calling `notion-update-page`. Notion MCP edits don't trigger Claude Code's built-in diff renderer, so the user has no visual confirmation otherwise. Show one or two lines of unchanged context (leading space) plus the added bullet (leading `+`). Wait for explicit approval before continuing. Example:

   ```diff
      ## 15.06.2026
      - Earlier bullet for today …
   +  - New bullet being added.
   ```
7. Append the entry:
   - Heading exists → `notion-update-page` with `update_content`, adding a new bullet under that heading.
   - Heading missing → `notion-update-page` with `insert_content` (position end), appending the new heading followed by the bullet.
8. **Pair with Obsidian.** Confirm the same task has been (or will be) logged via [[daily-obsidian-log]]. If not, invoke that skill now with the same summary. Notion entries must never exist without an Obsidian counterpart.
9. Confirm to the user: `Logged: {summary}` (and note both destinations: `Logged to Notion + Obsidian: {summary}`).

## Entry shape in Notion

```
## 12.06.2026
- Migrated the X service to Y. [PR #123](https://github.com/...) [Ticket](https://notion.so/...)
- Investigated the flaky test in Z.
## 13.06.2026
- Reviewed PR feedback and shipped follow-ups.
```

Do **not** leave a blank line between the last bullet of one day and the next day's `## DD.MM.YYYY` heading — the new heading must follow the previous day's final bullet directly.
