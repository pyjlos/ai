# Architecture Principles

## 1. Clear Ownership
- Every service must have a single owning team.
- Every database must have a clear owner.
- Shared ownership must be avoided.

## 2. Service Boundaries
- Services must communicate via explicit contracts.
- No shared databases between services.
- No cross-service direct table access.

## 3. Failure Isolation
- Failure in one service must not cascade.
- External calls must use timeouts.
- Retries must use exponential backoff.
- Calls must be idempotent where possible.

## 4. Observability
- Structured logging required.
- Metrics required for all critical paths.
- Tracing required for cross-service calls.

## 5. Scalability
- Systems must tolerate 10x current peak load.
- Horizontal scaling preferred over vertical scaling.
- Avoid in-memory state for horizontally scaled services.

## 6. Backwards Compatibility
- Public APIs must be versioned.
- Breaking changes require migration plan.

## 7. Data Safety
- Encryption at rest and in transit required.
- PII must be explicitly documented.