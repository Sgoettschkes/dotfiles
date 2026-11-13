---
name: sgoettschkes-claude-save-context
description: Before the user clears the context, sweep the current session for knowledge worth keeping and write it into the artifacts that should carry it — README, agent files (AGENTS.md, CLAUDE.md, .claude/agents, skills), docs, repo memory (checked-in CLAUDE.md / CLAUDE.local.md) and the local auto-memory. Walks through every proposed update one at a time, showing its exact diff and asking apply or skip (re-showing an item whenever the user changes its text), applies the approved ones, offers to commit the versioned files, then hands off to /clear. Use when the user says "save context", "persist what we learned", "before I clear", "prep for /clear", "update docs before clearing", or invokes this skill directly.
---

# Save context before /clear

`/clear` throws away everything this session learned. Anything that should outlive it has to land in a file first. This skill finds those things, walks the user through each change in full to apply or skip it, writes them, optionally commits, and ends with the user running `/clear`.

Run the steps in order. Nothing is written before §4.

## 1. Mine the session

Go back over the whole conversation and pull out what a future session in this repo would need but couldn't derive from the code or `git log`:

- Decisions made and the reason behind them
- Conventions or gotchas discovered (a flag that doesn't exist, a tool quirk, an ordering constraint)
- New or changed commands, scripts, skills, setup steps, config
- User corrections and confirmed preferences about how to work
- Facts about ongoing work: goals, constraints, deadlines (absolute dates, never "next week")
- Pointers to external resources (URLs, dashboards, tickets) that came up

Drop anything that only mattered to this conversation, is already in the repo, or is a fix whose story the commit message tells.

## 2. Find the artifacts

From the repo root (`git rev-parse --show-toplevel`; outside a git repo, only local memory applies):

| Kind | Where to look |
|---|---|
| README | `README.md` (and other top-level READMEs) |
| Agent files | `AGENTS.md`, `CLAUDE.md` (root and nested), `.claude/agents/`, `.claude/skills/`, `.claude/commands/`, plus any repo-owned skill dirs the agent files point to |
| Docs | `docs/`, other `*.md` the README links to, solution-doc dirs a plugin keeps in the repo |
| Repo memory | Checked-in `CLAUDE.md` files and `CLAUDE.local.md` |
| Local memory | The auto-memory dir named in the system prompt (`~/.claude/projects/<slug>/memory/`) and its `MEMORY.md` index |

Read every candidate before proposing an edit to it — the update has to fit what's there (structure, tone, language style, existing sections) and must not duplicate an existing entry. If the repo's agent files define documentation rules (e.g. "AGENTS.md lists all skills", "README is public-facing"), follow them.

For each learning, pick the **one** artifact where a future reader would look for it:

- How to set up / use the project → README
- How an agent should work in this repo → AGENTS.md (CLAUDE.md only for Claude-specific rules, when the repo splits them that way)
- Deep reference on one subsystem → docs
- About the user, their preferences, or cross-session project state that doesn't belong in the repo → local memory, following the memory format from the system prompt (one fact per file, frontmatter, `[[links]]`, pointer line in `MEMORY.md`; update an existing memory instead of duplicating it; delete memories this session proved wrong)

Also flag artifacts this session made **stale** — a renamed command still in the README, a skill list missing the new skill, a memory contradicted by what happened. Those are updates too.

Then check which targets are versioned:

```bash
git ls-files --error-unmatch <path>   # tracked
git check-ignore -q <path>            # ignored → not versioned
```

A new file in a non-ignored path counts as versioned (it will be committed). The auto-memory dir is never versioned.

## 3. Walk through each change and ask

The user decides item by item, so they must see exactly what would be written — not a summary of it. Split the findings into items (one item = one self-contained change the user can accept or skip on its own), number them, and open with a single line: how many changes were found. Nothing found → say so and skip to §6.

Then go through the items **one at a time**, in order. For each, show:

- **Target**: file, versioned or local, new file or update
- **Where**: the section / heading / line it lands at
- **Why**: one line — what in this session prompted it
- **Exact change**: a fenced `diff` block with the real lines removed (`-`) and added (`+`), plus a line or two of surrounding context so placement is unambiguous. New files show their complete content, frontmatter included. A new memory file and its `MEMORY.md` pointer line are shown together as one item.

Example (two separate turns, each followed by its own question):

````
[1/2] README.md (versioned, update) — Maintenance Commands
Why: `make foo` added this session, not documented anywhere
```diff
 - `make asdf-clean` - Remove unused asdf installs
+- `make foo` - Rebuild foo cache
 - `make claude` - Set up Claude Code …
```

[2/2] memory: wt-rm-flag-spelling.md (local, new) + MEMORY.md pointer
Why: `--db` failed twice this session with "unknown flag"
```diff
+---
+name: wt-rm-flag-spelling
+description: wt-rm takes -db, not --db
+metadata:
+  type: reference
+---
+
+`wt-rm` takes `-db`; `--db` exits "unknown flag".
```
```diff
 - [GTD and PARA both active](gtd-and-para-both-active.md) — …
+- [wt-rm flag spelling](wt-rm-flag-spelling.md) — -db not --db
```
````

Never shorten to "add a note about X" or "update the skill list" — if the text isn't shown, the user can't judge it.

After showing an item, `AskUserQuestion` for that item alone:

- **Apply**
- **Skip**

Don't mark either as recommended — the point is the user's judgment per item. Record the decision, then move to the next item. Don't write anything yet; collect decisions until every item is decided.

Free-text answer ("reword to …", "put it under X instead", "also mention Y") → revise that item, show it again in full, and ask again for the same item. Never apply text the user hasn't seen. If the user asks for a brand-new item, append it to the end of the queue. "Skip the rest" / "apply the rest" → decide all remaining items that way without asking further.

Once all items are decided, show a one-line-per-item recap (`[n] target — apply/skip`) and continue to §4. All skipped → go to §6.

## 4. Apply

Write each approved update with Edit (Write only for new files), using exactly the text shown in §3 — no rewording at apply time. Match the target file's style exactly — if a file is written in a compressed style, write compressed; if it's prose, write prose. Comments-say-why rules from the user's instructions apply to any code touched.

Keep a list of every file you touched, split into versioned and unversioned.

## 5. Offer to commit — versioned files only

Only if at least one versioned file changed. Check `git status --short` first: if files **outside** your list are dirty, mention them — they won't be part of this commit.

`AskUserQuestion`:

- **Commit** (recommended) — one commit with only the touched versioned files
- **Leave uncommitted**

On commit: `git add` exactly the touched files by path (never `-A` or `.`), commit with a message in the repo's convention (check `git log --oneline -10`; e.g. `docs(claude): …` for this dotfiles repo), plus the attribution trailer the harness specifies. Don't push.

Commit fails (hook, signing) → report the exact error, leave the changes staged, don't retry with `--no-verify`.

## 6. Hand off to /clear

`/clear` is a built-in CLI command. Claude cannot invoke it — not via the Skill tool, not via Bash. So the last step is the user's.

Finish with a short summary (files updated, memory written, commit hash or "uncommitted"), then the final line, on its own:

> Ready. Run `/clear` now.

Do nothing after that — no follow-up offers, no further tool calls, so nothing new lands in the context that's about to be thrown away.
