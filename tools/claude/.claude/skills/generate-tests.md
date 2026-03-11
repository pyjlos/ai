---
name: generate-tests
description: Generate comprehensive unit and integration tests for specified functions or modules
model-invocation: allowed
user-invocable: true
---

# Generate Tests Skill

Use this skill to automatically generate comprehensive test suites for functions, classes, or modules.

## How It Works

1. **Analyze Code** - Understand the function/class implementation
2. **Identify Test Cases** - Plan unit test scenarios
3. **Generate Tests** - Create test code
4. **Add Edge Cases** - Include boundary conditions
5. **Verify Coverage** - Ensure good coverage

## Usage Examples

```bash
claude --skill generate-tests "Write comprehensive tests for the User model"

claude --skill generate-tests "Generate tests for the payment processing service"

claude --skill generate-tests "Create integration tests for the auth API endpoints"
```

## Arguments

- `$0` or `$ARGUMENTS[0]`: The module/file to test
- `$1` or `$ARGUMENTS[1]`: (Optional) Test type: "unit", "integration", or "all"

## What Gets Generated

### Unit Tests
- Happy path tests
- Error case tests
- Boundary condition tests
- Type validation tests
- Return value verification

### Integration Tests
- Cross-module interactions
- Database operations (with fixtures)
- External service calls (mocked)
- Error propagation
- State changes

### Test Structure
- Clear describe blocks
- Descriptive test names
- Arrange-Act-Assert pattern
- Proper fixtures and mocks
- Cleanup after tests

## Test Characteristics

Generated tests:
- ✅ Are deterministic and non-flaky
- ✅ Run quickly (< 100ms per unit test)
- ✅ Use realistic test data
- ✅ Have clear assertions
- ✅ Mock external dependencies
- ✅ Include edge cases
- ✅ Use factories for complex objects
- ✅ Clean up after themselves

## Coverage Target

Tests aim for:
- 80%+ code coverage
- 100% coverage of critical paths
- All branches tested
- Happy and error paths

## Review & Customize

Generated tests are a starting point:
1. Review for correctness
2. Adjust test data if needed
3. Add domain-specific test cases
4. Verify they actually test behavior
5. Customize assertions as needed

## When to Use

Use for:
- New function implementation (write tests alongside)
- Adding tests to existing code
- Improving test coverage
- Creating integration tests
- Generating test stubs to fill in

Don't use for:
- Test-driven development (write tests first, manually)
- Complex domain logic (need domain expertise)
- UI component testing (use specialized tools)

## Limitations

Generated tests:
- May miss domain-specific edge cases
- Can't fully replace developer expertise
- Work best with clear, well-written code
- Benefit from review and customization

The skill provides a solid foundation; developers add the domain knowledge.
