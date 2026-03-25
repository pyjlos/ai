---
name: agent-improver
description: Analyzes session transcripts or notes to propose versioned updates to agent definition files (.md). Use this skill whenever the user wants to improve, tune, or evolve an existing agent based on real usage — including phrases like "update my agent", "refine based on sessions", "my agent keeps missing X", "what should I change in my agent file", or "I've been using this agent for a while and want to improve it". Also trigger when the user pastes an agent file alongside feedback, friction points, or session notes.
---

# Skill: Agent Improver

A skill for evolving agent definition files based on real usage sessions — turning friction, wins, and patterns into versioned spec updates.

## Overview

Agent files are living specs. After using an agent for days or weeks, you accumulate signal: things it consistently gets wrong, instructions that never trigger, assumptions that don't match reality. This skill closes the loop — it takes your session signal and produces a precise, reasoned diff to your agent file.

The output is never a full rewrite. It's a **targeted diff with a changelog entry** — surgical updates that reflect what actually happened in sessions.

---

## Inputs Required

To run this skill, you need at least:

1. **Current agent file** — the full markdown (paste it or reference the file)
2. **Session signal** — one or more of:
   - Raw session transcripts (paste or upload)
   - Bullet-point friction log ("it kept doing X when I wanted Y")
   - A mix of both

Optional but helpful:
- Notes on what worked well (to preserve and reinforce)
- Any manual corrections you made mid-session

---

## The Process

### Step 1 — Extract Signal

Read all session material and extract:

**Friction patterns** — recurring misses, wrong assumptions, over/under-verbose responses, wrong model tier suggestions, off-persona behavior

**Win patterns** — behaviors that worked well and should be preserved or made more explicit

**Missing behaviors** — things you needed that the agent didn't do

**Dead instructions** — guidelines in the current spec that never seemed to trigger or help

For each pattern, note:
- How many times it appeared (frequency = priority)
- Whether it's a prompt wording issue or a spec gap
- Whether it's a quick fix (add/remove a line) or a structural change

---

### Step 2 — Audit the Current Spec

Read the agent file with the extracted patterns in mind. For each section, ask:

- Does this instruction match how the agent actually behaved?
- Is this guideline too vague to be actionable?
- Is there a section missing that would have prevented a friction pattern?
- Are there contradictions between sections?
- Is anything over-specified for how the agent is actually used?

---

### Step 3 — Produce the Diff

Output a structured diff with three parts:

#### Part A: Proposed Changes
For each change, include:
```
SECTION: [which section of the agent file]
CHANGE TYPE: [add | remove | modify | reorder]
BEFORE: [current text, or "n/a" for additions]
AFTER: [proposed text]
REASON: [what session pattern drove this change]
PRIORITY: [high | medium | low]
```

Only include changes with clear session evidence. Do not refactor for aesthetics.

#### Part B: Preserved Wins
List behaviors that worked well and should stay exactly as-is. Explicitly name them so they aren't accidentally edited out.

#### Part C: Changelog Entry
A single changelog line to append to the agent file:
```
<!-- v1.x — [date] — [1-sentence summary of what changed and why] -->
```

---

### Step 4 — Confirm Before Applying

Present the diff to the user before making any changes. Ask:
- Do any of these changes feel wrong or overcorrect?
- Are there any wins you want to add that weren't captured?
- Confirm priority order if multiple high-priority changes exist

Only produce the updated agent file after confirmation.

---

### Step 5 — Output the Updated Agent File

Produce the full updated agent file with:
- All confirmed changes applied
- Changelog entry appended at the bottom
- Version comment in the frontmatter or as a comment at the top

Format it identically to the input — same structure, same heading levels, same style.

---

## Output Format

```markdown
---
name: [agent-name]
description: [unchanged or updated if description was a friction source]
---

[full updated agent body]

<!-- Changelog -->
<!-- v1.0 — original -->
<!-- v1.1 — [date] — [what changed and why] -->
```

---

## Guidelines

- **Minimal diffs only** — change what session evidence supports, nothing else
- **Preserve voice** — don't rewrite the agent's tone or style unless it was a friction source
- **Frequency = priority** — a pattern that appeared once is low priority; five times is high
- **Don't over-engineer** — if a one-line fix solves a pattern, use one line
- **Flag structural issues separately** — if a session reveals a deep spec problem, flag it as a separate conversation rather than trying to solve it in a diff
- **Changelog is mandatory** — every update needs a changelog entry, no exceptions

---

## Example Invocation

```
I've been using my ai-architect agent for a week. Here's my agent file and some notes on what frustrated me:

[agent file]

Friction log:
- It kept recommending Opus for simple summarization tasks even though I said to default to Haiku
- Every response started with a bullet list even when I asked a quick question
- It never flagged caching opportunities unless I specifically asked
- The "spec-driven" section was great, used it constantly

Run the agent-improver skill and propose updates.
```

---

## Minimum Viable Version (no transcripts)

If you don't have transcripts, bullet points are enough:

```
Here's my agent file and 3 things that frustrated me this week:
1. [friction point]
2. [friction point]  
3. [friction point]

What changes would fix these?
```

The skill will produce a targeted diff based on the friction points alone, without requiring full transcripts.