Review the code changes in $ARGUMENTS (a file path, directory, or git diff range).

## Guard

If $ARGUMENTS is empty or was not provided, stop immediately and respond with:

"⚠️ `/review-pr` requires a target. Usage:
  /review-pr <branch>         e.g. /review-pr feature/auth
  /review-pr <file>           e.g. /review-pr src/api/users.py
  /review-pr <git range>      e.g. /review-pr main..HEAD

Please re-run with a target."

Do not proceed with any review. Do not default to main..HEAD.

## Your job

You are the orchestrator. Spawn the three specialist reviewers below IN PARALLEL, then collate their output into a single review file.

## Step 1 — Gather the diff

If $ARGUMENTS is a file or directory, read those files directly.
If $ARGUMENTS looks like a git range (e.g. `main..HEAD` or a branch name), run:
```
git diff $ARGUMENTS
```
to get the changed files and lines. Pass the relevant file paths to each agent.

## Step 2 — Spawn reviewers in parallel

Launch all three agents simultaneously against the same target:

- **pragmatic-reviewer** — complexity and bloat audit
- **code-reviewer** — vulnerability, bug, and security exposure audit  
- **test-engineer** — coverage and test quality audit

Pass each agent the list of changed files so they focus only on what changed, not the entire codebase.

## Step 3 — Collate results

Once all three agents return, write a single file to `outputs/reviews/review-YYYY-MM-DD-HH-MM.md` with this structure:

---

```markdown
# Code review — <branch or file name>
Date: <today>
Reviewed by: pragmatic-reviewer, code-reviewer, test-engineer

## Summary

<2–3 sentence overall verdict. Call out the most important finding across all three reviews.
If everything is clean, say so plainly.>

## Overall verdicts

| Reviewer         | Verdict |
|------------------|---------|
| Pragmatic        | <lean / minor bloat / significant bloat / over-engineered> |
| Code review      | <clean / low / medium / high risk> |
| Tests            | <well tested / gaps present / significant gaps / untested> |

---

<paste the full ## Pragmatic review section from pragmatic-reviewer>

---

<paste the full ## Code review section from code-reviewer>

---

<paste the full ## Test review section from test-engineer>

---

## Action items

<Numbered list of concrete things to fix before merging, ordered by severity.
Pull only items that are actual blockers or high value — ignore nitpicks.
If nothing needs fixing, write "None — ready to merge.">
```

---

## Step 4 — Report back

Tell the user:
- The path to the review file
- The three verdicts in one line
- How many action items were found

Do not print the full review to the terminal — it's in the file.