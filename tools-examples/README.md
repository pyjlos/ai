# AI Coding Tools — Team Overview

Your company provides access to **three AI coding assistants**. This guide helps you understand what each one is best at and how to get started.

---

## Tool Quick Reference

| | **Claude Code** | **GitHub Copilot** | **Amazon Q Developer** |
|---|---|---|---|
| **Best for** | Complex reasoning, multi-file agents, CLI-first workflows | IDE completions, inline edits, GitHub-integrated tasks | AWS-heavy work, security scanning, cloud infrastructure |
| **Where it lives** | Terminal / CLI | IDE (VS Code, JetBrains) | IDE + Terminal + AWS Console |
| **Agent Mode** | ✅ Full agentic CLI | ✅ In-IDE agent | ✅ `/dev` command |
| **MCP / Integrations** | ✅ GitHub, Jira, Slack, more | GitHub-native | AWS ecosystem |
| **Security Scanning** | ❌ | ❌ | ✅ Built-in |
| **AWS Knowledge** | General | General | ✅ Deep AWS expertise |

---

## Getting Started

Each tool has its own README and setup script:

| Tool | README | Setup Script |
|---|---|---|
| Claude Code | [README-claude-code.md](./README-claude-code.md) | `bash setup-claude-code.sh` |
| GitHub Copilot | [README-github-copilot.md](./README-github-copilot.md) | `bash setup-github-copilot.sh` |
| Amazon Q Developer | [README-amazon-q.md](./README-amazon-q.md) | `bash setup-amazon-q.sh` |

### Run all setup scripts at once

```bash
bash setup-claude-code.sh
bash setup-amazon-q.sh
bash setup-github-copilot.sh
```

---

## When to Use Which Tool

```
Writing code in the IDE day-to-day?
  → GitHub Copilot (fastest inline completions)

Working with AWS services, CDK, CloudFormation, or Lambda?
  → Amazon Q Developer (deep AWS context + security scanning)

Complex multi-step task from the terminal, or connecting to Jira/GitHub/Slack?
  → Claude Code (most powerful agentic CLI + MCP integrations)

Need to scan your code for vulnerabilities?
  → Amazon Q Developer (/security scan)

Explaining an unfamiliar codebase?
  → Any — but Claude Code and Copilot Chat with @workspace are particularly strong

Pair-programming in real time while typing?
  → GitHub Copilot (lowest latency, best IDE integration)
```

---

## Tips for Using Multiple Tools Together

- **Use Copilot for flow** — keep it on while you code for instant completions
- **Switch to Claude Code for big tasks** — agent-mode refactors, cross-repo changes, or anything needing external tool access (Jira, GitHub PRs, Slack)
- **Use Q for AWS work** — whenever you're writing infra-as-code, Lambda functions, or debugging AWS-specific errors
- All three can be running simultaneously with no conflicts