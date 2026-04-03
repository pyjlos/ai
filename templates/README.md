## Templates
Contains helpful templates and tips for each

### CLAUDE.md
- Reference docs, don't embed them. Avoid using @file imports to embed entire docs directly — this loads the whole file on every run. Instead, write something like "For complex usage of FooBarError, see path/to/docs.md" so Claude fetches it only when needed.
- Document what Claude gets wrong, not what's obvious. The most effective CLAUDE.md files document what Claude gets wrong, not comprehensive manuals. Things Claude can infer from your code don't need to be in there.
- Iterate on it like a config file
- Focus on WHAT, WHY, and HOW. Tell Claude about your tech stack and project structure (WHAT), the purpose of the project and its parts (WHY), and how it should actually work on the project — e.g., do you use bun instead of node? How can Claude verify its changes via tests, typechecks, and compilation steps? (HOW)
- Don't use it for code style. LLMs are comparably expensive and slow compared to traditional linters and formatters. Code style guidelines add mostly-irrelevant instructions into your context window, degrading instruction-following. Use a linter/formatter instead.
- Use file imports to stay lean. CLAUDE.md files can import additional files using @path/to/import syntax — for example, @docs/git-instructions.md. This lets you keep the root file concise while pointing Claude to deeper references on demand.
Use a hierarchy of files. Claude Code reads CLAUDE.md files hierarchically: first from ~/.claude/CLAUDE.md (global), then project root, then individual subdirectories. This lets you set global preferences and layer in project-specific rules.
- Use CLAUDE.local.md for personal notes. Place personal project-specific notes in ./CLAUDE.local.md and add it to .gitignore so it isn't shared with your team. Check CLAUDE.md into git so your whole team benefits — the file compounds in value over time.

- 