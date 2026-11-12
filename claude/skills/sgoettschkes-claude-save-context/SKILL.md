---
name: sgoettschkes-claude-save-context
description: Before the user clears the context, sweep the current session for knowledge worth keeping and write it into the artifacts that should carry it — README, agent files (AGENTS.md, CLAUDE.md, .claude/agents, skills), docs, repo memory (checked-in CLAUDE.md / CLAUDE.local.md) and the local auto-memory. Lists every proposed update, asks whether to apply them (re-asking with the revised list whenever the user requests changes), applies the approved ones, offers to commit the versioned files, then hands off to /clear. Use when the user says "save context", "persist what we learned", "before I clear", "prep for /clear", "update docs before clearing", or invokes this skill directly.
---

# Save context before /clear

`/clear` throws away everything this session learned. Anything that should outlive it has to land in a file first. This skill finds those things, gets approval on the exact list, writes them, optionally commits, and ends with the user running `/clear`.

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

## 3. List everything and ask

Show the full list, grouped by artifact, versioned ones marked:

```
README.md (versioned)
  - Add `make foo` to Maintenance Commands — added this session
AGENTS.md (versioned)
  - Folder Structure: add `bin/wt-new` — new script
memory: wt-rm-flag-spelling.md (local, new)
  - `-db` not `--db`; `--db` exits "unknown flag"
memory: gws-cli-auth-setup-quirks.md (local, update)
  - Token expiry is now 30 days, not 7
```

Each line says what changes and why, in one line. Nothing found → say so and skip to §6.

Then `AskUserQuestion`:

- **Apply all** (recommended)
- **Pick some** → follow up with a multi-select of the items, then apply only those
- **Skip** → write nothing, go to §6

Any free-text answer ("all but the README one", "reword X", "also add Y") means the list changed: revise it, show the full revised list again, and ask again with the same options. Repeat until the user picks one of the three options — never apply a version they haven't seen.

## 4. Apply

Write each approved update with Edit (Write only for new files). Match the target file's style exactly — if a file is written in a compressed style, write compressed; if it's prose, write prose. Comments-say-why rules from the user's instructions apply to any code touched.

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
