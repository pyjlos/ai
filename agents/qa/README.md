---
model: claude-sonnet-4-6
---

# QA Agents

Quality assurance agent instruction files for code review, test engineering, test strategy, debugging, and chaos/resilience engineering.

## Available Agents

| File | Role | Focus |
|---|---|---|
| `code-reviewer.md` | Senior Staff Engineer | PR review, bug detection, security vulnerabilities, correctness, performance anti-patterns |
| `test-engineer.md` | Senior Test Engineer | Unit/integration test authoring, fixtures, mocks, fakes, coverage gaps across Python/TypeScript/Go |
| `test-automation-strategist.md` | Principal Test Strategist | Test pyramid design, E2E framework selection, CI pipeline structure, flaky test elimination, test strategy documents |
| `debugger.md` | Senior Debugging Engineer | Root cause analysis, stack trace reading, race conditions, memory leaks, production log analysis, 5 Whys |
| `chaos-engineer.md` | Senior Chaos/SRE Engineer | Failure mode analysis, fault injection, game day design, Toxiproxy/AWS FIS/Litmus, resilience checklists |

## Usage

```bash
# Review a pull request
claude --agent qa/code-reviewer.md "review this PR for correctness and security issues"

# Write tests for a module
claude --agent qa/test-engineer.md "write unit and integration tests for the OrderService class"

# Design a test strategy
claude --agent qa/test-automation-strategist.md "design a test strategy for the new checkout flow"

# Debug a production error
claude --agent qa/debugger.md "here's a stack trace and some logs — find the root cause"

# Design a chaos experiment
claude --agent qa/chaos-engineer.md "design a game day for our payment service failover"
```

## Setting Up Named Agents

```bash
mkdir -p ~/.claude/agents

for f in ~/repos/ai/agents/qa/*.md; do
  name=$(basename "$f" .md)
  ln -sf "$f" ~/.claude/agents/"${name}.md"
done
```

Makes available: `code-reviewer`, `test-engineer`, `test-automation-strategist`, `debugger`, `chaos-engineer`.

## Model Default

All agents default to `claude-sonnet-4-6`. The `debugger` and `chaos-engineer` agents benefit from `claude-opus-4-6` for complex multi-system analysis — override by editing the frontmatter `model` field.

## Agent Pairing

```bash
# Full QA workflow for a new feature
claude --agent qa/test-automation-strategist.md  "design the test strategy"
claude --agent qa/test-engineer.md               "implement the unit and integration tests"
claude --agent qa/code-reviewer.md               "review the implementation before merge"

# Reliability hardening
claude --agent qa/chaos-engineer.md   "identify failure modes and design experiments"
claude --agent qa/debugger.md         "analyze the incident logs from last week's outage"

# After a production incident
claude --agent qa/debugger.md                    "root cause analysis on this incident"
claude --agent qa/test-engineer.md               "write regression tests so this can't happen again"
claude --agent qa/chaos-engineer.md              "design an experiment to verify the fix holds under failure"
```
