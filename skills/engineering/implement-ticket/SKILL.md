---
name: implement-ticket
description: Implement a ticket from the ticket tracking system (for example Jira) end to end in a fresh worktree off the base branch - constraints, test-first build, review rounds, PR, and ticket update.
argument-hint: <TICKET-ID> [base branch]
disable-model-invocation: true
---

Implement ticket `$ARGUMENTS` end to end. If no ticket ID was given, ask for one.

## Setup

1. Find the base branch. If the user named one, use it. Else use the repo's default branch: `git symbolic-ref --short refs/remotes/origin/HEAD`. If that fails, run `git remote set-head origin --auto` and try again.
2. `git fetch origin <base>`, then create a worktree off `origin/<base>` on a branch named after the ticket (for example `PROJ-1234-short-title`). Do all work inside that worktree.

## Phase 1: Constraints and plan

1. Fetch the ticket and every linked ticket from the ticket tracking system. For Jira, use the Atlassian MCP. For GitHub issues, use `gh issue view <n> --comments`.
2. Write `CONSTRAINTS.md` at the worktree root with:
   - each acceptance criterion, numbered
   - each locked decision, quoted with its ID if it has one (for example `D7`)
   - ticket scope: what is in and what is explicitly out
3. Add `CONSTRAINTS.md` to the exclude file at `$(git rev-parse --git-path info/exclude)`, so it stays local. In a worktree, `.git` is a file, so do not write to `.git/info/exclude` directly.
4. If the build needs a local cache directory (for example `.m2-local` for Maven's `-Dmaven.repo.local`), put it inside the git directory at `$(git rev-parse --git-dir)/m2-local`. Git never tracks files there, and `git worktree remove` deletes it with the worktree.
5. Show the plan (files to touch, tests per criterion), then proceed without waiting.

Every later phase must respect `CONSTRAINTS.md`.

## Phase 2: Build test-first

For each acceptance criterion: write a test, run it and watch it fail, then make it pass. Done when every criterion in `CONSTRAINTS.md` has a test you saw fail, then pass. Commit as you go.

## Phase 3: Full check

Run the full test suite, then lint, then any other check the repo's CI runs (for example a policy gate), one after the other. Done when all of them are green.

## Phase 4: Review

Review the diff with parallel reviewer agents. Check every finding against `CONSTRAINTS.md` and the commit history before applying it. After the last fix, re-run Phase 3.

## Phase 5: Pull request

Push the branch and open a PR against the base branch with:
- a plain-English description of what changed and why
- a readiness table: one row per acceptance criterion and in-scope item, with the diff location that covers it, or "not covered"

## Phase 6: Ticket update

Comment on the ticket with the PR link. Update the ticket description only if the delivered scope differs from `CONSTRAINTS.md`.

## Stop conditions

Stop and ask before any action that skips required human review: merging, force-pushing, approving your own PR, bypassing branch protection or CI.

## Final summary

Run `/verify-branch` and end with its report table.
