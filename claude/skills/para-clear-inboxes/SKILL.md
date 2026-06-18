---
name: para-clear-inboxes
description: Process the user's PARA inboxes to zero, GTD-style. Walks every inbox Claude can reach (Obsidian, Nirvana, Slack, Gmail, Drive, Downloads), shows each item one at a time, and asks what to do with it — then applies the decision. Inboxes Claude can't reach (e.g. the Physical Inbox, or any connector that isn't authenticated) are collected and handed back to the user to process manually at the end. Use when the user asks to "clear inboxes", "process my inbox", "inbox zero", "do a PARA sweep", or similar.
---

# PARA — Clear Inboxes

Walk the user through emptying their PARA inboxes one item at a time, applying a GTD decision to each. The goal is **inbox zero across every reachable inbox**, plus a clear hand-off list for the ones Claude can't touch.

## Source of truth for the inbox list

The canonical list of inboxes lives in the **Spaces** note, section `## Inboxes`:

`~/Documents/Second Brain/1 - Projects/PARA umsetzen/Spaces.md`

**Always read this first** — don't hardcode the list. The user maintains it; it may have changed since this skill was written. As of writing it contains: Gmail privat, Gmail AgileAddicts, Gmail AccessOwl, Nirvana, Obsidian, Google Drive privat, Physical Inbox, AccessOwl Slack.

## Step 1 — Triage which inboxes are reachable

For each inbox in the Spaces list, decide if Claude can actually read it **right now** in this session. Connectors (Gmail, Slack, Drive) may not be authenticated in a CLI session — if a tool call fails or the connector isn't available, treat that inbox as **unreachable** and move on; don't keep retrying.

| Inbox | How to reach it | Notes |
|---|---|---|
| Obsidian | `0 - Inbox/` folder in the vault (`mcp__obsidian__list_directory` / `read_note`) | Always reachable (local). |
| Nirvana | `mcp__nirvana__get_tasks` with `state=inbox` | Always reachable. |
| AccessOwl Slack | Unread @-mentions, DMs, and saved/"Later" items via the Slack MCP | Connector — may be unauthenticated. |
| Gmail privat / AgileAddicts / AccessOwl | Unread / inbox messages per account via the Gmail MCP | Connector — may be unauthenticated. Three separate accounts. |
| Google Drive privat | Local synced folder `~/My Drive/0 - Inbox` (read with `Bash`/`Read`) | Always reachable (synced locally) — no connector needed. |
| Downloads folder | Local folder `~/Downloads` (read with `Bash`/`Read`) | Always reachable (local). |
| Physical Inbox | **Not reachable** — physical paper. | Always goes on the manual hand-off list. |

Announce the plan before starting: list which inboxes you'll process now and which you'll defer to manual hand-off, and roughly how many items each reachable inbox holds.

## Step 2 — Process reachable inboxes, one item at a time

Go inbox by inbox (reachable ones only). For **each item**, present it compactly and ask what to do. Show one item at a time — do not dump the whole inbox and batch-ask.

Present each item as:

```
[<inbox> · item N/total]
From/Title: …
When: …
Summary: <one line of what it is / what it's asking>
```

Then offer the GTD decision menu (let the user just reply with a number or natural language):

1. **Trash** — delete / archive it; nothing to keep.
2. **Do now** — it's a <2-minute action; do it immediately if Claude can, else tell the user to.
3. **Next action** → create a Nirvana task in `next`.
4. **Defer** → create a Nirvana task in `scheduled` with a start date.
5. **Waiting for** → create a Nirvana task in `waiting` (delegated / blocked).
6. **Someday** → create a Nirvana task in `someday`.
7. **Reference** → file into Obsidian Resources or Drive (it's material to keep, not an action).
8. **New project** → it needs multiple steps / has an outcome → create a Nirvana project (see project rule below).

Apply the decision with the right tool before moving to the next item, then confirm briefly (`✓ Filed to …` / `✓ Nirvana next: …`). Keep moving until the inbox is empty, then move to the next reachable inbox.

## Decision rules (respect these)

- **Nirvana states are explicit.** New standalone tasks go to the state the user picked from the menu — never silently assume `next` or `inbox`. Tasks created **under a project** default to `next` (or waiting/scheduled), never inbox.
- **New project** → when creating a Nirvana project, also auto-create the matching Obsidian stub and Drive folder, and tell the user which Gmail labels to add. Project names are outcome-oriented (Verb + Sache + optional Jahr). Follow the `para_create_project_workflow` memory.
- **Reference filing** follows the Resources-bucket rule: Obsidian = notes/knowledge, Gmail = correspondence, Drive = files. Don't mirror across tools — file where the material lives.
- **Obsidian inbox items** can be a single `.md` or a folder; either is fine. To file one, move it out of `0 - Inbox/` into the right PARA bucket with `mcp__obsidian__move_note`.
- When in doubt about where something belongs or whether it's work vs private, **ask** rather than guess.

## Step 3 — Hand off the unreachable inboxes

After every reachable inbox is at zero, list the inboxes Claude could **not** process — the Physical Inbox plus any connector that wasn't authenticated — and tell the user to go through those manually now. For example:

```
Reachable inboxes cleared ✓

Still to do yourself (no access):
- Physical Inbox — paper on your desk
- Gmail AccessOwl — connector not authenticated this session

Process these the same way: trash / do / defer / file.
```

## Done

Confirm the overall result: which inboxes hit zero, how many items were processed, what was created (tasks/projects), and the manual hand-off list. Don't offer to log this or post EOD — the user will ask if they want that.
