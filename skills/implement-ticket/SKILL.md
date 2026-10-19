---
name: implement-ticket
description: Implement a Jira ticket end to end in a fresh worktree off staging - constraints, test-first build, review rounds, PR, and Jira update.
argument-hint: <TICKET-ID>
disable-model-invocation: true
---

Implement Jira ticket `$ARGUMENTS` end to end. If no ticket ID was given, ask for one.

## Setup

`git fetch origin staging`, then create a worktree off `origin/staging` on a branch named after the ticket (e.g. `ZVC-1234-short-title`). Do all work inside that worktree.

## Phase 1: Constraints and plan

1. Fetch the ticket and every linked BE/FE ticket via the Atlassian MCP.
2. Write `CONSTRAINTS.md` at the worktree root with:
   - each acceptance criterion, numbered
   - each locked decision, quoted with its ID (e.g. `D7`)
   - ticket scope: what is in and what is explicitly out
3. Add `CONSTRAINTS.md` and `.m2-local/` to `.git/info/exclude` so they stay local.
4. Show the plan (files to touch, tests per criterion), then proceed without waiting.

Every later phase must respect `CONSTRAINTS.md`.

## Phase 2: Build test-first

For each acceptance criterion: write a test, run it and watch it fail, then make it pass. Done when every criterion in `CONSTRAINTS.md` has a test you saw fail, then pass. Commit as you go.

## Phase 3: Full check

Run the full test suite, then lint, then the policy gate, one after the other. Done when all three are green.

## Phase 4: Review

Review the diff with parallel reviewer agents. Check every finding against `CONSTRAINTS.md` and the commit history before applying it. After the last fix, re-run Phase 3.

## Phase 5: Pull request

Push the branch and open a PR against `staging` with:
- a plain-English description of what changed and why
- a readiness table: one row per acceptance criterion and in-scope item, with the diff location that covers it, or "not covered"

## Phase 6: Jira

Comment on the ticket with the PR link. Update the ticket description only if the delivered scope differs from `CONSTRAINTS.md`.

## Stop conditions

Stop and ask before any action that skips required human review: merging, force-pushing, approving your own PR, bypassing branch protection or CI.

## Final summary

Run `/verify-branch` and end with its report table.
