Produce a session handoff document so the next session (or next agent) can resume without loss of context.

## Guard

Run this command at the end of any session where:
- Work is in progress (not fully complete)
- Another agent will continue the work
- You are switching context and will return later

Do not skip this because the task "seems small" — incomplete context is the most common cause of regressions in resumed sessions.

---

## Step 1 — Assess current state

Before writing anything, answer these questions internally:

1. What phase of the workflow are we in? (Research / Plan / Execute / Review)
2. What was the original task or goal?
3. What has been completed? What has not?
4. What decisions were made and why? (The "why" is what gets lost most often)
5. What is the immediate next action the next session should take?
6. Are there any open questions, blockers, or known risks?
7. Which files were read or modified in this session?

---

## Step 2 — Write the handoff document

Handoffs are grouped by feature. Ask the user which feature directory this
handoff belongs to before writing anything — do not guess or infer it silently,
even if a feature name seems obvious from the conversation. Propose a
kebab-case name based on the session's work as a suggestion, but let the user
confirm or override it.

Target path is:

```
<current-working-directory>/outputs/handoffs/<feature-name>/handoff-<slug>-YYYY-MM-DD-HH-MM.md
```

- `<feature-name>` — the feature directory confirmed with the user in this step.
- `<slug>` — a short kebab-case slug describing this specific handoff (e.g. `jwt-refresh-fix`), derived from the one-line task description.

Do not write until the user has confirmed the feature directory.

Never write to `/tmp`, `$HOME`, or any path outside `outputs/handoffs/`.

Use this exact structure:

```markdown
# Handoff — <one-line task description>

**Date:** <today>
**Session phase:** <Research | Plan | Execute | Review>
**Status:** <In progress | Blocked | Ready for next agent>
**Next agent:** <agent name, or "same session">

---

## Goal

<1–2 sentences: what this work is trying to accomplish and why.
This is the anchor. Everything else is detail.>

---

## What was done this session

<Bullet list. Be specific: file names, function names, decisions made.
Not "looked at the auth code" — "read src/auth/jwt.go, confirmed token
expiry is 24h, found that refresh tokens are not rotated on use (see risk below)">

---

## Decisions made

<Each decision that would not be obvious from reading the code.>

| Decision | Rationale | Alternatives rejected |
|----------|-----------|----------------------|
| <what>   | <why>     | <what else was considered> |

---

## Current state of the codebase

<What is the code in right now? Passing tests? Partial implementation?
Compilation errors? The next session needs to know if they're picking up
a green state or a broken one.>

- Tests: <passing / failing / not yet written>
- Lint: <clean / has warnings>
- Build: <clean / broken>
- Files modified this session: <list>
- Files that still need changes: <list>

---

## Immediate next action

<Single, concrete next step. One thing. What should the next session do first?>

```
<exact command or action>
```

---

## Open questions

<Things that are unresolved and will affect the next session.
If none, write "None.">

1. <question>
2. <question>

---

## Risks and watch-outs

<Anything the next agent needs to be careful about.
If none, write "None.">

- <risk or constraint>

---

## Context that won't be in the code

<Anything important that lives only in conversation history and won't be
visible by reading files. Temporary workarounds, deferred decisions,
things explicitly not done.>

---

## Relevant files

<Files the next session should read first to rebuild context.
Order matters: list them in the order they should be read.>

1. `<path>` — <why this file matters>
2. `<path>` — <why this file matters>
```

---

## Step 3 — Report back

Tell the user:
- Path to the handoff file
- Current status in one line (phase + what's done + immediate next action)
- Any open questions that need human input before the next session starts

Do not print the full handoff to the terminal — it's in the file.
The user needs to answer any open questions before the next session begins.
