<!-- File managed by Sgoettschkes/dotfiles -->
<!-- Do not change -->

# Coding Guidelines

## Comments
- When adding comments, only describe why something was implemented, never what it is doing
- Only describe non-obvious why in comments

## General
- If clarifying questions are needed, ask them

## Daily Log

All logging goes through `sgoettschkes-log-task` — whenever the user asks to "log this" / "add to daily log" or confirms a proactive log offer. The skill appends every logged task to Obsidian (the source of truth) and additionally mirrors work tasks (anything tied to the user's job at AccessOwl) to Notion, which feeds the EOD Slack post. Never log to Notion only. If it's unclear whether a task is work-related, the skill asks (Work vs. Private) — don't guess.

Proactive offers after a substantial completed task: ask whether to log it; the skill handles the work/private split.

## EOD Slack Post

The `sgoettschkes-log-post-eod` skill is **user-initiated only**. Never offer it, never suggest it, never invoke it on your own — not after a log entry, not at the end of the day, not as a follow-up. The user will explicitly ask ("post EOD", "wrap up", "good night", etc.) when they want it.

## SSH Access

SSH access is always channeled through 1Password, which prompts the user for a password outside the shell. If SSH access is not granted (the command fails on auth/agent access), do NOT adjust SSH settings or config in any way. Instead, print a short message explaining that SSH access is needed and that the user should approve the 1Password prompt and ask to retry.