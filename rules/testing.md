# Testing
 
## Philosophy
 
- Test behaviour, not implementation — tests should survive a refactor without changing
- A test that always passes is worse than no test — it creates false confidence
- Prefer fewer, high-value tests over many shallow ones
- If something is hard to test, that is a signal the design needs simplifying
 
## What to test
 
- Every public function containing business logic or with a non-trivial error surface, and every API endpoint
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
- High coverage is not evidence the tests work — a suite can execute every line and still assert nothing meaningful. For business-critical logic (payment, auth, security, data integrity), run mutation testing on the changed lines before calling the tests done: Mutmut for Python, StrykerJS for TypeScript/JavaScript, Stryker.NET for C#, PIT for Java/JVM
- A surviving mutant means the suite didn't catch that fault, regardless of coverage percentage. For each survivor, either add the assertion that kills it or document why the mutant is equivalent (behaviorally identical to the original) — don't chase a 100% mutation score blindly
 