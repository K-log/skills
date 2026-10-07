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

## Add a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Add `"./skills/<name>"` to the `skills` list in `.claude-plugin/plugin.json`.
3. Push, then run `npx skills update` (or `/plugin update` for the plugin install).
