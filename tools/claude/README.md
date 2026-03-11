# Claude Code — Evaluation Kit

**Complete, production-ready evaluation setup for Claude Code as an AI coding assistant.**

This kit includes everything needed to thoroughly evaluate Claude Code's capabilities:
- ✅ 4 specialized agents (researcher, implementer, reviewer, architect)
- ✅ Multi-agent workflows and coordination
- ✅ Fine-grained permissions & safety guardrails
- ✅ Reusable skills for common tasks
- ✅ MCP integrations (GitHub, Slack, filesystem)
- ✅ Team standards & best practices codified
- ✅ Automation hooks for quality gates

**Not just "Claude Code basics" — this is everything for a production evaluation.**

---

## Quick Start (5 minutes)

### 1. Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude --version  # Verify
```

### 2. Copy Evaluation Kit
```bash
cp -r .claude your-project/
cp .mcp.json your-project/
```

### 3. Try The Three Agents
```bash
cd your-project

# Strategic decisions
claude "Principal Engineer, should we migrate to microservices?"

# Infrastructure & cloud design
claude "Cloud Architect, design multi-region disaster recovery"

# Implementation & features
claude "Senior Engineer, implement the user authentication feature"
```

---

## Learning Paths

Choose based on your time available:

| Path | Time | What you'll learn |
|------|------|-------------------|
| **Quick Demo** | 30 min | Agent roles and switching between strategic, infrastructure, and implementation tasks |
| **Hands-On** | 2 hours | Real workflows with all three agents on your code |
| **Deep Evaluation** | 1 week | Full capabilities, language support, integrations, team readiness |
| **Pilot** | 4 weeks | Production-ready assessment with your team |

**Start with the quick demo, then dive deeper based on interest.**

---

## The Three Agent Roles

This kit includes three specialized agents designed for different expertise levels:

| Agent | Focus | Use When | Tools |
|-------|-------|----------|-------|
| **Principal Engineer** | Strategy, architecture, vision | Strategic decisions, architectural reviews | Read-only codebase analysis |
| **Cloud Architect** | Infrastructure, reliability, DevOps | Cloud design, disaster recovery, scaling | Terraform, infrastructure planning |
| **Senior Engineer** | Implementation, features, DevOps | Building features, bug fixes, CI/CD | Full write access, testing, scripting |

### Language Support

- **Python** — See `.claude/rules/python.md`
- **JavaScript/TypeScript** — See `.claude/rules/javascript.md`
- **Go** — See `.claude/rules/go.md`

Each language has specific conventions, tooling, and best practices defined in the rules.

---

## Table of Contents

1. [Getting Started](#quick-start-5-minutes) (you are here)
2. [Setup Guides](#setup-options)
   - [Project-Level Setup](./SETUP_GUIDE.md) — For a single project
   - [Global Setup](./GLOBAL_SETUP.md) — For all projects/repos
3. [Workflow Examples](./WORKFLOW_EXAMPLES.md) — Real-world usage patterns
4. [Prerequisites](#prerequisites)
5. [Installation](#installation)

---

## Setup Options

Choose based on your needs:

| Option | Use When | Read |
|--------|----------|------|
| **Project-Level** | Setting up one repo with custom rules | [SETUP_GUIDE.md](./SETUP_GUIDE.md) |
| **Global** | Want Claude Code everywhere with team standards | [GLOBAL_SETUP.md](./GLOBAL_SETUP.md) |
| **Both** | Some global standards + project overrides | Both guides |

---

## Prerequisites

| Requirement | Minimum Version | Check |
|---|---|---|
| Node.js | **18+** | `node -v` |
| npm | **8+** | `npm -v` |
| OS | macOS, Linux, or WSL2 | — |

**Install or upgrade Node.js:**
```bash
# macOS (Homebrew)
brew install node

# Or download directly
open https://nodejs.org
```

---

## Installation

```bash
npm install -g @anthropic-ai/claude-code
```

Verify it worked:
```bash
claude --version
```

---

## First Run

Navigate to any project and start Claude Code:

```bash
cd your-project
claude
```

On first launch you'll be prompted to **log in with your Anthropic account** (or enter an API key if your company provided one). After that, you're in an interactive session — just describe what you want to do.

**One-shot mode** (no interactive session):
```bash
claude "explain what this repo does"
claude "fix the failing tests in src/utils"
claude "write a README for this project"
```

---

## MCP Integrations

MCP (Model Context Protocol) servers connect Claude Code to external tools so it can take actions — searching GitHub, creating Jira tickets, reading Confluence docs, and more.

### GitHub

**What it enables:** search repositories, read/create issues, manage pull requests, view code.

**Step 1 — Create a Personal Access Token (PAT):**
1. Go to https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Give it a name like `claude-code`
4. Check scopes: `repo`, `read:org`, `read:user`
5. Copy the token

**Step 2 — Add the MCP server:**
```bash
claude mcp add github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here \
  -- npx -y @modelcontextprotocol/server-github
```

**Test it:**
```bash
claude "list my open pull requests on GitHub"
```

---

### Atlassian (Jira + Confluence)

**What it enables:** create/update Jira tickets, search issues, read and write Confluence pages.

**Step 1 — Create an Atlassian API Token:**
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token"**
3. Name it `claude-code` and copy the token

**Step 2 — Add the MCP server:**
```bash
claude mcp add atlassian \
  -e ATLASSIAN_URL=https://yourcompany.atlassian.net \
  -e ATLASSIAN_EMAIL=you@yourcompany.com \
  -e ATLASSIAN_API_TOKEN=your_token_here \
  -- npx -y mcp-atlassian
```

> Replace `yourcompany`, `you@yourcompany.com`, and the token with your real values.

**Test it:**
```bash
claude "show my open Jira tickets assigned to me"
```

---

### Slack

**What it enables:** send messages, search channels, look up users.

**Step 1 — Create a Slack App & Bot Token:**
1. Go to https://api.slack.com/apps → **Create New App**
2. Choose **"From scratch"**, name it `Claude Code`, pick your workspace
3. Go to **OAuth & Permissions** → add these Bot Token Scopes:
   - `channels:read`, `channels:history`, `chat:write`, `users:read`
4. Click **"Install to Workspace"** → copy the **Bot User OAuth Token** (starts with `xoxb-`)

**Step 2 — Add the MCP server:**
```bash
claude mcp add slack \
  -e SLACK_BOT_TOKEN=xoxb-your-token-here \
  -- npx -y @modelcontextprotocol/server-slack
```

**Test it:**
```bash
claude "what was discussed in #general today?"
```

---

### Filesystem

**What it enables:** Claude can explicitly read and write files outside the current directory.

```bash
# Grant access to your home directory
claude mcp add filesystem \
  -- npx -y @modelcontextprotocol/server-filesystem ~/

# Or a specific project folder
claude mcp add filesystem \
  -- npx -y @modelcontextprotocol/server-filesystem ~/projects
```

---

## Automated Setup Script

> **Skip the manual steps above** — just run the script and follow the prompts.

```bash
# Download and run (if you have the script file)
bash setup-claude-code.sh
```

The script will:
- ✅ Check Node.js version
- ✅ Install Claude Code globally
- ✅ Walk you through each MCP integration interactively
- ✅ Confirm everything is wired up

---

## Useful Commands

```bash
# Start interactive session in current directory
claude

# One-shot task
claude "refactor the auth module to use async/await"

# List all configured MCP servers
claude mcp list

# Add a new MCP server
claude mcp add <name> -- <command>

# Remove an MCP server
claude mcp remove <name>

# View Claude Code version
claude --version

# Get help
claude --help
```

---

## Tips & Tricks

**Be specific about scope**
```
# Vague
claude "fix the bug"

# Better
claude "fix the null pointer error in src/api/users.ts line 42"
```

**Reference files directly**
```bash
claude "review this file for security issues" --file src/auth.js
```

**Use it for code reviews**
```bash
claude "review the changes in my current git diff and suggest improvements"
```

**Chain with git**
```bash
claude "write a commit message for my staged changes"
```

**Ask it to explain before doing**
```bash
claude "explain what you would do to add pagination, then do it"
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `claude: command not found` | Run `npm install -g @anthropic-ai/claude-code` again; check your PATH |
| MCP server not responding | Run `claude mcp list` to verify it's registered; re-add if missing |
| Auth errors with GitHub/Jira | Check your token hasn't expired; regenerate and re-add the MCP |
| Node version too old | Upgrade to Node 18+ via https://nodejs.org |

---

## Resources

- 📖 Official Docs: https://docs.anthropic.com/en/docs/claude-code/overview
- 🐛 Issues / Feedback: https://github.com/anthropics/claude-code
- 💬 Community: https://support.claude.ai