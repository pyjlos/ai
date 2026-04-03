## Templates
Contains reusable templates and authoring guidance.

### CLAUDE.md (`claude-md.md`)

A project CLAUDE.md is loaded into every Claude Code session as a system prompt prefix.
Every line costs context — write it like a tight system prompt, not a wiki page.

**Core principles**

- **Document what Claude gets wrong, not what is obvious.** The most effective CLAUDE.md files capture project-specific gotchas — things Claude cannot infer from reading the code. Things it can infer do not belong here.
- **Focus on WHAT, WHY, and HOW.** Tell Claude about your tech stack and structure (WHAT), the purpose of the project and its parts (WHY), and how to actually work on it — which commands to run, how to verify changes, which tools to use (HOW).
- **Separate hard rules from soft preferences.** Use "Must Never Do" for prohibitions Claude must treat as absolute. Use "Workflow" for preferences and patterns. Mixing them dilutes both.
- **Iterate on it like a config file.** Add a line when Claude makes a mistake. Delete a line when it stops being relevant. Prune on a regular cadence.
- **Don't use it for code style.** Linters and formatters (Ruff, ESLint, gofmt) enforce style reliably and cheaply. Restating style rules in CLAUDE.md adds tokens and degrades instruction-following on the rules that actually matter.

**Using @imports correctly**

CLAUDE.md supports `@path/to/file` syntax for importing other files. Use it selectively:

- `@` imports embed the entire file on every session load — treat them like inlining code.
- Reserve `@` imports for short, stable files that Claude needs in every session (e.g., a 20-line git workflow doc).
- For large or rarely-needed references, use plain text paths: `"For error handling patterns, see docs/errors.md"` — Claude will fetch the file only when relevant.

**Using the file hierarchy**

Claude Code loads CLAUDE.md files in layers, with later layers overriding earlier ones:

```
~/.claude/CLAUDE.md          # Global: applies to all projects
{project}/CLAUDE.md          # Project: team-shared rules
{project}/.claude/CLAUDE.md  # Project-scoped (alternative location)
{subdir}/CLAUDE.md           # Subdirectory: narrows scope for that subtree
```

Put team-wide standards (language version, forbidden commands, commit conventions) in `~/.claude/CLAUDE.md`. Put project-specific rules in the project root. Put module-specific constraints in subdirectory CLAUDE.md files. Never duplicate content between layers.

**Personal notes**

Place personal, project-specific notes in `CLAUDE.local.md` at the project root and add it to `.gitignore`. Commit `CLAUDE.md` so the whole team benefits — it compounds in value over time as gotchas accumulate.

**Using the template**

1. Copy `claude-md.md` to your project root as `CLAUDE.md`.
2. Fill in every `[ALL_CAPS]` placeholder or delete the line.
3. Delete or collapse any section that does not apply to your project type.
4. Delete the `Known gotchas` section if it is empty — a blank placeholder wastes context.
5. Add the file to git and treat it as a living document.
