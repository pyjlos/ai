# Testing
 
## Philosophy
 
- Test behaviour, not implementation — tests should survive a refactor without changing
- A test that always passes is worse than no test — it creates false confidence
- Prefer fewer, high-value tests over many shallow ones
- If something is hard to test, that is a signal the design needs simplifying
 
## What to test
 
- Every public function and API endpoint
- All error paths and exception branches — not just the happy path
- Boundary conditions: empty input, zero, None/null, maximum values
- Any business logic that has a cost if it breaks
 
## What not to test
 
- Third-party library behaviour — trust the library's own tests
- Implementation details that are invisible from the outside
- Trivial getters/setters with no logic
 
## Test design
 
- One logical assertion per test — if you need to assert many things, split the test
- Test names should read as sentences: `test_user_cannot_login_with_wrong_password`
- Arrange / Act / Assert — keep setup, action, and assertion clearly separated
- Avoid shared mutable state between tests — each test must be independent and order-agnostic
- Mock at the boundary (network, filesystem, time), not deep inside business logic
 
## Verification
 
- Always run affected tests after making changes — never assume they still pass
- Run the linter and type checker before considering a task done
- Never mark a task complete if any test is failing or skipped without explanation
 