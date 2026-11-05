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

Carry this rule forward: whenever you write a plan file, it must land
verbatim in it (see "Plan file blocks" below), because a session that
executes the plan after a context clear never sees this file.

## Review & verification — suggest these, every time

- After **significant code changes**, suggest the user run the
  **accessowl-review** skill (`/accessowl-review`) before committing or
  opening a PR.
- When the change includes **user-visible/visual changes** checkable in a
  browser, suggest the **accessowl-walk-through-change** skill
  (`/accessowl-walk-through-change`) to present it for manual verification.

Suggest only — don't run either unasked. Nothing visual? Say so instead of
suggesting the walk-through.

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

{Keep exactly ONE of the four variants below — the start mode the user
chose — and delete the other three together with every "Variant …" label.}

{Variant A — plan, then clear and work:}

1. Read the ticket (description **and** comments via `notion-get-comments`)
   plus every resource listed above, before planning.
2. Invoke the phx:plan skill exactly as if the user had typed
   `/phx:plan {ticket-url}` (Skill tool, skill `elixir-phoenix:plan`, the
   ticket URL as args). Steer it to save its plan as
   `.claude/plans/{slug}/plan.md`, next to this file; if it ends up under a
   different slug anyway, use that actual path in the steps below.
3. **Before you stop**, add the "Plan file blocks" below to the plan file.
   The plan is executed after a `/clear`, by a session that never sees your
   conversation — the plan file is the only channel that survives, so this
   step is mandatory.
4. Ask the user to run `/clear` and then `/phx:work <path-to-the-plan>`.

{Variant B — quick implementation, no phx:plan:}

1. Read the ticket (description **and** comments via `notion-get-comments`)
   plus every resource listed above.
2. Invoke the phx:quick skill exactly as if the user had typed
   `/phx:quick <one-line summary of the ticket>` (Skill tool, skill
   `elixir-phoenix:quick`, the summary as args). Do **not** run `/phx:plan`
   first. The environment rule above still applies to its verification
   commands.
3. If phx:quick hits its escape hatch (change too big for quick mode), stop
   and ask the user how to continue rather than switching to planning on
   your own.

{Variant C — implement directly:}

1. Read the ticket (description **and** comments via `notion-get-comments`)
   plus every resource listed above.
2. Implement the ticket directly in this session, following the environment
   rule above and suggesting the skills from "Review & verification" when
   they apply.

{Variant D — wait for the user:}

1. Confirm in one or two lines that you've read this briefing for
   "{ticket-title}", then wait for the user's instructions. Don't read the
   ticket or start any work until they say so.

## Plan file blocks

Whenever you write a plan file for this ticket, edit it so it carries both
of these, verbatim:

a. A section at the very top:

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

b. This final checkbox appended to the plan's task list:

```markdown
- [ ] Suggest next steps to the user: the accessowl-review skill
  (/accessowl-review) if the change touched significant code, and the
  accessowl-walk-through-change skill (/accessowl-walk-through-change) if it
  includes user-visible/visual changes checkable in a browser (otherwise say
  so). Suggest only — don't run either unasked.
```
