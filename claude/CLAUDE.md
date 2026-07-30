<!-- File managed by Sgoettschkes/dotfiles -->
<!-- Do not change -->

# Coding Guidelines

## Comments
- Comments say why, never what
- Only non-obvious why

## General
- Need clarify? Ask

## Daily Log

All logging go through `sgoettschkes-log-task` — when user say "log this" / "add to daily log", or confirm proactive offer. Skill append every task to Obsidian (source of truth). Work tasks (tied to user job at AccessOwl) also mirror to Notion, which feed EOD Slack post. Never Notion only. Unclear if work-related? Skill ask (Work vs. Private) — no guess.

Proactive offer after substantial done task: ask whether log it; skill handle work/private split.

## EOD Slack Post

`sgoettschkes-log-post-eod` skill **user-initiated only**. Never offer, never suggest, never invoke self — not after log entry, not at day end, not as follow-up. User ask explicit ("post EOD", "wrap up", "good night", etc.) when want it.

## SSH Access

SSH access always through 1Password, which prompt user for password outside shell. If SSH access not granted (command fail on auth/agent access), do NOT touch SSH settings or config. Instead print short message: SSH access needed, user should approve 1Password prompt, then ask retry.