# Session Continuity

Context loss between sessions and between agents is a reliability failure, not a workflow detail. These rules are mandatory.

---

## When to produce a handoff

Produce a handoff document (via `/handoff`) when:

- The task is not complete and the session is ending
- You are about to pass work to another agent in a pipeline
- You have made decisions whose rationale is not visible in the code
- The work spans more than one phase of the workflow

Do not skip the handoff because the work "seems small." A missed handoff is the most common cause of regressions in resumed sessions.

---

## What a handoff must contain

A handoff document is not a summary — it is a machine-readable state snapshot. It must answer:

1. What was the original goal?
2. What phase of the workflow are we in?
3. What was done and what was not?
4. What decisions were made and why? (Rationale that is not visible in the code)
5. What is the immediate next action?
6. What is the current state of the codebase (tests, lint, build)?
7. Which files should the next session read first?

A handoff that omits any of these is incomplete.

---

## When to produce a handoff mid-task

If you discover during execution that the task is significantly larger than expected, stop, produce a handoff, and flag it to the user before continuing. Do not silently expand scope.

---

## Agent pipeline handoffs

When running a pipeline (plan → execute → QA → review):

- Each agent reads the previous agent's artifact from disk — not from conversation history
- Each agent writes its output to a named file in `outputs/pipeline/<slug>/`
- No context is assumed to carry over between agent invocations
- If an artifact is missing or unreadable, the agent stops and reports it — never guesses

File naming convention for pipeline artifacts:
```
outputs/pipeline/<slug>/plan.md
outputs/pipeline/<slug>/execute-summary.md
outputs/pipeline/<slug>/qa-report.md
outputs/pipeline/<slug>/review.md
outputs/pipeline/<slug>/pipeline-report.md
```

---

## Resuming a session

When resuming from a handoff (via `/resume`):

1. Read the handoff file completely before reading any code
2. Verify that the current codebase state matches what the handoff describes
3. Surface any discrepancies before proceeding — do not silently work around them
4. Execute exactly what "Immediate next action" says — do not re-derive the plan

Trust the handoff unless you find a contradiction in the files.

---

## Where handoffs are stored

```
outputs/handoffs/handoff-YYYY-MM-DD-HH-MM.md   — session handoffs
outputs/pipeline/<slug>/                         — pipeline artifacts
```

The `outputs/` directory is the source of truth for in-progress work. When starting a new session on a task that has prior work, check `outputs/` before asking the user for context.
