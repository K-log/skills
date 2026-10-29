---
name: implement-ticket
description: Build a ticket from the ticket tracking system (for example Jira) end to end in a fresh worktree off the base branch - blocker check, constraints, test-first build, review, PR, CI and review-comment rounds, and ticket update. Use when the user or a coordinator says to build, implement, or ship a ticket (an ID such as PROJ-123, or a ticket URL).
argument-hint: <TICKET-ID> [base branch]
---

Implement ticket `$ARGUMENTS` end to end. If no ticket ID was given, ask for one.

## Context per stage

Run each stage in its own subagent, so that details from one stage do not fill the context of the next stage. You decide the exact split. A good default:

| Stage | Phases | Input | Output |
|---|---|---|---|
| Ticket review | 0, 1 | ticket ID, worktree path | `CONSTRAINTS.md` with risk areas and the plan, or the blocker or sanity-check report |
| Build | 2, 3 | worktree path, `CONSTRAINTS.md` | commits with green checks |
| Verify | 4 step 4, `/verify-branch` | worktree path, `CONSTRAINTS.md`, base branch | risk-area results and the verify report |

The main session runs Setup, Phase 4 steps 1-3, Phase 5, Phase 6, and Phase 7, and starts each subagent. The main session runs the review command itself, because the review command starts its own reviewer subagents. Give each subagent only its input from the table. Do not pass on what other stages found. If a subagent reports a blocker or a failure it cannot fix, stop and report it.

## Setup

1. Find the base branch. If the user named one, use it. Else use the repo's default branch: `git symbolic-ref --short refs/remotes/origin/HEAD`. If that fails, run `git remote set-head origin --auto` and try again.
2. If you already work in a worktree for this ticket, use it. Else `git fetch origin <base>`, then create a worktree off `origin/<base>` on a branch named after the ticket (for example `PROJ-1234-short-title`). Do all work inside that worktree.

## Phase 0: Can the ticket start?

1. Fetch the ticket and every linked ticket from the ticket tracking system. For Jira, use the Atlassian MCP. For GitHub issues, use `gh issue view <n> --comments`.
2. If a "blocked by" ticket is not done, stop. Report the blocker ticket ID, its title, and its status.
3. Read the code that the ticket touches in the worktree. Check that the change makes sense:
   - The problem still exists. Another branch or merged PR did not already fix it.
   - The ticket's assumptions about the code, the data, and the APIs match what is there.
   - The acceptance criteria do not conflict with each other, with locked decisions, or with linked tickets.
   - The scope is the right size for one PR.
4. If a check fails, stop. Report each problem with the evidence (file, line, PR, or ticket).
5. Move the ticket to its in-progress status.

## Phase 1: Constraints and plan

1. Write `CONSTRAINTS.md` at the worktree root with:
   - each acceptance criterion, numbered
   - each locked decision, quoted with its ID if it has one (for example `D7`)
   - ticket scope: what is in and what is explicitly out
   - risk areas: each place where the change can break existing behavior (shared code, other callers, data migrations, permissions, other tenants or product areas), with how to verify it
2. Add `CONSTRAINTS.md` to the exclude file at `$(git rev-parse --git-path info/exclude)`, so it stays local. In a worktree, `.git` is a file, so do not write to `.git/info/exclude` directly.
3. If the build needs a local cache directory (for example `.m2-local` for Maven's `-Dmaven.repo.local`), put it inside the git directory at `$(git rev-parse --git-dir)/m2-local`. Git never tracks files there, and `git worktree remove` deletes it with the worktree.
4. Show the plan (files to touch, tests per criterion), then proceed without waiting.

Every later phase must respect `CONSTRAINTS.md`.

## Phase 2: Build test-first

For each acceptance criterion: write a test, run it and watch it fail, then make it pass. Done when every criterion in `CONSTRAINTS.md` has a test you saw fail, then pass. Commit as you go.

## Phase 3: Full check

Run the full test suite, then lint, then any other check the repo's CI runs (for example a policy gate), one after the other. Use the repo's own scripts (`npm run`, `make`, `./mvnw`, `scripts/`), not `npx` or the tool directly. Done when all of them are green.

## Phase 4: Review

1. Commit all changes.
2. Run the repo's review command (a project skill such as `/<repo>-review`). If the repo has none, run `/code-review`.
3. Check every finding against `CONSTRAINTS.md` and the commit history before you apply it. Commit the fixes.
4. Verify each risk area in `CONSTRAINTS.md` as it says. Record the command or check and its result.
5. After the last fix, re-run Phase 3.

## Phase 5: Pull request

1. Push the branch. After a rebase, push with `--force-with-lease`.
2. If the branch has no PR, open a PR against the base branch. If it has a PR, update its title and body. The body has:
   - a plain-English description of what changed and why
   - a readiness table: one row per acceptance criterion and in-scope item, with the diff location that covers it, or "not covered"
   - a risk table: one row per risk area, with the check that verified it, or "UNVERIFIED"

## Phase 6: CI and review comments

1. Wait for the PR checks with `gh pr checks --watch` and a 20 minute timeout.
2. If a check failed, fix it.
3. If review threads are open, run `/pr-comments`.
4. If you changed code, do Phase 3, Phase 4, and Phase 5 again, then go back to step 1.

Done when all checks pass and no AI review thread is open. Stop after 3 rounds and summarize what is left.

## Phase 7: Ticket update

1. Comment on the ticket with the PR link.
2. Update the ticket description only if the delivered scope differs from `CONSTRAINTS.md`.
3. Move the ticket to its in-review status.

## Stop conditions

Stop and ask before any action that skips required human review: merging, pushing with `--force` or `-f`, approving your own PR, bypassing branch protection or CI.

## Final summary

Run `/verify-branch` and end with its report table.
