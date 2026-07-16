---
name: sgoettschkes-log-task
description: Log a completed task to the user's daily log. Every logged task is appended to the "Daily Log" file in the Obsidian vault (the source of truth, work and private alike); work tasks (tied to the user's job at AccessOwl) are ALSO mirrored to the "Daily Log" Notion page — never Notion alone. Use when the user asks to log a completed task ("log this", "add to daily log", "log to obsidian", "log to notion", "log to daily log"), or after the user confirms a proactive offer following a substantial completed task. For end-of-day Slack summaries, see [[sgoettschkes-log-post-eod]].
---

# Daily Log

One flow, one entry text, two destinations: the entry is always appended to the Obsidian Daily Log; if the task is a work item it is additionally mirrored to the Notion Daily Log (which feeds the EOD Slack post).

## Work vs. private

- **Work** = the user's job at AccessOwl: AccessOwl repos, Linear tickets, internal Notion/Slack threads, meetings with colleagues → Obsidian **and** Notion.
- **Private** = personal projects (dotfiles, side projects, hobby code), personal admin, notes → Obsidian only.
- **Never Notion alone.** If the user asks to log to Notion only, log to Obsidian too.
- Unclear → ask in the approval dialog (below); never guess.

## Workflow

1. Confirm the task is actually done.
2. Classify work vs. private. If unclear, it becomes a second question in the approval dialog.
3. Gather links to include inline: GitHub PRs, Linear tickets, Slack threads as direct URLs; Notion tickets/pages via `mcp__claude_ai_Notion__notion-search`. Ask whether anything else should be linked when more links seem likely.
4. Draft the entry (style below).
5. **Hard stop — approval dialog** (below). Nothing is written anywhere before the dialog returns an approval.
6. Append to Obsidian (mechanics below).
7. Work item → also append to Notion (mechanics below), same text verbatim.
8. Confirm: `Logged: {bullet}` (private) or `Logged to Obsidian + Notion: {bullet}` (work).

## Entry style

- One short line — enough to recognize the task later, no more. Past tense, action-led ("Fixed X", "Shipped Y", "Reviewed Z").
- **The verb must match the actual state of the work.** "Fixed"/"Shipped"/"Merged"/"Deployed" only for work that landed; work that stopped at an open, unmerged PR is "Opened PR for X" / "Raised PR to do Y". Unsure of the state → ask, don't assume done.
- Inline links where they exist: `Reviewed [PR #123](https://github.com/...)`.
- No private commentary that wouldn't make sense on reread.
- **Date format** (for day headings in both destinations): German numeric `DD.MM.YYYY`, derived from the environment's `currentDate`.

## Hard stop: approval dialog

Approval MUST go through the `AskUserQuestion` tool — a plain "ok?" in text is not enough, and auto-accept/autonomous modes do not waive this step. Never write to Obsidian or Notion before the dialog returns.

- Question: `Log this entry?` with the drafted bullet quoted in the question text. Options: **Log it** (append exactly as shown) and **Don't log** (abort, write nothing). The built-in "Other" is the edit channel: if the user's text reads as a replacement bullet, use it verbatim; if it reads as an instruction, redraft and run the dialog again. Repeat until "Log it" or "Don't log".
- If work vs. private is unclear, add a second question in the same call: `Is this a work item?` with options **Work** (Obsidian + Notion) and **Private** (Obsidian only).

## Obsidian append

The Obsidian Daily Log is the source of truth — every approved entry lands here.

- **File**: `~/Documents/Second Brain/3 - Resources/Daily Log.md`
- **Tools**: `grep`, `tail`, and `printf >>` via Bash — never `Read`/`Edit` (the file is long, and Edit's mid-file anchoring was the historical failure mode) and no Obsidian MCP server

Steps:

1. Check whether today's heading exists: `grep -q '^## DD.MM.YYYY$' file`.
2. Check the tail: `tail -n 2 file` to see the current last line.
3. Append with `printf '…' >> file` — appending to the end is always correct because today's section, when present, is always the last one. Always prefix the append with the guard below; it repairs a missing trailing newline deterministically in shell (command substitution strips a trailing newline, so `$(tail -c 1 …)` is empty iff the last byte is a newline). Never eyeball the last byte yourself and never hand-prepend `\n` — that's how stray blank lines got introduced:
   - Heading exists → `[ -n "$(tail -c 1 file)" ] && printf '\n' >> file; printf -- '- Bullet text\n' >> file`
   - Heading missing → `[ -n "$(tail -c 1 file)" ] && printf '\n' >> file; printf -- '## DD.MM.YYYY\n- Bullet text\n' >> file` (no blank line before the heading)

File shape:

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

## Notion append (work items only)

- **Page**: `Daily Log`, under the user's personal `Scratchpad` page. Resolve the ID each session via `mcp__claude_ai_Notion__notion-search` for `"Daily Log"` — pick the result whose ancestor is `Scratchpad`. Cache the ID for the session only; never persist it.
- Entry shape mirrors Obsidian: same `## DD.MM.YYYY` day headings, same bullet text, no blank line between one day's last bullet and the next day's heading.

Steps:

1. `notion-fetch` the Daily Log page and check whether today's `## DD.MM.YYYY` heading exists.
2. Append via `notion-update-page` with `insert_content`, position **end** — never `update_content`, never mid-page. Today's section is always last on the page, so appending to the end is always correct, and `insert_content` doesn't re-send existing bullets (see the WAF section).
   - Heading exists → content = just the new bullet.
   - Heading missing → content = the new heading followed by the bullet.

No second approval here — the text was already approved in the hard stop, and it goes in verbatim.

## Cloudflare WAF — keep path-like strings out of the Notion request body

The Notion MCP write path sits behind a Cloudflare WAF that blocks any request body matching a file-disclosure signature — most commonly literal paths like `/etc/hosts` or `/etc/passwd`. A blocked call returns a Cloudflare "Sorry, you have been blocked" HTML page.

This is **payload-based, not IP- or rate-based**: retrying, waiting, or reconnecting the MCP will not help — the same payload fails every time while other writes succeed. Fix the payload instead:

- Use `insert_content` with only the new bullet (this is why the append step forbids `update_content`, whose `old_str` echoes existing bullets — a trigger string in any earlier entry blocks the write even when the new bullet is clean).
- If the new bullet itself must mention such a path, reword it (e.g. "the hosts-file step"). If the literal path is essential, tell the user the WAF will block it and ask them to paste that bullet into Notion manually — the Obsidian copy can keep the exact path.
