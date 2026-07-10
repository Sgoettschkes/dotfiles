---
name: gtd-clear-inboxes
description: Process the user's GTD inboxes to zero. Walks every inbox Claude can reach (Obsidian, Nirvana, Slack, Gmail, Drive, Downloads), shows each item one at a time, and asks what to do with it — then applies the decision. Inboxes Claude can't reach (e.g. the Physical Inbox, or any connector that isn't authenticated) are collected and handed back to the user to process manually at the end. Use when the user asks to "clear inboxes", "process my inbox", "inbox zero", "do a GTD sweep", or similar.
---

# GTD — Clear Inboxes

Empty the user's inboxes one item at a time, applying a GTD decision to each. Goal: **inbox zero across every reachable inbox**, plus a hand-off list for the rest.

**GTD and PARA:** the user runs both methodologies side by side — GTD (Getting Things Done) for stuff to do, PARA for filing. This is a GTD workflow: capture lands in inboxes, and processing each item (trash / do / defer / delegate / file) is the GTD clarify step. Its outputs split along that line — actions become Nirvana tasks (GTD), while reference material files into the PARA buckets (Projects / AoR / Resources / Archives) across Obsidian, Drive, and Gmail. Projects exist in both systems.

## Source of truth

The canonical inbox list lives in the Spaces note, section `## Inboxes`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Read this first** — the user maintains it; never hardcode the list. As of writing: Gmail privat, Gmail AgileAddicts, Gmail AccessOwl, Nirvana, Obsidian, Google Drive privat, Physical Inbox, AccessOwl Slack.

## Step 1 — Triage reachability

For each inbox, decide whether it's readable **right now**. Connectors (Gmail, Slack) may be unauthenticated in a CLI session — one failed tool call means unreachable; move on, don't retry.

| Inbox | How to reach it | Notes |
|---|---|---|
| Obsidian | `0 - Inbox/` in `~/Documents/Second Brain` (`Bash`/`Read`) | Always reachable (local). |
| Nirvana | `mcp__nirvana__get_tasks` with `state=inbox` | Always reachable. |
| AccessOwl Slack | Unread @-mentions, DMs, saved/"Later" items via Slack MCP | Connector — may be unauthenticated. |
| Gmail privat | `gws` CLI (e.g. `gws gmail users messages list --params '{"userId": "me", ...}'`) — never the Gmail MCP | If auth expired, mark unreachable and suggest `gws auth login`. |
| Gmail AccessOwl | Gmail MCP | Connector — may be unauthenticated. |
| Gmail AgileAddicts | Not reachable — **never access any other Gmail account**. | Always on the manual hand-off list. |
| Google Drive privat | Local synced folder `~/My Drive/0 - Inbox` (`Bash`/`Read`) | Always reachable — no connector needed. |
| Downloads | `~/Downloads` (`Bash`/`Read`) | Always reachable (local). |
| Physical Inbox | Not reachable — paper. | Always on the manual hand-off list. |

Announce the plan before starting: which inboxes now, which deferred, and roughly how many items each reachable one holds.

## Step 2 — Process, one item at a time

Go inbox by inbox. Present **one item at a time** — never dump the whole inbox and batch-ask:

```
[<inbox> · item N/total]
From/Title: …
When: …
Summary: <one line of what it is / what it's asking>
```

Then offer the GTD menu (the user may reply with a number or natural language):

1. **Trash** — delete/archive; nothing to keep. For a **Nirvana** inbox capture, complete it instead of trashing (see Decision rules).
2. **Do now** — <2-minute action; do it immediately if Claude can, else tell the user to.
3. **Next action** → Nirvana task in `next`.
4. **Defer** → Nirvana task in `scheduled` with a start date.
5. **Waiting for** → Nirvana task in `waiting`.
6. **Someday** → Nirvana task in `someday`.
7. **Reference** → file into Obsidian Resources or Drive (material to keep, not an action).
8. **New project** → multiple steps / has an outcome → create a Nirvana project (see rules).

Apply each decision before moving on, confirm briefly (`✓ Filed to …` / `✓ Nirvana next: …`), and continue until the inbox is empty.

## Decision rules

- **Nirvana states are explicit.** Standalone tasks get exactly the state the user picked — never silently assume `next` or `inbox`. Tasks created under a project default to `next` (or waiting/scheduled), never inbox.
- **Nirvana project tasks inherit their area — don't re-tag.** A task created under a project (`parentid` set) inherits the project's area (`private`, `AccessOwl`, etc.); passing that area again in `tags` makes it show up twice. Create child tasks with `tags: []` (or only context tags like `computer`/`home`/`call`). Standalone tasks with no parent still get the area tag explicitly.
- **Nirvana inbox captures: complete, don't trash.** When a Nirvana inbox capture has been actioned or folded into a project/task, mark it `completed: true` (it stays as a record and drops out of the inbox) — never set state `trash`. Trashing soft-deletes and loses the record; completing preserves it. This applies only to Nirvana items; Gmail/Drive/Obsidian items are still archived/deleted per the user's choice.
- **New project** → also auto-create the matching Obsidian stub and Drive folder, and tell the user which Gmail labels to add. Names are outcome-oriented (Verb + Sache + optional Jahr). Follow the `para_create_project_workflow` memory.
- **Reference filing** follows the Resources-bucket rule: Obsidian = notes/knowledge, Gmail = correspondence, Drive = files. File where the material lives — don't mirror across tools.
- **Obsidian inbox items** are a single `.md` or a folder. File by `mv` out of `0 - Inbox/` into the right PARA bucket (no Obsidian MCP — the vault is local). After moving, fix links: `grep -rl` the vault for the old basename/path and rewrite explicit-path markdown links/embeds (plain `[[wikilinks]]` resolve by name and usually survive).
- In doubt about placement or work-vs-private → **ask**.

## Step 3 — Hand off the unreachable inboxes

Once every reachable inbox is at zero, list what Claude couldn't process (Physical Inbox + unauthenticated connectors) for the user to do manually now:

```
Reachable inboxes cleared ✓

Still to do yourself (no access):
- Physical Inbox — paper on your desk
- Gmail AgileAddicts — Claude never accesses this account
- Gmail AccessOwl — connector not authenticated this session

Process these the same way: trash / do / defer / file.
```

## Done

Report: which inboxes hit zero, items processed, tasks/projects created, and the manual hand-off list. Don't offer to log this or post EOD — the user will ask.
