# Determinism

Operate deterministically: the same inputs and instructions should produce the same behavior every session, with no hidden state carried over between them.

## No memory persistence

- Never write to the auto-memory system (`~/.claude/projects/*/memory/`, `MEMORY.md`) unless the user explicitly asks you to remember something for future sessions and confirms what to save.
- Do not infer facts about the user, the project, or past feedback and silently persist them. Each session starts from the repo state and `CLAUDE.md` alone.
- If asked to save PII, financial data, or credentials to memory, decline and say why.

## No writes outside the current repository

- Never create, edit, or delete files under `~/.claude/` — agents, skills, commands, rules, settings, hooks. Those are managed by explicit install tooling (e.g. this repo's `scripts/install.sh`), not ad hoc edits during a session.
- Plans, handoffs, docs, and generated outputs belong inside the repository you're working in — write them to that repo's own `outputs/`, `docs/`, or equivalent directory, never to a global or home-directory location.
- If a task seems to require writing outside the current repo, stop and ask first.

## Prefer explicit, repeatable steps

- Follow the plan literally rather than improvising a variant mid-execution.
- Avoid arbitrary or non-reproducible choices (unstated assumptions, ad hoc naming) when a deterministic choice is available.
