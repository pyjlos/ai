# Agents

Agents are specialist AI personas that Claude Code can invoke during a session. Each agent is a markdown file with a defined role, a set of behaviors it must follow, and a scope it stays within. Instead of asking a general-purpose model to do everything, you route tasks to the agent that was built for them — a Go agent for Go code, a Terraform agent for infrastructure, a chaos engineer for resilience testing. The result is more consistent, higher-quality output with less prompt writing on your end.

## Quick install

```bash
bash scripts/install.sh
```

Run interactively and choose Claude Code, GitHub Copilot, or Amazon Q / Kiro. Or run non-interactively:

```bash
bash scripts/install.sh --tool claude
```

Agents are installed to `~/.claude/agents/` as flat `.md` files. Claude Code loads them automatically at session start.

---

## Agent catalog

### AI

| Agent | Role | Best for |
|---|---|---|
| `ai-architect` | Principal AI / LLM systems designer | LLM system design, RAG, multi-agent patterns, prompt engineering, Claude Code configuration |

### DevOps

| Agent | Role | Best for |
|---|---|---|
| `devops-architect` | DevOps strategy and platform engineering lead | DevOps strategy, developer experience, SRE practices, DORA metrics, incident management |
| `cicd-architect` | CI/CD pipeline specialist | GitHub Actions workflows, deployment strategies (blue/green, canary), release automation |
| `terraform` | Infrastructure-as-code specialist | Terraform module authoring, state management, workspace strategy, testing |
| `kubernetes` | Kubernetes workload and cluster specialist | Workload design, manifest authoring, Helm charts, resource sizing, cluster operations |
| `docker` | Container and image specialist | Dockerfile authoring, image optimization, multi-stage builds, container security, Compose |
| `observability` | Observability and monitoring specialist | Metrics design, structured logging, distributed tracing, SLO/SLI definition, alerting |

### QA

| Agent | Role | Best for |
|---|---|---|
| `code-reviewer` | Code quality and security reviewer | Pull request review, bug identification, security issues, performance problems |
| `test-engineer` | Test writing specialist | Unit tests, integration tests, fixtures, mocks, improving test coverage |
| `test-automation-strategist` | Test strategy and automation architect | Test pyramid design, automation architecture, E2E framework selection, deciding what to test at which layer |
| `debugger` | Systematic fault isolation specialist | Production issue debugging, root cause analysis, stack trace analysis across Python, TypeScript, and Go |
| `chaos-engineer` | Resilience and failure testing specialist | Chaos engineering, failure mode analysis, game day design, fault injection, graceful degradation verification |

### Software Architecture

| Agent | Role | Best for |
|---|---|---|
| `solution-architect` | System design generalist | Architecture trade-offs, technology selection, cross-cutting architectural decisions |
| `api-designer` | API design specialist | REST API design, gRPC/GraphQL schema, OpenAPI specifications, API versioning |
| `12factor-architect` | Cloud-native application design specialist | 12-Factor App methodology, environment configuration, portable service architecture |
| `aws-expert` | AWS service and infrastructure specialist | AWS service selection, architecture on AWS, infrastructure patterns, cost optimization |
| `aws-well-architected` | AWS Well-Architected Framework reviewer | Pillar-by-pillar workload assessment and remediation planning across all six pillars |
| `distributed-systems-architect` | Distributed systems design specialist | Consensus algorithms, consistency models, replication strategies, partitioning, fault-tolerant architecture |
| `technical-writer` | Technical documentation specialist | Architecture diagrams, runbooks, README files, ADRs, onboarding guides, developer and business-facing docs |

### Software Development

| Agent | Role | Best for |
|---|---|---|
| `python-agent` | Python specialist (3.12+) | Writing, reviewing, or refactoring Python with type hints, ruff, mypy, and uv |
| `java-agent` | Java specialist (21+) | Writing, reviewing, or refactoring Java with modern language features and strong type discipline |
| `go-agent` | Go specialist (1.22+) | Writing, reviewing, or refactoring idiomatic Go with correct error handling and concurrency |
| `typescript-agent` | TypeScript specialist (5.x) | Writing, reviewing, or refactoring type-safe TypeScript in strict mode |
| `bash-agent` | Bash scripting specialist | Writing, reviewing, or hardening shell scripts with safe defaults and shellcheck |
| `sql-agent` | SQL and query optimization specialist | Query writing, schema design, performance optimization, migrations (PostgreSQL primary focus) |
| `database-admin` | Database administration specialist | Safe SQL operations, exploring database state, production database best practices, safe update/delete patterns |
| `pragmatic-reviewer` | Pragmatic code and design reviewer | Code review focused on simplicity, complexity audits, and practical actionable feedback |

---

## How to use agents

### From the Claude Code chat

The simplest way: name the agent at the start of your message. Claude Code reads the agent descriptions and routes your request automatically.

```
python-agent — refactor the retry logic in src/http/client.py to use exponential backoff
with jitter. Keep the public interface unchanged.
```

```
solution-architect — we need to support 10x our current write volume without changing the
API contract. Current stack: PostgreSQL, FastAPI, 3 app servers. What are the options?
```

Claude Code can also auto-select an agent based on context — if you ask a Terraform question with the `terraform` agent installed, it may route there without you naming it explicitly. Naming it explicitly is more reliable.

### As named subagents (parallel orchestration)

Agents can be spawned in parallel within a single Claude Code session. This is how the `review-pr` command works: it runs `pragmatic-reviewer`, `code-reviewer`, and `test-engineer` simultaneously against the same diff, then collates their output.

You can do the same thing manually:

```
Spawn these three agents in parallel against src/api/payments/:
  - code-reviewer — check for bugs and logic errors
  - pragmatic-reviewer — check for unnecessary complexity
  - test-engineer — identify missing test coverage
Then collate their findings into a single prioritized action list.
```

### Via the API (programmatic use)

If you are building an application on top of the Anthropic API, load an agent's markdown file as the system prompt:

```python
import anthropic
from pathlib import Path

client = anthropic.Anthropic()

system_prompt = Path("agents/software-development/python-agent.md").read_text()

response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=4096,
    system=system_prompt,
    messages=[{
        "role": "user",
        "content": "Review this function for correctness and type safety:\n\n" + code
    }]
)
```

This gives you the same specialist behavior in automated pipelines, CI jobs, or custom tooling.

---

## Best practices for prompting agents

**1. Name the agent explicitly.**
Start your message with the agent name followed by a dash. Do not make Claude guess which specialist you want.

```
go-agent — write a context-aware HTTP middleware that logs request duration and status code.
```

**2. State your constraints upfront.**
Agents cannot see your codebase unless you tell them what matters. Say which packages to use, which interfaces to preserve, and what is out of scope.

```
python-agent — add pagination to the /users endpoint. Use the existing Paginator class in
src/pagination.py. Do not change the response schema.
```

**3. One task per agent invocation.**
Agents perform best when the scope is narrow. "Refactor the auth module and write tests and review for security" is three tasks. Split them across separate invocations or use parallel subagents.

**4. Give the agent the relevant code.**
Paste the file or function if it is short. For larger codebases, give the agent the file path and let Claude Code read it. Do not expect the agent to find the relevant code on its own.

**5. Specify the output format if it matters.**
If you need a numbered action list, a JSON diff, or a table, say so. Agents default to prose otherwise.

**6. Use agents for their specialty, not as a general assistant.**
The `terraform` agent understands Terraform state management deeply. Asking it to review Python logic is a category error. Match the task to the agent.

**7. Combine rules with agents for tighter output.**
Load a rule file alongside an agent to enforce team standards without repeating them every session:

```
Load rules/security.md, then: code-reviewer — review src/api/auth.py for vulnerabilities.
```

**8. Ask for a plan before implementation on large tasks.**
For tasks that would take more than an hour, ask the agent to outline its approach first. Correct the plan before any code is written.

```
solution-architect — outline an approach for migrating our PostgreSQL monolith to read
replicas. Do not write any code yet — just the plan.
```

---

## Cross-category workflow examples

### Ship a new API endpoint safely

A realistic sequence for adding a new endpoint from design through deployment:

1. **`api-designer`** — design the REST contract, request/response schema, error codes, and versioning approach
2. **`python-agent`** (or the relevant language agent) — implement the endpoint following the agreed contract
3. **`test-engineer`** — write unit and integration tests covering the happy path, error paths, and boundary conditions
4. **`code-reviewer`** and **`pragmatic-reviewer`** in parallel — review for bugs, security, and unnecessary complexity
5. **`technical-writer`** — update the OpenAPI spec and runbook

### Debug and harden a production incident

When something breaks in production and you need to understand what happened and prevent recurrence:

1. **`debugger`** — analyze the stack trace and logs to identify root cause
2. **`code-reviewer`** — review the affected code for related vulnerabilities the incident exposed
3. **`chaos-engineer`** — design fault injection tests to verify the fix holds under the original failure conditions
4. **`observability`** — recommend metric, alert, and SLI changes so this failure class is caught earlier next time

### Evaluate a new system architecture

When a system is being redesigned or migrated:

1. **`solution-architect`** — frame the trade-offs and select the approach
2. **`aws-well-architected`** — evaluate the proposed design against all six Well-Architected pillars
3. **`distributed-systems-architect`** — stress-test the consistency and failure mode assumptions
4. **`cicd-architect`** — design the deployment pipeline and rollback strategy
5. **`technical-writer`** — write the Architecture Decision Record (ADR) capturing the decision and rationale
