# Task Template

<!--
PURPOSE: Use this template when giving Claude a task. Fill in every section that applies.
Omit sections that are genuinely not relevant, but err on the side of including them.
The more precise the input, the more reliable the output.
-->

---

## Task Title

<!-- A short imperative phrase (5–10 words). Examples:
     "Add pagination to the orders API endpoint"
     "Refactor authentication module to use JWT"
     "Write unit tests for the payment processor"
-->

_[Replace with task title]_

---

## Context

<!-- Background the model needs to understand WHY this task exists.
     Include: what system this affects, current state, and what changed to make this task necessary.
     Keep it to 3–5 sentences. Avoid restating the goal here.
-->

_[Describe the current state, the system involved, and why this work is needed now.]_

---

## Goal

<!-- A single, unambiguous statement of what "done" looks like.
     Should be verifiable: someone reading it should be able to confirm whether it was achieved.
     Start with a verb: "Implement...", "Produce...", "Migrate..."
-->

_[One sentence describing the end state.]_

---

## Inputs

<!-- Everything Claude needs to do the work. List each input explicitly.
     Examples: file paths, data samples, API specs, environment variables, screenshots.
     Use absolute paths for files. Attach or inline small data samples.
-->

| Input | Type | Notes |
|---|---|---|
| _[name]_ | _[file / value / schema / URL]_ | _[any relevant detail]_ |

---

## Constraints

<!-- Hard rules Claude must not violate. These override any judgment calls.
     Examples: language version, framework, no new dependencies, must not modify X file,
     must remain backward-compatible, must complete within N lines of code.
-->

- _[Constraint 1]_
- _[Constraint 2]_

---

## Deliverables

<!-- Explicit list of outputs expected. Be specific about format.
     Examples: "a modified src/api/orders.py with the new endpoint",
     "a test file at tests/test_orders.py with ≥ 80% coverage",
     "a summary of changes in plain English".
-->

- [ ] _[Deliverable 1 — file, artifact, or written output]_
- [ ] _[Deliverable 2]_

---

## Success Criteria

<!-- How to verify the task is complete and correct.
     List specific, checkable conditions. These become the acceptance tests.
     Examples: "all existing tests pass", "curl returns HTTP 200 with expected body",
     "no new mypy errors introduced".
-->

- [ ] _[Criterion 1]_
- [ ] _[Criterion 2]_

---

## References

<!-- Links, file paths, or documentation relevant to the task.
     Only include what Claude actually needs — not background reading.
-->

- _[Reference 1 — label and path/URL]_

---

## Out of Scope

<!-- Explicitly list what Claude should NOT do, even if it seems related.
     This prevents well-intentioned scope creep.
-->

- _[Thing that looks related but should not be touched]_

---

---

# Example: Filled-In Task

## Task Title

Add rate limiting to the public search API endpoint

---

## Context

The `/api/v1/search` endpoint is publicly accessible and has been targeted by scraping bots. Last week, a single IP made 40,000 requests in one hour, causing a 30% latency spike for legitimate users. We use FastAPI and Redis is already available in the infrastructure.

---

## Goal

Implement per-IP rate limiting on `GET /api/v1/search` that rejects requests exceeding 60 requests per minute with an HTTP 429 response, using Redis as the token bucket store.

---

## Inputs

| Input | Type | Notes |
|---|---|---|
| `/Users/philiplee/repos/api/src/routes/search.py` | file | The endpoint to modify |
| `/Users/philiplee/repos/api/src/middleware/` | directory | Existing middleware; follow patterns here |
| `/Users/philiplee/repos/api/requirements.txt` | file | Do not add packages not already present |
| `REDIS_URL` | env var | Already set in the environment; value is `redis://localhost:6379/0` |

---

## Constraints

- Python 3.12, FastAPI 0.111
- Do not add new Python packages — `redis-py` is already in requirements.txt
- Do not modify `src/models/` or `src/db/`
- Rate limit applies only to unauthenticated requests; authenticated users are exempt
- Must not break any existing tests in `tests/test_search.py`

---

## Deliverables

- [ ] Modified `src/routes/search.py` with rate limiting applied
- [ ] New `src/middleware/rate_limit.py` implementing the token bucket logic
- [ ] New tests in `tests/test_rate_limit.py` covering: allowed request, rejected request (429), and authenticated-user exemption

---

## Success Criteria

- [ ] `pytest tests/` passes with no regressions
- [ ] A script simulating 61 requests in under 60 seconds from the same IP returns exactly one HTTP 429
- [ ] An authenticated request (with a valid `Authorization` header) is never rate-limited
- [ ] `mypy src/` reports no new type errors

---

## References

- Existing auth middleware pattern: `/Users/philiplee/repos/api/src/middleware/auth.py`
- FastAPI middleware docs: https://fastapi.tiangolo.com/tutorial/middleware/
- Redis token bucket pattern: https://redis.io/docs/latest/commands/incr/#pattern-rate-limiter

---

## Out of Scope

- Do not implement rate limiting for any other endpoints
- Do not add request logging or metrics — that is a separate task
- Do not change the Redis connection pool configuration
