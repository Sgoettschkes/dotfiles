---
name: do-dev-work
description: Take a piece of dev work from a Notion 🔨 Product Backlog ticket all the way to a fresh Claude session implementing it in an isolated git worktree. Arrive at a ticket one of three ways — create a new ticket, work a specific existing ticket, or browse/filter the backlog (e.g. limited to one Epic) — then warn if the chosen ticket isn't "Selected for development" or is assigned to someone else, claim it, create a worktree via bin/wt-new, and launch a new Claude session in it via ao-open-worktree that runs /phx:full with full ticket/PR/Epic context. Use when the user says "do dev work", "start dev work", "work a ticket", "spin up a worktree for …", "pick up the next ticket and start building", etc.
---

# Do dev work

Orchestrates getting from "I want to work on something" to a fresh Claude session implementing it in its own git worktree. Run everything from the **access_owl** repository root.

This skill spans **two** Claude instances:
- **This (orchestrator) instance** does steps 1–4: arrive at a ticket, validate/claim it, create the worktree, launch the new session.
- **The new instance** (started by `ao-open-worktree`) does step 5: the actual implementation via `/phx:full`, plus the walk-through verification. The instruction handed to it tells it so.

Pairs with `fix-notion-ticket` (single-instance variant) and the team conventions in `.claude/memory/`.

## 1. Arrive at a ticket

Ask the user which path they want if it isn't already clear from their request:

- **A — Create a new ticket.** Gather the title/scope (and any follow-up context like a prior PR or Epic). Create it in the **🔨 Product Backlog** data source `collection://01334783-facd-4b17-81f2-de35711770de` via `notion-create-pages`. Set `Status = "In progress"`, `Assign = ["<current-user-id>"]` (see §2 for resolving the id), and the appropriate `Type` (`"Feature ⭐️"` / `"Bug 🐞"`) and `Priority` (`"Showstopper"`/`"High"`/`"Medium"`/`"Cosmetic"`). Relate the `Epic` when one applies (pass the Epic page URL). A freshly created ticket needs no warning in §2 — it's ours and claimed at creation.
- **B — Work a specific existing ticket.** The user gives a Notion URL/id or enough of the title to find it (`notion-search` / `notion-fetch`). Then run §2.
- **C — Browse the backlog list.** Query the data source and let the user pick. Honor any filter they give — most commonly **one Epic** (the `Epic` relation points at `collection://691eebe0-5a82-4595-a479-5d32319d43be`), but also Status, Type, Priority, or assignee. Use `notion-query-data-sources` (SQL over `collection://01334783-facd-4b17-81f2-de35711770de`) or the board view. Present the candidates, let the user choose, then run §2 for the chosen ticket.

Before coding direction is set, confirm the work lives in **this** repo — if the symptom originates in `extractor`/`provisioner` (see `reference_repo_boundaries`), flag it and stop.

## 2. Validate & claim (existing tickets — paths B and C)

Resolve the current user's Notion id from the session user's email via `notion-get-users`.

**Re-fetch the ticket** right before claiming, then **warn the user** if either is true:
- `Status` is **not** `"Selected for development"` (e.g. it's still Backlog/To triage, already In progress, Completed, Rejected, …), or
- `Assign` contains **someone other than the current user** (someone may have claimed it).

State plainly what you found and ask whether to proceed anyway. Do not silently claim a ticket that trips either condition.

Once cleared (or the user says go ahead), claim it: `notion-update-page` with `command: update_properties`, `properties: {"Status": "In progress", "Assign": "[\"<user-id>\"]"}`.

## 3. Create the worktree

Pick a **short** branch name that maps to the ticket — kebab-case, ~2–4 meaningful words from the ticket title, no ticket-id noise (e.g. `app-hub-experimental2-gate`, not `app-hub-gate-web-request-flow-on-experimental2-feature-flag`). `bin/wt-new` derives the worktree dir and the dev/test DB suffixes from it, so keep it tight.

```bash
bin/wt-new <branch>
```

This clones the dev DB and sets up the test DB — it takes a few minutes; let it finish. Note the printed worktree path (e.g. `../access_owl-<branch>`).

## 4. Launch the new Claude session

Hand the worktree off to a fresh Claude session via `ao-open-worktree <worktree-path> "<instruction>"`. The instruction becomes that session's first prompt, so compose it to carry **everything** the new instance needs:

- The `/phx:full <ticket-url>` invocation (full Notion ticket URL).
- All relevant context to understand the task: the ticket, plus any **prior/related PR** and the **Epic** (URLs), and a one-line note on how they relate. Read these out of the ticket / the user's request and inline them — the new instance starts cold.
- A note that **it was launched by the `do-dev-work` skill** and must **pick up the remaining steps of that skill** — specifically step 5 below.

Template (fill in the specifics):

```
ao-open-worktree <worktree-path> "/phx:full <ticket-url>

You were launched by the do-dev-work skill; pick up its remaining steps after implementing.

Context: <one-liner>. Related PR: <pr-url> — read its description, diff, and discussion to understand the prior approach. Epic: <epic-url> — read the Epic and its sibling tickets to understand the broader effort. Read all of this before implementing.

After /phx:full has implemented and verified the change: if it includes user-visible / visual changes that can be checked in a browser, run the walk-through-change skill (/walk-through-change) as a final step so the change is presented for manual verification. If there are no browser-verifiable visual changes, skip it and say so."
```

## 5. Implementation & walk-through — done by the new instance

For reference (this runs in the **new** session, not here):
1. `/phx:full` runs the plan → implement → review → commit cycle against the ticket, using the PR/Epic context provided.
2. After implementing and verifying, if the change has **user-visible/visual** behavior checkable in a browser, the new instance invokes the **walk-through-change** skill to boot the dev server, seed the DB, and open the changed page logged-in. If there's nothing visual to see, it skips this and notes why.

## Done

Once the new session is launched, report back to the user: the ticket (title + URL), its claimed state, the branch/worktree path and ports, and that the new Claude session is running `/phx:full`. This instance's job is finished at that point.
