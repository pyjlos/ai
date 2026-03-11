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
claude --skill batch-refactor "Rename all 'getUserData' functions to 'fetchUser' across the codebase"

claude --skill batch-refactor "Update error handling to use custom Error classes instead of generic Error"

claude --skill batch-refactor "Add input validation to all API endpoint handlers"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The refactoring task description
- `$1` or `$ARGUMENTS[1]`: (Optional) File path pattern to limit scope (e.g., "src/services/**")

## Workflow

### Phase 1: Analysis
- Search for all matches to the pattern
- Group them by file or logical unit
- Identify dependencies

### Phase 2: Planning
- Create detailed refactoring plan
- Identify test impacts
- Plan for potential breaking changes

### Phase 3: Execution
- Make changes in logical batches (5-10 files per batch)
- Run tests after each batch
- Commit each batch

### Phase 4: Verification
- Run full test suite
- Check for missed instances
- Verify no regressions

### Phase 5: Summary
- Document all changes
- Highlight any manual follow-up needed
- Create commit summary

## Safety Guardrails

- Never delete code without explicit confirmation
- Always run tests before moving to next batch
- Never refactor without understanding dependencies
- Flag breaking changes explicitly

## Example: Renaming a Function

```bash
claude --skill batch-refactor "Rename getUser to fetchUser everywhere"
```

This would:
1. Find all occurrences of `getUser`
2. Group by file
3. Rename in batches
4. Test each batch
5. Summarize changes

## When to Use

Perfect for:
- Renaming functions/variables across multiple files
- Updating error handling patterns
- Adding consistency to similar code
- Updating API patterns
- Migrating to new library versions

Not ideal for:
- Complex logic changes (use implementer agent directly)
- Changes requiring deep understanding (use architect first)
- One-off fixes (too heavy weight)
