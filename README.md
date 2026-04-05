# AI Config

Agents, commands, rules, and skills for Claude Code (and optionally GitHub Copilot / Amazon Q).

Install once, available in every project.

---

## Repo structure

```
agents/          Specialist agent personas (22 agents across 5 categories)
  ai/            AI architecture, prompt engineering, Claude Code config
  devops/        Docker, Kubernetes, CI/CD, Terraform, observability
  qa/            Code review, testing, debugging, chaos engineering
  software-architecture/  System design, API design, AWS, distributed systems
  software-development/   Python, Go, TypeScript, Java, SQL, Bash

commands/        Slash commands — multi-step workflows you invoke with /command-name
  /pipeline      Plan → Execute → QA → Code Review pipeline
  /handoff       End a session cleanly, produce a resume artifact
  /resume        Pick up where you left off in a new session
  /review-pr     Parallel code review (pragmatic + security + test coverage)

rules/           Behavioral constraints loaded into every Claude session
  workflow.md    Research → Plan → Execute → Review (mandatory phases)
  pragmatic.md   Write the simplest code that works
  security.md    Hardcoded secrets, injection, auth — non-negotiable
  testing.md     Test behaviour not implementation
  git.md         Conventional commits, branch naming, PR hygiene
  continuity.md  Handoff and resume protocol

scripts/
  install.sh     Installer — copies everything into your tool's config directory

skills/          Reusable skill definitions (invocable via the skills system)
templates/       Starter templates (CLAUDE.md, outputs structure, tasks)
```

---

## Install

Run the installer once. It copies agents, commands, rules, and skills into the right config directory for your tool.

```bash
bash scripts/install.sh
```

Interactive — it will ask which tool and where to install. Or non-interactive:

```bash
bash scripts/install.sh --tool claude          # ~/.claude/
bash scripts/install.sh --tool copilot         # ~/.copilot/
bash scripts/install.sh --tool kiro            # ~/.kiro/
```

**What it does for Claude Code:**

| What | Where |
|---|---|
| Agents | `~/.claude/agents/<name>.md` |
| Commands | `~/.claude/commands/<name>.md` |
| Rules | `~/.claude/rules/<name>.md` + imports added to `~/.claude/CLAUDE.md` |
| Skills | `~/.claude/skills/<name>/SKILL.md` |

Rules are automatically imported into `~/.claude/CLAUDE.md` so Claude loads them at the start of every session. The installer is idempotent — safe to re-run after adding or updating files.

---

## How to use

### Agents

Agents are specialist personas. Invoke them when you want Claude to reason from a specific domain perspective.

In Claude Code chat:

```
use the solution-architect agent to design a multi-tenant SaaS platform
use the code-reviewer agent to review src/api/users.py
use the python-agent to refactor this service for type safety
```

For parallel tasks — Claude can spawn multiple agents simultaneously:

```
use the docker agent and kubernetes agent together to containerize and deploy this service
```

See `agents/README.md` for the full catalog and prompting tips.

---

### Commands

Commands are multi-step workflows. Invoke them with `/command-name`.

**`/review-pr <target>`** — parallel code review across three lenses

```
/review-pr main..HEAD
/review-pr src/api/payments.py
/review-pr feature/auth
```

Spawns pragmatic-reviewer, code-reviewer, and test-engineer in parallel. Writes a report to `outputs/reviews/`.

**`/pipeline <task description>`** — full plan → execute → QA → review pipeline

```
/pipeline "add rate limiting to the orders API"
/pipeline "build analytics dashboard with chart components"
/pipeline "migrate user auth from sessions to JWT"
```

Each stage writes an artifact. Subsequent agents read from disk, not conversation history — so any stage can be re-run independently if it fails. Artifacts land in `outputs/pipeline/<task-slug>/`.

**`/handoff`** — end a session cleanly

Run this before closing Claude. Produces a handoff file in `outputs/handoffs/` capturing current phase, decisions made, what's done, what's next, and current test/lint state.

**`/resume [path]`** — pick up in a new session

```
/resume
/resume outputs/handoffs/handoff-2026-04-04-17-30.md
```

Reads the latest handoff (or the one you specify), verifies current code state matches, then continues from the exact next action — no re-explaining needed.

---

## The pipeline workflow in practice

The pipeline command is the main workflow for any task larger than a quick fix.

**Example: building a dashboard**

```
/pipeline "build analytics dashboard with chart components and API integration"
```

1. **solution-architect** reads the codebase and writes a plan — specific files, components, and changes. If there are open questions, it stops and asks before anything is built.

2. **executor** reads the plan and implements it. Writes an execute summary noting what's done, what's partial, and current test state.

3. **test-engineer** reads the execute summary and runs QA. If verdict is FAIL, the pipeline stops — code review doesn't happen on broken work.

4. **code-reviewer** reads the QA report and reviews the diff for bugs, security issues, and risk. Writes a verdict.

Final `pipeline-report.md` surfaces action items in priority order.

**Stopping mid-task:**

```
/handoff
```

**Resuming the next day:**

```
/resume
```

**The outputs directory**

The `outputs/` directory is created automatically in whatever project you're working in — not in this repo. Add it to your project's `.gitignore` or commit it depending on whether you want a paper trail.

```gitignore
outputs/handoffs/     # ephemeral, don't commit
# outputs/pipeline/  # useful record — consider committing
```

---

## Rules

Rules are loaded automatically into every Claude session via `~/.claude/CLAUDE.md`. You don't invoke them — they're always active.

The most important one is `workflow.md`, which enforces four mandatory phases for every non-trivial task:

1. **Research** — read relevant code, clarify ambiguity
2. **Plan** — write concrete ordered steps, confirm if large
3. **Execute** — one logical change at a time
4. **Review** — lint → typecheck → tests must pass

Claude will not skip phases or jump straight to writing code.

See `rules/README.md` for what each rule enforces and when to load rules situationally.

---

## Adding your own agents, commands, or rules

1. Create a `.md` file in the appropriate directory
2. Add a YAML frontmatter block with `name`, `description`, and `model`
3. Re-run `bash scripts/install.sh --tool claude`

Agent frontmatter example:

```markdown
---
name: my-agent
description: Use for X when Y. Triggers on requests like "do Z".
model: claude-sonnet-4-6
---

You are a ...
```

The installer picks up all `.md` files (excluding `README.md`) automatically.
