---
name: verify-branch
description: Verification pass before pushing a branch - run migrations against a disposable Postgres, run changed scripts end to end, browser-check UI changes with Playwright, and grade root-cause claims. Use when the user says "verify this branch" or invokes /verify-branch.
---

Run a verification pass on the current branch before it is pushed. Nothing is done without evidence.

## Scope

Diff against the base branch: the PR base (`gh pr view --json baseRefName`) if a PR exists, else `origin/staging`, else `origin/main`. Use `git diff --name-only $(git merge-base HEAD origin/<base>)`. Run only the checks that match changed files.

## 1. SQL migrations and views

For every migration or view in the diff:
1. Start a disposable Postgres with `docker compose` (use the repo's compose file if it has a Postgres service; otherwise a throwaway `postgres` service in a temp dir).
2. Apply all migrations in order, not just the changed ones.
3. Seed rows that hit edge cases: values outside the column's expected type, nulls, duplicates, plus anything the migration specifically handles.
4. Run the view or migration against the seeded rows. Show the query output and row counts.
5. Tear down with `docker compose down -v`.

## 2. Shell and Node scripts

For every changed shell or Node script: run it end to end in a temp dir from `mktemp -d`, with dry-run flags where the script has them. Capture the exit code and output.

## 3. UI changes

For UI changes: start the app locally, use Playwright to load each affected page, and exercise the changed behavior. Save screenshots and report their paths. If the browser check can't run, say "NOT browser-verified" and why.

## 4. Root-cause claims

For each root-cause claim in the user's notes or PR description, list the concrete evidence: logs, HTTP status codes, reproduced requests. Mark each claim CONFIRMED (direct evidence) or UNVERIFIED (anything less).

## 5. Fix and re-run

If a check fails, fix it, re-run that check, and repeat until it passes or you hit a genuine environment blocker (Docker not running, missing credentials, no network). Leave pushing to the user.

## Report

End with one table:

| Check | Result | Evidence | Remaining risk |
|---|---|---|---|

Result is PASS, FAIL, BLOCKED (name the blocker), or CONFIRMED / UNVERIFIED for root-cause claims. Evidence is the command plus key output, row counts, exit codes, or screenshot paths.
