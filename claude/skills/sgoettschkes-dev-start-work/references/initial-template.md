# Initial context: {ticket-title}

**Ticket**: {ticket-url}
**Branch**: {branch}
**Worktree**: {worktree-path}
**Claimed**: Status "In progress", assigned to {user-name}
**Written**: {date} by the sgoettschkes-dev-start-work skill

## Why this file exists

You are a fresh Claude session in a dedicated git worktree, launched to
implement the ticket above. This file is your full briefing: it carries
everything the orchestrator session knew that you cannot re-derive on your
own. Read it fully — starting with the environment rule directly below, which
applies to every command you run — then work through "Your remaining steps".

## STOP — environment rule for every mix command

This worktree has its **own** `.env.local` (written by `bin/wt-new`) holding
its dedicated `DATABASE_NAME`, `TEST_DATABASE_NAME`, `PORT` and `TEST_PORT`.
Nothing exports those for you.

**Before running any `mix` command — always, no exceptions — source
`.env.local` in the same shell invocation:**

```bash
source .env.local && mix test
source .env.local && mix test test/some/path_test.exs
source .env.local && mix compile
source .env.local && mix ecto.migrate
source .env.local && iex -S mix phx.server
```

Shell state does **not** persist between tool calls, so one earlier `source`
does not carry over: every command touching `mix` must re-source in its own
invocation. Chain with `&&` (or `cd {worktree-path} && source .env.local && …`
when the working directory may differ).

Running `mix` without it silently targets the **main checkout's** dev/test
database and the default port — it writes to the wrong database, collides
with other worktrees' servers, and produces test results that mean nothing.
If a mix command fails on DB or port, suspect a missing `source` first.

Carry this rule forward: it must land verbatim in the plan file you write in
step 2 below, because the session that executes the plan never sees this file.

## Context

{One-liner: what the ticket is about and how the PR/Epic below relate to it.}

### From the ticket comments

{Clarifications, scope changes, or decisions found in the ticket's comments
that are NOT in the description. Delete this whole section if the comments
held nothing relevant.}

### Related resources

- **Prior/related PR**: {pr-url} — read its description, diff, and discussion
  to understand the prior approach. {One line on how it relates.}
- **Epic**: {epic-url} — read the Epic and its sibling tickets to understand
  the broader effort.

{Delete any resource line that doesn't apply; delete the section if none do.}

## Your remaining steps

1. Read the ticket (description **and** comments via `notion-get-comments`)
   plus every resource listed above, before planning.
2. Invoke the phx:plan skill exactly as if the user had typed
   `/phx:plan {ticket-url}` (Skill tool, skill `elixir-phoenix:plan`, the
   ticket URL as args). Steer it to save its plan as
   `.claude/plans/{slug}/plan.md`, next to this file; if it ends up under a
   different slug anyway, use that actual path in the steps below.
3. **Before you stop**, edit the plan file so it carries both of these into
   the fresh session that executes it:

   a. A section at the very top, verbatim:

   ```markdown
   ## Environment — source .env.local before every mix command

   This worktree has its own `.env.local` with its dedicated
   `DATABASE_NAME`, `TEST_DATABASE_NAME`, `PORT` and `TEST_PORT`. Shell
   state does not persist between tool calls, so **every** command that
   runs `mix` must source it in the same invocation:

   `source .env.local && mix test`, `source .env.local && mix compile`,
   `source .env.local && iex -S mix phx.server`.

   Skipping it targets the main checkout's databases and default port:
   wrong database written, port collisions, meaningless test results.
   ```

   b. This final checkbox appended to the plan's task list, verbatim:

   ```markdown
   - [ ] Run the walk-through-change skill (/walk-through-change) to present
     the change for manual verification, if it includes user-visible/visual
     changes checkable in a browser; otherwise skip and say so.
   ```

   The plan is executed by `/phx:full` in a fresh session that never sees
   your conversation — the plan file is the only channel that survives the
   context clear, so this step is mandatory.
4. Prompt the user to start a fresh session and run
   `/phx:full <path-to-the-plan>`.
