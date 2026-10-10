---
name: scaffold
description: "Interactively set up Ponytail, Matt Pocock's skills, and/or CodeGraph in the current project, installed at project scope so everyone who clones the repo gets them."
disable-model-invocation: true
---

Walk the user through installing any of these into the **current project** (not their user config), so every person who clones the repo gets the same tooling:

| Component | What it is | Upstream |
|---|---|---|
| Ponytail | Skills that make the agent reuse existing code before writing new code (`/ponytail`, `/ponytail-review`, `/ponytail-audit`, ...) | `DietrichGebert/ponytail` |
| Matt Pocock's skills | Engineering skills (`/grill-me`, `/grill-with-docs`, `/triage`, TDD, ...) | `mattpocock/skills` |
| CodeGraph | Local code knowledge graph exposed to the agent over MCP | `colbymchenry/codegraph` (npm `@colbymchenry/codegraph`) |

Ask every question with the AskUserQuestion tool, recommended option first and marked "(Recommended)". Don't ask about anything the user already answered in their `/scaffold` arguments.

## 1. Preflight

1. Find the project root: `git rev-parse --show-toplevel`. If this isn't a git repo, say so and ask whether to continue in the current directory.
2. Read what already exists so you merge instead of overwrite: `.claude/settings.json`, `.mcp.json`, `.gitignore`, `CLAUDE.md`, and list `.claude/skills/`.
3. Note anything already installed, and leave it alone unless the user asks to reinstall:
   - Ponytail: `ponytail@ponytail` in `enabledPlugins`, or `.claude/skills/ponytail*/`
   - Matt Pocock: `mattpocock-skills@...` in `enabledPlugins`, or `.claude/skills/setup-matt-pocock-skills/`
   - CodeGraph: a `codegraph` server in `.mcp.json`
4. Check tools: `node --version`, `npx --version`, `codegraph --version`. Node is needed for the vendored-files route, the npx launcher, and Ponytail's hooks.

## 2. Ask what to install

One multi-select question: which components to set up. Mark the ones already installed as "(already installed)" in their descriptions.

Then, only for the components picked:

**Skill packs (Ponytail, Matt Pocock).** One question covering both: how to install them.
- **Plugin, enabled in project settings (Recommended).** Commits a few lines to `.claude/settings.json`. Teammates get the plugin when they trust the folder in Claude Code, and it updates itself from upstream. Claude Code only.
- **Vendored skill files.** Copies the skill files into `.claude/skills/` and commits them. Editable and reviewable in PRs, but updates are manual (`npx skills update`). Ponytail's always-on hooks and mode switches don't come along, only its skills.

Warn if the user already has the same pack at user scope (`~/.claude/skills/` or a user-scope plugin) and picks vendored: they'll see each skill twice.

**CodeGraph.** Ask:
1. How the MCP server is launched:
   - **Through npx (Recommended).** Nobody needs a global install; the first launch downloads it.
   - **A `codegraph` CLI on PATH.** Faster start, but each teammate installs it (`npm i -g @colbymchenry/codegraph` or the upstream install script).
2. Whether to build the index now (`codegraph init`). Usually yes.
3. Whether to add a SessionStart hook that builds the index on a fresh clone if `.codegraph/` is missing. The index is a local SQLite database, so it's gitignored and every clone builds its own. Recommend yes for teams.

## 3. Confirm the plan

Before touching anything, show a short list of every file you'll create or change and what goes into each, then ask "Proceed?". Stop if they decline.

## 4. Install

Merge into existing JSON files: keep every key already there, and never drop or reorder unrelated entries. Create `.claude/` if needed.

### Ponytail and Matt Pocock: plugin route

Add to `.claude/settings.json`, only the entries for what was picked:

```json
{
  "extraKnownMarketplaces": {
    "ponytail": { "source": { "source": "github", "repo": "DietrichGebert/ponytail" }, "autoUpdate": true },
    "mattpocock": { "source": { "source": "github", "repo": "mattpocock/skills" }, "autoUpdate": true }
  },
  "enabledPlugins": {
    "ponytail@ponytail": true,
    "mattpocock-skills@mattpocock": true
  }
}
```

Use the authors' own marketplaces, not `mattpocock-skills@claude-plugins-official`. Both list their plugin by a relative path, which Claude Code installs automatically from project settings once a teammate trusts the folder. The official-directory entry points at an external URL, so each teammate would have to install it by hand.

If `claude` is on PATH, also run `claude plugin install <plugin>@<marketplace> --scope project` for each, so it works for the current user right away. If that fails, the settings entries are still enough after a restart.

### Ponytail and Matt Pocock: vendored route

From the project root:

```sh
npx -y skills@latest add DietrichGebert/ponytail -a claude-code -s '*' --copy -y
npx -y skills@latest add mattpocock/skills -a claude-code -s '*' --copy -y
```

`--copy` writes real files instead of symlinks, so they commit cleanly. Check that `.claude/skills/` gained the new directories, including `setup-matt-pocock-skills` for Matt Pocock's pack.

### CodeGraph

1. Wire it into the project:

   ```sh
   npx -y @colbymchenry/codegraph install --target=claude --location=local --yes
   ```

   (Use `codegraph install ...` instead if it's already on PATH.) If that fails, write the files in step 2 yourself.

2. Check the result against this end state, and fix whatever the installer did differently:
   - `.mcp.json` has a `codegraph` server. With the npx launcher, set it to:

     ```json
     {
       "mcpServers": {
         "codegraph": {
           "type": "stdio",
           "command": "npx",
           "args": ["-y", "@colbymchenry/codegraph", "serve", "--mcp"]
         }
       }
     }
     ```

     With the PATH launcher, `"command": "codegraph", "args": ["serve", "--mcp"]`. Keep any `alwaysLoad` or other fields the installer added.
   - `.claude/settings.json` has `"mcp__codegraph__*"` in `permissions.allow`. If the installer put it in `.claude/settings.local.json` or `~/.claude/settings.json` instead, move it to `.claude/settings.json`, since local files aren't shared.
   - `CLAUDE.md` has the installer's marker-fenced CodeGraph section. Leave it as written.
3. Add `.codegraph/` to `.gitignore` if it isn't covered.
4. If the user wanted the index now, run `npx -y @colbymchenry/codegraph init --yes` (or `codegraph init --yes`).
5. If the user wanted the SessionStart hook, add it to `.claude/settings.json`, merging with any existing hooks:

   ```json
   {
     "hooks": {
       "SessionStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "cd \"$CLAUDE_PROJECT_DIR\" && [ -d .codegraph ] || npx -y @colbymchenry/codegraph init --yes >/dev/null 2>&1 &"
             }
           ]
         }
       ]
     }
   }
   ```

   It runs in the background, so a first session isn't blocked while the graph builds.

## 5. Verify

- Parse every JSON file you touched (`node -e "JSON.parse(require('fs').readFileSync(process.argv[1]))" <file>` or `python3 -m json.tool <file>`). Fix any error before going on.
- Run `git status` and show the user the changed files.

## 6. Wrap up

Report what was installed, where, and how, in a short list. Then give the follow-ups that apply:

- **Restart Claude Code** (or run `/reload-plugins` for plugins) so new plugins, skills, and the MCP server load. Teammates accept the folder trust prompt the first time they open the repo.
- **Matt Pocock's skills:** run `/setup-matt-pocock-skills` once in this repo after the restart. It asks where issues live, which triage labels you use, and where docs go, and its output should be committed too.
- **Ponytail plugin:** its hooks need `node` on PATH. Without it the skills still work, but each hook call prints a harmless `node: command not found`.
- **CodeGraph with the PATH launcher:** each teammate installs the CLI once.
- **Vendored skills:** update later with `npx skills update -p`.

Don't commit. Offer to commit the changes, and suggest adding a line to the README telling teammates that the project ships with these tools.
