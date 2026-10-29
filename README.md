# skills

My agent skills. The Claude plugin is named `nbd`, so Claude shows each skill as `nbd:<skill>`.

## Install

Pick one route for each agent. Two routes give each skill twice.

| Agent | Install | Update |
|---|---|---|
| Claude Code | `claude plugin marketplace add K-log/skills`, then `claude plugin install nbd@k-log-skills` | Set `autoUpdate: true` for `k-log-skills` in `~/.claude/settings.json`, or run `scripts/update.sh` |
| Claude Desktop and claude.ai | Customize > Plugins > Add marketplace > `K-log/skills`, then install `nbd` | Click Update on the marketplace |
| GitHub Copilot | `copilot plugin marketplace add K-log/skills`, then `copilot plugin install nbd@k-log-skills` | `scripts/update.sh` |
| Pi and other agents | `npx skills@latest add K-log/skills -a pi` | `npx skills@latest update` |

Pi and other agents do not show the `nbd:` prefix.

## Skills

| Skill | What it does |
|---|---|
| `implement-ticket` | Builds a ticket end to end, from the blocker check to a PR with green checks. |
| `pr-comments` | Addresses pull request review comments and resolves the AI reviewer threads. |
| `scaffold` | Walks you through installing [Ponytail](https://github.com/DietrichGebert/ponytail), [Matt Pocock's skills](https://github.com/mattpocock/skills), and/or [CodeGraph](https://github.com/colbymchenry/codegraph) into the current project. |
| `spec-diff` | Checks finished work against its ticket or spec. |
| `verify-branch` | Runs a verification pass before you push a branch. |
| `reformat` | Re-presents your last response in a cleaner format. |
| `technical-writing` | Rules for clear, simple technical English. |

## Add a skill

1. Create `skills/<category>/<name>/SKILL.md` with `name` and `description` frontmatter. The `name` must match the folder name.
2. Add `"./skills/<category>/<name>"` to the `skills` list in `.claude-plugin/plugin.json`.
3. Push, then run `scripts/update.sh`.
