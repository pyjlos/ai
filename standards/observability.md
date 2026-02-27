# Observability Standards

## Logging
- Use structured logging.
- Include:
  - Request ID
  - User ID where applicable
  - Service context

---

## Metrics
Track:
- Latency
- Error rate
- Throughput
- Resource utilization

---

## Tracing
Required for:
- Cross-service requests.
- Critical business workflows.

---

## Alerting
Alerts must:
- Be actionable.
- Reduce noise.
- Include root cause signals.