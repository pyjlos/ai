---
inclusion: always
---

# Coding Standards

## Python

- Formatter: Black (line length 100)
- Linter: Ruff with strict config; all warnings are errors
- Type hints: required on all function parameters, returns, and class attributes
- Docstrings: Google-style on all public functions and classes
- No mutable default arguments; no bare except clauses; no magic numbers

## JavaScript and TypeScript

- Formatter: Prettier (100 chars, 2 spaces, no semicolons, single quotes)
- Linter: ESLint with TypeScript strict mode
- No `any` type without an explanatory comment
- Prefer async/await over Promise chains
- Named constants instead of magic numbers
- No boolean function parameters — use object params

## Go

- Formatter: gofmt (enforced in pre-commit)
- Linter: golangci-lint with all warnings as errors
- All exported types and functions require comments
- Always check errors explicitly — never `_` an error silently
- Prefer early returns; cyclomatic complexity < 10
- No global variables; no panic for normal errors
