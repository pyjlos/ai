# Claude Code — Getting Started Guide

> **Claude Code** is Anthropic's AI-powered CLI tool that lives in your terminal and understands your codebase. It can read files, run commands, write code, and connect to your tools via MCP servers.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [First Run](#first-run)
4. [MCP Integrations](#mcp-integrations)
   - [GitHub](#github)
   - [Atlassian (Jira + Confluence)](#atlassian-jira--confluence)
   - [Slack](#slack)
   - [Filesystem](#filesystem)
5. [Automated Setup Script](#automated-setup-script)
6. [Useful Commands](#useful-commands)
7. [Tips & Tricks](#tips--tricks)

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