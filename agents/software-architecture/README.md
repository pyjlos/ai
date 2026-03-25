---
model: claude-sonnet-4-6
---

# Software Architecture Agents

Architecture-focused agent instruction files for system design, API contracts, cloud infrastructure, and framework reviews.

## Available Agents

| File | Role | Focus |
|---|---|---|
| `solution-architect.md` | Principal Solution Architect | System design, trade-off analysis, ADRs, decomposition, migration strategy |
| `api-designer.md` | Senior API Designer | REST, gRPC, GraphQL, OpenAPI, versioning, contract-first design |
| `12factor-architect.md` | Cloud-Native Architect | 12-Factor App methodology, portability, stateless design, dev/prod parity |
| `aws-expert.md` | Senior AWS Architect | AWS service selection, networking, security, cost optimization, IaC |
| `aws-well-architected.md` | Well-Architected Reviewer | Six-pillar reviews, findings classification, remediation planning |
| `distributed-systems-architect.md` | Principal Distributed Systems Architect | Consensus, consistency models, replication, partitioning, distributed transactions, fault tolerance |

## Usage

Reference a file directly in your prompt to load that agent's persona and standards:

```bash
claude --agent software-architecture/solution-architect.md "design a multi-tenant SaaS platform for 10k customers"
claude --agent software-architecture/api-designer.md "review this REST API for versioning and error handling issues"
claude --agent software-architecture/aws-expert.md "design a serverless event pipeline for order processing"
```

Or paste the file contents as a system prompt when building with the API.

## Setting Up Named Agents

To call agents by name (e.g. `solution-architect`) from anywhere in Claude Code, symlink or copy these files into `~/.claude/agents/`:

```bash
mkdir -p ~/.claude/agents

# Symlink all architecture agents
for f in ~/repos/ai/agents/software-architecture/*.md; do
  name=$(basename "$f" .md)
  ln -sf "$f" ~/.claude/agents/"${name}.md"
done
```

This makes them available as subagent types: `solution-architect`, `api-designer`, `12factor-architect`, `aws-expert`, `aws-well-architected`.

Each agent file includes a frontmatter block controlling the model and description:

```markdown
---
name: solution-architect
description: Use for system design, architecture trade-offs, technology selection, and cross-cutting architectural decisions
model: claude-sonnet-4-6
---

You are a Principal Solution Architect...
```

Claude Code reads the `~/.claude/agents/` directory and exposes each file as a named subagent type in the Agent tool and `/agents` dialog.

## Model Default

All agents in this directory default to `claude-sonnet-4-6` (Sonnet 4.6). To override for a specific agent, add a `model` field to that file's frontmatter.

## Agent Pairing

These agents work well together for complex workloads:

```bash
# Full architecture review
claude --agent software-architecture/solution-architect.md  "design the overall system"
claude --agent software-architecture/aws-expert.md          "map the design to AWS services"
claude --agent software-architecture/aws-well-architected.md "review the design against all six pillars"
claude --agent software-architecture/distributed-systems-architect.md "design a multi-region active-active event sourcing system"

# API-first service design
claude --agent software-architecture/api-designer.md        "design the API contract"
claude --agent software-architecture/12factor-architect.md  "validate the service design against 12-factor"
```
