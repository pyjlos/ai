# CLAUDE.md — Team Coding Standards & Conventions

This file defines team-wide standards, coding conventions, and workflow expectations for Claude Code. It's injected into every Claude Code session to ensure consistency.

## Table of Contents

1. [Languages](#supported-languages)
2. [Code Quality Standards](#code-quality-standards)
3. [Testing Requirements](#testing-requirements)
4. [Error Handling](#error-handling)
5. [Security Requirements](#security-requirements)
6. [Documentation Standards](#documentation-standards)
7. [Code Review Guidelines](#code-review-guidelines)
8. [Team Workflow](#team-workflow)

---

## Supported Languages

This team supports three primary languages:

- **Python** — Data processing, ML, backend services
- **JavaScript/TypeScript** — Frontend, Node.js backend, full-stack
- **Go** — DevOps, infrastructure, high-performance services

Each language has specific style rules in `.claude/rules/`:
- `python.md` — Python conventions
- `javascript.md` — JavaScript/TypeScript conventions
- `go.md` — Go conventions

## Code Quality Standards

### General Principles
- **Readability first**: Code is written once, read many times
- **Self-documenting**: Good naming and structure eliminate the need for comments
- **Explicit over implicit**: Ambiguity should never exist in code
- **Small functions**: Functions should do one thing well
- **DRY**: Don't repeat yourself, but avoid over-abstraction

### Standards by Language
- **Python**: See `.claude/rules/python.md`
- **JavaScript/TypeScript**: See `.claude/rules/javascript.md`
- **Go**: See `.claude/rules/go.md`

---

## Testing Requirements

### Coverage Targets
- **Unit tests**: 80% coverage minimum
- **Critical paths**: 100% coverage
- **Integration tests**: All API endpoints
- **E2E tests**: User-facing critical workflows

### Test Guidelines
- Clear test names that describe behavior
- Arrange-Act-Assert pattern
- Use descriptive variable names
- Mock dependencies, not behavior
- Tests must be deterministic and fast (< 100ms per unit test)

### Test Organization
- Test files live next to source files
- One describe block per unit (function, class, service)
- Flaky tests are treated as bugs

---

## Error Handling

### Principles
- Never silently swallow errors
- Distinguish between expected and unexpected errors
- Provide actionable error messages
- Log appropriately for debugging

### By Language
- **Python**: Return error objects or raise custom exceptions
- **JavaScript/TypeScript**: Use try/catch or Promise rejection handling
- **Go**: Follow Go error conventions (error as last return value)

---

## Security Requirements

### Sensitive Data Protection
- No hardcoded secrets, API keys, or credentials
- Use environment variables for secrets
- `.env` file is gitignored
- Secrets rotated every 90 days minimum

### Input Validation
- All user input is validated
- Whitelist allowed values, not blacklist bad ones
- Validate type, length, and format
- Sanitize HTML/SQL inputs

### Dependency Management
- Run security audit regularly (`pip audit`, `npm audit`, `go list -m all`)
- Update security patches immediately
- Review major version updates before upgrading
- Use exact versions in updates

### Logging
- Never log sensitive data (passwords, tokens, SSNs, etc.)
- Be careful with personally identifiable information
- Redact anything that could leak from logs

---

## Documentation Standards

### Code Comments
- Comment *why*, not *what*
- Self-documenting code needs fewer comments
- Use language-specific doc formats (docstrings, JSDoc, comments)

### API Documentation
- Document all endpoints
- Include request/response examples
- Document edge cases and errors
- Keep documentation in sync with code

### README Requirements
- Project description and purpose
- Quick start guide
- Installation instructions
- How to run tests
- Environment variables needed

---

## Code Review Guidelines

### What Reviewers Should Check
1. **Correctness**: Does this solve the stated problem?
2. **Tests**: Is the behavior covered by tests?
3. **Security**: Are there security implications?
4. **Maintainability**: Is this code clear and maintainable?
5. **Performance**: Are there obvious performance issues?

### Review Standards
- Reviews should happen within 24 hours
- Blocks only on critical issues (security, correctness)
- Be constructive and helpful
- Suggest improvements, don't just criticize
- Approve once satisfied with quality

---

## Team Workflow

### Three Agent Roles

Your team uses three specialized agents, each with different expertise:

#### 1. Principal Engineer
- Focuses on: Strategic technical decisions, 3-5 year vision, organization
- When to use: Major architectural decisions, technology strategy, mentoring senior engineers
- What they produce: Architecture vision, technical roadmaps, risk assessments

#### 2. Cloud Architect
- Focuses on: Cloud infrastructure, reliability, scalability, DevOps
- When to use: Infrastructure design, disaster recovery, cloud cost optimization
- What they produce: Infrastructure designs, Terraform reviews, SLA/SLO definitions

#### 3. Senior Engineer
- Focuses on: Implementation, code quality, DevOps scripting, shipping features
- When to use: Building features, fixing bugs, writing Terraform/infrastructure code
- What they produce: Shipping code, tests, CI/CD pipelines, documentation

### How to Use the Agents

```bash
# Strategic decision
claude "Principal Engineer, should we migrate from monolith to microservices?"

# Infrastructure question
claude "Cloud Architect, design multi-region disaster recovery"

# Feature or bug fix
claude "Senior Engineer, implement the user profile feature"
```

---

## Git & Version Control

### Branch Strategy
- **main**: Production-ready code, protected branch
- **develop**: Integration branch for features
- **feature/**: Feature branches from develop
- **fix/**: Bug fix branches from main
- **docs/**: Documentation-only changes

### Commit Standard
- Small, focused commits (one feature per commit)
- Commit messages explain *why*, not just *what*
- Format: `<type>(<scope>): <subject>`

### Pull Request Standards
- Title describes the change clearly
- Description explains context and testing
- Link to related issues
- Code review approval before merge
- CI/CD checks all pass

---

## Performance Expectations

### Response Times
- API endpoints: < 500ms for 95th percentile
- Database queries: < 100ms for 95th percentile
- Page load time: < 3 seconds for initial load
- Critical business operations: < 2 seconds

### Optimization Priorities (in order)
1. Correctness (first)
2. Clarity and maintainability
3. Performance (only optimize if measured need)
4. Minimal code

### Anti-Patterns
- ❌ N+1 queries (load relationship for each item)
- ❌ Full table scans without indexes
- ❌ Synchronous work in loops
- ❌ Large data transfers for small results
- ❌ Repeated calculations without caching

---

**Last Updated**: March 2025
**Maintained By**: Engineering Team
**Review Frequency**: Quarterly
