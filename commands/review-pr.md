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

## Step 4 — Select reviewers

**Core reviewers — always run, on every PR:**

- **pragmatic-reviewer** — complexity, bloat, and over-engineering audit
- **ponytail** — decision ladder enforcement; shortest working diff audit
- **code-reviewer** — security and vulnerability audit (injection, auth/authz gaps, secrets, unsafe deserialization, unvalidated input at trust boundaries)

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

A changed file can match more than one row — add every agent whose row matches at least one changed file. If no row matches anything in the diff, skip this step; the core three are sufficient.

**Judgment pass — for files the table above doesn't cover:**

After applying the table, look at any remaining changed files not matched by any row. If, and only if, one of them clearly falls in another specialist's domain from the agent roster (e.g. a `*.java` file with no row above → `java-agent`), add that agent too. Do not add an agent on a hunch — only when the file content unambiguously belongs to that domain. Record in the review file *why* each judgment-added agent was included (one line, e.g. "added `java-agent`: `BillingService.java` has no matching table row but is pure Java business logic").

Pass every selected agent the PR diff and the list of changed files so they focus only on what changed.

## Step 5 — Categorize findings by severity

Merge every spawned agent's findings into one list, bucketed as:

- **Critical** — exploitable security vulnerability, or breaks correctness and will fail in production
- **High** — real bug, risky security-adjacent pattern (e.g. missing auth check, weak crypto), or significant unjustified complexity that should block merge
- **Medium** — bloat/over-engineering worth fixing but not blocking
- **Low** — nitpick, style preference, or minor polish

Drop findings that are pure style opinion with no actionable fix.

## Step 6 — Write the review file

Write a single file to `outputs/reviews/review-pr-<number>-YYYY-MM-DD-HH-MM.md`:

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

<list core reviewers, then domain specialists added and which path rule triggered each, then any judgment-added agent with its one-line justification. If none were added beyond the core three, say so.>

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

## Step 7 — Report back

Tell the user:
- The path to the review file
- The PR reviewed (`owner/repo#number`)
- Which reviewers ran beyond the core three, and why
- Finding counts per severity (e.g. "Critical: 0, High: 2, Medium: 3, Low: 1")

Do not print the full review to the terminal — it's in the file.
