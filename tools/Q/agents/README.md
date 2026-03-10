# Amazon Q Developer — Custom Agent Personas

Ready-to-use agent personas for the Amazon Q Developer CLI.

---

## Personas Included

| Agent | Invoke with | Best for |
|---|---|---|
| `principal-engineer` | `q chat --agent principal-engineer` | Architecture review, code quality, cross-cutting decisions |
| `cloud-architect` | `q chat --agent cloud-architect` | AWS infra design, IaC review, security, cost, Well-Architected |
| `senior-engineer` | `q chat --agent senior-engineer` | Feature implementation, debugging, refactoring, testing |

---

## File Structure

```
q-agents/
├── cli-agents/                        # Agent config files (JSON)
│   ├── principal-engineer.json
│   ├── cloud-architect.json
│   └── senior-engineer.json
└── personas/                          # Prompt + context files (Markdown)
    ├── shared-context.md              # Team context injected into ALL agents
    ├── principal-engineer-prompt.md
    ├── cloud-architect-prompt.md
    └── senior-engineer-prompt.md
```

---

## Installation

### Step 1 — Copy the agent configs

```bash
mkdir -p ~/.aws/amazonq/cli-agents
cp cli-agents/*.json ~/.aws/amazonq/cli-agents/
```

### Step 2 — Copy the persona prompt files

```bash
mkdir -p ~/.aws/amazonq/personas
cp personas/*.md ~/.aws/amazonq/personas/
```

### Step 3 — Edit shared-context.md with your team's details

```bash
# Fill in your stack, conventions, and standards
nano ~/.aws/amazonq/personas/shared-context.md
```

This file is injected into **every** agent session — it's where you describe your tech stack, coding standards, and team conventions so you don't have to repeat it every time.

### Step 4 — Verify agents are registered

```bash
q agent list
```

---

## Usage

```bash
# Architecture review, code quality, cross-cutting decisions
q chat --agent principal-engineer

# AWS infra design, IaC review, security posture
q chat --agent cloud-architect

# Feature implementation, debugging, testing
q chat --agent senior-engineer
```

---

## Permissions Model

Each persona has different `allowedTools` — tools it can use **without asking permission**:

| Persona | Can read files | Can write files | Can run commands | Can call AWS |
|---|---|---|---|---|
| `principal-engineer` | ✅ | ❌ | ❌ | ❌ |
| `cloud-architect` | ✅ | ❌ | ❌ | ✅ (read-only calls) |
| `senior-engineer` | ✅ | ✅ | ✅ | ❌ |

This is intentional:
- The **principal engineer** is a reviewer — it reads and reports, it doesn't write.
- The **cloud architect** needs to call AWS APIs to introspect existing infrastructure.
- The **senior engineer** is an implementation partner — it needs write access and bash to actually build things.

---

## Customization

### Adding your own coding standards
Edit `~/.aws/amazonq/personas/shared-context.md` to describe your:
- Tech stack and frameworks
- Coding conventions and linting rules
- Branch/PR standards
- Testing requirements
- Architecture decisions already made

### Adding a new persona
1. Create `~/.aws/amazonq/cli-agents/your-persona.json`
2. Create `~/.aws/amazonq/personas/your-persona-prompt.md`
3. Reference the prompt file in the `resources` array of your JSON config
4. Run `q agent list` to confirm it's picked up

### Adding MCP servers to a persona
Add an `mcpServers` block to the relevant JSON config. For example, to give the cloud-architect access to your AWS infrastructure MCP:

```json
"mcpServers": {
  "aws-infra": {
    "command": "npx",
    "args": ["-y", "@aws/mcp-server"]
  }
}
```

---

## Tips

- **Start sessions with a specific task** — the persona prompts set the role, but you still need to give Q a concrete job to do.
- **The `shared-context.md` file is the most important thing to fill out** — the more it reflects your actual stack and standards, the more useful every session becomes.
- **Use `principal-engineer` for PR reviews** — run it in your repo root and ask it to review `git diff main`.
- **Use `cloud-architect` before opening a ticket** — describe the problem and ask it to sketch an architecture approach before you start building.
- **Use `senior-engineer` for day-to-day implementation** — it has write access and can make changes directly.