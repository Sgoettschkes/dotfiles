---
name: eod-slack-post
description: Post an end-of-day summary of today's work to Slack channel #check-in-out in the AccessOwl workspace. Pulls today's bullets from the user's Notion Daily Log (maintained by [[daily-notion-log]]) and composes a "Good night" message. Use ONLY when the user explicitly asks to post the EOD ("end of day", "wrap up", "post to slack", "good night", "EOD summary"). NEVER offer this skill proactively and NEVER invoke it on your own — the user always initiates it manually. Always shows a draft and waits for explicit confirmation before posting — Slack messages are visible to colleagues.
---

# End-of-Day Slack Post

Compose and post a daily summary to `#check-in-out` from today's entries in the Notion Daily Log.

**User-initiated only.** Never suggest, offer, or run this as a follow-up to other skills. The user asks explicitly when they want to wrap up.

## Configuration

Resolve IDs at runtime each session (cache for the session only):

- **Notion page**: `Daily Log`, under the personal `Scratchpad` page — `mcp__claude_ai_Notion__notion-search` for `"Daily Log"`, pick the result whose ancestor is `Scratchpad`.
- **Slack channel**: `check-in-out` in the AccessOwl workspace — `mcp__claude_ai_Slack__slack_search_channels`.
- **Date format**: German numeric `DD.MM.YYYY`, from the environment's `currentDate`.

## Workflow

1. Resolve and `notion-fetch` the Daily Log page.
2. Find today's `## DD.MM.YYYY` section. Missing or empty → tell the user and stop.
3. **Pick the sign-off line with the shell, never yourself** — the model cannot be relied on to vary it day to day.
   a. Resolve the channel and `slack_read_channel` its recent messages to find your own most recent EOD post. The emoji ending its first line is `LAST` (empty if no prior post found).
   b. Run this and use its output verbatim — never override its choice:
   ```bash
   LAST=':crescent_moon:'   # emoji from the previous EOD post, or leave empty
   printf '%s\n' \
     'Good night|:crescent_moon:' 'Calling it a day|:city_sunset:' \
     'Signing off for today|:waning_crescent_moon:' 'Heading out|:sunset:' \
     'Logging off|:night_with_stars:' "That's a wrap|:zzz:" \
     'Wrapping up|:full_moon:' 'Done for today|:bed:' \
     'Calling it here|:moon:' 'Out for the day|:sleeping:' \
     | grep -v "|${LAST}\$" \
     | awk -v seed=$RANDOM 'BEGIN{srand(seed)} {a[NR]=$0} END{if(NR>0) print a[int(rand()*NR)+1]}'
   ```
   Phrase before `|`, emoji after. The `grep -v` prevents repeating yesterday's emoji. (`awk` seeded from `$RANDOM` because `shuf` isn't on macOS by default.)
4. Compose the message in **Slack mrkdwn** (not standard markdown): links `<url|label>`, bullets `•`, bold `*bold*`.

   Structure:
   - Line 1: the sign-off phrase + emoji from step 3, verbatim (e.g. `Heading out :sunset:`). No period before the emoji.
   - Line 2: blank.
   - Line 3: a **fresh one-line summary** of the day's theme/mood — not a paraphrase of the bullets, not templated (e.g. "Mostly setup + small process wins.").
   - Line 4: blank.
   - Then today's log entries, one `•` bullet per line.

   Filter for colleague-readability:
   - **Drop private items** (personal notes, internal thoughts, friction logs, anything the user wouldn't share).
   - **Strip links to private Notion pages** (anything under `Scratchpad`, the personal `Welcome …` page, `Daily Log` itself). Private link on an otherwise fine bullet → drop the link, keep the prose. Bullet itself private → drop it.
   - Public-safe links stay: shared team pages (Architecture, Database Overview, anything under Product Engineering), GitHub PRs, Linear tickets, Slack threads.
   - When unsure, ask before posting.

   Example:
   ```
   Good night :crescent_moon:

   Mostly setup + small process wins — feels like the workflow is starting to click.

   • Migrated the X service to Y (<https://github.com/...|PR #123>)
   • Investigated the flaky test in Z
   ```
5. Show the draft and **wait for explicit confirmation** — the post is visible to colleagues. On requested changes: redraft, show again, wait for another explicit OK.
6. Post via `mcp__claude_ai_Slack__slack_send_message` to the resolved channel.
7. Confirm with the message URL or timestamp Slack returns.
