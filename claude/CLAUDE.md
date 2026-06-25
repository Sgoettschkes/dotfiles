<!-- File managed by Sgoettschkes/dotfiles -->
<!-- Do not change -->

# Coding Guidelines

## Comments
- When adding comments, only describe why something was implemented, never what it is doing
- Only describe non-obvious why in comments

## General
- If clarifying questions are needed, ask them

## Daily Log

Logging rule — applies whenever the user asks to "log this" / "add to daily log" or confirms a proactive log offer:

- **Every logged task goes to Obsidian** via `daily-obsidian-log`. This is non-negotiable — Obsidian is the source of truth for both work and private logs.
- **Work tasks ALSO go to Notion** via `daily-notion-log` (which mirrors the entry to Notion and is the source for the EOD Slack post). A work task means anything tied to the user's job at AccessOwl: AccessOwl repos, Linear tickets, internal Notion/Slack threads, meetings with colleagues, etc.
- **Never log to Notion only.** If a task warrants a Notion entry, it warrants an Obsidian entry too. For work tasks both skills must be invoked — Obsidian first, then Notion.
- **If it's unclear whether a task is work-related, ASK before logging.** Don't guess. Personal projects (dotfiles, side projects, hobby code) and personal admin (errands, life admin) are Obsidian-only.

Proactive offers after a substantial completed task: ask whether to log it. If the task is clearly work, offer both Obsidian + Notion. If clearly personal, offer Obsidian only. If ambiguous, ask which.

## EOD Slack Post

The `eod-slack-post` skill is **user-initiated only**. Never offer it, never suggest it, never invoke it on your own — not after a log entry, not at the end of the day, not as a follow-up. The user will explicitly ask ("post EOD", "wrap up", "good night", etc.) when they want it.