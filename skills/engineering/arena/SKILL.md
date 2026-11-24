---
name: arena
description: "Spawn N parallel candidates at the same task, pick the strongest as a base, then graft the best pieces of the losers into it. Use for \"arena this\", \"throw it in the arena\", or when one attempt at a non-trivial artifact risks locking in the wrong shape."
disable-model-invocation: true
metadata:
  credits:
    skill: arena
    author: Lauren Tan
    organisation: Cursor (pstack plugin)
    url: "https://github.com/cursor/plugins/blob/main/pstack/skills/arena/SKILL.md"
---

# Arena

Open a todolist with one entry per phase (Frame, Fan out, Cross-judge, Pick, Graft, Verify) before launching anything.

## Phase A: Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive a rubric: 3-6 concrete, gradeable criteria for what success looks like on *this* task. It's the picker's tool in Phase D. Candidates only see the task, never the rubric.
3. Pick N runners, each a separate Agent call. Vary the agent type or model where this repo's tooling allows it (different `subagent_type` values, or a `model` override on the Agent tool); when only one model is available, repeat it and rely on independent framing to produce divergence, and say so in the output. Spawn more runners only for multiple genuinely different design directions — don't pad the arena past that.
4. Give each candidate its own output location — a git worktree where one is available, otherwise its own scratch directory — so writes never collide.

## Phase B: Fan out

Spawn all N candidates in one message so they run concurrently, each with the task, the shared grounding (not the rubric itself, so candidates don't game it), its own output path, and instructions to produce the artifact plus a short rationale naming the alternatives it considered and rejected.

If a candidate produces no output, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

After every Phase B candidate completes, spawn one independent read-only reviewer — a fresh agent with no memory of Phase A or B — to score each candidate, by path label, against the rubric and recommend a base. Prefer a reviewer built on a different model or agent type than most of the runners, to avoid correlated blind spots; say so when that isn't possible.

## Phase D: Pick a base

Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare against the cross-judge's recommendation. Agreement confirms the pick; disagreement means either the rubric was ambiguous or one read is biased — read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants. When two are tied, prefer the cleaner boundary or the smaller API.

## Phase E: Graft

Walk each losing candidate once more for what's worth porting into the base — usually one or two things per candidate, not most of it. Fold each graft in by hand so the result stays coherent under one mental model; don't paste mechanically.

If the candidates converge on one shape, that's a strong signal: note it and ship the consensus shape, no graft needed. If they wildly diverge, Phase A was under-specified — reframe and re-run rather than averaging the divergence.

## Phase F: Verify

Verify the synthesized artifact against the real thing, not the rubric on paper — run the feature, read the actual value, inspect the diff (see `rules/testing.md`'s Verification section). If verification finds a problem the arena missed, either Phase A was wrong (reframe and re-run) or a candidate caught it and the graft missed it (back to Phase E). Don't paper over it.

## Output

One synthesized artifact, with a short synthesis note alongside it naming: the base and why, the cross-judge's verdict (or that Phase C was skipped and why), each graft with its source candidate, what was rejected and why, any convergence or dropouts, and the verification result.
