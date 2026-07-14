---
name: sgoettschkes-log-notion
description: Mirror a completed WORK task to the user's "Daily Log" Notion page (in addition to Obsidian). Use ONLY for tasks tied to the user's job at AccessOwl, and ALWAYS pair with [[sgoettschkes-log-obsidian]] — Notion is never logged in isolation. Use when the user asks to log a completed work task ("log this", "log to daily log"). Also offer proactively after the user finishes a substantial work task — ask whether to log it. Do NOT use for personal projects, dotfiles changes, side projects, or anything outside the user's job. For end-of-day Slack summaries, see [[sgoettschkes-log-eod-slack]].
---

# Daily Notion Log

Mirror a completed **work** task to the Notion Daily Log. Obsidian ([[sgoettschkes-log-obsidian]]) is the source of truth; Notion is the work-only mirror that feeds the EOD Slack post.

## Scope

- Work = the user's job at AccessOwl: AccessOwl repos, Linear tickets, internal Notion/Slack threads, meetings with colleagues. Personal projects (dotfiles, side projects), personal admin, and notes never go here.
- **Never Notion alone.** Every Notion entry needs an Obsidian counterpart. If the user only asks to log to Notion, log to Obsidian too (default is both).
- Offer proactively only when the completed task is clearly job-related. If unsure whether something counts as work, ask before logging.

## Configuration

- **Page**: `Daily Log`, under the user's personal `Scratchpad` page. Resolve the ID each session via `mcp__claude_ai_Notion__notion-search` for `"Daily Log"` — pick the result whose ancestor is `Scratchpad`. Cache the ID for the session only; never persist it.
- **Date format**: German numeric `DD.MM.YYYY`, derived from the environment's `currentDate`.

## Workflow

1. Confirm the task is actually done.
2. Draft a one-sentence summary and show it for approval; use the user's edit verbatim. **The wording must match the actual state of the work**: "Fixed"/"Shipped"/"Merged"/"Deployed" only for work that landed; an open, unmerged PR is "Opened PR for X". Unsure → ask.
3. Gather links: Notion tickets/pages via `notion-search`; GitHub PRs, Linear tickets, Slack threads as direct URLs. Ask whether anything else should be linked.
4. `notion-fetch` the Daily Log page and check whether today's `## DD.MM.YYYY` heading exists.
5. **Preview the change as a fenced ```` ```diff ```` block and wait for explicit approval.** Notion MCP edits don't trigger Claude Code's diff renderer, so this preview is the user's only visual confirmation. Show one or two unchanged context lines (leading space) plus the added bullet (leading `+`):

   ```diff
      ## 15.06.2026
      - Earlier bullet for today …
   +  - New bullet being added.
   ```
6. Append via `notion-update-page` with `insert_content`, position **end** — never `update_content`, never mid-page. Today's section is always last on the page, so appending to the end is always correct, and `insert_content` doesn't re-send existing bullets (see the WAF section).
   - Heading exists → content = just the new bullet.
   - Heading missing → content = the new heading followed by the bullet.
7. Confirm the Obsidian counterpart exists; if not, invoke [[sgoettschkes-log-obsidian]] now with the same summary.
8. Confirm: `Logged to Notion + Obsidian: {summary}`.

## Entry shape

```
## 12.06.2026
- Migrated the X service to Y. [PR #123](https://github.com/...) [Ticket](https://notion.so/...)
- Investigated the flaky test in Z.
## 13.06.2026
- Reviewed PR feedback and shipped follow-ups.
```

No blank line between one day's last bullet and the next day's heading.

## Cloudflare WAF — keep path-like strings out of the request body

The Notion MCP write path sits behind a Cloudflare WAF that blocks any request body matching a file-disclosure signature — most commonly literal paths like `/etc/hosts` or `/etc/passwd`. A blocked call returns a Cloudflare "Sorry, you have been blocked" HTML page.

This is **payload-based, not IP- or rate-based**: retrying, waiting, or reconnecting the MCP will not help — the same payload fails every time while other writes succeed. Fix the payload instead:

- Use `insert_content` with only the new bullet (this is why step 6 forbids `update_content`, whose `old_str` echoes existing bullets — a trigger string in any earlier entry blocks the write even when the new bullet is clean).
- If the new bullet itself must mention such a path, reword it (e.g. "the hosts-file step"). If the literal path is essential, tell the user the WAF will block it and ask them to paste that bullet into Notion manually — the Obsidian copy can keep the exact path.
