---
name: eod-slack-post
description: Post an end-of-day summary of today's work to Slack channel #check-in-out in the AccessOwl workspace. Pulls today's bullets from the user's Notion Daily Log (maintained by [[daily-notion-log]]) and composes a "Good night" message. Use when the user asks to wrap up the workday ("end of day", "wrap up", "post to slack", "good night", "EOD summary"). Always shows a draft and waits for explicit confirmation before posting — Slack messages are visible to colleagues.
---

# End-of-Day Slack Post

Composes and posts a daily summary to `#check-in-out` based on today's entries in the Notion Daily Log.

## Configuration

Names — resolve to IDs at runtime via MCP.

- **Notion page name**: `Daily Log` (lives under the user's personal `Scratchpad` page)
- **Slack workspace**: AccessOwl
- **Slack channel name**: `check-in-out`
- **Date format**: German numeric `DD.MM.YYYY` (e.g. `12.06.2026`)

ID resolution (do not persist these — re-resolve each session):
- Notion: `mcp__claude_ai_Notion__notion-search` with query `"Daily Log"`, pick the result titled `Daily Log` whose ancestor is `Scratchpad`.
- Slack: `mcp__claude_ai_Slack__slack_search_channels` with query `"check-in-out"`.

You may cache the resolved IDs in your working context for the duration of the session.

Today's date comes from the conversation environment's `currentDate` value, formatted as `DD.MM.YYYY`.

## Workflow

Triggers: "end of day", "wrap up the day", "EOD summary", "post to slack", "good night".

Steps:

1. Resolve the Daily Log page and `notion-fetch` it.
2. Find today's `## DD.MM.YYYY` section. If it's missing or empty, tell the user and stop.
3. Compose a Slack message in **Slack mrkdwn** (not standard markdown):
   - Links: `<url|label>`
   - Bullets: `•` at line start
   - Bold: `*bold*`

   Structure:
   - Line 1: `Good night.` (always — exact text).
   - Line 2 (blank).
   - Line 3: a **unique one-line summary** of the day, written fresh each time — not a paraphrase of the bullets. Captures the theme/mood (e.g. "Mostly setup + small process wins."). Avoid templated phrasing.
   - Line 4 (blank).
   - Bullets: today's log entries, one per line, prefixed with `•`.

   Filter the bullets for colleague-readability:
   - **Exclude private items.** Skip anything that's clearly for the user only (personal notes, internal thoughts, friction logs, items pointing at private pages they wouldn't want shared).
   - **Strip links to private Notion pages** (anything under the user's `Scratchpad`, personal `Welcome …` onboarding page, `Daily Log`, etc.). If a bullet's only link is private, drop the link and keep the prose; if the bullet itself is private, drop the bullet entirely.
   - Public-safe links stay: shared team pages (Architecture, Database Overview, anything under Product Engineering), GitHub PRs, Linear tickets, Slack threads.
   - When unsure, ask the user before posting.

   Example:
   ```
   Good night.

   Mostly setup + small process wins — feels like the workflow is starting to click.

   • Migrated the X service to Y (<https://github.com/...|PR #123>)
   • Investigated the flaky test in Z
   ```
4. Show the draft to the user. **Always** wait for explicit confirmation before posting — Slack messages are visible to colleagues. If the user requests changes, redraft, show again, and wait for another explicit OK.
5. Resolve the `#check-in-out` channel ID via `slack_search_channels` if not already known.
6. Post via `mcp__claude_ai_Slack__slack_send_message`.
7. Confirm with the message URL or timestamp returned by Slack.
