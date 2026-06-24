---
name: eod-slack-post
description: Post an end-of-day summary of today's work to Slack channel #check-in-out in the AccessOwl workspace. Pulls today's bullets from the user's Notion Daily Log (maintained by [[daily-notion-log]]) and composes a "Good night" message. Use ONLY when the user explicitly asks to post the EOD ("end of day", "wrap up", "post to slack", "good night", "EOD summary"). NEVER offer this skill proactively and NEVER invoke it on your own — the user always initiates it manually. Always shows a draft and waits for explicit confirmation before posting — Slack messages are visible to colleagues.
---

# End-of-Day Slack Post

Composes and posts a daily summary to `#check-in-out` based on today's entries in the Notion Daily Log.

## Invocation rule — user-initiated only

This skill is **never** invoked proactively. Do not suggest it, offer it, or run it as a follow-up to other skills (e.g. after `daily-notion-log` or `daily-obsidian-log`). The user will ask explicitly when they want to wrap up the day. If you find yourself considering whether to mention this skill — don't.

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
3. **Pick the sign-off line randomly — do not choose it yourself.** The model cannot be relied on to vary this; the shell must.
   a. Resolve the `#check-in-out` channel ID (`slack_search_channels`) and read its recent messages (`slack_read_channel`) to find your own most recent EOD post. Note the emoji it ended its first line with — this is `LAST`. If you can't find a prior post, leave `LAST` empty.
   b. Run this command and use its output verbatim. Re-running it is fine; never override its choice with your own preference:
   ```bash
   LAST=':crescent_moon:'   # the emoji from your previous EOD post, or leave empty
   printf '%s\n' \
     'Good night|:crescent_moon:' 'Calling it a day|:city_sunset:' \
     'Signing off for today|:waning_crescent_moon:' 'Heading out|:sunset:' \
     'Logging off|:night_with_stars:' "That's a wrap|:zzz:" \
     'Wrapping up|:full_moon:' 'Done for today|:bed:' \
     'Calling it here|:moon:' 'Out for the day|:sleeping:' \
     | grep -v "|${LAST}\$" \
     | awk -v seed=$RANDOM 'BEGIN{srand(seed)} {a[NR]=$0} END{if(NR>0) print a[int(rand()*NR)+1]}'
   ```
   The part before `|` is the sign-off phrase; the part after is the emoji. The `grep -v` drops yesterday's emoji so it never repeats two days running. (`shuf` is intentionally avoided — it's not on macOS by default; this uses `awk` seeded from `$RANDOM`.)
4. Compose a Slack message in **Slack mrkdwn** (not standard markdown):
   - Links: `<url|label>`
   - Bullets: `•` at line start
   - Bold: `*bold*`

   Structure:
   - Line 1: the **sign-off phrase + emoji produced by the `shuf` command in step 3** — use it verbatim (e.g. `Heading out :sunset:`). Never a period before the emoji. Do not substitute your own phrasing or emoji.
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
   Good night :crescent_moon:

   Mostly setup + small process wins — feels like the workflow is starting to click.

   • Migrated the X service to Y (<https://github.com/...|PR #123>)
   • Investigated the flaky test in Z
   ```
5. Show the draft to the user. **Always** wait for explicit confirmation before posting — Slack messages are visible to colleagues. If the user requests changes, redraft, show again, and wait for another explicit OK.
6. Post via `mcp__claude_ai_Slack__slack_send_message` to the `#check-in-out` channel resolved in step 3.
7. Confirm with the message URL or timestamp returned by Slack.
