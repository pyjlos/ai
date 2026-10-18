# Pragmatics

Write the simplest code that correctly solves the problem. No more.

## The decision ladder

Before writing any code, stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need → skip it. (YAGNI)
2. **Already in this codebase?** Reuse the helper, util, or pattern that lives here.
3. **Stdlib does it?** Use it.
4. **Native platform feature covers it?** CSS over JS, DB constraint over app code.
5. **Installed dependency solves it?** Use it.
6. **Can it be one line?** One line.
7. **Only then:** the minimum code that works.

## Core rules

- Solve the problem that exists today, not the one that might exist later
- Duplication is cheaper than the wrong abstraction — don't abstract until you see a third use case
- Delete code before refactoring it; refactor before rewriting it
- Prefer flat over nested; prefer simple over clever

## Comments

- Comments explain *why*, never *what* — well-named code already says what it does
- Never reference ticket IDs, issue numbers, PR numbers, or sprint/project names in comments — they rot as trackers get archived or renamed; put that context in the commit message instead
- Only add a comment when the reasoning is non-obvious: a hidden constraint, a workaround for a specific bug, a subtle invariant — if removing the comment wouldn't confuse a future reader, don't write it
- No commented-out code, no restating the diff ("added X", "removed Y") in a comment

## AI-code smells

Flag and remove these when reviewing or writing code — they're the patterns AI assistants over-produce by default:

- Comments that restate what the code already says, or that don't match the surrounding file's comment style and density
- Defensive checks, try/catch, or input validation on a path that's otherwise trusted internal code — only validate at real boundaries
- A cast or suppression that exists only to silence the type checker (`as any`, blanket `# type: ignore`, `@ts-ignore`) rather than to express a real union or narrowing need
- Nested conditionals an early return would flatten
- Anything else that doesn't match the surrounding file's or codebase's own style — consistency with what's already there beats a "better" pattern imported from elsewhere

## What to avoid

- Abstractions, interfaces, or base classes with only one implementation
- Wrapper functions that only call one other function
- Config flags for behaviour that never changes
- Custom exceptions for conditions that `ValueError` or `RuntimeError` covers fine
- Utility files that contain a single function
- Log lines that only say a function was entered or exited with no state — they add noise without signal

## When in doubt

Ask: *what requirement forced this complexity?*
If there is no clear answer, remove it.
