# CLAUDE.md
# Loaded by Claude Code at the start of every session.
# Keep it short — every line costs context. Prune regularly.
# Placeholders use [ALL_CAPS] — fill in or delete before committing.

## Project
[PROJECT_NAME] — [one sentence: what it does and who uses it]
Stack: Python [VERSION], [FRAMEWORK e.g. FastAPI | Typer | Prefect], uv, Ruff, Mypy
Type: [REST API | CLI tool | data pipeline | background worker | library]

## Repo layout
[Describe your actual structure. Example for a src-layout FastAPI service:]
src/[PACKAGE]/
  api/        # Route handlers
  core/       # Business logic
  models/     # Pydantic schemas and DB models
  utils/      # Shared helpers
tests/
pyproject.toml
uv.lock       # Commit this

## Dependency management — uv only
Do NOT use pip, pipenv, or poetry.

uv sync                   # install all deps (creates .venv)
uv add <pkg>              # add runtime dep
uv add --dev <pkg>        # add dev-only dep
uv remove <pkg>           # remove dep
uv run <cmd>              # run inside venv

## Commands
uv run [DEV_SERVER_CMD]   # [e.g. "fastapi dev" | "python -m [PACKAGE]"]
uv run pytest -x          # run tests, stop on first failure
uv run mypy src/          # type-check
uv run ruff check .       # lint
uv run ruff format .      # format

## Verifying changes
Run all three before marking a task done:
1. `uv run mypy src/` — zero errors
2. `uv run ruff check .` — zero errors
3. `uv run pytest tests/[RELEVANT_FILE].py` — affected tests pass

## Must Never Do
- Edit uv.lock manually — let uv manage it
- Install packages globally — always use `uv add`
- Change the Python version (pinned in .python-version and pyproject.toml) without asking
- [PROJECT-SPECIFIC hard prohibitions — e.g. "never truncate migration files"]

## Workflow
- For tasks > ~1 hour: write a plan and confirm before coding
- [OPTIONAL: migration command — e.g. "uv run alembic upgrade head"]
- [OPTIONAL: seed/fixture command — e.g. "uv run python scripts/seed.py"]
- [Add team-specific workflow rules here]

## Known gotchas
[Document what Claude gets wrong on this project specifically.
 Delete this section if empty — don't leave it as a placeholder.
 Examples:
 - "The `EventBus` in core/events.py is a singleton — never instantiate it directly"
 - "Integration tests require a running Postgres; see docker-compose.yml"
 - "src/[PACKAGE]/config.py must be imported before any other module"]

## References
For full setup: README.md
For system design: docs/architecture.md
For scripts and tool config: pyproject.toml

# Personal overrides → CLAUDE.local.md (gitignored)
