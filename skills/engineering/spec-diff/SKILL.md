---
name: spec-diff
description: "Check a branch or chunk of finished work against its ticket or spec, line by line, and list exactly what has to change to match. Use when the ticket or spec may have been updated after work started, when the user asks 'does this still match the ticket', 'the spec changed, what do I need to update', 'diff my branch against JIRA-123', 'what's left on this ticket', or wants to re-check work against requirements before opening or updating a PR. Pass --report to get only the list of changes needed."
argument-hint: "[ticket or spec] [base ref] [--report]"
---

Compare work that is already done against the current version of its ticket or spec, and produce an exact list of what needs to change. The spec may have moved since the work started, so the goal is not "is this good code" but "does this match what is asked for now, and what was built against an older version".

This is a read-only check. Do not edit code unless the user asks after seeing the report.

If the arguments include `--report`, still do every step below, but print only the change list described in "5b. --report output" instead of the full report. The check has to be just as thorough; only the output is shorter.

## 1. Pin down the inputs

Work out both from the request and the repo. Ask only if you truly can't tell.

**The spec.** A ticket ID, URL, file path, or pasted text.
- Ticket tracking system (for example Jira): fetch with the available tools, such as the Atlassian MCP for Jira. Read the description, acceptance criteria, sub-tasks, and comments (decisions often land in comments, not the description).
- GitHub issue: `gh issue view <n> --comments`.
- File in the repo: read the current version.
- If the branch name or commit messages contain a ticket ID and the user named none, use it and say so.

**The work.** Default to the current branch against its base.
- Base: `git merge-base HEAD origin/<default>`, where `<default>` is the repo's default branch (`git symbolic-ref --short refs/remotes/origin/HEAD`). The user may name a different base, commit, or range.
- Committed: `git diff <base>...HEAD` and `git log <base>..HEAD --format='%h %ad %s' --date=iso`.
- Uncommitted: `git diff HEAD` and `git status`. Include it, and mark which findings depend on it.

## 2. Find out what changed in the spec

This is what makes the check worth doing. Find the version the work was built against and compare it with the current one.

- Work started: the date of the first commit after the base.
- Jira or another ticket tracking system: fetch the issue history (for Jira, the changelog with `expand=changelog`) and find edits to description, acceptance criteria, and other fields after the start date. Read comments posted after the start date.
- GitHub issue: get edit history with `gh api graphql` on the issue's `userContentEdits`, and read comments after the start date.
- Spec file in git: `git log -p --since=<start date> -- <path>`.

List each change since work started: what was added, removed, or reworded. If no history is available (pasted text, no access), say so and do the check against the current spec only. Every finding is still valid; you just can't say which ones came from a spec change.

## 3. Break the spec into requirements

Split the current spec into the smallest checkable statements. Number them (R1, R2, ...) and quote the spec text for each so the user can see you didn't paraphrase it into something else. Acceptance criteria, edge cases, error states, copy and labels, naming, and "should not" rules all count. Mark the ones that were added or changed since work started.

Vague requirements ("should be fast", "clean UI") still get a row. Mark them as not checkable against code and say what would settle them.

## 4. Check each requirement against the work

For each requirement, find the evidence in the diff and give it as `path/to/file.ts:42`. Read the surrounding code when the diff alone doesn't show the behavior. Tests that cover a requirement are evidence too.

Give each one a status:
- **Done**: the work does what the current spec says.
- **Partial**: some of it is there. Say exactly which part is missing.
- **Missing**: nothing in the work does this.
- **Outdated**: the work matches an older version of the spec. Quote the old and new text.
- **Conflicts**: the work does something the spec says not to do, or does it a different way.
- **Can't tell**: needs a human, a running app, or information you don't have. Say what would settle it.

Then go the other way: look for things in the diff that no requirement asks for. Flag code that implements something removed from the spec, and changes that look out of scope. Ignore incidental refactors and test setup unless they matter.

Be exact. "Error handling looks incomplete" is not a finding. "R4 says show 'Upload failed, try again'; `UploadForm.tsx:88` shows 'Error'" is.

## 5. Report

Use this structure. Refer to tickets with their title, e.g. `JIRA-1234(Update upload form)`.

```
# Spec check: <TICKET-ID>(<title>) vs <branch>

Base: <base ref> (<sha>), <n> commits, work started <date>. Uncommitted changes: yes/no.

## Summary
<One or two sentences: does the work match, and how much needs to change.>
<Counts: Done n, Partial n, Missing n, Outdated n, Conflicts n, Can't tell n.>

## Spec changes since work started
- <date>, <who if known>: <what changed>, quoted old -> new
(or: "No history available; checked against the current spec only.")

## Needs updating
1. **R<n> <short name>** (<status>)
   Spec: "<quote>"
   Now: <what the code does>, `path:line`
   Change: <the specific edit needed>

## Not in the spec
- `path:line`: <what it does>, <why it looks out of scope or removed from the spec>

## Done
- R<n> <short name>: `path:line`

## Can't tell
- R<n> <short name>: <what would settle it>
```

Put "Needs updating" in the order the user would do the work: Outdated and Conflicts first (they mean undoing something), then Missing, then Partial. Keep "Done" short; it's there so the user can trust the check covered everything.

End by offering to make the changes, or to post the summary to the ticket. Don't do either without being asked.

## 5b. --report output

A list of changes that would bring the work into line with the ticket, and nothing else. Someone should be able to work down it, or hand it to another agent, without reading the full report. Leave out Done items, counts, and the summary.

```
# Changes to match <TICKET-ID>(<title>): <branch> vs <base ref>

1. [<status>] R<n> <short name>: `path:line`
   Spec: "<quote>" (was: "<old quote>", only for Outdated)
   Change: <the specific edit, as an instruction>
2. [Remove] `path:line`: <what to take out>, <why: removed from the spec on <date>, or not asked for>

## Needs a decision
- R<n> <short name>: <the question that has to be answered first>
```

- One numbered item per change, in the same order as "Needs updating": Outdated and Conflicts, then Missing, then Partial, then Remove.
- Write each "Change" as an instruction someone can act on: "Change the retry limit from 3 to 5 in `upload.ts:42`", not "Retry limit is wrong".
- Use `[Remove]` for code from "Not in the spec" that should come out. Leave out incidental changes.
- "Needs a decision" holds the Can't tell items. Leave the section out if it's empty.
- If nothing needs to change, print one line saying the work matches the current spec, and which spec version or date you checked against.

Don't add an offer or closing line after the list.
