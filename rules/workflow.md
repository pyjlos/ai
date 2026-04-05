# Workflow

For every non-trivial task, follow these four phases in order. Do not skip phases or collapse them together.

---

## Phase 1 — Research

Before writing any code or making a plan:

- Read every file, function, and type directly relevant to the task — do not guess at existing behaviour
- Identify what already exists that the change will affect (callers, tests, config, migrations)
- Check whether the problem is already solved elsewhere in the codebase
- If the requirement is ambiguous, stop and ask before proceeding — clarify once, not repeatedly

**Output:** a clear statement of what the problem actually is, grounded in what you read.

---

## Phase 2 — Plan

Before touching any file:

- Write out the specific steps you will take: which files change, what each change does, and why
- For any step with meaningful risk or uncertainty, call it out explicitly
- For tasks larger than ~1 hour of work, share the plan and get confirmation before implementing
- Prefer the smallest change that solves the problem — if a simpler path exists, take it

**Output:** a concrete, ordered list of changes. Not prose. Steps.

---

## Phase 3 — Execute

Implement the plan:

- Make one logical change at a time — do not bundle unrelated fixes into the same edit
- Prefer editing existing files over creating new ones
- If you discover something broken that is out of scope, note it but do not fix it inline — stay focused
- Run the linter and type checker incrementally; do not save verification for the end

---

## Phase 4 — Review

Before declaring the task done:

- Run: lint → typecheck → affected tests — all must pass
- Read your own diff: remove debug logs, commented-out code, and leftover TODOs
- Verify new behaviour works end-to-end, not just in unit tests
- If any test is failing or any known issue is unresolved, the task is not done — say so

---

## Communication rules

- Never say a task is done if tests are failing or issues are unresolved
- If a task turns out significantly larger than expected, flag it before proceeding
- If you hit a blocker, say so clearly — do not work around it silently
