# Agent Output Template

<!--
PURPOSE: Use this template when Claude produces output intended to be read and
executed by a downstream AI agent (not a human). Structure enables reliable parsing.

DESIGN PRINCIPLES:
  - Every section has a machine-readable label and a human-readable description
  - File operations use absolute paths
  - Code blocks carry a language tag and a descriptive label
  - Preconditions are checked before execution; postconditions verify success
  - Ambiguity is resolved explicitly — agents must not infer intent

CONVENTIONS:
  - Replace all [PLACEHOLDERS] before passing to an executing agent
  - Sections marked REQUIRED must always be present
  - Sections marked OPTIONAL may be omitted if genuinely not applicable
  - Status values: PENDING | IN_PROGRESS | COMPLETE | BLOCKED
-->

---

## Metadata
<!-- REQUIRED. Machine-readable header. -->

```yaml
task_id: [unique-id or short-slug]
title: [Task title matching the originating task.md]
status: PENDING
created: [YYYY-MM-DD]
model: [model that produced this output]
input_task: [absolute path to the originating tasks.md, or "inline"]
target_agent: [agent name, or "human" if a person will execute this]
```

---

## Summary

<!-- REQUIRED. 2–4 sentences. What this output does and why.
     Written for a human reviewer who will approve before agent execution.
     Do not repeat the metadata fields here.
-->

_[Plain English summary of the work this output describes.]_

---

## Preconditions

<!-- REQUIRED. Conditions that must be true before execution begins.
     An agent must verify each precondition and halt with an error if any fail.
     Format: checkable assertion, not a vague description.
-->

- [ ] _[File X exists at path Y]_
- [ ] _[Environment variable Z is set]_
- [ ] _[Test suite passes before changes are made]_

---

## Implementation Plan

<!-- REQUIRED. Ordered steps. Each step must be atomic and independently verifiable.
     Number the steps — agents reference them by number in logs and error reports.
     If a step has sub-steps, use nested numbering (1.1, 1.2).
-->

### Step 1 — [Action title]

<!-- State: what must be true before this step. -->
**Pre-state:** _[Condition that must hold entering this step]_

<!-- Action: what to do. Be explicit — no room for interpretation. -->
**Action:** _[Precise instruction. Prefer "create", "modify", "delete", "run" over vague verbs.]_

<!-- Verification: how to confirm this step succeeded. -->
**Verify:** _[Command to run or condition to check after this step]_

---

### Step 2 — [Action title]

**Pre-state:** _[Condition]_

**Action:** _[Instruction]_

**Verify:** _[Check]_

---

## File Operations

<!-- REQUIRED if any files are created or modified.
     List every file touched. Use absolute paths. State the operation type explicitly.
     Operations: CREATE | MODIFY | DELETE | MOVE | CHMOD
-->

| Operation | Absolute Path | Notes |
|---|---|---|
| _[CREATE/MODIFY/DELETE]_ | _[/absolute/path/to/file]_ | _[what changes and why]_ |

---

## Code

<!-- REQUIRED if the implementation involves code.
     Each block must have: a language tag, a label comment on the first line,
     and the absolute path of the file it belongs to.
     Write complete file contents for CREATE operations.
     Write only the changed function/section for MODIFY operations, with enough
     surrounding context (5+ lines) to locate it unambiguously.
-->

<!-- LABEL FORMAT: # [CREATE|MODIFY] <absolute/path/to/file> -->

```python
# MODIFY /absolute/path/to/file.py

# [5+ lines of unchanged context above the change]

def changed_function(...):
    # [new implementation]
    pass

# [5+ lines of unchanged context below the change]
```

---

## Commands

<!-- OPTIONAL. Shell commands the agent must run, in order.
     Include: working directory, exact command, and expected output/exit code.
     Never use relative paths. Never use interactive commands.
-->

```bash
# Working directory: /absolute/path/to/project

# Step 3 — install dependencies
pip install -r requirements.txt
# Expected: exit code 0

# Step 4 — run tests
pytest tests/ -v
# Expected: exit code 0, all tests pass
```

---

## Postconditions

<!-- REQUIRED. Verifiable conditions that must all be true after execution completes.
     An agent must check each postcondition and report failure if any are not met.
     These are the acceptance criteria for the output.
-->

- [ ] _[Specific test passes or returns expected output]_
- [ ] _[File exists at expected path with expected content]_
- [ ] _[No regressions: original test suite still passes]_

---

## Error Handling

<!-- OPTIONAL but recommended for multi-step plans.
     Map anticipated failure modes to recovery actions.
     If no recovery is possible, specify "HALT and notify operator".
-->

| Failure | Recovery Action |
|---|---|
| _[Precondition N fails]_ | _[What to do — retry, skip, halt]_ |
| _[Step N fails with error Y]_ | _[Specific recovery or escalation]_ |

---

## Rollback

<!-- OPTIONAL. How to undo the changes made by this output if postconditions fail.
     Include commands or file restoration steps.
     If rollback is not possible, state that explicitly.
-->

_[Rollback procedure, or "Not applicable — changes are additive and safe to remove manually."]_

---

## Notes for Executing Agent

<!-- OPTIONAL. Anything that doesn't fit the above structure.
     Use for: known quirks, environment-specific considerations,
     decisions that were made and why (so the agent doesn't second-guess them).
-->

_[Any supplementary context the executing agent needs.]_

---

---

# Example: Filled-In Output

## Metadata

```yaml
task_id: add-rate-limiting-search-api
title: Add rate limiting to the public search API endpoint
status: PENDING
created: 2026-03-29
model: claude-sonnet-4-6
input_task: /Users/philiplee/repos/ai/tasks/2026-03-29-rate-limit.md
target_agent: senior-engineer
```

---

## Summary

This output adds per-IP rate limiting to the `GET /api/v1/search` endpoint using a Redis token bucket. Unauthenticated requests are capped at 60 per minute per IP; authenticated requests bypass the limit. A new middleware module handles all rate limit logic; the route file is modified only to register the middleware.

---

## Preconditions

- [ ] `/Users/philiplee/repos/api/src/routes/search.py` exists
- [ ] `/Users/philiplee/repos/api/requirements.txt` contains `redis`
- [ ] Environment variable `REDIS_URL` is set to a reachable Redis instance
- [ ] `pytest tests/test_search.py` exits with code 0 before any changes

---

## Implementation Plan

### Step 1 — Create rate limit middleware

**Pre-state:** `/Users/philiplee/repos/api/src/middleware/rate_limit.py` does not exist.

**Action:** Create the file with the contents defined in the Code section below.

**Verify:** File exists at `/Users/philiplee/repos/api/src/middleware/rate_limit.py` and `mypy src/middleware/rate_limit.py` exits with code 0.

---

### Step 2 — Register middleware on the search route

**Pre-state:** Step 1 is complete. `/Users/philiplee/repos/api/src/routes/search.py` does not import `RateLimitMiddleware`.

**Action:** Apply the MODIFY patch in the Code section to `src/routes/search.py`.

**Verify:** `grep "RateLimitMiddleware" /Users/philiplee/repos/api/src/routes/search.py` returns a match.

---

### Step 3 — Create tests

**Pre-state:** Step 2 is complete. `/Users/philiplee/repos/api/tests/test_rate_limit.py` does not exist.

**Action:** Create the test file with the contents defined in the Code section below.

**Verify:** File exists. `pytest tests/test_rate_limit.py -v` exits with code 0.

---

## File Operations

| Operation | Absolute Path | Notes |
|---|---|---|
| CREATE | `/Users/philiplee/repos/api/src/middleware/rate_limit.py` | New token bucket middleware |
| MODIFY | `/Users/philiplee/repos/api/src/routes/search.py` | Register middleware; no other changes |
| CREATE | `/Users/philiplee/repos/api/tests/test_rate_limit.py` | Three test cases |

---

## Code

```python
# CREATE /Users/philiplee/repos/api/src/middleware/rate_limit.py

from __future__ import annotations

import os
import time

import redis
from fastapi import Request, Response
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware

RATE_LIMIT = 60          # requests
WINDOW_SECONDS = 60      # per minute
REDIS_URL = os.environ["REDIS_URL"]

_redis: redis.Redis = redis.from_url(REDIS_URL, decode_responses=True)


class RateLimitMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next) -> Response:
        # Authenticated requests are exempt
        if request.headers.get("Authorization"):
            return await call_next(request)

        ip = request.client.host if request.client else "unknown"
        key = f"rate_limit:{ip}"
        now = int(time.time())
        window_start = now - WINDOW_SECONDS

        pipe = _redis.pipeline()
        pipe.zremrangebyscore(key, 0, window_start)
        pipe.zadd(key, {str(now): now})
        pipe.zcard(key)
        pipe.expire(key, WINDOW_SECONDS)
        _, _, count, _ = pipe.execute()

        if count > RATE_LIMIT:
            return JSONResponse(
                status_code=429,
                content={"detail": "Rate limit exceeded. Max 60 requests per minute."},
                headers={"Retry-After": str(WINDOW_SECONDS)},
            )

        return await call_next(request)
```

```python
# MODIFY /Users/philiplee/repos/api/src/routes/search.py

# --- existing imports (unchanged) ---
from fastapi import APIRouter, Depends, Query
from src.services.search import SearchService

# ADD this import after existing imports:
from src.middleware.rate_limit import RateLimitMiddleware

router = APIRouter()

# ADD middleware registration after router is defined:
router.add_middleware(RateLimitMiddleware)

# --- rest of file unchanged ---
@router.get("/search")
async def search(q: Query = Query(...), service: SearchService = Depends()):
    return await service.run(q)
```

```python
# CREATE /Users/philiplee/repos/api/tests/test_rate_limit.py

import pytest
from httpx import AsyncClient
from unittest.mock import patch, MagicMock

from src.main import app


@pytest.mark.asyncio
async def test_request_within_limit_is_allowed():
    with patch("src.middleware.rate_limit._redis") as mock_redis:
        mock_redis.pipeline.return_value.__enter__ = MagicMock(return_value=mock_redis.pipeline.return_value)
        mock_redis.pipeline.return_value.execute.return_value = [None, None, 1, None]
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get("/api/v1/search?q=test")
        assert response.status_code == 200


@pytest.mark.asyncio
async def test_request_over_limit_returns_429():
    with patch("src.middleware.rate_limit._redis") as mock_redis:
        mock_redis.pipeline.return_value.execute.return_value = [None, None, 61, None]
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get("/api/v1/search?q=test")
        assert response.status_code == 429
        assert response.headers["Retry-After"] == "60"


@pytest.mark.asyncio
async def test_authenticated_request_bypasses_rate_limit():
    with patch("src.middleware.rate_limit._redis") as mock_redis:
        # Even if Redis would reject, authenticated requests must pass
        mock_redis.pipeline.return_value.execute.return_value = [None, None, 999, None]
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/search?q=test",
                headers={"Authorization": "Bearer valid-token"},
            )
        assert response.status_code == 200
```

---

## Commands

```bash
# Working directory: /Users/philiplee/repos/api

# Verify types after implementation
mypy src/middleware/rate_limit.py src/routes/search.py
# Expected: exit code 0

# Run full test suite
pytest tests/ -v
# Expected: exit code 0, no regressions
```

---

## Postconditions

- [ ] `/Users/philiplee/repos/api/src/middleware/rate_limit.py` exists
- [ ] `mypy src/` exits with code 0 (no new type errors)
- [ ] `pytest tests/test_rate_limit.py -v` exits with code 0 (all 3 new tests pass)
- [ ] `pytest tests/test_search.py -v` exits with code 0 (no regressions)

---

## Error Handling

| Failure | Recovery Action |
|---|---|
| `REDIS_URL` not set at precondition check | HALT. Notify operator: environment is not configured. |
| `mypy` reports errors after Step 1 | Fix type errors in `rate_limit.py` before proceeding to Step 2. |
| `pytest tests/test_search.py` regresses after Step 2 | Revert the MODIFY patch to `search.py`; investigate middleware registration. |
| Redis connection refused at test runtime | Ensure a Redis instance is running and `REDIS_URL` is correct. |

---

## Rollback

```bash
# Working directory: /Users/philiplee/repos/api

# Remove the new middleware file
rm /Users/philiplee/repos/api/src/middleware/rate_limit.py

# Remove the new test file
rm /Users/philiplee/repos/api/tests/test_rate_limit.py

# Restore search.py to its pre-change state
git checkout HEAD -- src/routes/search.py
```

---

## Notes for Executing Agent

The `router.add_middleware()` call must appear after the `router = APIRouter()` line and before any route definitions. FastAPI applies middleware in reverse registration order; if other middleware already exists on this router, verify that rate limiting runs before authentication to avoid unnecessary Redis calls for already-rejected requests.
