# Pragmatics

Write the simplest code that correctly solves the problem. No more.

## Core rules

- Solve the problem that exists today, not the one that might exist later
- Duplication is cheaper than the wrong abstraction — don't abstract until you see a third use case
- Delete code before refactoring it; refactor before rewriting it
- The best function is the one you don't write — if the caller can do it simply inline, do that
- Prefer flat over nested; prefer simple over clever
- If you find yourself writing a comment to explain what the code does, simplify the code instead
- Comments explain *why*, never *what*

## What to avoid

- Abstractions, interfaces, or base classes with only one implementation
- Wrapper functions that only call one other function
- Config flags for behaviour that never changes
- Custom exceptions for conditions that `ValueError` or `RuntimeError` covers fine
- Utility files that contain a single function
- Logging at every function entry and exit with no diagnostic value

## When in doubt

Ask: *what requirement forced this complexity?*
If there is no clear answer, remove it.