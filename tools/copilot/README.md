# GitHub Copilot CLI — Standalone Tool Evaluation Kit

## Quick install
```
git clone <repo-url> /tmp/copilot-kit

mkdir -p ~/.copilot/agents ~/.claude/agents

# Copilot CLI config
cp /tmp/copilot-kit/.github/lsp.json ~/.copilot/config.json

# Agent definitions (used by Copilot and Claude)
cp -a /tmp/copilot-kit/.github/agents/*.md ~/.copilot/agents/
cp -a /tmp/copilot-kit/.github/agents/*.md ~/.claude/agents/
```

**Complete setup for evaluating GitHub Copilot CLI (standalone) as your team's AI development assistant.**

This is the **standalone Copilot CLI** tool (`@github/copilot`), not the `gh copilot` GitHub CLI extension.

This kit includes:
- ✅ Global and project-level configuration templates
- ✅ Three specialized custom agents (principal-engineer, cloud-architect, senior-engineer)
- ✅ Configuration files for team standardization
- ✅ Complete setup and usage guides
- ✅ Real-world workflow examples with multi-agent support
- ✅ `/agent`, `/fleet`, `/delegate`, and other advanced commands

---

## Quick Start (5 minutes)

### 1. Install Copilot CLI

```bash
# macOS (Homebrew)
brew install copilot-cli

# macOS / Linux (npm)
npm install -g @github/copilot

# Verify installation
copilot --version
```

### 2. Authenticate

```bash
copilot /login
# Follow prompts to authenticate with GitHub
```

### 3. Verify Installation

```bash
copilot -p "Explain what you can help me with"
```

### 4. Read the Setup Guide

See [SETUP.md](./SETUP.md) for detailed configuration instructions.

---

## The Three Agents

This evaluation kit aligns with a proven three-tier agent model for different expertise levels:

| Agent | Focus | Use When |
|-------|-------|----------|
| **Principal Engineer** | Strategy, architecture, system design, vision | Making big decisions, designing systems, technology choices |
| **Cloud Architect** | Cloud infrastructure, DevOps, reliability, disaster recovery | Infrastructure design, scaling, availability, cost optimization |
| **Senior Engineer** | Code implementation, features, bug fixes, infrastructure code | Building features, fixing bugs, writing Terraform, scripting |

### Using Agents

```bash
# Explicit invocation (recommended)
copilot -p "Principal Engineer, should we migrate to microservices?"
copilot -p "Cloud Architect, design multi-region setup"
copilot -p "Senior Engineer, implement user authentication"

# Switch to specific agent
copilot /agent principal-engineer
copilot -p "Design our system architecture"

# Parallel execution with multiple agents
copilot -p "Implement the feature" /fleet principal-engineer cloud-architect senior-engineer

# Autonomous execution (creates branches, PRs)
copilot -p "Implement the feature" /delegate senior-engineer
```

---

## Setup Options

### Option A: Global Configuration (Recommended)

```bash
mkdir -p ~/.copilot
cp .github/lsp.json ~/.copilot/config.json
```

**Best for:** Small teams, consistent practices across all projects

### Option B: Project-Level Configuration

```bash
mkdir -p .github
cp .github/lsp.json .github/
cp AGENTS.md ./
git add .github/lsp.json AGENTS.md
git commit -m "Add Copilot CLI configuration"
git push
```

**Best for:** Large teams, project-specific customization, version-controlled setup

### Option C: Hybrid (Global + Project Overrides)

```bash
# Step 1: Global defaults
mkdir -p ~/.copilot
cp .github/lsp.json ~/.copilot/config.json

# Step 2: Per-project overrides (when needed)
cd ~/special-project
mkdir -p .github
# Add custom .github/lsp.json for this project
```

**Best for:** Medium teams, team-wide standards with project flexibility

---

## Configuration Files

### .github/lsp.json
Configuration for model selection, agent definitions, and security settings:
- AI model selection (Claude, GPT-4, etc.)
- Agent definitions and capabilities
- Security and approval requirements
- Timeouts and logging levels

**Location priority:**
1. Project `.github/lsp.json` (highest)
2. Global `~/.copilot/config.json`
3. System defaults (lowest)

### AGENTS.md
Custom agent definitions, version-controlled in git:
- All team members use the same agents
- Changes tracked in git history
- Activated via `/agent` command or natural language prompting

---

## Key Commands

```bash
# Basic prompt
copilot -p "Your task here"

# Plan your work (start with planning)
copilot -p "..." /plan

# Get explanation
copilot -p "..." /explain

# Get suggestions
copilot -p "..." /suggest

# Switch to specific agent
copilot /agent principal-engineer
copilot /agent cloud-architect
copilot /agent senior-engineer

# Run multiple agents in parallel
copilot -p "..." /fleet agent1 agent2 agent3

# Autonomous execution (creates branch, PR)
copilot -p "..." /delegate senior-engineer

# Continue previous session
copilot /resume

# Switch model
copilot -p "..." /model gpt-4
copilot -p "..." /model claude-3-opus

# List available models
copilot /model list
```

---

## Common Workflows

### Simple Feature Development

```bash
copilot /agent senior-engineer
copilot -p "Implement user profile feature" /plan
copilot -p "Implement user profile feature"
copilot -p "Write comprehensive tests"
copilot /agent principal-engineer
copilot -p "Review for scalability and design patterns"
```

### Complex Architecture Redesign

```bash
copilot /agent principal-engineer
copilot -p "Design microservices migration strategy" /plan

copilot /agent cloud-architect
copilot -p "Create Terraform for new microservices architecture"

copilot -p "Implement services" /fleet principal-engineer cloud-architect senior-engineer
```

### Production Bug Fix with Review

```bash
copilot /agent senior-engineer
copilot -p "Debug this memory leak in production"
copilot -p "Implement the fix with comprehensive tests"

copilot /agent principal-engineer
copilot -p "Design long-term solution to prevent this class of bugs" /resume
```

---

## Documentation

- **[SETUP.md](./SETUP.md)** — Detailed setup and configuration for standalone CLI
- **[AGENTS.md](./AGENTS.md)** — Custom agent definitions and usage patterns
- **[WALKTHROUGH.md](./WALKTHROUGH.md)** — Complete walkthrough of commands and workflows
- **[.github/lsp.json](./.github/lsp.json)** — Configuration example

---

## Getting Started

1. **Install Copilot CLI**: `brew install copilot-cli` or `npm install -g @github/copilot`
2. **Authenticate**: `copilot /login`
3. **Read SETUP.md**: Detailed configuration instructions
4. **Choose setup**: Global, project-level, or hybrid
5. **Test**: `copilot -p "Analyze this repository"`

**Next:** Head to [SETUP.md](./SETUP.md) for step-by-step instructions! 🚀
