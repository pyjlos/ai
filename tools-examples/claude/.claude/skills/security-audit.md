---
name: security-audit
description: Scan codebase for security vulnerabilities, misconfigurations, and risky patterns
model-invocation: allowed
user-invocable: true
---

# Security Audit Skill

Use this skill to scan your codebase for security issues, vulnerabilities, and risky patterns.

## How It Works

1. **Static Analysis** - Scan for known vulnerability patterns
2. **Configuration Review** - Check security configurations
3. **Dependency Audit** - Review dependencies for known vulnerabilities
4. **Pattern Detection** - Find risky code patterns
5. **Risk Report** - Produce prioritized findings and recommendations

## Usage Examples

```bash
claude --skill security-audit "Audit the entire codebase for security issues"

claude --skill security-audit "Check for hardcoded secrets and insecure patterns in src/"

claude --skill security-audit "Review authentication and authorization implementation"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The audit scope description
- `$1` or `$ARGUMENTS[1]`: (Optional) File path pattern to limit scope (e.g., "src/auth/**")

## What It Checks

### Critical Issues (Block deployment)
- Hardcoded secrets (API keys, passwords, tokens)
- SQL injection vulnerabilities
- Cross-site scripting (XSS) vulnerabilities
- Missing authentication/authorization checks
- Insecure cryptography

### Major Issues (Fix before release)
- Insecure dependency versions
- Missing input validation
- Weak password requirements
- Overly permissive CORS
- Unencrypted sensitive data

### Minor Issues (Address in sprints)
- Logging sensitive data
- Comments revealing internal details
- Missing rate limiting
- Incomplete error handling

## Output Format

The audit produces:
1. **Severity Summary** - Count of issues by severity
2. **Detailed Findings** - Location and explanation of each issue
3. **Recommendations** - Suggestions for remediation
4. **Risk Assessment** - Overall security posture
5. **Priority Fixes** - What to fix first

## When to Use

Run security audits:
- Before any production deployment
- After adding new dependencies
- When onboarding new security practices
- When adding authentication/authorization
- Quarterly as part of maintenance

## Limitations

This is a code analysis tool, not a penetration test:
- Catches common patterns
- May have false positives/negatives
- Doesn't test runtime behavior
- Doesn't verify protection against all attacks
- Should supplement, not replace, professional security review

## Follow-Up

After remediation:
1. Use this skill again to verify fixes
2. Consider professional security review
3. Add security tests to prevent regression
4. Document decisions for deferred issues
