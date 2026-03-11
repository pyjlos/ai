# File Index & Navigation Guide

Here's what's in the Claude Code evaluation kit and where to find information.

## 📖 Documentation Files (Start Here)

| File | Purpose | Read Time |
|------|---------|-----------|
| **[README.md](./README.md)** | 👈 **START HERE** — Overview and quick start | 10 min |
| **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** | Project-level setup (one repo) | 30 min |
| **[GLOBAL_SETUP.md](./GLOBAL_SETUP.md)** | Global setup (all projects/repos) | 25 min |
| **[WORKFLOW_EXAMPLES.md](./WORKFLOW_EXAMPLES.md)** | Real-world examples and best practices | 20 min |
| **[INDEX.md](./INDEX.md)** | This file — where to find everything | 5 min |

**Recommended reading order:**
1. README.md (overview)
2. Choose path:
   - **For one project**: SETUP_GUIDE.md
   - **For all projects**: GLOBAL_SETUP.md
3. WORKFLOW_EXAMPLES.md (how to use effectively)

---

## 🤖 Agent Definitions

Located in `.claude/agents/`

| Agent | File | What It Does | When to Use |
|-------|------|-------------|------------|
| **Principal Engineer** | `principal-engineer.md` | Strategic technical decisions, 3-5 year vision, organizational impact | Major architecture decisions, technology strategy, mentoring |
| **Cloud Architect** | `cloud-architect.md` | Cloud infrastructure, reliability, disaster recovery, DevOps | Infrastructure design, scaling, disaster recovery, cloud costs |
| **Senior Engineer** | `senior-engineer.md` | Feature implementation, bug fixes, DevOps scripting, shipping code | Building features, fixing bugs, writing infrastructure code |

**Each agent includes:**
- Clear role definition and expertise
- Specific tools they have access to
- What they produce
- Guidelines and best practices

**Usage Examples:**
```bash
# Strategic decision
claude "Principal Engineer, should we migrate to microservices?"

# Infrastructure question
claude "Cloud Architect, design multi-region disaster recovery"

# Feature or bug fix
claude "Senior Engineer, implement user authentication"
```

---

## 📋 Team Standards & Rules

Located in `.claude/`

### Main Standards File
- **[.claude/CLAUDE.md](./.claude/CLAUDE.md)** — Company-wide coding standards
  - Supported languages (Python, JavaScript/TypeScript, Go)
  - Code quality requirements by language
  - Testing expectations
  - Security practices
  - Documentation and review guidelines
  - Team workflow with the three agents

Automatically injected into every Claude Code session.

### Language-Specific Rules
Located in `.claude/rules/`

| Rule | File | Content |
|------|------|---------|
| **Python** | `python.md` | Black formatting, Ruff linting, pytest, type hints |
| **JavaScript/TypeScript** | `javascript.md` | Prettier formatting, ESLint, TypeScript strict mode, React patterns |
| **Go** | `go.md` | gofmt, golangci-lint, error handling, interfaces |
| **Security** | `security.md` | Secrets protection, input validation, authentication, logging |
| **Testing** | `testing.md` | Coverage targets, test organization, flaky tests |

Path-specific rules that guide Claude on different types of code.

---

## 🛠️ Reusable Skills

Located in `.claude/skills/`

Skills are workflows you invoke repeatedly.

| Skill | File | Usage |
|-------|------|-------|
| **Batch Refactor** | `batch-refactor.md` | Refactor code across multiple files systematically |
| **Security Audit** | `security-audit.md` | Scan codebase for security vulnerabilities |
| **Generate Tests** | `generate-tests.md` | Auto-generate unit and integration tests |

**Usage:**
```bash
claude --skill batch-refactor "Rename function X to Y across codebase"
claude --skill security-audit "Scan for vulnerabilities"
claude --skill generate-tests "Write tests for UserService"
```

---

## ⚙️ Configuration

| File | Purpose |
|------|---------|
| **[.claude/settings.json](./.claude/settings.json)** | Permissions, tool restrictions, environment setup |
| **[.mcp.json](./.mcp.json)** | MCP server configuration for integrations |

### settings.json
Defines:
- Agent permission models (who can do what)
- Tool access by agent type
- Safety guardrails (blocked commands)
- Language and tool configuration

### .mcp.json
Configures:
- GitHub integration
- Slack integration
- Filesystem access
- Authentication settings

---

## 🚨 Automation Hooks

Located in `.claude/hooks/`

Scripts that run automatically to enforce quality and safety.

| Hook | File | What It Does |
|------|------|-------------|
| **Pre-Commit** | `pre-commit.sh` | Blocks commits with secrets, .env files |
| **Post-Implementation** | `post-implementation.sh` | Runs tests and linter after implementation |

Both hooks:
- Prevent common mistakes
- Enforce standards
- Provide clear feedback
- Are easily customizable

---

## 📊 File Structure

```
claude/
├── README.md                    ← Start here
├── SETUP_GUIDE.md              ← Project-level setup
├── GLOBAL_SETUP.md             ← Global setup (all projects)
├── WORKFLOW_EXAMPLES.md        ← Real-world patterns
├── INDEX.md                    ← This file
├── setup.sh                    ← Installation script
│
├── .claude/                    ← Core configuration
│   ├── CLAUDE.md              ← Team standards (auto-injected)
│   ├── settings.json          ← Permissions & config
│   ├── agents/                ← Agent definitions
│   │   ├── principal-engineer.md
│   │   ├── cloud-architect.md
│   │   └── senior-engineer.md
│   ├── rules/                 ← Language-specific guidance
│   │   ├── python.md
│   │   ├── javascript.md
│   │   ├── go.md
│   │   ├── security.md
│   │   └── testing.md
│   ├── skills/                ← Reusable workflows
│   │   ├── batch-refactor.md
│   │   ├── security-audit.md
│   │   └── generate-tests.md
│   └── hooks/                 ← Automation scripts
│       ├── pre-commit.sh
│       └── post-implementation.sh
│
└── .mcp.json                  ← MCP integrations
```

---

## ❓ FAQs

**Q: Where do I start?**
A: Read README.md, then SETUP_GUIDE.md or GLOBAL_SETUP.md

**Q: How do I use the agents?**
A: `claude "Principal Engineer, what you want"`
See WORKFLOW_EXAMPLES.md for patterns

**Q: Can I customize this?**
A: Yes! Edit agents, rules, skills, and CLAUDE.md

**Q: What languages are supported?**
A: Python, JavaScript/TypeScript, Go. Each has its own rules file.

**Q: How do I add integrations?**
A: Edit .mcp.json or use `claude mcp add`

**Q: Is this secure?**
A: Yes. settings.json defines fine-grained permissions, and hooks block dangerous operations

**Q: Can my whole team use this?**
A: Yes. This is designed for teams. Follow GLOBAL_SETUP.md for team-wide deployment.

---

## 🚀 Next Steps

**Choose your path:**

### Path A: Single Project Setup (30 min)
1. **Read README.md** (5 min) — Get the overview
2. **Follow SETUP_GUIDE.md** (20 min) — Set up one project
3. **Try the agents** (5 min) — See them in action
4. **Explore WORKFLOW_EXAMPLES.md** — Learn usage patterns

### Path B: Global Setup (40 min)
1. **Read README.md** (5 min) — Get the overview
2. **Follow GLOBAL_SETUP.md** (25 min) — Set up globally
3. **Try the agents** (5 min) — See them in action
4. **Explore WORKFLOW_EXAMPLES.md** — Learn usage patterns

### Path C: Both (combine strategies)
1. **Read README.md** (5 min)
2. **Follow GLOBAL_SETUP.md** (25 min) — Set team defaults
3. **Follow SETUP_GUIDE.md** (20 min) — Project-specific overrides
4. **WORKFLOW_EXAMPLES.md** — Real patterns

---

**Questions? Check the documentation or see official resources at the top of each file.**

*Last updated: March 2025*
