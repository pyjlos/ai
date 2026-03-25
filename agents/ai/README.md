---
model: claude-sonnet-4-6
---

# AI Agents

Agent instruction files for AI system design, prompt engineering, LLM architecture, and Claude Code configuration.

## Available Agents

| File | Role | Focus |
|---|---|---|
| `ai-architect.md` | Principal AI Architect | Prompt engineering, model selection, multi-agent design, RAG, evals, safety, and the full Claude Code config surface (CLAUDE.md, settings.json, agents, hooks, skills, MCP) |

## Usage

```bash
# Learn AI best practices
claude --agent ai/ai-architect.md "what's the right pattern for building a RAG system over our internal docs?"

# Update Claude Code config
claude --agent ai/ai-architect.md "review my settings.json and suggest improvements for the senior-engineer agent permissions"

# Design an LLM system
claude --agent ai/ai-architect.md "design an eval framework for our customer support classifier"

# Model selection advice
claude --agent ai/ai-architect.md "we're classifying 100k support tickets/day — what model and caching strategy minimizes cost?"

# Improve an agent file
claude --agent ai/ai-architect.md "here's my terraform agent and some friction notes — propose updates"
```

## Setting Up as a Named Agent

```bash
mkdir -p ~/.claude/agents
ln -sf ~/repos/ai/agents/ai/ai-architect.md ~/.claude/agents/ai-architect.md
```

Then invoke directly:

```bash
claude "ai-architect — review my CLAUDE.md and identify instructions that are ambiguous or untestable"
```

## Model Default

`claude-sonnet-4-6`. For complex architectural questions or deep configuration reviews, the agent may suggest switching to `claude-opus-4-6` for extended thinking.

## What This Agent Covers

**Claude Code configuration**
- CLAUDE.md authoring (global vs project, structure, testable rules)
- `settings.json` (permissions, agent scoping, safety blocklists)
- Agent file design (`~/.claude/agents/`)
- Hooks (PreToolUse, PostToolUse, Stop) and when to use each
- Skills (`~/.claude/skills/`) authoring and invocation
- MCP server selection and setup
- Memory system (`~/.claude/projects/*/memory/`)

**Prompt engineering**
- System prompt structure (role, context, constraints, format, tone)
- Structured output via JSON or tool use
- Few-shot examples
- Context window management and token budgeting
- Prompt caching

**LLM system design**
- Model selection (Opus 4.6 / Sonnet 4.6 / Haiku 4.5)
- Cost optimization (caching, batching, routing)
- Extended thinking
- Multi-agent orchestration patterns
- Tool use design
- RAG architecture (chunking, hybrid search, context assembly)

**Evaluations**
- Eval framework design
- LLM-as-judge patterns
- Dataset curation
- CI/CD integration for evals

**Safety**
- Input validation and prompt injection defense
- Output validation
- PII handling
- Guardrail design

**AI toolchain strategy**
- Claude Code vs GitHub Copilot vs Amazon Q Developer — when to use each
- Multi-tool workflows
