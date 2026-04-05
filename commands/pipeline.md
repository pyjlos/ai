Run the full plan → execute → QA → code review pipeline on $ARGUMENTS.

$ARGUMENTS is a task description, a path to a spec file, or a path to an existing handoff document.

## Guard

If $ARGUMENTS is empty, stop and respond:

"`/pipeline` requires a task. Usage:
  /pipeline <task description>
  /pipeline <path to spec file>
  /pipeline <path to handoff document>

Example: /pipeline 'Add rate limiting to the POST /orders endpoint'"

---

## Overview

This command runs four agents in sequence. Each agent produces a structured artifact that is the input to the next. Context is never passed through conversation history — it is passed through files.

```
[solution-architect] → plan.md
        ↓
[executor (you)]     → execute against plan.md → handoff.md
        ↓
[test-engineer]      → qa-report.md
        ↓
[code-reviewer]      → review.md
        ↓
[synthesizer (you)]  → pipeline-report.md
```

The output directory for all artifacts is `outputs/pipeline/<slug>/` where `<slug>` is a short identifier derived from the task (e.g., `rate-limiting-orders`).

---

## Step 1 — Initialize

Create the output directory:
```
outputs/pipeline/<slug>/
```

Write a `task.md` file there with:
- The original $ARGUMENTS verbatim
- Date and time
- A numbered list of the agents that will run

---

## Step 2 — Plan (solution-architect agent)

Invoke the **solution-architect** agent with this prompt:

```
You are planning an implementation task. Produce a structured implementation plan.

Task: <$ARGUMENTS>

Research the codebase first, then produce a plan in this exact format:

---
# Implementation Plan

## Problem statement
<1–2 sentences: what is being built and why>

## Scope
- In scope: <bullet list>
- Out of scope: <bullet list — be explicit>

## Files that will change
| File | Change type | What changes |
|------|-------------|--------------|
| <path> | create/modify/delete | <what> |

## Files that must not change
<List any files that are off-limits. If none, write "None.">

## Implementation steps
<Ordered list. Each step: what to do, in which file, why.>
1. ...
2. ...

## Acceptance criteria
<Numbered list. These are the tests the QA agent will use.>
1. ...
2. ...

## Risks
<What could go wrong. If none, write "None.">

## Open questions
<What needs human input before implementing. If none, write "None.">
---
```

Save the output to `outputs/pipeline/<slug>/plan.md`.

If the plan contains open questions, stop and surface them to the user. Do not proceed to Step 3 until the user answers them and you have updated the plan.

---

## Step 3 — Execute

Read `outputs/pipeline/<slug>/plan.md` completely before touching any file.

Implement every step in the plan in order. For each step:
1. Make the change
2. Run lint and typecheck incrementally (do not save for the end)
3. Note any deviation from the plan (unexpected finding, simpler path, forced change)

When implementation is complete, write `outputs/pipeline/<slug>/execute-summary.md`:

```markdown
# Execute Summary

## Completed steps
<Numbered list matching the plan's implementation steps. Mark each: done / skipped / modified>

## Deviations from plan
<Any step where what you did differs from what the plan said, and why.
If none, write "None.">

## Current state
- Tests: <passing | failing | not yet run>
- Lint: <clean | warnings | errors>
- Build: <clean | broken>

## Files changed
<List of every file actually modified, created, or deleted>

## Notes for QA
<Anything the test-engineer should know: tricky edge cases, partial
implementations, areas of higher uncertainty>
```

---

## Step 4 — QA (test-engineer agent)

Invoke the **test-engineer** agent with this prompt:

```
You are the QA agent in a pipeline. You have two inputs:

1. The implementation plan (acceptance criteria section is most important):
<contents of outputs/pipeline/<slug>/plan.md>

2. The execute summary:
<contents of outputs/pipeline/<slug>/execute-summary.md>

Your job:
- Verify each acceptance criterion from the plan is met
- Check test coverage for the changed files
- Identify any edge cases the implementation doesn't handle
- Run existing tests and report results

Produce a QA report in this format:

---
# QA Report

## Acceptance criteria verification
| Criterion | Status | Evidence |
|-----------|--------|----------|
| <criterion> | PASS / FAIL / PARTIAL | <how you verified it> |

## Test coverage
- New tests written: <yes/no, and list them>
- Coverage gaps: <list uncovered paths, or "None">
- Existing tests affected: <list, or "None">

## Edge cases
<List edge cases found. For each: description + whether it is handled.>

## Issues found
<Numbered list of problems. For each:>
- Severity: blocking / warning / note
- Description: <what is wrong>
- Location: <file:line if applicable>
- Suggested fix: <concrete suggestion>

## Verdict
<PASS — ready for code review>
<CONDITIONAL PASS — minor issues noted, proceed with caution>
<FAIL — blocking issues found, do not proceed>
---
```

Save to `outputs/pipeline/<slug>/qa-report.md`.

If the verdict is FAIL, stop the pipeline. Report the blocking issues to the user. The pipeline cannot continue until they are resolved (re-run from Step 3 after fixes).

---

## Step 5 — Code Review (code-reviewer agent)

Invoke the **code-reviewer** agent with this prompt:

```
You are the code reviewer in a pipeline. You have three inputs:

1. The implementation plan:
<contents of outputs/pipeline/<slug>/plan.md>

2. The execute summary:
<contents of outputs/pipeline/<slug>/execute-summary.md>

3. The QA report (already passed):
<contents of outputs/pipeline/<slug>/qa-report.md>

Changed files to review:
<list from execute-summary.md>

Your job: review the actual changed files for correctness, security,
reliability, and maintainability. The QA report has already confirmed
functional correctness — focus on what it cannot catch:
injection vectors, error handling gaps, resource leaks, race conditions,
and code that will cause maintenance pain.

Do not re-verify acceptance criteria — QA did that.

Produce a code review in this format:

---
# Code Review

## Summary
<2–3 sentences: overall quality signal. Be direct.>

## Verdict
<APPROVED | APPROVED WITH COMMENTS | CHANGES REQUIRED>

## Findings
<For each finding:>
- Severity: blocking / warning / suggestion
- File: <path:line>
- Issue: <what is wrong and why it matters>
- Fix: <concrete code or approach>

## Security checklist
- [ ] No secrets or credentials in code
- [ ] Inputs validated before use
- [ ] Auth/authz boundaries respected
- [ ] Error messages do not leak internals

## What is good
<Concrete things done well. This is not optional — name them.>
---
```

Save to `outputs/pipeline/<slug>/review.md`.

---

## Step 6 — Synthesize

Write `outputs/pipeline/<slug>/pipeline-report.md`:

```markdown
# Pipeline Report — <task slug>

**Date:** <today>
**Task:** <$ARGUMENTS>

## Outcome

| Stage    | Status  | Artifact |
|----------|---------|----------|
| Plan     | Done    | plan.md |
| Execute  | Done    | execute-summary.md |
| QA       | <PASS / FAIL> | qa-report.md |
| Review   | <APPROVED / CHANGES REQUIRED> | review.md |

## Action items

<Pull all blocking findings from the QA report and code review.
Numbered, ordered by severity. If nothing is blocking, write "None — ready to ship.">

## Files changed

<Final list of all files modified, created, or deleted>

## What to do next

<One of:>
- "All stages passed. The implementation is ready to ship."
- "QA found blocking issues. Resolve items X, Y, Z before proceeding."
- "Code review requires changes. See review.md items X, Y."
```

---

## Step 7 — Report to user

Tell the user:
- Path to `pipeline-report.md`
- Overall outcome in one line (all passed / what failed)
- How many action items remain
- Exact paths to all artifacts produced

Do not print any artifact contents to the terminal.
