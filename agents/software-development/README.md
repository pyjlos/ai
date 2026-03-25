---
model: claude-sonnet-4-6
---

# Software Development Agents

Language-specific agent instruction files for code review, implementation, and technical guidance.

## Available Agents

| File | Language | Version Target |
|---|---|---|
| `python.md` | Python | 3.12+, uv/ruff/mypy/pytest |
| `java.md` | Java | 21+, records, virtual threads |
| `go.md` | Go | 1.22+, generics, slog |
| `bash.md` | Bash | POSIX-safe, shellcheck patterns |
| `typescript.md` | TypeScript | 5.x, strict mode, Vitest |
| `sql.md` | SQL | PostgreSQL 16+, query optimization |

## Usage

Reference a file directly in your prompt to load that agent's persona and standards:

```bash
claude --agent software-development/python.md "review this service for type safety issues"
```

Or paste the file contents as a system prompt when building with the API.

## Setting Up Named Agents

To call agents by name (e.g. `python-agent`) from anywhere in Claude Code, symlink or copy these files into `~/.claude/agents/`:

```bash
mkdir -p ~/.claude/agents

# Symlink all language agents
for f in ~/repos/ai/agents/software-development/*.md; do
  name=$(basename "$f" .md)
  ln -sf "$f" ~/.claude/agents/"${name}-agent.md"
done
```

This makes them available as subagent types: `python-agent`, `java-agent`, `go-agent`, `bash-agent`, `typescript-agent`, `sql-agent`.

Each agent file can include a frontmatter block to control the model and description:

```markdown
---
name: python-agent
description: Use for Python code review, implementation, and toolchain guidance (Python 3.12+)
model: claude-sonnet-4-6
---

You are a Senior Software Engineer specializing in Python...
```

Claude Code reads the `~/.claude/agents/` directory and exposes each file as a named subagent type in the Agent tool and `/agents` dialog.

## Model Default

All agents in this directory default to `claude-sonnet-4-6` (Sonnet 4.6). To override for a specific agent, add a `model` field to that file's frontmatter.
