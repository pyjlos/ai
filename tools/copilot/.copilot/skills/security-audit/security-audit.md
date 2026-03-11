---
name: security-audit
description: Scan code for security issues and suggest hardening improvements
model-invocation: allowed
user-invocable: true
---

# Security Audit Skill

Use this skill to review code for security vulnerabilities, unsafe patterns, and misconfigurations.

## Usage Examples

```bash
copilot --skill security-audit "Audit the authentication module for security issues"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The area or module to audit
- `$1` or `$ARGUMENTS[1]`: (Optional) File path pattern to limit the scan
