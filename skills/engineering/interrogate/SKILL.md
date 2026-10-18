---
name: interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"multi-angle review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Parallel subagent reviewers challenge changes from independent adversarial angles."
disable-model-invocation: true
metadata:
  credits:
    skill: interrogate
    author: Lauren Tan
    organisation: Cursor (pstack plugin)
    url: "https://github.com/cursor/plugins/blob/main/pstack/skills/interrogate/SKILL.md"
---

# Interrogate

Spawn several reviewers in parallel to adversarially review a change from independent angles. The adversarial signal comes from giving each reviewer a distinct angle to attack, not from assigning them different personas on the same brief. The deliverable is a synthesized verdict, sorted into buckets. Never auto-apply changes.

This repo has no per-model routing config — reviewer diversity comes from angle, not model, mirroring how `code-review` fans a review across axes instead of across models.

## Step 1, scope

Identify what to review from context:

- If the user points at specific files or a diff, use that.
- If on a feature branch, run `git diff <base-branch>...HEAD` for the full changeset.
- If the user's message references recent work, gather the relevant files.

## Step 2, state intent

Before spawning reviewers, state the intent in one clear paragraph, drawn from the user's message, commit messages, the PR description if one exists, and the code. If you're unsure about the intent, ask the user before proceeding.

## Step 3, spawn reviewers

Launch all reviewers together, in one message, each as a read-only subagent given the same diff and intent but a different adversarial angle. Label them Reviewer A, B, C... Default angles, drop or add per what the change actually touches:

- **Correctness** — edge cases, off-by-ones, error paths, concurrency, state mutation
- **Security** — injection, auth/authz gaps, secret handling, trust boundaries
- **Simplicity** — over-engineering, speculative abstraction, code that doesn't match this repo's `pragmatic.md`
- **Spec fidelity** — does the diff actually do what the stated intent says, no more and no less

Each reviewer's brief: the stated intent, the diff or file contents, its assigned angle, and "report findings only from that angle; cite file:line for each."

## Step 4, synthesize

As results come back, build a unified picture. Merge findings that describe the same issue raised from different angles. A finding two or more reviewers raised independently is the strongest signal — weight a lone reviewer's finding accordingly. Note disagreements: if one reviewer flags something and the evidence from another angle contradicts it, that's context for the verdict, not a tiebreak to silently resolve.

## Step 5, lead judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator. Put every finding in one of four buckets, with the reviewer(s) that raised it and a one-line rationale:

- **Act on**. Real issues affecting correctness, security, or maintainability given the actual goals. They would block a real PR.
- **Consider**. Legitimate, but not clearly worth the cost of addressing now. Worth the user's attention.
- **Noted**. Technically valid but not actionable — context-dependent, premature, or low-impact at this stage.
- **Dismissed**. Wrong, nitpicky, or missing context, with a brief reason.

## Output format

### Intent
> [The stated intent paragraph from Step 2]

### Reviewers
- Reviewer [label]: [angle], [N findings] (one bullet per reviewer)

### Act On
[Each: description, which reviewers raised it, why it matters.]

### Consider
[Each: description, which reviewers raised it, the tradeoff.]

### Noted
[Brief list.]

### Dismissed
[Each with a brief rationale.]

### Agreement map
[Where reviewers agreed and diverged, and what that pattern tells us.]
