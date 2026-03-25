---
inclusion: always
---

# Testing Standards

## Coverage Requirements

- General code: 80% minimum
- Security-critical paths: 100%
- Business logic: 100%
- All public APIs must have tests

## Test Organization

- Test files colocated with source: `feature.ts` → `feature.test.ts`
- One describe block per unit (function, class, service)
- Arrange-Act-Assert pattern
- Tests must be deterministic and fast (< 100ms per unit test)

## What Not to Do

- Do not mock the module under test — only mock external dependencies
- Do not commit tests that depend on timing, test order, or external services
- Do not leave flaky tests — treat them as bugs

## Test Levels

- **Unit**: Single function/method in isolation with mocked dependencies
- **Integration**: Multiple units together with a real test database
- **E2E**: Full system, user-facing critical workflows
