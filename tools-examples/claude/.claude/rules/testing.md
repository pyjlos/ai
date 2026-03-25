# Testing Rules

Applies to: `src/**/*`, `tests/**/*`

## Test Coverage Requirements

- Minimum 80% coverage for general code
- 100% coverage for security-critical code
- 100% coverage for business logic
- All public APIs must have tests

## Test Organization

Test files should be organized:
- Colocated with source: `feature.ts` → `feature.test.ts`
- One describe block per unit
- Clear test names describing behavior
- Arrange-Act-Assert pattern

```typescript
describe('UserService', () => {
  describe('validateEmail', () => {
    it('should return true for valid email addresses', () => {
      // Arrange
      const service = new UserService();
      const email = 'user@example.com';

      // Act
      const result = service.validateEmail(email);

      // Assert
      expect(result).toBe(true);
    });
  });
});
```

## Flaky Tests

Flaky tests are a critical bug. Never commit:
- Tests that depend on timing or order
- Tests with hard timeouts < 5 seconds
- Tests that depend on external services (mock them)
- Tests with random assertions

If you find a flaky test:
1. Fix it before committing
2. If unfixable, flag it with `test.todo()`
3. Create an issue to track it

## Unit vs Integration vs E2E

- **Unit**: Single function/method in isolation, mocked dependencies
- **Integration**: Multiple units together, real database (in test fixture)
- **E2E**: Real system, user workflows

Place tests accordingly:
- `tests/unit/` - Unit tests
- `tests/integration/` - Integration tests
- `tests/e2e/` - End-to-end tests

## Mocking & Fixtures

- Mock external dependencies (APIs, databases, services)
- Use fixtures for consistent test data
- Factories for creating complex test objects
- Never mock the code under test

```typescript
// DO: Mock external dependency
jest.mock('../utils/externalAPI');
const mockFetch = jest.mocked(externalAPI.fetch);

// DON'T: Mock the function you're testing
jest.mock('../service'); // Don't mock what you're testing!
```

## Test Data

- Use factories for creating test objects
- Keep test data realistic but minimal
- Reset database state between tests
- Use transactions that rollback

## Running Tests Before Commit

Always run full test suite:
```bash
npm test              # All tests
npm run test:watch   # Watch mode during development
npm test -- --coverage  # Check coverage
```

No commits without passing tests.

## Critical Path Testing

Business-critical paths must have tests:
- Authentication flows
- Payment/transaction processing
- Data persistence and retrieval
- Error handling
- Edge cases

These functions should have 100% test coverage.
