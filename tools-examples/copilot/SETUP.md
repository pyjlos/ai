# GitHub Copilot CLI — Setup Guide (Standalone)

This guide walks you through setting up GitHub Copilot CLI (standalone) for your team, including global configuration and project-level customization.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Authentication](#authentication)
4. [Global Configuration](#global-configuration)
5. [Project-Level Configuration](#project-level-configuration)
6. [Configuration Precedence](#configuration-precedence)
7. [Usage Guide](#usage-guide)
8. [Team Deployment](#team-deployment)
9. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### System Requirements

- **OS:** macOS, Linux, or Windows
- **Node.js:** Version 18+ (for npm installation) OR Homebrew (for macOS)
- **Git:** Version 2.20 or higher
- **GitHub Account:** With Copilot subscription (Free, Pro, Pro+, Business, or Enterprise)

### Verify Prerequisites

```bash
# Check OS
uname -s  # Should show: Darwin (macOS), Linux, or Windows

# Check Git
git --version

# Check Node.js (if using npm)
node --version  # Should show v18 or higher
```

---

## Installation

### Option A: macOS with Homebrew (Recommended)

```bash
# Install Copilot CLI
brew install copilot-cli

# Verify installation
copilot --version

# Show help
copilot --help
```

### Option B: Universal Installation with npm

Works on macOS, Linux, and Windows:

```bash
# Install Copilot CLI globally
npm install -g @github/copilot

# Verify installation
copilot --version

# Show help
copilot --help
```

### Option C: Update Existing Installation

```bash
# macOS with Homebrew
brew upgrade copilot-cli

# or with npm
npm install -g @github/copilot@latest
```

---

## Authentication

### Step 1: Initial Login

```bash
# Start the login process
copilot /login

# This will:
# 1. Open your browser to GitHub
# 2. Ask you to authorize Copilot CLI
# 3. Return a device code if needed
# 4. Save your credentials locally
```

### Step 2: Verify Authentication

```bash
# Check authentication status
copilot /status

# Should show your GitHub username and authentication status
```

### Understanding Token Priority

Copilot CLI uses this precedence for authentication:

1. **`GITHUB_TOKEN` environment variable** (highest priority)
2. **Credentials stored from `copilot /login`** (standard)
3. **`GH_TOKEN` environment variable** (fallback)

### Option A: Use Existing GitHub Authentication (Recommended)

If you've already run `copilot /login`, you're done. Credentials are stored locally.

```bash
# Verify authentication
copilot /status
```

### Option B: Create a Fine-Grained Personal Access Token (PAT)

For better security and token isolation:

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Fine-grained personal access token"
3. Set details:
   - **Token name:** `copilot-cli`
   - **Expiration:** 90 days
   - **Repository access:** All repositories (or specific repos)
   - **Permissions:** Check "Copilot requests"
4. Copy the token (starts with `github_pat_`)
5. Set environment variable:

```bash
# Temporarily (this session only)
export GITHUB_TOKEN=github_pat_xxxxxxxxxxxx

# Permanently (add to ~/.bashrc, ~/.zshrc, or ~/.profile)
echo 'export GITHUB_TOKEN=github_pat_xxxxxxxxxxxx' >> ~/.bashrc
source ~/.bashrc
```

### Option C: Per-Project Token

For team projects with different access levels:

```bash
# Set per-project token
cd ~/projects/sensitive-project
export GITHUB_TOKEN=github_pat_project_specific_xxxxxxxxxxxx

# Run Copilot CLI with this token
copilot -p "Your prompt here"
```

---

## Global Configuration

### Directory Structure

```
~/.copilot/
├── config.json              # LSP configuration (your settings)
└── logs/                    # (optional) Debug logs
```

### Step 1: Create Global Config Directory

```bash
mkdir -p ~/.copilot
```

### Step 2: Create Configuration File

Copy or create `~/.copilot/config.json`:

```bash
cat > ~/.copilot/config.json << 'EOF'
{
  "modelDefaults": {
    "provider": "anthropic",
    "model": "claude-3-opus-20250219"
  },

  "agents": {
    "principal-engineer": {
      "enabled": true,
      "description": "Strategic architecture, system design, technology decisions"
    },
    "cloud-architect": {
      "enabled": true,
      "description": "Cloud infrastructure, DevOps, reliability, disaster recovery"
    },
    "senior-engineer": {
      "enabled": true,
      "description": "Code implementation, features, bug fixes, infrastructure code"
    }
  },

  "security": {
    "requireApprovalForFileModification": true,
    "requireApprovalForCommandExecution": true,
    "allowSandboxedExecution": true
  },

  "logging": {
    "level": "info",
    "enabled": true
  },

  "timeout": {
    "requestTimeoutSeconds": 120,
    "agentTimeoutSeconds": 300
  }
}
EOF
```

### Step 3: Verify Global Configuration

```bash
# Test with basic prompt
copilot -p "Explain what Copilot CLI can help me with"

# Switch to specific agent
copilot /agent principal-engineer
copilot -p "Suggest system design patterns"

# Check that it uses your settings
# Should respond using Claude (from modelDefaults)
```

---

## Project-Level Configuration

### Directory Structure

```
project-root/
├── .github/
│   └── lsp.json         # Project-specific LSP config (recommended)
├── AGENTS.md            # Custom agent definitions (version-controlled)
└── .gitignore           # Include .env files with secrets
```

### Step 1: Create Project Configuration

In your project root, create `.github/lsp.json`:

```bash
mkdir -p .github
cat > .github/lsp.json << 'EOF'
{
  "modelDefaults": {
    "provider": "anthropic",
    "model": "claude-3-opus-20250219"
  },

  "agents": {
    "principal-engineer": {
      "enabled": true,
      "description": "Strategic architecture, system design, technology decisions",
      "instructions": "Focus on scalability and long-term design."
    },
    "cloud-architect": {
      "enabled": true,
      "description": "Cloud infrastructure, DevOps, reliability, disaster recovery"
    },
    "senior-engineer": {
      "enabled": true,
      "description": "Code implementation, features, bug fixes, infrastructure code"
    }
  },

  "security": {
    "requireApprovalForFileModification": true,
    "requireApprovalForCommandExecution": true
  },

  "logging": {
    "level": "info",
    "enabled": true
  }
}
EOF
```

### Step 2: Define Custom Agents

Copy `AGENTS.md` to your project:

```bash
# Copy from this kit
cp /path/to/copilot/AGENTS.md ./AGENTS.md

# CommitterInfo to version control
git add .github/lsp.json AGENTS.md
git commit -m "Add Copilot CLI configuration and agent definitions"
git push
```

### Step 3: Verify Project Configuration

```bash
# Test with your custom agent
copilot /agent principal-engineer
copilot -p "Analyze our system design"

# Should use Claude model and your project's agent definitions
```

---

## Configuration Precedence

When you run `copilot`, it loads configuration in this order (highest to lowest priority):

```
1. .github/lsp.json          (Project-level)
2. ~/.copilot/config.json    (User-level)
3. System defaults           (Built-in)
```

**Example:**

If you have both:
- Global `~/.copilot/config.json` with Claude
- Project `.github/lsp.json` with GPT-4

The project config wins. This allows:
- Team-wide defaults in global config
- Project-specific overrides in `.github/lsp.json`
- Different agents per project

---

## Usage Guide

### Basic Commands

```bash
# Basic prompt
copilot -p "Your task here"

# Plan your work
copilot -p "..." /plan

# Get explanation
copilot -p "..." /explain

# Get suggestions
copilot -p "..." /suggest

# Switch model
copilot -p "..." /model gpt-4
copilot -p "..." /model claude-3-opus

# Run parallel agents
copilot -p "..." /fleet principal-engineer cloud-architect senior-engineer

# Resume long session
copilot /resume

# List available models
copilot /model list
```

### Working with Custom Agents

```bash
# Switch to specific agent
copilot /agent principal-engineer
copilot -p "Design our authentication system"

# Invoke agent directly in prompt
copilot -p "Cloud Architect, optimize our cloud costs"
copilot -p "Senior Engineer, implement the API endpoint"

# Autonomous execution (creates PR)
copilot -p "Implement user profile" /delegate senior-engineer
```

### Workflow Example

```bash
# Step 1: Strategic planning
copilot /agent principal-engineer
copilot -p "Design a caching layer for our system" /plan

# Step 2: Infrastructure setup
copilot /agent cloud-architect
copilot -p "Create Terraform for Redis cluster"

# Step 3: Implementation
copilot /agent senior-engineer
copilot -p "Implement cache service in Python"

# Step 4: Testing
copilot -p "Generate comprehensive tests"

# Step 5: Review
copilot /agent principal-engineer
copilot -p "Review implementation for scalability" /resume
```

### Parallel Execution

```bash
# Run multiple agents simultaneously
copilot -p "Your task" /fleet agent1 agent2 agent3

# Example: Plan + implement in parallel
copilot -p "Implement API endpoint" /fleet principal-engineer senior-engineer
```

---

## Team Deployment

### Step 1: Share Configuration

1. Add configuration files to your team's shared repository:

```bash
# In your repository:
git add .github/lsp.json AGENTS.md
git commit -m "Add Copilot CLI configuration and agent definitions"
git push
```

2. Add to your team's README or wiki:

```markdown
## Copilot CLI Setup

1. Install: `brew install copilot-cli` or `npm install -g @github/copilot`
2. Authenticate: `copilot /login`
3. Clone this repository (configuration is automatic)
4. Test: `copilot -p "Explain our authentication system"`

See [AGENTS.md](./AGENTS.md) for agent descriptions and [WALKTHROUGH.md](./WALKTHROUGH.md) for examples.
```

### Step 2: Team Members Set Up

Each team member runs:

```bash
# 1. Install Copilot CLI
brew install copilot-cli  # or: npm install -g @github/copilot

# 2. Authenticate
copilot /login

# 3. Clone repository (configuration is automatic)
git clone <your-repo>
cd <your-repo>

# 4. Test
copilot /agent principal-engineer
copilot -p "Explain our authentication system"
```

### Step 3: Optional - Global Team Setup

For teams using global configuration:

```bash
# 1. Create shared documentation:
# "Team Copilot CLI Setup: Run once per machine"

# 2. Each person runs:
mkdir -p ~/.copilot
cp <path-to-shared-config>/lsp.json ~/.copilot/config.json

# 3. Then use Copilot CLI anywhere
copilot -p "Your task"
```

### Step 4: Enforce Standards (Optional CI/CD)

Add to `.github/workflows/lint.yml`:

```yaml
name: Copilot Config Validation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate LSP config
        run: |
          if [ -f ".github/lsp.json" ]; then
            jq . .github/lsp.json > /dev/null || exit 1
          fi
      - name: Check AGENTS.md exists
        run: '[ -f "AGENTS.md" ] || exit 1'
```

---

## Troubleshooting

### Copilot CLI Not Found

**Problem:** `command not found: copilot`

**Solution:**

```bash
# macOS with Homebrew
brew install copilot-cli

# or with npm
npm install -g @github/copilot

# Verify
copilot --version
```

### Authentication Issues

**Problem:** `Error: Not authenticated` or `Authentication required`

**Solution:**

```bash
# Check auth status
copilot /status

# Re-authenticate
copilot /login

# Or set token
export GITHUB_TOKEN=github_pat_xxxxxxxxxxxx
```

### Configuration Not Loading

**Problem:** Settings in `.github/lsp.json` not being used

**Solution:**

```bash
# Verify file exists
ls -la .github/lsp.json

# Validate JSON syntax
jq . .github/lsp.json

# Check file is readable
cat .github/lsp.json

# Verify precedence by checking global config
ls -la ~/.copilot/config.json
```

### Model Not Available

**Problem:** `Error: Model 'claude-3-opus' not available`

**Solution:**

```bash
# Check available models
copilot /model list

# Use available model
copilot -p "prompt" /model gpt-4

# Update config.json with available model
# Edit ~/.copilot/config.json or .github/lsp.json
```

### Agent Not Found

**Problem:** `Error: Agent 'principal-engineer' not found`

**Solution:**

```bash
# List available agents
copilot /agent list

# Verify AGENTS.md exists
cat AGENTS.md

# Check that agent name in AGENTS.md matches your invocation
copilot /agent principal-engineer
```

### Timeout Issues

**Problem:** Copilot requests timing out

**Solution:**

```bash
# Edit ~/.copilot/config.json or .github/lsp.json
{
  "timeout": {
    "requestTimeoutSeconds": 300,
    "agentTimeoutSeconds": 600
  }
}

# Or via environment
export COPILOT_TIMEOUT=300
```

---

## Monitoring & Logging

### Enable Debug Logging

```bash
# Edit ~/.copilot/config.json or .github/lsp.json
{
  "logging": {
    "level": "debug",
    "enabled": true
  }
}

# Or via environment
export COPILOT_LOG_LEVEL=debug
```

### View Logs

```bash
# Logs are stored in
tail -f ~/.copilot/logs/copilot.log

# Or check recent errors
cat ~/.copilot/logs/error.log
```

---

## Best Practices

1. **Version control config**: Commit `.github/lsp.json` and `AGENTS.md` to git
2. **Secure tokens**: Never commit tokens to git; use environment variables
3. **Approve changes**: Always review file modifications and commands before accepting
4. **Team alignment**: Use global config for team standards
5. **Project overrides**: Use `.github/lsp.json` for project-specific needs
6. **Agent selection**: Be explicit about which agent for complex tasks
7. **Rotate tokens**: Refresh PATs quarterly
8. **Use `/plan` first**: For complex changes, start with planning
9. **Use `/fleet`**: Get parallel perspectives from multiple agents
10. **Resume sessions**: Use `/resume` to continue long-running implementations

---

## Next Steps

1. **Install & Authenticate**: Complete installation and auth steps above
2. **Set up global config**: Create `~/.copilot/config.json`
3. **Add project config**: Create `.github/lsp.json` in your repos
4. **Define agents**: Copy and customize `AGENTS.md`
5. **Test workflow**: Try 3-step workflow (plan → implement → review)
6. **Team rollout**: Share config with your team

---

**Happy using Copilot CLI!** 🚀
