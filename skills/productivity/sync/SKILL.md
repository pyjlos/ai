---
name: sync
description: Scan GitHub (via gh CLI, respecting GH_TOKEN/GITHUB_TOKEN/GH_HOST) for PRs across all accessible repos that need the user's attention — reviews requested of them, their own PRs awaiting review or with changes requested, failing CI, and approved-but-unmerged PRs. Use when the user asks "what PRs need my attention", "what do I need to review", "status of my PRs", invokes /sync, or asks for a GitHub review inbox check.
---

# PR Triage

Cross-repo PR inbox check using `gh search prs`, which queries GitHub globally (not just the current repo's remote) — this works from any directory.

## Step 1 — Verify auth

```
gh auth status
```

If that fails, check for `GH_TOKEN` or `GITHUB_TOKEN` in the environment (`gh` honors these automatically — no need to pass them explicitly). If neither auth method works, stop and tell the user to run `gh auth login` or export `GH_TOKEN`. If they use GitHub Enterprise, `GH_HOST` must also be set.

Get the username once, reuse it in every query below:

```
ME=$(gh api user --jq .login)
```

## Step 2 — Run the queries

Run each in parallel (independent `gh` calls). Use `--json` + `-q` to keep output compact:

```
JQ='.[] | "- [\(.repository.nameWithOwner)#\(.number)] \(.title) — \(.url) (updated \(.updatedAt | sub("T.*";"")))"'

# 1. Needs your review right now
gh search prs --review-requested=@me --state=open --json repository,number,title,url,updatedAt -q "$JQ"

# 2. Your open PRs with no reviews yet
gh search prs --author=@me --state=open --review=none --json repository,number,title,url,updatedAt -q "$JQ"

# 3. Your open PRs with changes requested — action needed from you
gh search prs --author=@me --state=open --review=changes_requested --json repository,number,title,url,updatedAt -q "$JQ"

# 4. Your open PRs approved and likely mergeable
gh search prs --author=@me --state=open --review=approved --json repository,number,title,url,updatedAt -q "$JQ"

# 5. Your open PRs with failing CI
gh search prs --author=@me --state=open --checks=failure --json repository,number,title,url,updatedAt -q "$JQ"

# 6. PRs where you're assigned (not just review-requested)
gh search prs --assignee=@me --state=open --json repository,number,title,url,updatedAt -q "$JQ"
```

Skip the `--draft` PRs in bucket 1 and 2 by adding `--draft=false` if the user says they don't want draft noise — otherwise include drafts, since review-requested-on-draft usually still means "take a look."

## Step 3 — Report

Present directly in chat (this is a live status check, not a file to persist — no handoff needed). Group under exactly these headers, omitting any bucket that is empty, and say "none" explicitly rather than hiding an empty bucket if the user is scanning for all-clear:

```
## Needs your review
<bucket 1>

## Your PRs — no reviewers yet
<bucket 2>

## Your PRs — changes requested
<bucket 3>

## Your PRs — approved, ready to merge
<bucket 4>

## Your PRs — CI failing
<bucket 5>

## Assigned to you
<bucket 6>
```

Keep each line to the one-liner format from `$JQ` — no extra commentary unless a PR is stale (updated >14 days ago), in which case flag it inline with "(stale)".
