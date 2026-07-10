---
name: gtd-weekly-review
description: Run the user's full GTD Weekly Review in the canonical three phases — Get Clear (papers, inboxes to zero via gtd-clear-inboxes, mind sweep), Get Current (next actions, calendars back and forward, waiting-for, projects, scheduled, AoR checklist), Get Creative (someday/maybe, new ideas). Nirvana is the task master; every phase is interactive and skippable; anything unreachable lands on a manual hand-off list. Use when the user asks for a "weekly review", "GTD review", "do my review", or "review my system".
---

# GTD — Weekly Review

David Allen's canonical Weekly Review (Get Clear → Get Current → Get Creative), mapped onto the user's system. The goal: **the whole system is current and trusted again** — inboxes empty, every list reviewed, every active project moving.

**GTD and PARA:** the user runs both side by side — GTD for stuff to do, PARA for filing. The Weekly Review is the core GTD habit; PARA filing only comes up when inbox processing files reference material.

This is a long, interactive session (60–90 min when done fully). Rules of engagement:

- **Announce the phase plan up front, then work phase by phase.** The user may say "skip X" or "stop after Y" at any point — honor it and note skipped steps in the final summary.
- **Compact lists for reviewing, one-at-a-time for deciding.** Long lists (next actions, scheduled) are shown grouped and whole; the user flags what needs action. Short lists and real decisions (waiting-for, stalled projects, strays) go one item at a time.
- **Nirvana decision rules from [[gtd-clear-inboxes]] apply throughout:** states are explicit, never assume `next`; project child tasks get `tags: []` (area is inherited); actioned Nirvana items are completed, never trashed.

## Setup

1. Read the Spaces note — inboxes and AoR list live there, never hardcode:
   `~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`
2. `mcp__nirvana__get_task_counts` → announce the shape of the review: inbox n, next n, waiting n, scheduled n, someday n, active projects n.
3. Ask if anything should be skipped this week (e.g. inboxes already cleared today).

## Phase 1 — Get Clear

### 1. Collect loose papers and materials
Not reachable (physical). Goes on the manual hand-off list; remind the user at the end.

### 2. Get inboxes to zero
Invoke the **[[gtd-clear-inboxes]]** skill via the Skill tool — it owns the inbox list, reachability rules, and the clarify menu. Don't reimplement it here. If the user already cleared inboxes recently, skip on their say-so.

### 3. Mind sweep — empty the head
Prompt the user to dump whatever's on their mind, seeded with a short trigger list:

> Anything on your mind? Triggers: promises made · Sophie/family · AccessOwl (tickets, reviews, people) · Selbstständigkeit (Kunden, Rechnungen, Steuer) · Wohnung/Besorgungen · Gesundheit/Termine · Finanzen · Freunde · anstehende Reisen/Events

Clarify each capture immediately using the same GTD menu as gtd-clear-inboxes (do now / next / defer / waiting / someday / reference / project) — during a review nothing gets parked in the inbox that was just emptied.

## Phase 2 — Get Current

### 4. Review next actions
`get_tasks` with `state=next`. Show the full list compactly, grouped by area, and ask the user to flag: **done** (→ `completed: true`), **no longer a next action** (→ renegotiate to `scheduled`/`someday`), **dead** (→ complete with a note, trash only on explicit request). Everything unflagged stays.

### 5. Review the past calendar (last 7 days)
- **Privat calendar:** `gws calendar events list` with `calendarId: "primary"` and a `timeMin`/`timeMax` window (never the Google Calendar MCP for privat).
- **AccessOwl calendar:** Google Calendar MCP (`list_events`) — connector, may be unauthenticated.

One failed call → that calendar goes on the manual hand-off list; don't retry. Walk the past week's events and ask: anything left over — follow-ups, notes to file, promises made? Capture as Nirvana tasks.

### 6. Review the upcoming calendar (next 14 days)
Same sources. Ask per notable event: any prep action needed? Capture with the right state (`next` or `scheduled`).

### 7. Review waiting-for
`get_tasks` with `state=waiting` — one item at a time:
1. **Received** → `completed: true`.
2. **Nudge** → create a next action to follow up (or draft the message right now if it's Slack/email Claude can reach).
3. **Still waiting** → keep, optionally note the date of last check in the task.

### 8. Review projects
`get_tasks` with `type=project`, `state=active`, plus each project's tasks. For every project check: **does it have at least one next or scheduled action?** Surface stalled projects one at a time:
1. **Add next action** → create it under the project.
2. **It's actually done** → hand to [[gtd-finish-project]].
3. **Demote** → move project to `someday`.
4. **Skip** → leave for now.

Also ask once whether to run [[gtd-sync-projects]] (mirror reconciliation across Obsidian/Drive/Gmail) — useful every few weeks, not required weekly.

### 9. Review the scheduled list
`get_tasks` with `state=scheduled`, shown compactly sorted by start date. Sanity check: dates still right, anything that should start now (→ `next`), anything that will never happen (→ `someday` or complete).

### 10. Review AoR checklist
The GTD "review relevant checklists" step, using the `## AoR` section of Spaces.md. Show each AoR with its purpose line and ask which need attention this week. For flagged ones, capture the action or project ([[gtd-create-project]] for projects).

## Phase 3 — Get Creative

### 11. Review someday/maybe
`get_tasks` with `state=someday`, one item at a time:
1. **Activate** → `next` (or a real project via [[gtd-create-project]]).
2. **Keep** → still a maybe.
3. **Drop** → complete with a note; trash only if the user explicitly says so.

### 12. Be creative and courageous
Last question: "Any new ideas, projects, or experiments — however unlikely?" Capture each with an explicit state (usually `someday`).

## Done

Summarize the review:

```
Weekly Review complete ✓
- Inboxes: cleared (via gtd-clear-inboxes) / skipped
- Mind sweep: n captures
- Next: n completed, n renegotiated · Waiting: n resolved · Scheduled: n adjusted
- Projects: n active, n un-stalled, n finished/demoted
- Someday: n activated, n dropped · New ideas: n

Still to do yourself (no access):
- Physical papers & inbox
- <calendars/connectors that failed>
```

Don't offer to log this or post EOD — the user will ask.

## Related

- [[gtd-clear-inboxes]] — owns inbox processing (step 2).
- [[gtd-sync-projects]] — optional mirror reconciliation (step 8).
- [[gtd-finish-project]] / [[gtd-create-project]] — invoked from steps 8, 10, 11 as needed.
