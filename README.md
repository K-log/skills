# skills

My agent skills.

## Install

With the [skills CLI](https://github.com/vercel-labs/skills) (Claude Code, Codex, Cursor, and others):

```sh
npx skills add K-log/skills -g
```

As a Claude Code plugin:

```
/plugin marketplace add K-log/skills
/plugin install skills@k-log-skills
```

Pick one. Installing both gives you each skill twice.

## Skills

| Skill | What it does |
|---|---|
| `/reformat` | Re-presents your last response in a cleaner format. |
| `/scaffold` | Walks you through installing [Ponytail](https://github.com/DietrichGebert/ponytail), [Matt Pocock's skills](https://github.com/mattpocock/skills), and/or [CodeGraph](https://github.com/colbymchenry/codegraph) into the current project, so everyone who clones it gets them. |

## Add a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Add `"./skills/<name>"` to the `skills` list in `.claude-plugin/plugin.json`.
3. Push, then run `npx skills update` (or `/plugin update` for the plugin install).
