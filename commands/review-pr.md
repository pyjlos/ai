Review the pull request at $ARGUMENTS (a GitHub PR URL — this is the only input this command accepts).

## Guard

If $ARGUMENTS is empty, or is not a GitHub PR URL matching `https://github.com/<owner>/<repo>/pull/<number>`, stop immediately and respond with:

"⚠️ `/review-pr` requires a PR URL. Usage:
  /review-pr https://github.com/<owner>/<repo>/pull/<number>

Please re-run with a PR link."

Do not proceed with any review.

## Your job

You are the orchestrator. Locate the repo locally, pull the PR's diff, spawn the core reviewers plus any domain specialists the diff calls for, then collate everything — grouped by severity — into a single review file.

## Step 1 — Parse the PR link

Extract `<owner>`, `<repo>`, and `<number>` from $ARGUMENTS.

## Step 2 — Locate the repo locally

1. Check whether the current working directory's git remote matches `<owner>/<repo>` (`git remote get-url origin`).
2. If not, search likely clone locations (siblings of the current directory, and `~/repos/**`) for a `.git` directory whose `origin` remote matches `<owner>/<repo>`.
3. If no local clone is found, stop and ask the user:

   "⚠️ No local clone of `<owner>/<repo>` found. Clone it with:
     gh repo clone <owner>/<repo>
   or tell me the local path to an existing clone."

   Do not clone it yourself — wait for the user to confirm a path.

## Step 3 — Fetch the PR diff

From inside the located repo:
```
gh pr view <number> --repo <owner>/<repo> --json title,number,baseRefName,headRefName,files
gh pr diff <number> --repo <owner>/<repo>
```
Use the `files` list to scope the reviewers to changed files only — do not review the whole repo.

## Step 3.5 — Create a shared review worktree

Reviewers need the actual checked-out PR code, not just a diff, so they can open files, follow imports, and run tools. Create one worktree and point every spawned agent at it, rather than each agent cloning its own.

1. Let `<repo-root>` be the located repo's top-level directory (`git rev-parse --show-toplevel`) and `<repo-name>` its directory name. The worktree path is `<repo-root>/../<repo-name>-pr-<number>-worktree` (a sibling of the source repo, not nested inside it) — the PR number is part of the path so worktrees for different PRs can never collide or be silently reused for the wrong PR.
2. If that path already exists:
   - If it's a git worktree registered to this repo (`git worktree list` shows it), reuse it — run `git fetch origin` inside it, then explicitly `git checkout pr-<number>` (creating it from the freshly fetched ref with `git checkout -b pr-<number> origin/pr-<number>`, or the equivalent fetched ref, if the local branch doesn't exist yet, matching step 3 below) before moving to step 4. Do not rely on `git fetch origin` alone to leave the worktree on the right branch.
   - If it exists but isn't a registered worktree for this repo, stop and ask the user how to proceed (do not delete it yourself).
3. Otherwise create it:
   ```
   git fetch origin pull/<number>/head:pr-<number>
   git worktree add <repo-root>/../<repo-name>-pr-<number>-worktree pr-<number>
   ```
   If the local branch `pr-<number>` already exists, reuse it; if `git fetch` with that refspec fails, fall back to `gh pr checkout <number> --repo <owner>/<repo>` run inside a worktree created from `headRefName`.
4. Confirm the worktree's `HEAD` matches the PR's `headRefName`/head commit before proceeding. This check is now meaningful either way, since steps 2 and 3 both guarantee the worktree is on the right PR's branch before reaching it.

Pass `<repo-root>/../<repo-name>-pr-<number>-worktree` as the working directory to every reviewer spawned in Step 4 — each agent reviews the real files there, scoped to the `files` list from Step 3, not the whole repo.

## Step 4 — Select reviewers

**Core reviewers — always run, on every PR:**

- **pragmatic-reviewer** agent — complexity, bloat, and over-engineering audit
- **code-reviewer** agent — security and vulnerability audit (injection, auth/authz gaps, secrets, unsafe deserialization, unvalidated input at trust boundaries)

Also apply the **ponytail** skill (`Skill` tool, not `Agent` — it lives under `skills/engineering/ponytail`, there is no `ponytail` agent) yourself as orchestrator for a decision-ladder/shortest-working-diff pass, and fold its findings into the same severity buckets as the spawned agents.

Also apply the **blast-radius** skill (`Skill` tool, not `Agent` — it lives under `skills/engineering/blast-radius`, has `disable-model-invocation: true`, and must be invoked explicitly by name, the same way as `ponytail` above) yourself as orchestrator for a hidden-assumption / implicit-state-machine pass. Feed it the PR diff, the changed-files list, the review worktree path, and the PR title and description fetched in Step 3 (`gh pr view`), so it has the stated intent to check the diff against, not just the raw diff. Fold its findings into the same severity buckets as the spawned agents': a proven, confirmed risk from its own "how sure are you" ladder is Critical or High depending on its real chance/cost per its own "Be honest about each risk" step; an unproven or merely plausible one is Medium or Low. Do not invent a fifth bucket for it.

**Domain specialists — added deterministically by path, based on the `files` list from Step 3:**

| Changed path matches | Add agent |
|---|---|
| `*.tf`, `*.tfvars` | `terraform` |
| `Dockerfile*`, `docker-compose*` | `docker` |
| `**/k8s/**`, `**/manifests/**`, `*.helm`, `Chart.yaml` | `kubernetes` |
| `**/*.proto`, `openapi.yaml`/`.json`, `**/routes/**`, `**/api/**` | `api-designer` |
| `*.tsx`, `*.jsx`, `**/components/**`, `**/pages/**` | `typescript-agent` |
| `*.sql`, `**/migrations/**` | `sql-agent` |
| `**/terraform/**`, `**/cloudformation/**`, AWS SDK imports | `aws-expert` |
| `.github/workflows/**`, `**/ci/**` | `cicd-architect` |

A changed file can match more than one row — add every agent whose row matches at least one changed file. If no row matches anything in the diff, skip this step; the core reviewers are sufficient.

**Judgment pass — for files the table above doesn't cover:**

After applying the table, look at any remaining changed files not matched by any row. If, and only if, one of them clearly falls in another specialist's domain from the agent roster (e.g. a `*.java` file with no row above → `java-agent`), add that agent too. Do not add an agent on a hunch — only when the file content unambiguously belongs to that domain. Record in the review file *why* each judgment-added agent was included (one line, e.g. "added `java-agent`: `BillingService.java` has no matching table row but is pure Java business logic").

Pass every selected agent the review worktree path (from Step 3.5), the PR diff, and the list of changed files, so each agent reviews the real checked-out code but stays scoped to what changed.

## Step 5 — Categorize findings by severity

Merge every spawned agent's findings into one list, bucketed as:

- **Critical** — exploitable security vulnerability, or breaks correctness and will fail in production
- **High** — real bug, risky security-adjacent pattern (e.g. missing auth check, weak crypto), or significant unjustified complexity that should block merge
- **Medium** — bloat/over-engineering worth fixing but not blocking
- **Low** — nitpick, style preference, or minor polish

Drop findings that are pure style opinion with no actionable fix.

## Step 6 — Write the review file

Write a single file to `outputs/<project-name>/reviews/review-pr-<number>-YYYY-MM-DD-HH-MM.md`, where `<project-name>` is `<repo>` from Step 1 (no re-derivation from the working directory's remote):

```markdown
# Code review — PR #<number>: <PR title>
Repo: <owner>/<repo>
Branch: <headRefName> → <baseRefName>
Date: <today>
Reviewed by: <list every agent actually spawned, core + domain + judgment>

## Summary

<2-3 sentence overall verdict. Call out the most important finding.
If everything is clean, say so plainly.>

## Reviewers

<list core reviewers (including ponytail and blast-radius, which always run), then domain specialists added and which path rule triggered each, then any judgment-added agent with its one-line justification. If none were added beyond the core reviewers, say so.>

## Findings by severity

### Critical
<finding: file + line range, what, why, suggested fix — or "None">

### High
<same format, or "None">

### Medium
<same format, or "None">

### Low
<same format, or "None">

## Action items

<Numbered list of Critical + High findings only, in order. If none, write "None — ready to merge.">
```

## Step 7 — Clean up the worktree

After all reviewers have finished and findings are written to the review file, remove the review worktree so it doesn't linger as stale state:
```
git worktree remove <repo-root>/../<repo-name>-pr-<number>-worktree
git worktree prune
```
If the worktree has uncommitted changes (it shouldn't — reviewers should only read), stop and ask the user before removing it.

## Step 8 — Report back

Tell the user:
- The path to the review file (`outputs/<repo>/reviews/review-pr-<number>-YYYY-MM-DD-HH-MM.md`)
- The PR reviewed (`owner/repo#number`)
- Which reviewers ran beyond the core reviewers, and why
- Finding counts per severity (e.g. "Critical: 0, High: 2, Medium: 3, Low: 1")

Do not print the full review to the terminal — it's in the file.
