# Git
 
## Commits
 
- Commit messages use conventional commits format: `type(scope): short description`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`
  - Example: `fix(auth): handle expired token on refresh`
- Subject line is imperative mood, 72 chars max — "add feature" not "added feature"
- Commit one logical change at a time — don't bundle unrelated fixes
- Stage only the files that belong to the change being made — never `git add -A` or `git add .` as a shortcut. Review `git status` before committing and exclude unrelated modified or untracked files
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
- Any comment posted on a PR or issue (via `gh pr comment`, `gh issue comment`, review comments, etc.) must end with a line reading `Generated with Claude` so readers can tell it was authored by an agent

## Worktrees

- Use `git worktree add <path> <branch>` to work on multiple branches simultaneously without stashing
- Name worktree paths clearly: `../project-feat-foo`, `../project-fix-bar` — keep them adjacent to the main clone
- Remove worktrees when done: `git worktree remove <path>` then `git worktree prune`
- Never share a worktree path between two active branches — each worktree is locked to one branch
- Do not commit from a worktree to the branch that is checked out in the main clone simultaneously

## Rebasing

- Before rebasing, **ask the user which branch to rebase from** — projects vary (`main`, `master`, `develop`, `trunk`)
- Prefer rebase over merge for keeping feature branches up to date: `git rebase <base-branch>`
- Always rebase from the latest remote: `git fetch origin && git rebase origin/<base-branch>`
- Interactive rebase (`git rebase -i`) to clean up commits before opening a PR — squash fixups, reword unclear messages
- Never rebase a branch that others are working from — rebase only private/unshared branches
- After a forced push following rebase, notify anyone who had the old branch checked out

## Conflict resolution

- Resolve conflicts at the rebase step, not in a merge commit — keeps history linear
- For each conflicted file: understand both sides before choosing — do not blindly accept "ours" or "theirs"
- After resolving, `git add <file>` then `git rebase --continue` — never `git commit` mid-rebase
- If a conflict is unclear or the two sides represent different intentions, **stop and ask** before resolving
- Run lint + typecheck + affected tests after resolving all conflicts — resolution can silently break logic
- If a rebase goes wrong: `git rebase --abort` resets to the pre-rebase state cleanly — use it freely
