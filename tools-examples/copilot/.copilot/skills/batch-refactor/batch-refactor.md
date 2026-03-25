---
name: batch-refactor
description: Refactor and update code across multiple files in a codebase systematically
model-invocation: allowed
user-invocable: true
---

# Batch Refactor Skill

Use this skill to refactor code across multiple files in an organized, testable way.

## How It Works

1. **Understand the full scope** - Identify all files that need changes
2. **Plan the refactoring** - Outline the transformation approach
3. **Execute in batches** - Make changes in logical groups
4. **Verify at each step** - Run tests after each batch
5. **Summarize changes** - Document what changed and why

## Usage Examples

```bash
copilot --skill batch-refactor "Rename all 'getUserData' functions to 'fetchUser' across the codebase"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The refactoring task description
- `$1` or `$ARGUMENTS[1]`: (Optional) File path pattern to limit scope (e.g., "src/services/**")
