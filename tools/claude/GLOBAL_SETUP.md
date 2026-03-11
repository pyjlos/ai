# Global Setup — Use Claude Code Across All Projects

This guide shows how to set up the Claude Code evaluation kit **globally** so your agents, standards, and rules apply to **every project** on your machine.

## Why Global Setup?

| Scenario | Benefit |
|----------|---------|
| **You work on multiple projects** | Same standards everywhere |
| **Team standards** | Everyone uses the same agents and rules |
| **Less duplication** | Configure once, use everywhere |
| **Consistency** | All repos follow same practices |
| **Easy onboarding** | New projects automatically use team setup |

---

## Quick Start (2 minutes)

```bash
# 1. Copy the kit to your home directory
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude

# 2. Copy MCP configuration
cp /Users/philiplee/repos/ai/tools/claude/.mcp.json ~/.mcp.json

# 3. Done! Now all projects use these agents and standards
cd any-project
claude "Principal Engineer, should we migrate to microservices?"  # It works!
```

---

## How it Works

Claude Code looks for configuration in this order (highest to lowest priority):

```
1. Project-level:    .claude/ (in your repo)
                     ↓ overrides ↓
2. User-level:       ~/.claude/ (your home directory)
                     ↓ overrides ↓
3. System defaults:   Built-in Claude Code standards
```

### Example: Configuration Cascade

```bash
# Global setup (applies to all projects)
~/.claude/CLAUDE.md
~/.claude/agents/
~/.claude/rules/
~/.mcp.json

# Project 1 can use global setup as-is
my-project-1/
  # No .claude/ → uses ~/.claude/

# Project 2 can override with specific rules
my-project-2/
  .claude/CLAUDE.md  # Overrides ~/.claude/CLAUDE.md
  .claude/agents/
  # rules/ still come from ~/.claude/rules/

# Project 3 can completely override
my-project-3/
  .claude/          # Complete override of ~/.claude/
```

---

## Step-by-Step Global Setup

### Step 1: Choose Your Setup Location

**Option A: Home Directory (Recommended)**

Most user-friendly. Claude Code automatically finds `~/.claude/`:

```bash
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude
```

**Option B: Custom Location**

If you prefer a different location:

```bash
# Example: Put in a tools directory
mkdir -p ~/tools
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/tools/.claude

# Then configure Claude Code to find it
export CLAUDE_CONFIG_DIR=~/tools/.claude
```

We'll use **Option A** in the rest of this guide.

### Step 2: Set Up User-Level Configuration

```bash
# Copy agents, standards, and rules
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude

# Copy MCP configuration
cp /Users/philiplee/repos/ai/tools/claude/.mcp.json ~/.mcp.json

# Verify it was copied
ls -la ~/.claude/
# Should show: CLAUDE.md, agents/, rules/, skills/, hooks/, settings.json
```

### Step 3: Verify the Setup

```bash
# Test that Claude Code finds your configuration
claude --version

# Test with a real project
cd ~/my-project
claude "Principal Engineer, what's the architecture of this project?"
```

If Claude Code responds with the principal-engineer agent's analysis, **it worked!**

### Step 4: (Optional) Update CLAUDE.md for Your Team

Edit `~/.claude/CLAUDE.md` to customize team standards:

```bash
# Edit your global standards
nano ~/.claude/CLAUDE.md

# Or use your preferred editor
code ~/.claude/CLAUDE.md
```

Changes:
- Update supported tech stack if different (currently Python, JavaScript/TypeScript, Go)
- Adjust testing requirements
- Modify naming conventions
- Add company-specific practices
- Update team workflow section with your agent process

Then customize language-specific rules:

```bash
# Edit Python standards
nano ~/.claude/rules/python.md

# Edit JavaScript/TypeScript standards
nano ~/.claude/rules/javascript.md

# Edit Go standards
nano ~/.claude/rules/go.md

# Edit cross-cutting rules
nano ~/.claude/rules/security.md
nano ~/.claude/rules/testing.md
```

These changes apply to **all projects** automatically.

### Step 5: (Optional) Configure MCP Tokens

Add authentication for integrations:

```bash
# For GitHub integration
export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxx

# For Slack integration
export SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxx

# Add to ~/.bashrc or ~/.zshrc to persist
echo "export GITHUB_PERSONAL_ACCESS_TOKEN=..." >> ~/.bashrc
```

Then configure MCP:

```bash
# GitHub
claude mcp add github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN \
  -- npx -y @modelcontextprotocol/server-github

# Slack
claude mcp add slack \
  -e SLACK_BOT_TOKEN=$SLACK_BOT_TOKEN \
  -- npx -y @modelcontextprotocol/server-slack
```

---

## Global vs. Project-Level Configuration

### When to Use Global Setup

Use `~/.claude/` when:
- ✅ Everyone on the team should follow the same standards
- ✅ You work on multiple projects with similar practices
- ✅ You want consistent agents across all repos
- ✅ You rarely need project-specific overrides

### When to Use Project-Level Setup

Create `.claude/` in your repo when:
- ✅ A specific project has unique requirements
- ✅ You need to override team standards for that repo
- ✅ The project has its own MCP integrations
- ✅ You want to version control project-specific config

### Best Practice: Hybrid Approach

```bash
# Global setup (team standards, shared across all languages)
~/.claude/CLAUDE.md                    # Your team standards
~/.claude/agents/                      # All 3 agents
│   ├── principal-engineer.md
│   ├── cloud-architect.md
│   └── senior-engineer.md
~/.claude/rules/                       # Language-specific & cross-cutting
│   ├── python.md                      # Python standards
│   ├── javascript.md                  # JS/TS standards
│   ├── go.md                          # Go standards
│   ├── security.md                    # All languages
│   └── testing.md                     # All languages
~/.claude/skills/                      # Reusable workflows
~/.mcp.json                            # GitHub, Slack, filesystem access

# Project overrides (when needed, for specific repos)
my-project/.claude/CLAUDE.md           # Project-specific standards if needed
my-project/.claude/rules/security.md   # Stricter security for sensitive project
```

---

## File Structure After Global Setup

After running the global setup, your home directory will have:

```
~
├── .claude/
│   ├── CLAUDE.md                    ← Team standards & coding guidelines
│   ├── settings.json                ← Global permissions & safety
│   │
│   ├── agents/
│   │   ├── principal-engineer.md    ← Strategic decisions, architecture
│   │   ├── cloud-architect.md       ← Infrastructure, reliability, DevOps
│   │   └── senior-engineer.md       ← Implementation, features, scripting
│   │
│   ├── rules/
│   │   ├── python.md                ← Python conventions (Black, Ruff, pytest)
│   │   ├── javascript.md            ← JavaScript/TypeScript (Prettier, ESLint)
│   │   ├── go.md                    ← Go conventions (gofmt, golangci-lint)
│   │   ├── security.md              ← Security best practices
│   │   └── testing.md               ← Testing requirements
│   │
│   ├── skills/
│   │   ├── batch-refactor.md
│   │   ├── security-audit.md
│   │   └── generate-tests.md
│   │
│   └── hooks/
│       ├── pre-commit.sh
│       └── post-implementation.sh
│
├── .mcp.json                        ← MCP integrations (GitHub, Slack)
│
└── repos/
    ├── python-project/              ← Uses ~/.claude/ with python.md rules
    ├── js-frontend/                 ← Uses ~/.claude/ with javascript.md rules
    ├── go-service/                  ← Uses ~/.claude/ with go.md rules
    └── special-project/.claude/     ← Overrides ~/.claude/ with project-specific
```

---

## Using Claude Code After Global Setup

### With Any Project

```bash
cd any-project-anywhere

# Strategic decisions (principal-engineer agent)
claude "Principal Engineer, should we migrate to microservices?"
claude "Principal Engineer, design a 3-year technical roadmap"

# Infrastructure & cloud design (cloud-architect agent)
claude "Cloud Architect, design multi-region disaster recovery"
claude "Cloud Architect, optimize our cloud costs"
claude "Cloud Architect, design a CI/CD pipeline for safe deployments"

# Implementation & features (senior-engineer agent)
claude "Senior Engineer, implement user authentication"
claude "Senior Engineer, write Terraform for staging environment"
claude "Senior Engineer, fix this production performance issue"

# Skills work globally (language-agnostic)
claude --skill batch-refactor "Rename function X to Y across codebase"
claude --skill security-audit "Scan for vulnerabilities"
claude --skill generate-tests "Write tests for UserService"

# MCP integrations work globally
claude "Search GitHub for authentication examples"
```

### Understanding Language-Specific Rules

The agents automatically apply the right rules based on the file type:

```bash
# Python projects automatically use python.md rules
claude "Senior Engineer, implement the data pipeline in Python"
# → Uses: Black formatter, Ruff linter, pytest framework, type hints

# JavaScript/TypeScript projects automatically use javascript.md rules
claude "Senior Engineer, implement the React component"
# → Uses: Prettier formatter, ESLint, TypeScript strict mode

# Go projects automatically use go.md rules
claude "Senior Engineer, implement the API service in Go"
# → Uses: gofmt formatter, golangci-lint, proper error handling
```

### Override for Specific Project

If a project needs different standards:

```bash
cd special-project

# Copy just what you need to override
mkdir -p .claude/rules
cp ~/.claude/CLAUDE.md .claude/
# Edit the local version
nano .claude/CLAUDE.md

# Now this project uses local .claude/CLAUDE.md
# But still uses ~/.claude/agents/, ~/.claude/skills/, etc.
```

---

## Team Deployment

### For Your Development Team

To roll out to your team:

1. **Create a shared repo** with your configured `.claude/`
   ```bash
   # In your central config repo
   mkdir -p config/claude-code
   cp -r ~/.claude config/claude-code/
   cp ~/.mcp.json config/claude-code/
   ```

2. **Document the setup** in your team wiki
   ```markdown
   ## Claude Code Setup

   Copy to your home directory:
   ```bash
   cp -r <repo>/config/claude-code/.claude ~/.claude
   cp <repo>/config/claude-code/.mcp.json ~/.mcp.json
   ```
   ```

3. **Each team member runs:**
   ```bash
   # Copy team configuration
   cp -r /path/to/shared-config/.claude ~/.claude

   # Authenticate with their own API key
   claude login

   # Optionally add their own MCP tokens
   export GITHUB_TOKEN=...
   ```

4. **All team members** now have:
   - Three specialized agents (principal-engineer, cloud-architect, senior-engineer)
   - Consistent coding standards across Python, JavaScript/TypeScript, and Go
   - Language-specific rules and conventions
   - Shared skills for batch refactoring, security audits, test generation
   - Consistent security and testing practices

---

## Updating Global Configuration

### Update to Latest Standards

When you update team standards:

```bash
# 1. Update your local ~/.claude/
nano ~/.claude/CLAUDE.md

# 2. Test it
cd any-project
claude --show-config  # Verify it's loading

# 3. Share with team
# If in shared repo, push changes
git -C ~/shared-config/ add -A && git commit -m "Update standards"
git push

# 4. Team members pull latest
cp -r /path/to/shared-config/.claude ~/.claude
```

### Add New Skill Globally

```bash
# Create new skill in your global skills directory
cat > ~/.claude/skills/my-workflow.md << 'EOF'
---
name: my-workflow
description: My custom workflow
---

[skill content]
EOF

# Now available to all projects
claude --skill my-workflow "argument"
```

### Customize for Your Team

```bash
# Edit global standards
nano ~/.claude/CLAUDE.md

# Update for your tech stack and workflow
# - Change supported languages if needed (currently Python, JS/TS, Go)
# - Update agent roles and descriptions if needed
# - Modify testing expectations
# - Add your company practices

# Customize language-specific rules
nano ~/.claude/rules/python.md       # Update Python tooling/versions
nano ~/.claude/rules/javascript.md   # Update JS/TS tooling/versions
nano ~/.claude/rules/go.md           # Update Go tooling/versions

# Test it
cd test-project
claude "What are your coding standards?"
# Should show your customized standards for the appropriate language
```

---

## Troubleshooting Global Setup

### Claude Code Not Finding Global Config

**Problem**: Agents/standards not available

**Solutions**:

```bash
# 1. Check if ~/.claude/ exists
ls -la ~/.claude/

# 2. If not, copy it again
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude

# 3. Verify Claude Code sees it
claude --show-config  # Should show ~/.claude/ paths

# 4. Restart terminal
exec $SHELL
```

### MCP Not Working Globally

**Problem**: GitHub/Slack integrations not available

**Solutions**:

```bash
# 1. List configured MCP servers
claude mcp list

# 2. If missing, add them
claude mcp add github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN \
  -- npx -y @modelcontextprotocol/server-github

# 3. Verify tokens are set
echo $GITHUB_TOKEN
echo $SLACK_BOT_TOKEN

# 4. Test
claude "Search GitHub for repos"
```

### Agents Available Locally but Not Globally

**Problem**: `.claude/agents/` in project work, but `~/.claude/agents/` don't

**Solution**: Ensure `.claude/` directory structure is correct

```bash
# Check structure
ls -la ~/.claude/
# Should show: CLAUDE.md, agents/, rules/, skills/, hooks/, settings.json

# Check agents are present
ls -la ~/.claude/agents/
# Should show: principal-engineer.md, cloud-architect.md, senior-engineer.md

# If agents/ missing, copy it
cp -r /Users/philiplee/repos/ai/tools/claude/.claude/agents ~/.claude/
```

---

## Migrating to Global Setup

### If You Already Have Project-Level Setup

```bash
# 1. Back up your current project setups
find ~/repos -name ".claude" -type d | xargs -I {} cp -r {} {}.backup

# 2. Set up global
cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude

# 3. Remove duplicates from projects (optional)
# Now that it's global, you can remove .claude/ from individual projects
# They'll use ~/.claude/ instead

# 4. Or keep project-specific overrides where needed
# Some projects can still have .claude/ for custom rules
```

---

## Advanced: Multiple Configurations

### Use Different Configs for Different Teams or Projects

```bash
# Create different configs for different languages or team groups
cp -r ~/.claude ~/.claude-python        # For Python-heavy teams
cp -r ~/.claude ~/.claude-typescript    # For TypeScript/React teams
cp -r ~/.claude ~/.claude-devops        # For Go/DevOps teams

# Edit each for their specific language focus
nano ~/.claude-python/CLAUDE.md         # Update for Python focus

# Symlink based on project type
cd python-data-pipeline
ln -s ~/.claude-python .claude

cd typescript-api
ln -s ~/.claude-typescript .claude

cd devops-infrastructure
ln -s ~/.claude-devops .claude
```

### Use Environment Variable

```bash
# Export config location per session
export CLAUDE_CONFIG_DIR=~/.claude-team-a

# Or per project
cd team-a-project
export CLAUDE_CONFIG_DIR=~/.claude-team-a
claude "Researcher, analyze this"
```

---

## Summary

### Global Setup Benefits

✅ **Single source of truth** — One place to manage standards
✅ **Consistency** — All projects follow same practices
✅ **Easy updates** — Change standards once, apply everywhere
✅ **Less duplication** — Config defined once, used everywhere
✅ **Team alignment** — Everyone uses same agents and rules
✅ **New projects ready** — No setup needed, just start using

### What to Do Now

1. **Copy globally** (2 min):
   ```bash
   cp -r /Users/philiplee/repos/ai/tools/claude/.claude ~/.claude
   cp /Users/philiplee/repos/ai/tools/claude/.mcp.json ~/.mcp.json
   ```

2. **Customize** (15 min):
   ```bash
   nano ~/.claude/CLAUDE.md              # Update team standards
   nano ~/.claude/rules/python.md        # Update Python specifics
   nano ~/.claude/rules/javascript.md    # Update JS/TS specifics
   nano ~/.claude/rules/go.md            # Update Go specifics
   nano ~/.mcp.json                      # Add your MCP tokens (optional)
   ```

3. **Test** (5 min):
   ```bash
   cd any-project
   claude "Principal Engineer, what should our architecture be?"
   ```

4. **Share with team** (when ready):
   - Document in team wiki
   - Put in shared config repo
   - Have team members copy to `~/.claude/`
   - They only need to run `claude login` for their API key

---

## Next Steps

- **[README.md](./README.md)** — Overview of the kit and three agent roles
- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** — Project-level setup
- **[WORKFLOW_EXAMPLES.md](./WORKFLOW_EXAMPLES.md)** — How to use agents effectively
- **[INDEX.md](./INDEX.md)** — File navigation guide

---

**Global setup complete!** Now all your projects have access to your three agents (principal-engineer, cloud-architect, senior-engineer), language-specific rules, standards, and integrations. 🚀
