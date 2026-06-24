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
- Comments explain *why*, never *what*

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
