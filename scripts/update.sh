#!/bin/bash
# Update the nbd skills on every harness on this machine. Claude Desktop has no command: click Update on the marketplace.

claude plugin marketplace update k-log-skills && claude plugin update nbd@k-log-skills
command -v copilot >/dev/null && copilot plugin marketplace update k-log-skills
if command -v npx >/dev/null && [ -d ~/.pi/agent ]; then
    npx skills@latest update -g -y
    # Claude Code loads these skills from the nbd plugin. Remove the links that npx adds, or Claude Code loads each skill two times.
    npx skills@latest remove -g -a claude-code -y -s $(jq -r '.skills[] | split("/")[-1]' "$(dirname "$0")/../.claude-plugin/plugin.json")
fi

echo "Claude Desktop: Customize > Plugins > k-log-skills > Update."
echo "Restart Claude Code to load the new skills."
