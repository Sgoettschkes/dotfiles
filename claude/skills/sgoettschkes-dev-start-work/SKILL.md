---
name: sgoettschkes-dev-start-work
description: Take a piece of dev work from a Notion 🔨 Product Backlog ticket all the way to a fresh Claude session implementing it in an isolated git worktree. Arrive at a ticket one of three ways — create a new ticket, work a specific existing ticket, or browse/filter the backlog (e.g. limited to one Epic) — then warn if the chosen ticket isn't "Selected for development" or is assigned to someone else, claim it, create a worktree via bin/wt-new, write the full ticket/PR/Epic briefing to .claude/plans/<slug>/initial.md in the worktree, and launch a new Claude session in it via ao-open-worktree that runs /phx:plan against that briefing. Use when the user says "do dev work", "start dev work", "work a ticket", "spin up a worktree for …", "pick up the next ticket and start building", etc.
---

# Do dev work

Get from "I want to work on something" to a fresh Claude session implementing it in its own git worktree. Run everything from the **access_owl** repository root.

Two Claude instances are involved:
- **This (orchestrator) instance**: steps 1–4 — arrive at a ticket, validate/claim, create the worktree, write the handoff file, launch the new session.
- **The new instance** (started by `ao-open-worktree`): step 5 — `/phx:plan` produces the plan, then hands off to `/phx:full` to implement it, then walk-through verification. Its briefing lives in `.claude/plans/<slug>/initial.md` (written in §4), not in its first prompt.

Pairs with `fix-notion-ticket` (single-instance variant) and the team conventions in `.claude/memory/`.

## 1. Arrive at a ticket

Ask which path the user wants if not already clear:

- **A — Create a new ticket.** Gather title/scope (and follow-up context like a prior PR or Epic). Create it in the **🔨 Product Backlog** data source `collection://01334783-facd-4b17-81f2-de35711770de` via `notion-create-pages` with `Status = "In progress"`, `Assign = ["<current-user-id>"]` (resolution in §2), `Type` (`"Feature ⭐️"` / `"Bug 🐞"`), `Priority` (`"Showstopper"`/`"High"`/`"Medium"`/`"Cosmetic"`), and the `Epic` relation when one applies (pass the Epic page URL). A freshly created ticket skips the §2 warnings — it's ours and claimed at creation.
- **B — Work a specific existing ticket.** From a Notion URL/id or enough title to find it (`notion-search` / `notion-fetch`). Then §2.
- **C — Browse the backlog.** Query the data source (`notion-query-data-sources` SQL over `collection://01334783-facd-4b17-81f2-de35711770de`, or the board view) honoring any filter the user gives — most commonly one **Epic** (the `Epic` relation points at `collection://691eebe0-5a82-4595-a479-5d32319d43be`), but also Status, Type, Priority, or assignee. Present candidates, let the user pick, then §2.

Whenever you read an existing ticket (paths B and C), don't stop at the page description — also fetch its **comments** via `notion-get-comments`. Comments often carry clarifications, scope changes, or decisions that never made it into the description. Fold anything relevant into the context you gather.

Before coding direction is set, confirm the work lives in **this** repo — if the symptom originates in `extractor`/`provisioner` (see `reference_repo_boundaries`), flag it and stop.

## 2. Validate & claim (paths B and C)

Resolve the current user's Notion id from the session email via `notion-get-users`.

**Re-fetch the ticket** right before claiming, then **warn** if either holds:
- `Status` is not `"Selected for development"` (still Backlog/To triage, already In progress, Completed, Rejected, …), or
- `Assign` contains someone other than the current user.

State what you found and ask whether to proceed. Never silently claim a ticket that trips either condition.

Once cleared: `notion-update-page` with `command: update_properties`, `properties: {"Status": "In progress", "Assign": "[\"<user-id>\"]"}`.

## 3. Create the worktree

Pick a **short** branch name — kebab-case, ~2–4 meaningful words from the ticket title, no ticket-id noise (e.g. `app-hub-experimental2-gate`, not `app-hub-gate-web-request-flow-on-experimental2-feature-flag`). `bin/wt-new` derives the worktree dir and dev/test DB suffixes from it, so keep it tight.

```bash
bin/wt-new <branch>
```

This clones the dev DB and sets up the test DB — takes a few minutes; let it finish. Note the printed worktree path (e.g. `../access_owl-<branch>`).

## 4. Write the handoff file & launch the new session

The new session starts cold; its entire briefing lives in a handoff file inside the worktree, and the launch prompt is only a pointer to it.

1. Use the branch name as the **slug**.
2. Fill in the template at `references/initial-template.md` next to this SKILL.md (`~/.claude/skills/sgoettschkes-dev-start-work/references/initial-template.md`): replace every `{placeholder}` with what §§1–3 gathered, drop the sections the template marks as deletable when they don't apply, and let nothing template-ish (placeholders, fill-in instructions) survive into the result. Surface anything from the ticket comments the new session can't re-derive from the ticket page itself.
3. Write it to `<worktree-path>/.claude/plans/<slug>/initial.md`.
4. Launch:

```
ao-open-worktree <worktree-path> "Follow .claude/plans/<slug>/initial.md — it is your full briefing from the sgoettschkes-dev-start-work skill."
```

## 5. In the new instance — reference only, nothing to do here

`initial.md` carries the new session's steps: read ticket/PR/Epic → `/phx:plan` → append the walk-through checkbox task to the plan file (verbatim text in the template; the plan file is the only context that survives into the fresh `/phx:full` session) → hand the user to `/phx:full`, which implements, reviews, commits, and ends with the walk-through task (visual changes → **walk-through-change** presents them in the browser; nothing visual → skip and say why).

## Done

Report back: the ticket (title + URL), its claimed state, the branch/worktree path and ports, the handoff file path (`.claude/plans/<slug>/initial.md`), and that the new session is running `/phx:plan` (which will hand off to `/phx:full`). This instance's job ends there.
