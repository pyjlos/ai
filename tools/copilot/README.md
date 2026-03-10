# GitHub Copilot — Getting Started Guide

> **GitHub Copilot** is GitHub's AI pair programmer. It suggests code completions as you type, answers questions about your codebase, explains code, writes tests, and — with Agent Mode — can plan and execute multi-step coding tasks autonomously.

---

## Table of Contents

1. [Plans & What Your Company Provides](#plans--what-your-company-provides)
2. [Prerequisites](#prerequisites)
3. [Installation by IDE](#installation-by-ide)
   - [VS Code](#vs-code)
   - [JetBrains IDEs](#jetbrains-ides)
   - [Visual Studio](#visual-studio)
   - [Neovim](#neovim)
4. [Authentication](#authentication)
5. [Core Features](#core-features)
6. [Copilot Chat](#copilot-chat)
7. [Agent Mode (Best Practices)](#agent-mode-best-practices)
8. [Copilot for CLI](#copilot-for-cli)
9. [Tips & Best Practices](#tips--best-practices)
10. [Troubleshooting](#troubleshooting)

---

## Plans & What Your Company Provides

| | **Individual** | **Business** | **Enterprise** |
|---|---|---|---|
| Price | $10/month | $19/user/month | $39/user/month |
| Code completions | ✅ | ✅ | ✅ |
| Copilot Chat | ✅ | ✅ | ✅ |
| Agent Mode | ✅ | ✅ | ✅ |
| Organization policy controls | ❌ | ✅ | ✅ |
| Fine-tuned on company code | ❌ | ❌ | ✅ |
| Audit logs | ❌ | ✅ | ✅ |

> **If your company provides Copilot:** You'll receive an invitation to join the organization on GitHub. Accept it, and your account will have Copilot enabled automatically — no payment needed.

---

## Prerequisites

| Requirement | Details |
|---|---|
| GitHub Account | Sign up at https://github.com if you don't have one |
| Copilot License | Provided by your company (accept the org invite) or via personal subscription |
| IDE | VS Code, JetBrains, Visual Studio, or Neovim |

---

## Installation by IDE

### VS Code

**Step 1 — Install the extensions:**
```bash
# Install both the base extension and Copilot Chat
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

Or search **"GitHub Copilot"** in the Extensions panel (`Ctrl+Shift+X`).

**Step 2 — Sign in** (see [Authentication](#authentication) below)

**Step 3 — Verify it's active:**
The Copilot icon (✓ or ~) appears in the bottom status bar. Click it to check status.

---

### JetBrains IDEs

*(IntelliJ IDEA, PyCharm, WebStorm, GoLand, Rider, etc.)*

**Step 1 — Install the plugin:**
1. Open **Settings** → `Plugins` → `Marketplace`
2. Search **"GitHub Copilot"**
3. Click **Install** → restart the IDE

**Step 2 — Sign in:**
1. Go to **Tools** → **GitHub Copilot** → **Login to GitHub**
2. Copy the device code shown
3. Go to https://github.com/login/device and enter the code
4. Authorize the app

---

### Visual Studio

**Step 1 — Install the extension:**
1. Open **Extensions** → **Manage Extensions**
2. Search **"GitHub Copilot"**
3. Download and install → restart Visual Studio

**Step 2 — Sign in:**
- Go to **Tools** → **GitHub Copilot** → **Manage GitHub Copilot Subscription**

---

### Neovim

```bash
# Using vim-plug — add to your init.vim or init.lua
Plug 'github/copilot.vim'

# Then in Neovim
:PlugInstall
:Copilot setup
```

---

## Authentication

### Company-Managed (Business/Enterprise)

```
1. Accept the GitHub organization invite from your company
   (Check your email for an invite, or visit github.com/orgs)
2. Open your IDE → GitHub Copilot extension
3. Sign in to GitHub with your work GitHub account
4. Copilot is automatically enabled — no further setup needed
```

### Personal Subscription

```
1. Go to https://github.com/settings/copilot
2. Start a free trial or subscribe
3. In your IDE, sign in to GitHub when prompted
```

---

## Core Features

### Inline Code Completions
Copilot suggests code as you type — ghost text appears in gray. Press:
- `Tab` to accept the full suggestion
- `Alt+]` / `Alt+[` to cycle through alternate suggestions
- `Ctrl+→` to accept word-by-word
- `Esc` to dismiss

### Copilot Chat
A full chat interface to ask questions about your code:
- Open with `Ctrl+Alt+I` (VS Code) or the chat icon in the sidebar
- Select code first to ask questions about specific sections

### Inline Chat
Ask Copilot to make changes directly in the editor without opening a panel:
- `Ctrl+I` (VS Code) — opens an inline prompt at your cursor

---

## Copilot Chat

### Chat Context Variables

Copilot Chat supports special `@` variables and `/` commands to give it the right context:

| Variable | What it includes |
|---|---|
| `@workspace` | Your entire open workspace / project |
| `@vscode` | VS Code settings, commands, and extensions |
| `@terminal` | Content and errors from the terminal |
| `#file` | A specific file — `#file:src/auth.ts` |
| `#selection` | Your currently highlighted code |
| `#codebase` | Indexes and searches your whole codebase |

**Examples:**
```
@workspace what design patterns are used in this project?

@workspace /explain how does authentication work?

Can you fix the bug in #file:src/api/users.ts on line 42?

@terminal the last command failed — what went wrong and how do I fix it?
```

### Slash Commands

| Command | What it does |
|---|---|
| `/explain` | Explain the selected code |
| `/fix` | Fix bugs in selected code |
| `/tests` | Generate unit tests |
| `/doc` | Add documentation/comments |
| `/simplify` | Simplify complex code |
| `/new` | Scaffold a new project or file |
| `/newNotebook` | Create a Jupyter notebook |

---

## Agent Mode (Best Practices)

Copilot's **Agent Mode** (also called "Edits" in some IDEs) lets Copilot autonomously plan and execute multi-file changes. It reasons about what to do, shows you a diff, and waits for approval.

### Enabling Agent Mode in VS Code

1. Open Copilot Chat panel
2. At the top of the chat, switch the dropdown from **"Ask"** to **"Agent"**
3. Describe your task

### Writing Good Agent Prompts

**✅ Describe the outcome, not the steps**
```
# Good — outcome-focused
Add email verification to the signup flow. Users should receive a 
confirmation email and can't log in until they verify their address.

# Too prescriptive (let the agent decide the steps)
Step 1: add a verified field to the User model. Step 2: ...
```

**✅ Reference existing patterns**
```
Create a NotificationService following the same dependency injection 
pattern used in EmailService. Include unit tests matching the style 
in __tests__/EmailService.test.ts
```

**✅ Set constraints clearly**
```
Refactor the data layer to use the repository pattern. Keep all public 
interfaces identical — no breaking changes to existing callers.
```

**✅ Use `@workspace` for large-scope tasks**
```
@workspace identify all places where we're directly calling the database 
without going through the service layer, and refactor them
```

**✅ Review every diff before accepting**
Especially for:
- Changes to authentication or authorization
- Database schema changes
- Config or environment variable changes
- Any file touching billing or payments

**✅ Break large tasks into phases**
```
Phase 1: "Add the data model and migration for subscriptions"
[Review & accept]
Phase 2: "Add the API endpoints for subscription management"
[Review & accept]
Phase 3: "Add the frontend subscription settings page"
```

**❌ Avoid in agent mode**
- Extremely open-ended tasks ("improve the whole app")
- Tasks requiring secrets or credentials
- Deploys or production changes

---

## Copilot for CLI

Copilot can assist in the terminal — explaining commands, translating plain English to shell, and fixing errors.

### Installation

```bash
# Install GitHub CLI first
# macOS
brew install gh

# Then install the Copilot CLI extension
gh extension install github/gh-copilot
```

### CLI Usage

```bash
# Ask a question about shell commands
gh copilot explain "git rebase -i HEAD~3"

# Translate plain English to a shell command
gh copilot suggest "find all node_modules folders over 500MB and delete them"

# Get help with a specific tool
gh copilot explain "docker compose up --build -d"
```

---

## Tips & Best Practices

**Write descriptive comments before functions**
Copilot reads your comments as intent — a comment like `// Validate email and check for duplicates before saving user` will produce a much better function than an empty function signature.

**Use meaningful variable and function names**
Copilot uses names as context. `getUserById` leads to better completions than `getU`.

**Put examples in comments**
```python
# Input: {"name": "Alice", "age": 30}
# Output: "Alice is 30 years old"
def format_user(user):
```

**Open relevant files**
Copilot considers all open editor tabs as context. Open your interfaces, types, and related files before asking for an implementation.

**Use inline chat for quick edits**
`Ctrl+I` is faster than the full panel for small changes:
- *"make this async"*
- *"add error handling"*
- *"convert to TypeScript"*

**Ask Copilot to review before you commit**
```
@workspace review the changes in my current working files for any bugs, 
security issues, or style inconsistencies before I commit
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| No completions appearing | Check the status bar — Copilot icon should show ✓. Click it to re-authenticate |
| "Copilot is not enabled" | Your GitHub account may not have an active license. Check https://github.com/settings/copilot |
| Completions are off/irrelevant | Open relevant files in other tabs to give more context |
| Agent mode not available | Ensure you're on the latest Copilot Chat extension version |
| SSO / company account issues | Make sure you accepted the org invite; contact your GitHub admin |
| JetBrains: plugin not loading | Confirm IDE version is supported (IntelliJ 2022.1+) |

---

## Resources

- 📖 Official Docs: https://docs.github.com/en/copilot
- 🔧 VS Code Extension: https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
- 💬 Copilot Chat Docs: https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide
- 🤖 Agent Mode: https://docs.github.com/en/copilot/using-github-copilot/coding-agent/using-copilot-coding-agent
- 🖥️ CLI Extension: https://docs.github.com/en/copilot/github-copilot-in-the-cli