# Amazon Q Developer — Getting Started Guide

> **Amazon Q Developer** is AWS's AI-powered coding assistant. It lives in your IDE, terminal, and AWS Console — helping you write code, debug, explain AWS services, scan for vulnerabilities, and work across your entire AWS environment.

---

## Table of Contents

1. [What is Amazon Q Developer?](#what-is-amazon-q-developer)
2. [Prerequisites](#prerequisites)
3. [Installation by IDE](#installation-by-ide)
   - [VS Code](#vs-code)
   - [JetBrains IDEs](#jetbrains-ides)
   - [CLI / Terminal](#cli--terminal)
4. [Authentication](#authentication)
5. [Core Features](#core-features)
6. [Agent Mode (Best Practices)](#agent-mode-best-practices)
7. [Custom Agent Personas](#custom-agent-personas)
   - [Install the Personas](#install-the-personas)
   - [Using the Personas](#using-the-personas)
   - [Customizing for Your Team](#customizing-for-your-team)
8. [Security Scanning](#security-scanning)
9. [Useful Commands](#useful-commands)
10. [Tips & Best Practices](#tips--best-practices)
11. [Troubleshooting](#troubleshooting)

---

## What is Amazon Q Developer?

Amazon Q Developer has two tiers:

| | **Free Tier** | **Pro Tier** |
|---|---|---|
| Price | Free | ~$19/user/month |
| Code completions | ✅ Unlimited | ✅ Unlimited |
| Chat in IDE | ✅ | ✅ |
| Agent for software dev | ✅ Limited | ✅ Unlimited |
| Security scans | 50/month | Unlimited |
| Customization (your codebase) | ❌ | ✅ |
| Admin controls | ❌ | ✅ |

> Your company likely provides **Pro Tier** access via AWS IAM Identity Center (SSO). Use that — don't create a personal account.

---

## Prerequisites

| Requirement | Details |
|---|---|
| AWS Account / SSO | Your IT/DevOps team will provide this |
| IDE | VS Code, IntelliJ, PyCharm, WebStorm, or other JetBrains IDE |
| AWS CLI (optional) | For terminal-based Q usage |

---

## Installation by IDE

### VS Code

**Step 1 — Install the extension:**
```bash
# Via terminal
code --install-extension AmazonWebServices.amazon-q-vscode

# Or search "Amazon Q" in the VS Code Extensions panel (Ctrl+Shift+X)
```

**Step 2 — Sign in** (see [Authentication](#authentication) below)

**Step 3 — Open the Q panel:**
- Click the **Amazon Q icon** in the left sidebar
- Or press `Ctrl+Shift+P` → type `Amazon Q: Focus on Chat View`

---

### JetBrains IDEs

*(IntelliJ IDEA, PyCharm, WebStorm, GoLand, Rider, etc.)*

**Step 1 — Install the plugin:**
1. Open **Settings** → `Plugins` → `Marketplace`
2. Search for **"Amazon Q"**
3. Click **Install** → restart the IDE

**Step 2 — Sign in** (see [Authentication](#authentication) below)

**Step 3 — Open the Q panel:**
- View menu → **Tool Windows** → **Amazon Q**

---

### CLI / Terminal

Amazon Q also has a terminal companion that offers inline suggestions and natural language shell commands.

```bash
# macOS
brew install amazon-q

# After install, set up shell integration
q integrations install
```

Once installed, press **Option+C** in your terminal to open the Q chat panel, or just start typing a shell command and Q will offer completions.

---

## Authentication

Your company will use one of two methods:

### Option A — AWS IAM Identity Center (SSO) — *Most common for company accounts*

```
1. Open the Amazon Q panel in your IDE
2. Click "Sign in with IAM Identity Center"
3. Enter your company's SSO start URL
   (e.g., https://yourcompany.awsapps.com/start)
4. A browser window will open — log in with your company SSO credentials
5. Return to the IDE — you're authenticated
```

### Option B — AWS Builder ID (personal/free tier)

```
1. Open the Amazon Q panel in your IDE
2. Click "Sign in with AWS Builder ID"
3. Create or log into a Builder ID at https://profile.aws.amazon.com
4. Authorize the IDE connection
```

> **Company users:** Use Option A. It connects to your org's Pro Tier subscription and gives access to any custom models your team has configured.

---

## Core Features

### Inline Code Completions
Start typing — Q suggests completions automatically. Press `Tab` to accept.

### Chat in IDE
Ask questions about your code directly:
- *"What does this function do?"*
- *"Why is this throwing a NullPointerException?"*
- *"Rewrite this to be more performant"*
- *"Write unit tests for the selected code"*

Select code first to give Q context, then ask your question.

### Explain & Document
Right-click selected code → **Amazon Q** → **Explain** or **Generate Tests**

### AWS-Specific Help
Q has deep knowledge of every AWS service:
```
"What's the difference between SQS and SNS?"
"Write a CDK stack that creates an RDS instance with a VPC"
"How do I set up S3 cross-region replication?"
```

---

## Agent Mode (Best Practices)

Amazon Q's **Agent for Software Development** can autonomously make multi-file changes — it plans, implements, and creates a diff for your review.

### How to Invoke an Agent Task

In the Q chat panel, just describe a multi-step task:

```
/dev Add a REST endpoint to the users service that returns paginated 
results, with validation, error handling, and unit tests
```

The `/dev` command signals Q to enter agent mode.

### Agent Best Practices

**✅ Give agents a clear, scoped task**
```
# Good
/dev Refactor the PaymentService class to use the repository pattern, 
update all callers, and add unit tests for the new structure

# Too vague
/dev improve the code
```

**✅ Provide relevant context upfront**
```
/dev Using our existing UserRepository pattern (see src/repositories/UserRepository.java),
create a new OrderRepository with the same structure
```

**✅ Review the diff before accepting**
The agent produces a diff. Always read it before clicking "Accept" — especially for changes touching auth, DB schemas, or config files.

**✅ Run one agent task at a time**
Don't stack multiple `/dev` tasks simultaneously. Let each complete, review, then proceed.

**✅ Use for boilerplate-heavy work**
Agents shine at:
- Adding new CRUD endpoints
- Writing test suites for existing code
- Migrating between frameworks/patterns
- Creating CloudFormation / CDK / Terraform from plain English

**❌ Don't use agents for**
- Changes requiring live environment context (use standard chat instead)
- Security-sensitive code without careful review
- Production hotfixes under time pressure

---

## Custom Agent Personas

The Q Developer CLI supports **custom agents** — purpose-built personas you can switch between by name. Each one has its own tools, permissions, and pre-loaded context, so you never have to re-explain your stack or role at the start of a session.

Three ready-to-use personas are included alongside this README:

| Agent | Command | Best for |
|---|---|---|
| `principal-engineer` | `q chat --agent principal-engineer` | Architecture review, code quality, cross-cutting decisions |
| `cloud-architect` | `q chat --agent cloud-architect` | AWS infra design, IaC review, security, cost |
| `senior-engineer` | `q chat --agent senior-engineer` | Feature implementation, debugging, testing |

> **CLI only.** Custom agents are a terminal feature — they are not available in the VS Code or JetBrains extensions.

---

### Install the Personas

Run these commands from the directory containing the `q-agents/` folder (included alongside this README):

```bash
# 1. Create the required directories
mkdir -p ~/.aws/amazonq/cli-agents
mkdir -p ~/.aws/amazonq/personas

# 2. Copy the agent config files
cp q-agents/cli-agents/*.json ~/.aws/amazonq/cli-agents/

# 3. Copy the persona prompt files
cp q-agents/personas/*.md ~/.aws/amazonq/personas/

# 4. Verify the agents are registered
q agent list
```

**One-liner (if you're already in the right directory):**
```bash
mkdir -p ~/.aws/amazonq/cli-agents ~/.aws/amazonq/personas && \
cp q-agents/cli-agents/*.json ~/.aws/amazonq/cli-agents/ && \
cp q-agents/personas/*.md ~/.aws/amazonq/personas/ && \
q agent list
```

---

### Using the Personas

```bash
# Principal Engineer — review, architecture, raising the quality bar
q chat --agent principal-engineer

# Cloud Architect — AWS infra design, IaC review, Well-Architected lens
q chat --agent cloud-architect

# Senior Engineer — hands-on implementation, debugging, testing
q chat --agent senior-engineer
```

**Permissions are scoped to each role** — intentionally:

| Persona | Read files | Write files | Run commands | Call AWS |
|---|---|---|---|---|
| `principal-engineer` | ✅ | ❌ | ❌ | ❌ |
| `cloud-architect` | ✅ | ❌ | ❌ | ✅ |
| `senior-engineer` | ✅ | ✅ | ✅ | ❌ |

The principal engineer is a reviewer — it reads and reports, it doesn't write. The cloud architect can call AWS APIs to introspect live infrastructure. The senior engineer has full write and bash access to actually build things.

---

### Customizing for Your Team

The most important file to edit is `shared-context.md` — it's injected into **every** agent session and is where you describe your actual stack, conventions, and standards:

```bash
nano ~/.aws/amazonq/personas/shared-context.md
```

Fill in:
- Your tech stack and frameworks
- Coding conventions and linting config
- Architecture decisions already made (so Q doesn't re-litigate them)
- Things that should always be flagged (e.g. wildcard IAM, missing input validation)

The more accurately this file reflects your team, the less you'll need to repeat yourself in every session.

---

## Security Scanning

Amazon Q can scan your code for vulnerabilities (OWASP Top 10, CWEs, secrets leakage, etc.):

```bash
# In the IDE: right-click project → Amazon Q → Run Security Scan

# Or via CLI
q security-scan --path ./src
```

**What it detects:**
- Hardcoded credentials / secrets
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Insecure cryptography
- Path traversal issues
- Log injection

**After a scan:** Q provides a description of each finding, the exact line, and a suggested fix. You can apply fixes directly from the scan results panel.

---

## Useful Commands

### IDE Chat Slash Commands

| Command | What it does |
|---|---|
| `/dev <task>` | Launch agent for multi-file code changes |
| `/explain` | Explain the selected code |
| `/fix` | Fix issues in selected code |
| `/tests` | Generate unit tests for selected code |
| `/doc` | Generate documentation/docstrings |
| `/review` | Review selected code for issues |

### CLI Commands

```bash
# Open Q chat in terminal
q chat

# Ask a one-shot question
q chat "how do I list all S3 buckets with versioning disabled using AWS CLI"

# Run security scan
q security-scan --path .

# Translate natural language to a shell command
q translate "find all files modified in the last 7 days and larger than 10MB"
```

---

## Tips & Best Practices

**Highlight before you ask**
Always select the relevant code before using chat or commands — Q uses the selection as context. Without a selection, it uses the whole open file.

**Be AWS-specific when possible**
```
# Generic
"How do I read from a queue?"

# Gets much better answers
"How do I consume messages from an SQS FIFO queue in Python using boto3,
with visibility timeout handling and dead letter queue support?"
```

**Use Q for unfamiliar AWS services**
If you're working with a service you don't know well (e.g., EventBridge, Step Functions), ask Q to scaffold the implementation before diving into docs.

**Ask it to explain errors**
Paste an error message or stack trace directly into the chat:
```
I'm getting this error in my Lambda: [paste error]
What's causing it and how do I fix it?
```

**Keep chats focused**
Start a new chat for each new topic. Long conversations with mixed context produce worse results.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Extension not activating | Ensure you're on VS Code 1.75+ or a supported JetBrains version |
| SSO login not working | Confirm your start URL with IT; check you're on the company VPN if required |
| Completions not appearing | Check Q is enabled: bottom status bar should show "Amazon Q" as active |
| Agent task stalls | Cancel and re-try with a more specific task description |
| "Not authorized" error | Your Pro license may not be assigned — contact your AWS admin |

---

## Resources

- 📖 Official Docs: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/what-is.html
- 🔧 VS Code Extension: https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.amazon-q-vscode
- 🔧 JetBrains Plugin: https://plugins.jetbrains.com/plugin/24267-amazon-q
- 🖥️ CLI Docs: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html