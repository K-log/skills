---
name: reformat
description: "Fix the formatting of your last response and re-present it: questions go through the question tool, tables get repaired, and sources get previews."
disable-model-invocation: true
---

The user could not easily read your last response. Re-present the same information in a cleaner format. This is a formatting pass, not a redo: keep every fact, finding, and caveat; drop nothing; add no new analysis.

If your last message was short or only a status update, use the most recent substantive answer instead.

## What to fix

**Questions.** Move every question you asked the user into the AskUserQuestion tool instead of leaving them in prose. Put the recommended option first and mark it "(Recommended)". The tool takes up to 4 questions per call, so split a longer list across several calls. Present the rest of the response as text first, then ask.

**Tables.** The terminal renders GitHub-flavored markdown, and broken tables show up as a wall of pipes. Check that each table has:
- A header row and a `|---|` separator row
- The same number of cells in every row
- No raw `|` inside a cell (escape it as `\|`)
- Short cells. If a cell needs a paragraph, or the table has more than about 5 columns, switch to a list or one heading per row instead.

**Sources.** A bare ID or a bare number makes the reader look it up. Give each reference enough context to be understood in place:
- Tickets: `JIRA-1234(Update component styling)`. Include the title every time. If you don't know the title and a lookup tool is available (Jira, GitHub), fetch it. If you can't, say the title is unknown; don't invent one.
- Links: cite inline as `[1](https://...)`, and end with a Sources list where each entry has a short description: `1. [Jira search API docs](https://...)`.
- Code: `path/to/file.ts:42`, so the user can click it.
- PRs and commits: `#123(Add retry to upload)`, `abc1234(Fix null check)`.

**Structure.**
- Lead with the answer or decision, then supporting detail.
- Use headings and lists to break up long paragraphs.
- Use plain terms and the project's existing words. Don't invent abbreviations.
- No emojis.

## Output

Re-present the full response, not a diff or a list of what you changed. Don't open with "Here's the reformatted version"; just give the content. Only fetch information when you need it to fill in a reference preview.
