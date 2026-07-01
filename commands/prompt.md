Refine a broad engineering goal into a self-contained prompt that a fresh agent can pick up and execute. $ARGUMENTS is the user's raw goal statement.

## Guard

If $ARGUMENTS is empty, stop and ask:
"What's the goal? Describe it however you like — rough, vague, or partial is fine."

Do not proceed until the user provides a goal.

---

## Step 1 — Surface ambiguities and ask

Read $ARGUMENTS. Map it against these dimensions:

- **What:** what exactly needs to be built, changed, or fixed
- **Where:** which repo, service, or module
- **Why:** the motivation (affects scope and trade-offs)
- **Done looks like:** how success is measured or verified
- **Constraints:** tech stack, compat requirements, explicit non-goals

For each dimension that is missing or unclear, formulate a question. Ask **all questions in a single message** — do not drip them one at a time. Max 5 questions.

**Do not skip this step.** Do not guess or assume an answer you could ask about instead. A bad assumption in the prompt compounds downstream.

Example question format:
> A few questions before I draft this:
> 1. Which repo / service does this live in?
> 2. Is there an existing auth layer or is this greenfield?
> 3. What does "done" look like — a passing test suite, a live endpoint, a migration applied?
> 4. Any hard constraints? (e.g., no new dependencies, must stay on Postgres)

Wait for the user's answers before proceeding.

---

## Step 2 — Gather codebase context

With the user's answers in hand, read the relevant project state:

1. Check for CLAUDE.md at the repo root — note stack, conventions, constraints
2. Find the 2–5 files most directly relevant to the goal
3. Run `git status` and `git log --oneline -5` to capture current branch and recent work
4. Check `outputs/handoffs/` for any overlapping in-progress work

If anything you find contradicts or complicates the user's stated goal, **stop and flag it** — do not work around it silently.

If you cannot find a key file or piece of context (e.g., you don't know which service owns this feature), ask the user rather than guessing.

---

## Step 3 — Confirm scope before drafting

Before writing the prompt file, present a brief scope summary and ask for confirmation:

> Here's what I'm planning to capture in the prompt:
>
> - **Goal:** <one sentence>
> - **Scope in:** <bullet list>
> - **Scope out:** <bullet list>
> - **Success looks like:** <bullet list>
> - **Key files:** <list>
>
> Does this match what you have in mind? Anything to add, cut, or correct?

Do not write the file until the user confirms or adjusts the scope.

---

## Step 4 — Write the prompt file

Write to `outputs/prompts/prompt-<slug>-YYYY-MM-DD.md` where `<slug>` is a 2–4 word kebab-case summary.

Use this exact structure:

```markdown
# Prompt — <one-line goal title>

**Date:** <today>
**Repo:** <repo name or path>
**Branch:** <current branch>

---

## Goal

<1–3 sentences. Concrete outcome — what needs to exist or be different when done.
No vague language. "Add JWT authentication to the /api routes" not "improve security".>

---

## Context

<Everything a fresh agent needs to start without asking follow-up questions.>

- **Stack:** <languages, frameworks, key dependencies>
- **Relevant files:** <file path — one-line description of why it matters>
- **Current state:** <what exists today vs. what is missing>
- **Prior work:** <handoff path if one exists, otherwise "none">

---

## Scope

**In:**
- <specific deliverable 1>
- <specific deliverable 2>

**Out:**
- <explicit non-goal 1>
- <explicit non-goal 2>

---

## Success criteria

<Each item is independently verifiable.>

1. <verifiable criterion — e.g., "`npm test` passes with no failures">
2. <verifiable criterion>

---

## Constraints

- <hard constraint — e.g., "no new runtime dependencies", "must not break existing API surface">

---

## Suggested starting point

<Only if there is a non-obvious entry point. 1–3 steps max. Leave room for the agent to reason.>

1. <first concrete action>
```

---

## Step 5 — Report back

Tell the user:
- Path to the prompt file
- One sentence: what was vague in the original → what it is now
- Any remaining open questions or assumptions baked in that the user should validate

Do not print the full prompt to the terminal — it's in the file.
