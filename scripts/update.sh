#!/bin/bash
# Update the nbd skills on every harness on this machine. Claude Desktop has no command: click Update on the marketplace.

claude plugin marketplace update k-log-skills && claude plugin update nbd@k-log-skills
command -v copilot >/dev/null && copilot plugin marketplace update k-log-skills
command -v npx >/dev/null && [ -d ~/.pi/agent ] && npx skills@latest update

echo "Claude Desktop: Customize > Plugins > k-log-skills > Update."
echo "Restart Claude Code to load the new skills."
