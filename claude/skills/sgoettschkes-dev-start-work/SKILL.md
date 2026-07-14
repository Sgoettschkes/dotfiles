---
name: sgoettschkes-dev-start-work
description: Take a piece of dev work from a Notion 🔨 Product Backlog ticket all the way to a fresh Claude session implementing it in an isolated git worktree. Arrive at a ticket one of three ways — create a new ticket, work a specific existing ticket, or browse/filter the backlog (e.g. limited to one Epic) — then warn if the chosen ticket isn't "Selected for development" or is assigned to someone else, claim it, create a worktree via bin/wt-new, and launch a new Claude session in it via ao-open-worktree that runs /phx:plan with full ticket/PR/Epic context. Use when the user says "do dev work", "start dev work", "work a ticket", "spin up a worktree for …", "pick up the next ticket and start building", etc.
---

# Do dev work

Get from "I want to work on something" to a fresh Claude session implementing it in its own git worktree. Run everything from the **access_owl** repository root.

Two Claude instances are involved:
- **This (orchestrator) instance**: steps 1–4 — arrive at a ticket, validate/claim, create the worktree, launch the new session.
- **The new instance** (started by `ao-open-worktree`): step 5 — `/phx:plan` produces the plan, then hands off to `/phx:full` to implement it, then walk-through verification. The hand-off instruction tells it so.

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

## 4. Launch the new Claude session

Hand off via `ao-open-worktree <worktree-path> "<instruction>"`. The instruction is the new session's first prompt — it starts cold, so the instruction must carry everything:

- The `/phx:plan <ticket-url>` invocation (full Notion ticket URL).
- All context: the ticket (description **and** comments — see §1), any prior/related **PR** and the **Epic** (URLs), plus a one-liner on how they relate — read these out of the ticket / the user's request and inline them. Surface anything from the comments the new session can't re-derive from the ticket page itself.
- A note that it was launched by the `sgoettschkes-dev-start-work` skill and must pick up step 5.

Template:

```
ao-open-worktree <worktree-path> "/phx:plan <ticket-url>

You were launched by the sgoettschkes-dev-start-work skill; pick up its remaining steps after planning.

Context: <one-liner>. Related PR: <pr-url> — read its description, diff, and discussion to understand the prior approach. Epic: <epic-url> — read the Epic and its sibling tickets to understand the broader effort. Read all of this before planning.

/phx:plan will produce a plan file and then prompt you to start a fresh session and run /phx:full on it. That fresh session loses this conversation, so before you stop you MUST bake the follow-up into the plan file itself: append a final checkbox task to the plan's task list — '[ ] Run the walk-through-change skill (/walk-through-change) to present the change for manual verification, if it includes user-visible/visual changes checkable in a browser; otherwise skip and say so.' Putting it in the plan is the only way /phx:full sees it after the context clear."
```

## 5. Plan → implement → walk-through — runs in the new instance

For reference (not here):
1. `/phx:plan` produces an implementation plan against the ticket, using the PR/Epic context. Because it then recommends a fresh session (context clear) before `/phx:full`, the walk-through follow-up would be lost — so the plan session appends it as a **final checkbox task in the plan file** so it survives the clear. Then it prompts the user to start `/phx:full` with that plan.
2. `/phx:full` (fresh session) reads the plan file, implements it (implement → review → commit), and verifies it — including the appended walk-through task.
3. Per that task: user-visible/visual changes → invoke **walk-through-change** to boot the dev server, seed the DB, and open the changed page logged-in; nothing visual → skip and say why.

## Done

Report back: the ticket (title + URL), its claimed state, the branch/worktree path and ports, and that the new session is running `/phx:plan` (which will hand off to `/phx:full`). This instance's job ends there.
