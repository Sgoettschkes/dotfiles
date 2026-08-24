---
name: sgoettschkes-dev-finish-work
description: Close out a finished piece of dev work — the mirror of [[sgoettschkes-dev-start-work]]. Verifies the PR actually merged, stops the worktree's dev server, sets the Notion 🔨 Product Backlog ticket to Completed, logs the task via sgoettschkes-log-task, removes the git worktree plus its dev/test DBs via bin/wt-rm (access_owl repo only), and deletes the branch on GitHub. Use when the user says "finish dev work", "wrap up this ticket", "the PR is merged, clean up", "close out the worktree", "done with this branch", etc.
---

# Finish dev work

Take a merged piece of dev work and leave nothing behind: dev server stopped, ticket closed, task logged, worktree and DBs gone, branch deleted locally and on GitHub.

Pairs with `sgoettschkes-dev-start-work` (which created the ticket claim, the worktree, and the briefing file this skill reads).

Run the steps in order. §2 is a gate: nothing after it runs while the PR is unmerged.

## 1. Gather context — before anything is deleted

Everything that lives in the worktree (the `.claude/plans/<slug>/` briefing and plan, local commit messages, `.env.local`) disappears in §7. Collect all of it now.

```bash
git rev-parse --abbrev-ref HEAD                                        # branch
git rev-parse --show-toplevel                                          # this worktree
git worktree list --porcelain | awk '/^worktree / {print $2; exit}'     # main checkout
gh pr view <branch> --json number,url,title,state,mergedAt,mergeCommit,baseRefName
```

The **Notion ticket URL**, in order of preference:

1. `<worktree>/.claude/plans/<slug>/initial.md` — the start-work briefing has it in its header.
2. The PR body or the branch's commit messages — the repo convention puts `Ticket: <title>` plus the Notion URL in the commit description.
3. `notion-search` for the ticket title, then confirm the match with the user.

Never guess the ticket. If none of the three lands it, ask.

## 2. Check the PR merged

The PR is merged only when `state` is `MERGED` **and** `mergedAt` is non-null. Anything else stops the flow:

- `OPEN` → report the PR state (and review state if useful) and stop. The ticket stays as it is.
- `CLOSED` with no `mergedAt` → the PR was closed unmerged. Say so and stop; abandoning work is a different flow and needs the user's call.

Also report which branch it merged into (`baseRefName`) — the ticket only moves to Completed once the change is on `main`.

## 3. Stop the dev server

Early, and well before §7: live connections to the dev DB make `dropdb` fail, and `bin/wt-rm` swallows dropdb errors (`|| true`) — a running server means the worktree vanishes while its DBs stay behind as orphans.

The dev server runs as a **background shell of this Claude session** (it was started here with `run_in_background`). So terminate that shell — no port hunting, no pid guessing. List the session's background shells, identify the `mix phx.server` one, and kill it through the harness (`/bashes`, or the kill-shell / task-stop tool). Confirm it reports as killed.

No such background shell → the server is running outside this session (another pane, another Claude session). Then say so and ask the user to stop it, or, with their go-ahead, fall back to the port: `PORT` from `<worktree>/.env.local`, `lsof -ti tcp:<PORT>`, verify the pid's cwd is this worktree (`lsof -a -p <pid> -d cwd`) before `kill`. Never kill a process whose cwd is a different worktree.

## 4. Complete the Notion ticket

Re-fetch the ticket (`notion-fetch`) before writing:

- Already `Completed` → skip, say so.
- `In progress` / `Has review comments` → complete it.
- Anything unexpected (`Rejected`, back in `Backlog`, …) → report and ask before touching it.

```
notion-update-page  page_id: <ticket page id>  command: update_properties
properties: {"Status": "Completed"}
```

## 5. Log the task

Invoke the `sgoettschkes-log-task` skill. This is AccessOwl work, so it lands in Obsidian **and** Notion.

The PR is merged, so the entry's verb says so — "Shipped X" / "Merged X", never "Opened PR for X". Hand the skill the PR URL and the ticket URL to inline. That skill owns its own approval dialog; don't pre-approve or bypass it.

## 6. Confirm the destructive cleanup

§7 and §8 delete the worktree, drop both DBs, and delete the branch locally and on the remote. None of that is reversible. Get an explicit go-ahead via `AskUserQuestion` first, listing exactly what goes: worktree path, dev DB, test DB, local branch, remote branch.

## 7. Remove the worktree — access_owl repo only

Only for the **access_owl** repo, which is where `bin/wt-rm` and the per-worktree DBs exist. Any other repo: skip this step and say why.

```bash
cd <main-checkout> && bin/wt-rm <branch> -db -y
```

- Run it from the **main checkout** — git refuses to remove the worktree you are standing in.
- `-db` (or `--delete-branch`) also deletes the local branch. Note the spelling: `--db` is **not** a valid flag, `wt-rm` exits with `unknown flag: --db`.
- `-y` skips wt-rm's own prompt because §6 already got the confirmation.
- Postgres must be up; `wt-rm` aborts early otherwise rather than orphaning DBs. Start it and re-run.
- Uncommitted changes make `git worktree remove` fail. Show the user what's dirty (`git -C <worktree> status --short`) and ask before adding `--force` — that throws the changes away.

If this Claude session's cwd is inside the removed worktree, that directory no longer exists: every later command needs an absolute path or a `cd` to the main checkout, and the user's shell in that pane is stranded. Tell them.

## 8. Delete the remote branch

Through the **GitHub CLI** — `git push` is not permitted in this setup, so `git push origin --delete` is not an option:

```bash
gh api repos/{owner}/{repo}/git/ref/heads/<branch>              # still there? 404 = already gone
gh api -X DELETE repos/{owner}/{repo}/git/refs/heads/<branch>   # delete it
```

Repos with "automatically delete head branches" on remove the branch at merge time — a 404 on the first call means done, not an error.

## Done

Report, one line each: the PR (number, URL, merged into which branch), the dev server (shell killed, or nothing running), the ticket's new status, where the task got logged, the worktree and DBs dropped plus the local branch, and the remote branch. Name every step that was skipped and why.
