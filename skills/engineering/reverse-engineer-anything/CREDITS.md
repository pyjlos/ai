# Credits

This skill is copied from [morluto/rea](https://github.com/morluto/rea)
(`.agents/skills/reverse-engineer-anything/`), MIT-licensed, at commit
`a6a2527ade0fb115358194e29a0538ec9af45846` (2026-11-11). REA ("Reverse Engineer
Anything") is a standalone MCP server for reverse engineering native, managed,
Electron/JavaScript, packaged, firmware, and browser targets; this skill is the
usage guide the upstream project ships for driving it. As the skill's own text
states, installing it only supplies instructions — it does not register the REA
MCP server or install any analysis engine. Connecting it to a running `rea`
server (via `npx rea-agents setup` or a Claude Code/Codex plugin install) is a
separate, explicit step left to whoever uses the skill.

The upstream skill nests its reference docs under a `references/` subdirectory.
This repo's `scripts/install.sh` only installs a skill's `SKILL.md` plus flat
sibling files (`find "$skill_src_dir" -maxdepth 1`), matching every other
skill already here — none use a nested resource directory. The reference docs
are flattened to siblings of `SKILL.md` and `SKILL.md`'s `references/*.md`
links updated to match; their content is otherwise unmodified.
