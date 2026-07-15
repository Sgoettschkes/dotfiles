# Initial context: {ticket-title}

**Ticket**: {ticket-url}
**Branch**: {branch}
**Claimed**: Status "In progress", assigned to {user-name}
**Written**: {date} by the sgoettschkes-dev-start-work skill

## Why this file exists

You are a fresh Claude session in a dedicated git worktree, launched to
implement the ticket above. This file is your full briefing: it carries
everything the orchestrator session knew that you cannot re-derive on your
own. Read it fully, then work through "Your remaining steps" below in order.

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
3. **Before you stop**, append this final checkbox task to the plan's task
   list, verbatim:

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
