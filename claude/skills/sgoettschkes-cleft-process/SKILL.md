---
name: sgoettschkes-cleft-process
description: Process exported Cleft voice-capture notes one at a time. Reads every note in the Cleft export folder, deletes re-exports already recorded in the processed-IDs log, and for each new note proposes what it is and where its content belongs (Nirvana tasks, Obsidian PARA buckets, project/AoR/Reference filing) — hard-stopping for the user's decision before touching anything, and offering per-part decisions when a note should be split. After applying, records the cleft_id in Obsidian and deletes the source file. Use when the user asks to "process cleft notes", "go through my cleft captures", "clear cleft", or similar.
---

# Cleft — Process Captured Notes

Cleft is a voice-capture app: the user dictates a thought, Cleft transcribes and cleans it up, and exports one Markdown file per note. This skill empties that export folder by deciding — together with the user — where each note's content belongs, then filing it there.

**GTD and PARA:** the user runs both side by side — GTD for stuff to do, PARA for filing. A Cleft note is raw capture, so processing it is the GTD clarify step: actions become Nirvana tasks, everything worth keeping files into the PARA buckets (Projects / AoR / Resources / Archives) in Obsidian.

## Source

Export folder: `/Users/sebastian/Library/Containers/com.cleft.notes/Data/Documents/Cleft Notes/`

Each note is a `.md` file (`<date>-<slug>-<cleft_id>.md`) with YAML frontmatter:

- `cleft_id` — stable numeric ID; the dedup key
- `title`, `created`, `updated`, `source`
- `transcript` — the raw speech-to-text output

The **body** below the frontmatter is Cleft's cleaned-up version of the transcript — always work from the body, not the raw `transcript` field.

## Processed-IDs log

`~/Documents/Second Brain/3 - Resources/Cleft/Processed Cleft Notes.md`

One line per processed note:

```
- 98745 | 2026-07-16 | Gita Integration Next Steps → 1 - Projects/…/…
```

Create the folder and note on first run. This log is the memory across runs — Cleft may re-export notes that were already processed.

## Step 1 — Delete re-exports

Read the log first. Any file in the export folder whose `cleft_id` already appears in the log has been processed before — delete it right away, no questions. Report briefly how many re-exports were removed, then announce how many new notes remain.

## Step 2 — Process new notes, one at a time

Go oldest first. Present **one note at a time** — never dump all notes and batch-ask:

```
[Cleft · note N/total]
Title: …
Captured: …
Summary: <one or two lines of what it is>
```

Then classify the note and **propose a decision** — what kind of note it is and where its content should go:

- **Brain dump** — a stream of mixed thoughts. Split it: actionable items → Nirvana, notes worth keeping → Obsidian, throwaway musings → nowhere.
- **Project material** — belongs to a specific project → `1 - Projects/<project>/` (and/or Nirvana tasks under that project).
- **AoR material** → `2 - AoR/<AoR>/`.
- **Reference material** → `3 - Resources/<topic>/` (create or reuse a topic folder; check what already exists before inventing a new one).
- **Recurring formats** (e.g. health-diary entries) — look for where earlier entries of the same kind already live and propose that location.

**Hard stop: never apply anything without the user's explicit approval.** Present the proposal — destination(s), the Nirvana task titles/states, and the content as it would be filed — and wait. The user may accept, redirect, or reject each piece.

**Splitting:** when a note contains parts with different destinations, present one decision per part (numbered), not one blanket decision for the whole note. `AskUserQuestion` with one question per part works well for up to a few parts; fall back to a numbered list in prose for more.

## Decision rules

- **Nirvana states are explicit.** Standalone tasks get exactly the state the user picked — never silently assume `next` or `inbox`. Tasks created under a project default to `next`, never inbox.
- **Nirvana project tasks inherit their area — don't re-tag.** Child tasks (`parentid` set) get `tags: []` (or only context tags); standalone tasks get the area tag (`private`, `AccessOwl`, …) explicitly.
- **Filing follows PARA**: Obsidian = notes/knowledge. Don't mirror the same content into multiple buckets.
- **Clean up dictation artifacts** when filing: transcripts are speech-to-text, so fix obvious mis-hearings (e.g. "Access All" → AccessOwl, "Gita" → GitHub where context says so) and keep the user's meaning and wording otherwise. Flag any fix you're unsure about in the proposal.
- Work vs. private unclear → **ask**, never guess.
- In doubt about placement → **ask**, and prefer existing folders/notes over creating new ones.

## Step 3 — Apply, record, delete

Only after approval, per note:

1. Apply every approved decision (create tasks, write/append Obsidian notes, move content).
2. Append one line per processed note to the processed-IDs log (list all destinations if split).
3. Delete the source file from the Cleft export folder.
4. Confirm briefly (`✓ 98745 filed → …, task created in Nirvana`) and move to the next note.

A note the user wants to skip stays in the export folder and does **not** get logged — it will come up again next run.

## Done

Report: re-exports deleted, notes processed, tasks created, where content was filed, and any notes skipped. Don't offer to log this or post EOD — the user will ask.
