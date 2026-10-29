---
name: technical-writing
description: Rules for clear, simple technical English (Simplified Technical English). Use when writing or reviewing docs, READMEs, runbooks, procedures, PR bodies, tickets, or messages, or when the user asks for plain, simpler, or controlled English.
---

These rules make technical text easy to read. The goal: the reader understands each sentence the first time, also if English is not their first language.

These rules follow Simplified Technical English (ASD-STE100, Issue 9). When this file does not cover a case, apply that standard.

## Two types of text

Every block of text is one of two types. The rules differ, so decide the type first.

- **Instructions** tell the reader what to do: setup steps, runbooks, "how to" sections.
- **Descriptions** give information only: explanations, architecture notes, PR summaries, status messages.

## How to use this skill

1. Decide the type of each block: instructions or description.
2. Write or rewrite each block with the rules below.
3. Read each sentence again and check it against every rule. Count the words with the counting rules.
4. If a simpler word changes the meaning, rewrite the whole sentence. Do not force a word-for-word swap. Ask two questions: "What does this word mean here?" and "What must the reader do?" Then write that with permitted words. It is correct to split a sentence, delete words that give no information, or ask for missing facts.

You are done when every sentence obeys every rule, or you can say which rule a sentence breaks on purpose, and why.

## Sentence length

- Instructions: a maximum of 20 words in each sentence.
- Descriptions: a maximum of 25 words in each sentence.
- Paragraphs: one topic, and a maximum of six sentences. Start with a sentence that names the topic.
- Notes in a procedure: a maximum of 25 words in each sentence.

When you count words, each of these counts as one word:
- A number, also with its unit ("20 MB")
- An abbreviation ("API", "VPN")
- An identifier ("PR 42", "v2.1")
- Inline code, a command, a file name, or a quoted UI label or error message
- A title, a heading, or a proper name
- A hyphenated group ("read-only")
- Text in parentheses (count that text as a separate sentence too)

In a list, the colon ends the first sentence. Each item is a new sentence with its own limit.

## Instructions

- Use the command form. Start with the verb.
  - Good: Start the server again.
  - Bad: The server should be restarted.
- Write one instruction in each sentence. Join two actions only when they happen at the same time ("Cut and remove the wire"). Number the steps.
- If one action is too long for 20 words, split it into two sentences in the same step.
  - Good: Copy the files to the backup bucket. Continue until the bucket contains 40 GB.
- Put a condition first, then a comma, then the command.
  - Good: If the build shows an error, read the log.
  - Bad: Read the log if the build fails.
- The position of the comma changes the meaning. "If the job does not stop correctly, delete it" is not the same as "If the job does not stop, correctly delete it".
- Do not write "you must" before a command. Use "must" only for safety or for an important condition.
- Put an expected result or a limit in the same step, directly after the action.
  - Good: Run the health check. The response time must be less than 200 ms.
- A note gives information only. It contains no commands, requirements, or limits. Test: the reader can do the procedure correctly without reading the notes. If a note can prevent data loss or an outage, make it a warning (see Warnings). Use notes in procedures only.

## Descriptions

- A description gives information only. It contains no commands. To show what the reader is able to do, write "you can" ("You can change the timeout in `config.yml`").
- Give information gradually. Put one subject in each sentence.
- Use the same key words again to connect sentences. Do not change a term halfway through the text.
- Use connecting words to show how sentences relate: "and", "but", "then", "thus", "as a result", "at the same time".
- Give accurate data, not general statements.
  - Good: When the cache is full, the response time increases to 2 s.
  - Bad: Cache size affects performance.

## Verbs

- Use the active voice. Name who or what does the action.
  - Good: The scheduler starts the job.
  - Bad: The job is started by the scheduler.
- Test for the passive voice: ask "by whom or by what?" If the sentence answers that question, or a word "by" names the doer, the sentence is passive.
- Use the passive voice only in a description, and only when you do not know who did the action ("The file was deleted"). Do not name a wrong doer to make a sentence active. If the doer is unknown, "something" is correct: "Something deleted the file".
- To make a passive sentence active:
  - Put the doer first ("The scheduler starts the job").
  - In instructions, use the command form ("Remove the logs").
  - Use "you" when the doer is the reader. Use "we" when the doer is the team.
- Use only simple tenses: present ("runs"), past ("ran"), and future ("will run"). Do not use "has run", "had run", "is running", or "was running".
- Do not use "-ing" verb forms, except in names of things ("logging", "load balancing", "the caching layer").
  - Good: When you run the tests, close other apps.
  - Bad: When you are running the tests, close other apps.
  - These "-ing" words are permitted: "during", "missing", "remaining", "something", "opening" (a hole), "routing".
- Use "can" for possibility. Do not use "could", "may", "might", or "would".
  - Good: If you do not make a backup, data loss can occur.
  - Bad: If you do not make a backup, data loss could occur.
- Do not build long verb chains with helper verbs.
  - Good: Update the config.
  - Bad: The config is to be updated.
- Show an action with a verb, not a noun.
  - Good: Before you remove the key, ...
  - Bad: Before the removal of the key, ...
- Do not use phrasal verbs (a verb plus a small word that together have a new meaning). Use a single verb.
  - "set up" -> "install" or "prepare"
  - "carry out" -> "do"
  - "find out" -> "find" or "make sure"
  - "give off" -> "release"
  - "go down" (for a value) -> "decrease"

## Words

- Use common words, and use each word with one meaning only. [`WORDS.md`](WORDS.md) lists words to replace and all permitted verbs. Read it before you choose a verb or check a text for word errors.
- For a word that `WORDS.md` does not list, select the simplest common word that has the same meaning. If no single word gives the meaning, rewrite the sentence.
- Use each word as one part of speech only: a word that is a noun stays a noun, and a verb stays a verb.
- Some words that are often verbs are nouns here.
  - Good: Do a test of the API. Do a check of the logs. This can cause damage to the data.
  - Bad: Test the API. Check the logs. This can damage the data.
- Use some words only with their literal meaning:
  - "follow" means "come after". For instructions, write "obey".
  - "see" is only for what you see with your eyes. Otherwise, write "make sure that".
  - "turn" is only for rotation. "The status turns green" -> "The status changes to green".
  - "above" and "below" are only for positions. For limits, write "more than" and "less than".
  - "wear" means "become damaged by friction". For clothing, write "put on".
  - "extend" means "increase in length or range". "The rule extends to all services" -> "The rule is applicable to all services".
  - "work" is only a noun ("When you do work on the database"). "help" is only a verb ("with the aid of a second person").
- **Field terms** are the names of things in the subject field: `repository`, `branch`, `endpoint`, `migration`, `token`, `database`. They are permitted. A field term can contain a word that is not permitted on its own: "main branch" is correct, although "main" -> "primary" in other text ("the primary cause").
- Do not use a field term as a verb.
  - Good: Apply grease to the bolts. Put the logs in a file.
  - Bad: Grease the bolts. File the logs.
- **Field verbs** are permitted when no verb in [`WORDS.md`](WORDS.md) gives the same meaning:
  - Input: click, enter, press, print, swipe, tap, type
  - User interface: clear, close, copy, cut, delete, deselect, disable, drag, drag and drop, enable, encrypt, erase, filter, highlight, invalidate, maximize, minimize, navigate, open, paste, save, scroll, sort, store, validate, zoom in, zoom out
  - System: abort, boot, debug, download, format, install, load, process, reboot, update, upgrade, upload
  - Code and delivery: call, commit, deploy, merge, push, return, run
- Use a field verb only with its field meaning.
  - Good: Enter your password. Enable the `retry` flag.
  - Bad: Do not enter the server room. This change enables faster builds.
  - Fix: Do not go into the server room. This change lets the build operate faster.
- Use a permitted verb when it gives the meaning ("If you find an error", not "If you detect an error"). When you must use a field verb, select the one with the most accurate meaning. Do not use vague verbs such as "handle" or "process".
  - Good: If the request shows a timeout error, send it again.
  - Bad: Handle the timeout.
- Do not use slang or jargon that only a small group understands.
  - Good: After the update, do not disconnect the router from power.
  - Bad: After the update, do not brick the router.
- Use the project's own term for each item. Use one term for one item in all of the text.
- Keep names of things to three words or fewer. Break up long groups with "of", "for", "on", or "in".
  - Good: the timeout of the retry policy for the upload job
  - Bad: the upload job retry policy timeout
- If an official name is longer than three words, write it in full the first time. Then use a short form.
- Do not make an abbreviation for a name of three words or fewer. A text full of abbreviations is shorter, but it is not easy to read.
  - Good: Remove the cache layer from the request path.
  - Bad: Remove the CL from the RP.
- When a name has an identifier (a step number, a PR number, a file path), a short name is sufficient: "the handler in `auth.ts`", not "the authentication middleware request handler in `auth.ts`".
- Use American English spelling. Do not change the spelling of quoted text.

## Complete sentences

- Do not leave out words to make a sentence shorter. Keep the subject, the verb, and "the", "a", or "an".
  - Good: If the flag is set, remove it.
  - Bad: If set, remove.
- Do not use contractions. Write "do not", not "don't". Write "it is", not "it's".
- Write "that" after "make sure", "show", and "recommend".
  - Good: Make sure that the port is open.
  - Bad: Make sure the port is open.
- Do not put "the" before a name with an identifier ("Run job 42", not "Run the job 42").
- Do not put "the" before a general concept.
  - Good: Retries increase load on the database.
  - Bad: The retries increase the load on the database. (when the sentence is about all retries)
- In a series, one "the" applies its adjective to all items. Repeat "the" to limit the adjective to the first item.
  - "Delete the expired logs, caches, and backups." (All three are expired.)
  - "Delete the expired logs, the caches, and the backups." (Only the logs are expired.)

## Lists

Use a list when a sentence has many items or actions.

- Put a colon at the end of the text before the list.
- Start each item with an uppercase letter.
- Put a period after an item that is a full sentence. Put no period after an item that is not a full sentence.
- Put no comma or semicolon at the end of an item. Put a period after the last item.
- Make sure that each item reads correctly with the text before the colon.
- Do not mix instructions and descriptions in one list. Keep all items at one level when possible.

## Punctuation

- Do not use semicolons. Write two sentences.
- Use a hyphen to join words that work as one unit before a noun ("read-only file", "rate-limited endpoint").
- Use parentheses for references, identifiers, abbreviations, singular-and-plural forms ("file(s)"), short explanations, and alternatives.
- Do not use Latin abbreviations. "e.g." -> "for example". "i.e." -> "that is". For "etc.", write "or other ..." or delete it.

## Clarity checks

- **"with"**: "Install the panel with the green fasteners" has three meanings. Read each sentence with "with" again. Start with the main action: "Seal the opening with tool X", not "Use tool X to seal the opening".
- **Pronouns**: when "it", "they", or "this" can refer to more than one thing, repeat the noun.
- **Possessives**: use "'s" only when it is clear. "The config of the service" is always clear.
- **Gender**: use gender-neutral words. Do not use "he" or "she" for an unknown person.
- **False friends**: a word that looks like a word in another language can have a different meaning in English. Use the English meaning ("eventually" means "in the end", not "possibly").
- **Consistency**: write the same kind of step or statement the same way each time.

## Warnings

Use a warning for an action that can cause data loss, an outage, or injury, for example a destructive command or a production change.

1. Start with a label that shows the risk. WARNING: risk to people. CAUTION: risk of damage, data loss, or downtime. If there are both risks, use WARNING.
2. Then give a clear command or condition.
3. Then give the risk or the possible result.

A warning obeys the 20-word limit for instructions. In a list of prohibited actions, start each item with "Do not".

Example: "CAUTION: Before you run this migration on production, make a backup. The migration deletes the columns that it replaces."

## What not to change

Do not rewrite quoted text: code, commands, identifiers, error messages, UI labels, titles, and text from other documents.
