---
name: review-community-sources
description: "Check the tracked community/open-source agent-config repos in skills/community-sources.md for what's new since last review, and propose concrete candidates to adopt. Never applies changes automatically. Use for \"check for new skills to adopt\", \"review community sources\", or a periodic upstream-scan request."
disable-model-invocation: true
---

# Review community sources

Read `skills/community-sources.md`. For each entry:

1. Fetch the repo's current state (clone or `git fetch` a shallow copy, or browse via the forge) and diff it against the recorded last-reviewed ref — `git diff <last-ref>..<current-ref> -- <tracked-path>` for a local clone, or the forge's compare view.
2. Read what's new or changed in that diff: added, removed, or substantially rewritten skills/rules/agents/commands under the path this repo draws from.
3. Compare each new or changed item against what this repo already has (`skills/`, `rules/`, `agents/`, `commands/`). Skip anything this repo already ported or that duplicates an existing capability.
4. For everything left, write one candidate: name, source path, and a one-line rationale for why it's worth adopting (what gap it fills, not a restatement of its description).

## Output

A proposal list, grouped by source repo, each candidate as:

- `<name>` (`<source path>`) — `<one-line rationale>`

This is a proposal for a human or firstmate to decide on. Never copy files, never open a PR, never merge — this skill only reports.

## After a review pass

For each repo actually reviewed (diffed against its prior ref, not skipped), update its entry in `skills/community-sources.md`: set "Last reviewed" to the ref you diffed against and today's date. Leave unreviewed entries untouched.
