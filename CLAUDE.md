# CLAUDE.md — ai agents & skills library

This repo is the source of truth for Claude Code agents, skills, commands, and rules.
Files in this repo get installed into `~/.claude/` (or the equivalent for Copilot/Kiro)
by `scripts/install.sh`.

## Must Do

- After editing any agent, skill, command, or rule in this repo, remind the user to
  re-run `bash scripts/install.sh --tool claude` so the changes take effect.
- Preserve the existing structure conventions:
  - **Agents** end with a `## Behavioral Expectations` section.
  - **Skills** have YAML frontmatter (`name`, `description`); engineering skills
    that ship bundled `.md` resources reference them via relative links from `SKILL.md`.
  - **Rules** are single-purpose, concrete, and idempotent (safe to re-source).
- Keep agent `description:` fields specific enough that auto-routing picks the right
  agent without ambiguity. If two agents could match the same trigger, sharpen one.

## Must Never Do

- Edit files in `~/.claude/` directly — edit the source in this repo and reinstall.
  The install script is the only thing that should write to `~/.claude/`.
- Bundle unrelated changes into a single edit. One logical change per commit.
- Add a new agent or skill without checking whether an existing one already covers the
  trigger space. Duplication causes routing ambiguity.

## Layout

```
agents/         — agent persona files, grouped by domain
skills/         — skills (SKILL.md per directory; siblings are bundled resources)
  agents/       — thin delegation wrappers that hand off to the same-named agent
  engineering/  — substantive skills with methodology and bundled .md resources
  productivity/ — workflow / pipeline / handoff skills
commands/       — slash commands (Claude Code)
rules/          — global rules imported into ~/.claude/CLAUDE.md
scripts/        — install.sh and helpers
outputs/        — in-progress handoffs and pipeline artifacts (gitignored where appropriate)
```

## Sync model

- `scripts/install.sh` is idempotent. Running it after a source edit re-syncs the
  installed copy.
- Bundled resource files (sibling `.md` files alongside a `SKILL.md`) are copied
  automatically. Cross-skill references via `../other-skill/FILE.md` resolve in the
  installed layout because skills live as siblings under `~/.claude/skills/`.
