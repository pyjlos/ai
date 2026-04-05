# Rules

Rules are focused instruction files that tell Claude how to behave in a specific dimension — security, testing, git hygiene, and so on. They are not agents (which have broad domain expertise) and not commands (which define multi-step workflows). Rules are constraints: things Claude must do, must not do, or must check before considering a task complete.

Rules are plain markdown files. They work by being read into Claude's context at the start of a session, either by referencing them in your `CLAUDE.md` or by citing them directly in a prompt.

---

## How to load rules

### Option 1 — Add to CLAUDE.md (always active)

Put rules that should apply to every session in your project's `CLAUDE.md`. Reference the file rather than pasting the content:

```markdown
## Rules

Follow all rules in:
- @rules/security.md
- @rules/git.md
- @rules/workflow.md
```

Claude Code resolves `@rules/filename.md` relative to the project root and injects the content automatically.

### Option 2 — Reference in a prompt (situational)

Load a rule only when it is relevant to the current task:

```
Load rules/testing.md, then: test-engineer — write tests for src/api/orders.py
```

```
Load rules/security.md and rules/pragmatic.md, then review this pull request.
```

This keeps your base context lean and loads extra constraints only when needed.

### Option 3 — Use with a command

The `review-pr` command implicitly relies on the behaviors defined in these rules because the agents it spawns were built with them in mind. If you want to make rules explicit for a review, pass them in the prompt before invoking the command.

---

## Rules reference

### `pragmatic.md` — Write the simplest code that works

Enforces one principle: solve today's problem, not tomorrow's hypothetical one. Claude will avoid premature abstractions, unnecessary wrapper functions, single-implementation interfaces, and config flags for behavior that never changes. Comments must explain *why*, not *what*.

**Why it matters:** The most common source of accidental complexity in codebases is code written for requirements that never materialized. This rule keeps Claude from introducing that complexity on your behalf.

**Load when:** You are implementing a new feature, refactoring existing code, or doing a complexity audit. This rule pairs well with the `pragmatic-reviewer` agent.

---

### `security.md` — Non-negotiable security constraints

Defines a set of hard rules with no exceptions: no hardcoded secrets or credentials, no SQL/shell injection via string concatenation, no `eval()` on untrusted input, no logging of PII or tokens, no use of MD5/SHA1 for anything security-sensitive, no raw stack traces exposed to users. Also covers input validation, least privilege, and dependency pinning.

**Why it matters:** Security failures are often not mistakes of ignorance — they are mistakes of omission. This rule makes the constraints explicit so Claude cannot skip them by accident.

**Load when:** Reviewing code for security, implementing authentication or authorization, working on anything that touches user data, credentials, or external input. This rule should be in your `CLAUDE.md` for any project that ships to production.

---

### `testing.md` — Test behavior, not implementation

Defines what good tests look like: one logical assertion per test, Arrange / Act / Assert structure, test names that read as sentences, mocks only at the boundary (network, filesystem, time — not deep inside business logic), and tests that survive a refactor without changing. Also defines what not to test: third-party library behavior, trivial getters/setters, implementation details invisible from the outside.

**Why it matters:** Tests that are tightly coupled to implementation details break every time you refactor, creating friction that slows the team down. Tests that only cover the happy path give false confidence. This rule steers Claude toward tests that are actually useful.

**Load when:** Asking any agent to write or review tests. The `test-engineer` agent is built with this philosophy, but loading the rule explicitly reinforces it.

---

### `git.md` — Conventional commits, branch hygiene, and PR discipline

Enforces conventional commit format (`feat(scope): description`), imperative mood in commit subjects, one logical change per commit, and branch naming conventions (`feat/`, `fix/`). Requires running lint, typecheck, and tests before pushing. PRs must include what changed, why, and how to verify — and should be reviewable in under 15 minutes.

**Why it matters:** Consistent commit history makes `git log`, `git bisect`, and changelog generation reliable. Small, focused PRs reduce review time and merge risk. These are team-level habits that compound over time.

**Load when:** You want Claude to generate commit messages, write PR descriptions, or advise on branch strategy. Also useful when reviewing a PR with `review-pr` to ensure the change itself is well-scoped.

---

### `workflow.md` — Plan before coding, stay focused, communicate blockers

Enforces a disciplined approach to task execution: understand requirements before touching any file, write a plan for tasks over an hour, make the smallest change that solves the problem, run lint and typecheck incrementally, and never declare a task done if tests are failing. Also covers communication: stop and ask when requirements are ambiguous rather than guessing and reworking.

**Why it matters:** AI models, like engineers under time pressure, will sometimes take shortcuts — implementing something plausible rather than verifying it is correct, or fixing something adjacent rather than the actual problem. This rule makes the disciplined approach explicit.

**Load when:** Starting a non-trivial implementation task. This is a good candidate for `CLAUDE.md` so it applies to every session.

---

## Best practices for using rules

**Always load security.md for production code.**
Security constraints should not be optional. Add `@rules/security.md` to your project `CLAUDE.md` and leave it there.

**Load workflow.md globally.**
The workflow discipline — plan first, smallest change, verify before done — is useful in every session. Put it in `CLAUDE.md`.

**Load testing.md and pragmatic.md situationally.**
These rules are most valuable when writing or reviewing code. Loading them for every session adds context without always needing it. Reference them in a prompt when the task calls for them.

**Load git.md when generating commit messages or PR descriptions.**
Claude will produce conventional-format commit messages and well-structured PR descriptions when this rule is active.

**Layer rules with agents for maximum precision.**
Rules define constraints; agents provide domain expertise. Together they produce more consistent output than either alone:

```
Load rules/security.md and rules/testing.md, then:
test-engineer — write tests for the authentication middleware in src/middleware/auth.py
```

### A note on rule conflicts

Rules are designed to be complementary, but apparent conflicts can arise. The most common case: `pragmatic.md` says to write the simplest code that works, while `testing.md` says to test all error paths — which can require more code.

These do not actually conflict. Pragmatic is about production code, not test code. Test thoroughness is a form of correctness, not complexity.

If two rules give you genuinely contradictory guidance for a specific situation, resolve it by being explicit in your prompt:

```
Load rules/pragmatic.md and rules/security.md. If they conflict on input validation,
prefer security.md — correctness over brevity for anything touching user input.
```

Explicit instruction always takes priority over a rule file. Rules set defaults; your prompt sets the specific intent.
