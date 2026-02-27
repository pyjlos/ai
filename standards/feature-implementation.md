# Feature Implementation Standards

## Design First, Code Second
Before implementation:
- Define business requirements.
- Define non-functional requirements.
- Identify success metrics.
- Identify failure scenarios.

Every feature must have:
- Clear acceptance criteria.
- Test strategy.
- Rollback strategy.

---

## Keep Features Isolated
Features should:
- Live within bounded domains.
- Avoid cross-service logic.
- Communicate via APIs or events.

Avoid:
- Shared mutable state.
- Business logic in UI or infrastructure layers.

---

## Complexity Control
Prefer:
- Composition over inheritance.
- Simple control flow over clever abstractions.

If code requires extensive comments to understand:
- The design is likely too complex.

---

## Validation & Safety
All inputs must be validated.

Include:
- Type validation
- Schema validation
- Boundary validation

Never trust external inputs.

---

## Testing Requirements
Minimum required:
- Unit tests for business logic.
- Integration tests for external dependencies.
- Contract tests for APIs.

Critical features require:
- End-to-end tests.

---

## Error Handling
Features must:
- Handle failures explicitly.
- Provide meaningful error messages.
- Avoid silent failures.

External calls must include:
- Timeout
- Retry with backoff
- Idempotency where appropriate.

---

## Performance Awareness
Evaluate:
- Database query cost
- Network calls
- Memory usage
- Serialization overhead

Avoid N+1 query patterns.

---

## Observability
Features must emit:
- Structured logs
- Metrics
- Trace correlation IDs

If you cannot monitor it, you cannot operate it safely.