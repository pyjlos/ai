# Multi-Agent Architecture Patterns

## Orchestrator + Subagent Pattern

```
User → [Orchestrator] → [Subagent A]
                      → [Subagent B]
                      → [Subagent C]
                           ↓
                       [Synthesizer]
                           ↓
                         Output
```

The orchestrator decomposes the task and routes to specialized subagents. Each subagent has a narrow, testable responsibility.

```python
import anthropic
from anthropic import Anthropic

client = Anthropic()

def run_orchestrator(task: str) -> str:
    decomposition = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=1024,
        system="Decompose the task into subtasks for specialist agents. Output JSON.",
        messages=[{"role": "user", "content": task}]
    )
    subtasks = parse_subtasks(decomposition)

    import concurrent.futures
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        futures = {executor.submit(run_subagent, s): s for s in subtasks}
        results = {s: f.result() for f, s in futures.items()}

    return synthesize(results)
```

## Agent Design Rules

1. **Single responsibility**: each agent does one thing; orchestrator handles composition
2. **Defined output contracts**: agents return structured, typed output — not free text
3. **Idempotency**: agents can be safely retried; no side effects without explicit tool calls
4. **Timeout and retry**: every agent call has a timeout; transient failures retry with backoff
5. **Human-in-the-loop**: irreversible actions (email sent, payment charged, DB deleted) require confirmation before execution

## Tool Use Design

Design tools to be narrow and safe:

```python
tools = [
    {
        "name": "search_orders",
        "description": "Search orders by customer ID or order status. Read-only.",
        "input_schema": {
            "type": "object",
            "properties": {
                "customer_id": {"type": "string"},
                "status": {"type": "string", "enum": ["pending", "shipped", "delivered"]}
            }
        }
    },
    {
        "name": "cancel_order",
        "description": "Cancel a specific order. IRREVERSIBLE. Requires explicit user confirmation.",
        "input_schema": {
            "type": "object",
            "required": ["order_id", "reason", "confirmed"],
            "properties": {
                "order_id": {"type": "string"},
                "reason": {"type": "string"},
                "confirmed": {"type": "boolean", "description": "Must be true; never assume true"}
            }
        }
    }
]
```
