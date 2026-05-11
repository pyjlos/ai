---
name: adr-research
description: >
  Deep research skill for system design decisions and Architecture Decision Records (ADRs).
  Use this skill whenever the user is exploring a technology choice, comparing architectural
  options, investigating an unfamiliar tool or pattern, or preparing to write an ADR.
  Trigger on phrases like: "research X for our stack", "comparing X vs Y", "what do I need
  to know about X", "help me write an ADR", "trade-offs of X", "is X a good fit for...",
  "what's the community consensus on X", "evaluate X for our use case", or any system design
  question where the answer is non-obvious or the technology is niche/emerging. Also trigger
  when the user mentions unfamiliar libraries, patterns, databases, messaging systems, or
  infrastructure tools — especially ones that lack broad documentation.
---

# ADR Research Skill

You are helping the user make an informed architectural decision. Your job is to research thoroughly, surface trade-offs honestly, and produce output that feeds directly into an ADR or design discussion.

## When NOT to use

- The decision is already made and the user just wants implementation — go straight to `solution-architect` or the relevant language agent.
- The choice is well-known and reversible (e.g., picking a JSON library) — don't burn research budget on low-stakes decisions.
- The user is stress-testing a plan against *internal* documentation rather than external sources — use `grill-with-docs` instead.

## Related skills

- `grill-with-docs` — internal-facing companion: sharpens a plan against project CONTEXT.md and existing ADRs.
- `solution-architect` (agent) — consumes the research output to make a final recommendation.
- `to-issue` — once an ADR is accepted, break the implementation into vertical slices.

---

## Step 1: Detect the Mode

Before researching, identify which mode applies (it may be a mix):

| Mode | Signal phrases | Primary goal |
|---|---|---|
| **Compare** | "X vs Y", "which is better for...", "should we use X or Y" | Structured comparison of 2–4 options |
| **Deep Dive** | "what do I need to know about X", "tell me about X", "evaluate X" | Full profile of one technology/pattern |
| **Pattern Exploration** | "what are the approaches to X problem", "how do people solve X", "common patterns for X" | Map the solution space before options are named |

If unclear, ask one question: *"Are you already considering specific options, or still mapping the solution space?"*

---

## Step 2: Clarify Decision Context (briefly)

Before researching, quickly surface constraints that change what matters:

- **Scale**: expected load, data volume, team size
- **Stack**: existing technologies, language ecosystem
- **Constraints**: compliance, on-prem vs cloud, budget, operational maturity
- **Timeline**: greenfield vs migration, how reversible does this need to be?

Don't over-interview. If context is already in the conversation, extract it and proceed.

---

## Step 3: Research Protocol

### Source Strategy (by priority)

**For well-known technologies:**
- Official docs (architecture/operations sections, not just quickstart)
- GitHub: issues labeled `bug`, `performance`, `scalability` — these surface real failure modes
- GitHub: PR history and changelog — signals maintenance health
- HackerNews: search `site:news.ycombinator.com <technology>` for candid practitioner opinions
- Reddit: r/devops, r/softwarearchitecture, r/dataengineering, r/kubernetes, etc.

**For obscure/emerging technologies (primary concern of this skill):**
- GitHub star trajectory + recent commit frequency (is it alive?)
- Issues: look for unanswered questions — signals community maturity
- Conference talks: search `<technology> site:youtube.com` + year filter for recency
- CNCF landscape, ThoughtWorks Technology Radar, State of DB survey, Stack Overflow survey
- Academic papers if relevant (arXiv, VLDB, OSDI proceedings)
- Company engineering blogs (Uber, Netflix, Stripe, Cloudflare, Discord, Shopify tech blogs)
- The README's "who uses this in production" section

**For patterns (not specific tools):**
- Martin Fowler's catalog (martinfowler.com/articles)
- Microsoft Azure Architecture Center, AWS Well-Architected
- High Scalability blog (highscalability.com)
- InfoQ architecture articles

### What to Look For

Always extract these signals, regardless of mode:

1. **Known failure modes** — what breaks at scale, under load, with inexperienced operators
2. **Operational complexity** — how hard is it to run day 2, day 30, day 365
3. **Community health** — contributors, response time on issues, commercial backing
4. **Migration path** — how do you get out if this turns out to be wrong
5. **Lock-in surface** — proprietary APIs, data formats, vendor dependency
6. **Adoption signal** — who uses this in production, at what scale
7. **Maturity cliff** — things that work in demos but fail in production

---

## Step 4: Output Format

Adapt output to the mode detected:

---

### Mode: Compare

```
## [Option A] vs [Option B] (vs [Option C])

### Decision Context
[constraints extracted from conversation]

### At a Glance
| Dimension | Option A | Option B |
|---|---|---|
| Maturity | | |
| Operational complexity | | |
| Performance ceiling | | |
| Community/support | | |
| Lock-in risk | | |
| Migration cost | | |

### Option A — [name]
**Strengths**: ...
**Weaknesses / Known failure modes**: ...
**Best fit when**: ...
**Watch out for**: ...

### Option B — [name]
[same structure]

### Recommendation
[If a clear winner exists given the context, state it and why. If genuinely context-dependent, say so and give the tie-breaking question.]

### Gaps / What I Couldn't Find
[Be explicit about what's unclear, underdocumented, or missing from the research]
```

---

### Mode: Deep Dive

```
## [Technology/Pattern] — Research Summary

### What It Is
[2–3 sentences. What problem it solves, what category it belongs to]

### How It Actually Works
[Not the happy path — focus on the internals that affect architectural decisions: consistency model, failure handling, replication, persistence, etc.]

### Operational Reality
[What running this looks like after day 1: monitoring, failure recovery, upgrades, scaling]

### Known Failure Modes
[Bulleted. Sourced where possible]

### Community & Maturity
[Age, who maintains it, commercial backing, adoption, GitHub health]

### When to Use / When Not To
[Be opinionated based on the research]

### Lock-in & Exit Path
[What migration looks like if you need to leave]

### Gaps / What I Couldn't Find
```

---

### Mode: Pattern Exploration

```
## Approaches to [Problem]

### Problem Framing
[Restate what's actually being solved, including constraints]

### Option Map
[3–5 approaches, not specific tools yet]

| Approach | Trade-off summary | Best when |
|---|---|---|
| | | |

### Approach 1: [name]
[How it works, pros, cons, representative tools]

### Approach 2: [name]
[...]

### Narrowing the Field
[Given the context provided, which 1–2 approaches are worth deeper evaluation? Why?]

### Next Step
[Suggest whether to go into Compare mode or Deep Dive mode next]
```

---

## Step 5: ADR Output (if requested)

If the user wants to produce an ADR, use this template after the research is complete:

```markdown
# ADR-[number]: [Short decision title]

**Date**: [date]
**Status**: Proposed | Accepted | Deprecated | Superseded

## Context
[What is the situation that requires a decision? Include constraints.]

## Decision Drivers
- [key factor 1]
- [key factor 2]

## Options Considered
- [Option A]
- [Option B]

## Decision
[What was decided and the primary reason]

## Trade-offs
**Pros**:
- ...

**Cons / Accepted risks**:
- ...

## Consequences
[What changes as a result. What becomes easier, what becomes harder. What to watch for.]

## References
[Links to research, docs, discussions that informed this]
```

---

## File Output

After completing any research or ADR output, always save the result to a `.md` file and present it for download.

**Naming convention**: `YYYY-MM-DD-research-<topic-slug>.md`
- Use today's date
- Slugify the topic: lowercase, hyphens, no special characters
- Examples: `2026-05-11-research-kafka-vs-pulsar.md`, `2026-05-11-research-event-sourcing-patterns.md`

**Save location**: `research/`

**File contents**: the full research output exactly as it appears in the conversation — mode header, tables, sections, and gaps. If an ADR was also produced, append it to the same file under a `---` divider.

After saving, tell the user the path to the saved file.

---

## Honesty Standards

- **Flag thin sources**: if a technology has limited production case studies, say so explicitly
- **Separate facts from opinions**: attribute opinionated claims ("practitioners report...", "the GitHub issues suggest...")
- **Don't force a recommendation**: if context is insufficient, say what additional information would resolve the decision
- **Recency matters**: prefer sources from the last 18 months for fast-moving technologies; note when information might be outdated