# Kiro CLI — Custom Agent Personas

Ready-to-use agent personas for the Kiro CLI.

---

## Personas Included

| Agent | Invoke with | Best for |
|---|---|---|
| `principal-engineer` | `kiro chat --agent principal-engineer` | Architecture review, code quality, cross-cutting decisions |
| `cloud-architect` | `kiro chat --agent cloud-architect` | AWS infra design, IaC review, security, cost, Well-Architected |
| `senior-engineer` | `kiro chat --agent senior-engineer` | Feature implementation, debugging, refactoring, testing |

---

## File Structure

```
agents/
├── principal-engineer/
│   ├── principal-engineer.json
│   └── PRINCIPAL_ENGINEER.md
├── cloud-architect/
│   ├── cloud-architect.json
│   └── CLOUD_ARCHITECT.md
├── senior-engineer/
│   ├── senior-engineer.json
│   └── SENIOR_ENGINEER.md
└── SHARED_CONTEXT.md                # Team context injected into ALL agents
```

---

## Installation

### Step 1 — Prepare Kiro agent directories

```bash
mkdir -p ~/.kiro/agents
mkdir -p ~/.kiro/context
```

### Step 2 — Copy agent configurations

```bash
cp */*.json ~/.kiro/agents/
cp SHARED_CONTEXT.md ~/.kiro/context/
cp */*.md ~/.kiro/context/
```

### Step 3 — Edit shared-context.md with your team's details

```bash
# Fill in your stack, conventions, and standards
nano ~/.kiro/context/SHARED_CONTEXT.md
```

This file is injected into **every** agent session — it's where you describe your tech stack, coding standards, and team conventions so you don't have to repeat it every time.

### Step 4 — Verify agents are registered

```bash
kiro --help
```

---

## Usage

```bash
# Architecture review, code quality, cross-cutting decisions
kiro chat --agent principal-engineer

# AWS infra design, IaC review, security posture
kiro chat --agent cloud-architect

# Feature implementation, debugging, testing
kiro chat --agent senior-engineer
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
Edit `~/.kiro/context/SHARED_CONTEXT.md` to describe your:
- Tech stack and frameworks
- Coding conventions and linting rules
- Branch/PR standards
- Testing requirements
- Architecture decisions already made

### Adding a new persona
1. Create `~/.kiro/agents/your-persona.json`
2. Create `~/.kiro/context/your-persona.md`
3. Reference the prompt file in the `resources` array of your JSON config
4. Restart kiro or run `kiro --help` to confirm it's picked up

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

- **Start sessions with a specific task** — the persona prompts set the role, but you still need to give Kiro a concrete job to do.
- **The `SHARED_CONTEXT.md` file is the most important thing to fill out** — the more it reflects your actual stack and standards, the more useful every session becomes.
- **Use `principal-engineer` for code reviews** — run it in your repo and describe the code you want reviewed.
- **Use `cloud-architect` before opening a ticket** — describe the problem and ask it to sketch an architecture approach before you start building.
- **Use `senior-engineer` for day-to-day implementation** — it has write access and can make changes directly.