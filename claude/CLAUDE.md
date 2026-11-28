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
Report only what changes the decision.
- Fact: checked for the user's context (country, product, version), stated plainly. Unknown: "don't know yet" + how to find out. Idea: labeled, short, never dressed as fact
- Costly if wrong (print, purchase, order, migration): facts only; a gap is checked or named, never guessed
- Nothing borrowed from another context (country, shop, version) unless labeled and it helps decide
- Evidence sized honestly: one data point ≠ "partly", estimate ≠ "verified"

## Personal tools
- After a substantial task, offer to log it (`sgoettschkes-log-task`); `sgoettschkes-log-post-eod` only when the user asks
- GTD (Nirvana) for what to do and PARA (Obsidian, Drive, Gmail) for filing run side by side; never frame PARA as legacy
- The Google Calendar connector is the AccessOwl work account; private calendar and Gmail go through `gws` (`/opt/homebrew/bin/gws`)
- Nirvana done is one `update_tasks` call with `completed: true` and `state: "logbook"`; this counts as an explicit logbook request

## Shell

- zsh doesn't word-split: `T="a.exs b.exs"; mix test $T` passes one argument and silently runs nothing. Write paths out or use `${=T}`.
- An unquoted word starting with `=` becomes a command path (`echo ====X` fails and ends the command list). Quote it (`echo "=== x"`).
- A command the user runs themselves goes into the clipboard unasked: `printf '%s' '…' | pbcopy`, one line, no trailing newline (copying wrapped commands from chat splits them). Never `pbcopy` while the user may still need to paste something.
- Nested quotes or long commands get cut off in the `!` prompt: write a scratchpad script and copy its path.

## 1Password CLI

`op` fails in Claude's shell and in `!` commands ("No accounts configured" / "not signed in"): macOS TCC blocks reading 1Password's group container, and the fix needs an iTerm2 restart the user can't do. Don't retry or ask for a restart; the user runs commands and scripts calling `op` in Terminal.app, handed over via the clipboard. Secrets are stored in 1Password with `op item edit`, run by the user the same way.

## SSH Access

SSH access always goes through 1Password, which prompts the user for a password outside the shell. If SSH access isn't granted (a command fails on auth or agent access), do not touch SSH settings or config. Instead print a short message: SSH access is needed, the user should approve the 1Password prompt, then ask to retry.
