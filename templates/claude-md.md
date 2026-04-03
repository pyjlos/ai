# CLAUDE.md
# Loaded by Claude Code at the start of every session.
# Keep it short — every line costs context. Prune regularly.

## Project overview
This is [PROJECT NAME] — [one sentence description].
Stack: Python 3.12+, [e.g. FastAPI / Django / Typer], uv, Ruff, Mypy
Purpose: [e.g., REST API for X / CLI tool for Y / data pipeline for Z]

## Repo structure
src/[package]/    # Main package (importable as `[package]`)
  api/            # Route handlers / controllers
  core/           # Business logic
  models/         # Pydantic schemas & DB models
  utils/          # Shared helpers
tests/            # Pytest test suite
pyproject.toml    # Project metadata, deps, tool config
uv.lock           # Lockfile — commit this

## Environment & dependency management
This project uses uv — do NOT use pip, pipenv, or poetry.

uv sync                    # install all deps (creates .venv if needed)
uv add <package>           # add a runtime dependency
uv add --dev <package>     # add a dev-only dependency
uv remove <package>        # remove a dependency
uv run <command>           # run a command inside the venv

# Python version is pinned in .python-version and pyproject.toml.
# Never change the Python version without asking first.

## Key commands
uv run fastapi dev         # start dev server (port 8000)
uv run pytest              # run full test suite
uv run pytest tests/path/test_file.py  # run a single test file
uv run mypy src/           # type-check
uv run ruff check .        # lint
uv run ruff format .       # format

# IMPORTANT: Always run mypy + ruff after making changes.
# Prefer running a single test file over the full suite for speed.

## How to verify your work
1. `uv run mypy src/` must pass — no type errors
2. `uv run ruff check .` must pass — no lint errors
3. `uv run pytest tests/[relevant_file].py` — affected tests green

## Code conventions
- Python 3.12+ only — use match/case, type unions (X | Y), f-strings
- All public functions and classes must have type annotations
- Use `from __future__ import annotations` at the top of every file
- Prefer `pathlib.Path` over `os.path`
- Prefer `httpx` over `requests` for HTTP calls
- [Add project-specific conventions here]

## Workflow rules
- Never edit uv.lock manually — let uv manage it
- Never install packages globally — always use `uv add`
- Migrations: use `uv run alembic upgrade head` (never edit migrations by hand)
- Create a plan before writing code on tasks > ~1hr
- [Add your team-specific rules here]

## References
See @README.md for full setup instructions
See @docs/architecture.md for system design
See @pyproject.toml for available scripts and tool config

# Local/personal overrides → CLAUDE.local.md (gitignored)