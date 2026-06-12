---
name: daily-log
description: Maintain a running "Daily Log" Notion page in the user's personal area, and post an end-of-day summary to Slack channel #check-in-out in the AccessOwl workspace. Use when the user asks to log a completed task ("log this", "log to daily log"), or to wrap up the day with a Slack summary ("end of day", "wrap up", "post to slack"). Also offer proactively after the user finishes a substantial task — ask whether to log it.
---

# Daily Log

Maintains a daily work log on Notion and posts an end-of-day summary to Slack.

## Configuration

Names — these are the canonical references. Resolve to IDs at runtime via MCP.

- **Notion page name**: `Daily Log` (lives under the user's personal `Scratchpad` page)
- **Slack workspace**: AccessOwl
- **Slack channel name**: `check-in-out`
- **Date format**: German numeric `DD.MM.YYYY` (e.g. `12.06.2026`)

ID resolution (do not persist these — re-resolve each session):
- Notion: `mcp__claude_ai_Notion__notion-search` with query `"Daily Log"`, pick the result titled `Daily Log` whose ancestor is `Scratchpad`.
- Slack: `mcp__claude_ai_Slack__slack_search_channels` with query `"check-in-out"`.

You may cache the resolved IDs in your working context for the duration of the session.

Today's date comes from the conversation environment's `currentDate` value, formatted as `DD.MM.YYYY`.

## Mode 1: Append a log entry

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
6. Append the entry:
   - Heading exists → `notion-update-page` with `update_content`, adding a new bullet under that heading.
   - Heading missing → `notion-update-page` with `insert_content` (position end), appending the new heading followed by the bullet.
7. Confirm to the user: `Logged: {summary}`.

Entry shape in Notion:

```
## 12.06.2026
- Migrated the X service to Y. [PR #123](https://github.com/...) [Ticket](https://notion.so/...)
- Investigated the flaky test in Z.
```

## Mode 2: End-of-day Slack post

Triggers: "end of day", "wrap up the day", "EOD summary", "post to slack".

Steps:

1. Resolve the Daily Log page and `notion-fetch` it.
2. Find today's `## DD.MM.YYYY` section. If it's missing or empty, tell the user and stop.
3. Compose a Slack message in **Slack mrkdwn** (not standard markdown):
   - Links: `<url|label>`
   - Bullets: `•` at line start
   - Bold: `*bold*`

   Example:
   ```
   Heute:
   • Migrated the X service to Y (<https://github.com/...|PR #123>)
   • Investigated the flaky test in Z
   ```
4. Show the draft to the user. **Always** wait for explicit confirmation before posting — Slack messages are visible to colleagues.
5. Resolve the `#check-in-out` channel ID via `slack_search_channels` if not already known.
6. Post via `mcp__claude_ai_Slack__slack_send_message`.
7. Confirm with the message URL or timestamp returned by Slack.
