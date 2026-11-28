<!-- File managed by Sgoettschkes/dotfiles -->
<!-- Do not change -->

# Global guidelines

## Comments
- Comments say why, never what
- Only non-obvious why

## General
- Need clarify? Ask
- Answer in English, also after a bare slash command, notification or wakeup. German only for translations and German UI texts.
- "Formulate", "write up", "summarize", "critique", "what else could we do?" and "why X?" are answered in chat; change no file until the user says so (at most one line on where it could go).
- Open points needing a short answer: phrase each as a choice with one reading ("Arrow or no arrow?"). If an answer still has two readings, ask before building.
- In a list walk-through, show only the current item, never the remaining list.
- Questions and list items are numbered continuously through the whole message (1, 2, 3 …, never restarting per list or section), so the user can answer or comment by number.
- Many findings in a cleanup: verify each, apply the sure ones, ask only about the unsure ones, summarize afterwards.

## Research & unknowns
Research feeds decision → report only what changes decision. Relevant > complete.
- Fact: checked for user's actual context (country, product, version). State plainly.
- Unknown: one line "don't know yet" + what pending/how to find out. Fine to wait on running research.
- Idea/hypothesis: welcome while exploring ("X might work because Y"), labeled as such, short. Never dressed as fact.
- Wrong input costly (print, purchase, order, migration)? Facts only. Gap → check or say unknown, no guess.
- No borrowing from other context (other country, shop, version) as answer. Only labeled, only if it actually helps decide.
- Evidence sized honestly: one data point ≠ "partly", estimate ≠ "verified".
- Unsure which bucket? Ask, don't pad.

## Daily Log

All logging goes through `sgoettschkes-log-task`, when the user says "log this" / "add to daily log" or confirms a proactive offer. The skill appends every task to Obsidian (source of truth). Work tasks (tied to the user's job at AccessOwl) are also mirrored to Notion, which feeds the EOD Slack post. Never Notion only. If it's unclear whether a task is work-related, the skill asks (Work vs. Private) instead of guessing.

After a substantial task is done, offer to log it; the skill handles the work/private split.

## EOD Slack Post

`sgoettschkes-log-post-eod` runs only when the user asks ("post EOD", "wrap up", "good night", etc.). Don't offer, suggest or start it on your own — including after a log entry, at day end, or as a follow-up.

## GTD and PARA

The user runs both side by side: GTD (Nirvana tasks, inbox processing, reviews) for what to do, PARA (Projects / AoR / Resources / Archives in Obsidian, Drive, Gmail) for filing. Projects exist in both. Never frame PARA as legacy or replaced.

## Google accounts

The Google Calendar connector is the AccessOwl work account. Private calendar and Gmail go through the `gws` CLI (`/opt/homebrew/bin/gws`), e.g. `gws calendar events list --params '{"calendarId":"primary",...}'`, `gws gmail users messages list --params '{"userId":"me","q":"..."}'`.

## Nirvana Done

A task or project is done with one `update_tasks` call setting `completed: true` **and** `state: "logbook"`, same as clicking it in the app. `completed` alone leaves a checked item the user must collect by hand. This is a standing user instruction and counts as an explicit logbook request.

## Shell

- zsh doesn't word-split: `T="a.exs b.exs"; mix test $T` passes one argument and silently runs nothing. Write paths out or use `${=T}`.
- An unquoted word starting with `=` becomes a command path (`echo ====X` fails and ends the command list). Quote it (`echo "=== x"`).
- A command the user runs themselves goes into the clipboard unasked: `printf '%s' '…' | pbcopy`, one line, no trailing newline (copying wrapped commands from chat splits them). Never `pbcopy` while the user may still need to paste something.
- Nested quotes or long commands get cut off in the `!` prompt: write a scratchpad script and copy its path.

## 1Password CLI

`op` fails in Claude's shell and in `!` commands ("No accounts configured" / "not signed in"): macOS TCC blocks reading 1Password's group container, and the fix needs an iTerm2 restart the user can't do. Don't retry or ask for a restart; the user runs commands and scripts calling `op` in Terminal.app, handed over via the clipboard. Secrets are stored in 1Password with `op item edit`, run by the user the same way.

## SSH Access

SSH access always goes through 1Password, which prompts the user for a password outside the shell. If SSH access isn't granted (a command fails on auth or agent access), do not touch SSH settings or config. Instead print a short message: SSH access is needed, the user should approve the 1Password prompt, then ask to retry.
