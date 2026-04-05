# Git
 
## Commits
 
- Commit messages use conventional commits format: `type(scope): short description`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`
  - Example: `fix(auth): handle expired token on refresh`
- Subject line is imperative mood, 72 chars max — "add feature" not "added feature"
- Commit one logical change at a time — don't bundle unrelated fixes
- Never commit: `.env` files, secrets, build artefacts, `node_modules`, `__pycache__`, `.venv`
 
## Branches
 
- Feature branches: `feat/short-description`
- Bug fixes: `fix/short-description`
- Never commit directly to `main` or `master`
- Keep branches short-lived — long-running branches cause painful merges
 
## Before pushing
 
- Run the full lint + typecheck + affected tests — do not push a broken build
- Review your own diff before opening a PR — catch obvious issues yourself first
- If a change is larger than ~400 lines of diff, consider splitting it
 
## Pull requests
 
- PR title follows the same conventional commit format as commits
- Description covers: what changed, why, and how to verify it
- Link to the relevant issue or ticket if one exists
- PRs should be reviewable in under 15 minutes — if they're longer, split them
 