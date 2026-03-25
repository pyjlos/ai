# Kiro CLI — Getting Started Guide

> **Kiro CLI** is an AI-powered command-line coding assistant powered by Claude. It lives in your terminal, helping you write code, debug, understand your codebase, and automate workflows through interactive chat and custom agents.

---

## Table of Contents

1. [What is Kiro CLI?](#what-is-kiro-cli)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Authentication](#authentication)
5. [Core Features](#core-features)
6. [Agent Mode & Custom Agents](#agent-mode--custom-agents)
7. [Context Management](#context-management)
8. [Useful Commands](#useful-commands)
9. [Tips & Best Practices](#tips--best-practices)
10. [Troubleshooting](#troubleshooting)

---

## What is Kiro CLI?

Kiro CLI is a command-line tool that brings AI-powered code assistance directly to your terminal. Powered by Claude, it provides:

- **Interactive Chat** — Natural language conversations about your code
- **Custom Agents** — Task-specific agents optimized for code quality, architecture, and implementation
- **Context Awareness** — Automatically understands your codebase and project structure
- **MCP Integration** — Connect external tools and extend capabilities
- **Smart Hooks** — Pre/post-command automation for workflow integration

Unlike traditional IDE extensions, Kiro CLI integrates seamlessly into your existing terminal workflow, shell history, and command chains.

---

## Prerequisites

| Requirement | Details |
|---|---|
| OS | macOS or Linux |
| Shell | bash, zsh, or compatible shell |
| Kiro Account | Sign up at app.kiro.dev |
| curl | For installation |

---

## Installation

**Step 1 — Install Kiro CLI:**
```bash
curl -fsSL https://cli.kiro.dev/install | bash
```

**Step 2 — Verify installation:**
```bash
kiro --version
```

**Step 3 — Install team configuration (one command):**

From the root of this repo:
```bash
cp -r ai/tools/Q/.kiro/ ~/.kiro/
```

This copies agents, steering files (always-loaded team context), and MCP settings directly into Kiro's global config directory. Kiro discovers everything automatically — no registration steps.

**Step 4 — Customize your team context:**
```bash
nano ~/.kiro/steering/AGENTS.md
```

This file is always loaded into every Kiro session. Fill in your actual tech stack, conventions, and settled decisions.

**Step 5 — Sign in** (see [Authentication](#authentication) below)

---

## Authentication

Kiro CLI uses browser-based authentication via your Kiro account:

```bash
kiro login
```

This will:
1. Open your browser to https://app.kiro.dev
2. Prompt you to sign in or create an account
3. Generate an authentication token
4. Return you to the CLI, fully authenticated

Your authentication persists across sessions and is stored securely in `~/.kiro/config`.

---

## Core Features

### Interactive Chat
Start a conversation with Claude directly in your terminal:

```bash
kiro chat
```

Ask questions about your code, get explanations, request implementations:
- *"What does this function do?"*
- *"Why is this throwing an error?"*
- *"Rewrite this to be more performant"*
- *"Write unit tests for this component"*

### Context Awareness
Kiro automatically understands your project structure, files, and codebase through:
- Directory-based conversation persistence
- Automatic file indexing and understanding
- Slash commands to manage context (`/save`, `/load`, `/prompts`)

### Custom Agents
Leverage pre-configured agents for specific tasks:
- Code implementation and debugging
- Architecture review and design
- Testing and quality assurance
- Security analysis

Switch between agents with:
```bash
kiro chat --agent agent-name
```

### MCP Integration
Connect external tools and data sources using the Model Context Protocol (MCP) to extend Kiro's capabilities with custom integrations.

### Smart Hooks
Automate workflow tasks with pre/post-command hooks that trigger actions before or after Kiro operations, enabling seamless integration with your development pipeline.

---

## Agent Mode & Custom Agents

Kiro CLI supports custom agents — specialized personas you can create and switch between for specific development tasks. Each agent has its own configuration, instructions, and capabilities.

### Using Agents

Switch to an agent with:
```bash
kiro chat --agent agent-name
```

Or specify an agent for a one-shot command:
```bash
kiro chat --agent agent-name "describe the architecture of this project"
```

### Agent Best Practices

**✅ Use agents for domain-specific tasks**
```bash
# Architecture review
kiro chat --agent architect "review the database schema"

# Security analysis
kiro chat --agent security "scan this for vulnerabilities"

# Testing
kiro chat --agent tester "write comprehensive tests for this module"
```

**✅ Keep agent instructions focused**
Agents work best when they have a specific purpose and clear constraints. Overly broad agents produce less focused results.

**✅ Use the included team agents**
```bash
# Architecture review, code quality, cross-cutting decisions
kiro chat --agent principal-engineer "review the service layer design"

# AWS infra design, IaC review, security posture
kiro chat --agent cloud-architect "design a multi-AZ RDS setup"

# Feature implementation, debugging, testing
kiro chat --agent senior-engineer "implement pagination for the users endpoint"

# Prompt engineering, AI workflow design, model tier strategy
kiro chat --agent ai-architect "review this prompt for token efficiency"
```

**✅ Combine agents in a workflow**
Use different agents sequentially for different aspects of your task:
1. Start with `principal-engineer` for design review
2. Hand off to `senior-engineer` for implementation
3. Use `cloud-architect` for infrastructure decisions

**✅ Customize agents for your team**
Create team-specific agents that understand your conventions, stack, and standards by modifying agent configuration files.

---

## Context Management

Kiro automatically maintains conversation context within your project directory. Conversations are scoped to directories, so:
- `~/project-a/`: Conversations about project-a
- `~/project-b/`: Separate conversations about project-b

### Managing Context

**Save important context for reuse:**
```bash
/save important-context
```

**Load previously saved context:**
```bash
/load important-context
```

**View available prompts and context:**
```bash
/prompts
```

**Share context across your team**
Check your steering files and knowledge bases in the Kiro app to collaborate with teammates and standardize how Kiro understands your codebase.

## Useful Commands

### Core Commands

```bash
# Start interactive chat
kiro chat

# Ask a one-shot question
kiro chat "how do I implement pagination in Go?"

# Use a specific agent
kiro chat --agent architect "review this architecture"

# Log in to your Kiro account
kiro login

# Log out
kiro logout

# Check version
kiro --version

# Get help
kiro --help
```

### Slash Commands in Chat

Within an interactive chat session, use these commands:

| Command | What it does |
|---|---|
| `/save context-name` | Save current conversation context for reuse |
| `/load context-name` | Load a previously saved context |
| `/prompts` | View available prompts and steering instructions |
| `/help` | Show available slash commands |
| `/clear` | Clear current conversation history |
| `/exit` | Exit chat |

---

## Tips & Best Practices

**Provide project context upfront**
Include file paths and project structure when asking questions. Kiro learns your codebase automatically, but explicit context helps:
```bash
kiro chat "In my Go project (src/services/), how should I structure error handling?"
```

**Use slash commands to manage context**
Save context for complex projects or frequently-asked topics:
```bash
/save go-conventions
/save architecture-decisions
```

**Keep conversations focused**
Start a new chat for each distinct topic. Long conversations with mixed subjects produce less accurate results.

**Leverage agents for different roles**
- Use one agent for architecture decisions
- Use another for implementation
- Use another for testing

This prevents the AI from switching contexts constantly.

**Put steering files in your repo**
Add `.kiro/steering.md` to your repository root to share project conventions with all team members:
```markdown
# Our Stack
- Go 1.21, PostgreSQL, React
- Clean architecture pattern
- All services use dependency injection
```

**Review generated code carefully**
Claude is powerful but can make mistakes. Always review suggestions before applying them to your codebase, especially for security-sensitive code.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `kiro: command not found` | Reinstall with `curl -fsSL https://cli.kiro.dev/install \| bash` and restart your shell |
| `Not authenticated` | Run `kiro login` to authenticate with your Kiro account |
| `Agent not found` | Verify the agent exists in your configuration with `kiro --help` |
| `Chat times out` | Your internet connection may be unstable, or the request is too large. Try a simpler query |
| `Permission denied` | Ensure `~/.kiro/config` has correct permissions (`chmod 600 ~/.kiro/config`) |

---

## Resources

- 📖 Official Docs: https://kiro.dev/cli/
- 🌐 Kiro App: https://app.kiro.dev
- 🔧 Installation: https://cli.kiro.dev/install
- 📝 GitHub Issues: Report bugs at the Kiro project repository