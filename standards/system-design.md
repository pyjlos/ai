# System Design Standards

## Bounded Contexts
Systems must align with domain boundaries.

Avoid:
- Shared databases between services.
- Cross-domain business logic.

Prefer:
- API-based communication.
- Event-driven communication where appropriate.

---

## Failure Domains
Design systems so failures are isolated.

Evaluate:
- Dependency reliability.
- Network partition tolerance.
- Partial failure behavior.

---

## Scalability
Systems must support:
- Horizontal scaling.
- Backpressure handling.
- Asynchronous processing where possible.

Design for 10x load growth.

---

## State Management
State must have:
- Clear ownership.
- Persistence strategy.
- Recovery strategy.

Avoid:
- Hidden in-memory state dependencies.

---

## Versioning Strategy
All public interfaces must be versioned.

Includes:
- APIs
- Event schemas
- Database migrations

Provide backwards compatibility paths.

---

## Migration Planning
Every major system change must include:
- Migration plan.
- Rollback plan.
- Data safety guarantees.