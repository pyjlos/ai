---
name: generate-tests
description: Auto-generate unit and integration tests for existing code
model-invocation: allowed
user-invocable: true
---

# Generate Tests Skill

Use this skill to automatically generate tests for functions, modules, or services in the codebase.

## Usage Examples

```bash
copilot --skill generate-tests "Write unit tests for src/services/user_service.py"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The code area or feature to generate tests for
- `$1` or `$ARGUMENTS[1]`: (Optional) File path pattern to narrow scope
