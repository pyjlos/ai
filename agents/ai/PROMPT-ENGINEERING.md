# Prompt Engineering Patterns

## System Prompt Design

A well-structured system prompt has five layers:

```
1. Role        — who Claude is and its primary goal
2. Context     — background the model needs to do the task well
3. Constraints — what it must/must not do
4. Format      — exact output format with an example
5. Tone        — register, verbosity, style preferences
```

```python
SYSTEM_PROMPT = """
You are a senior code reviewer for a Python 3.12+ codebase.

Context: This is a financial services application. All code must be type-safe,
testable, and handle errors explicitly. The team uses uv, ruff, mypy, and pytest.

Constraints:
- Flag missing type annotations as blocking issues
- Flag bare except clauses as blocking issues
- Do not suggest refactors beyond the immediate review scope
- Do not restate what the code does — explain what is wrong and why

Output format:
Return a JSON array of findings:
[{
  "severity": "blocking" | "warning" | "suggestion",
  "line": <line number or null>,
  "issue": "<what is wrong>",
  "fix": "<concrete suggestion>"
}]

Return an empty array [] if no issues are found.
"""
```

## Structured Output

Always specify output format when the response feeds another system:

```python
from anthropic import Anthropic
import json

client = Anthropic()

response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system=SYSTEM_PROMPT,
    messages=[{"role": "user", "content": code}]
)

findings = json.loads(response.content[0].text)
```

For strongly-typed output, use tool use as a structured output mechanism:

```python
tools = [{
    "name": "submit_review",
    "description": "Submit the code review findings",
    "input_schema": {
        "type": "object",
        "properties": {
            "findings": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "severity": {"type": "string", "enum": ["blocking", "warning", "suggestion"]},
                        "line": {"type": ["integer", "null"]},
                        "issue": {"type": "string"},
                        "fix": {"type": "string"}
                    },
                    "required": ["severity", "issue", "fix"]
                }
            }
        },
        "required": ["findings"]
    }
}]

response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    tools=tools,
    tool_choice={"type": "tool", "name": "submit_review"},
    messages=[{"role": "user", "content": code}]
)
```

## Few-Shot Examples

Include 2–3 examples when the task has a non-obvious format or edge case behavior:

```python
messages = [
    {"role": "user", "content": "Classify: 'My order never arrived'"},
    {"role": "assistant", "content": '{"category": "shipping", "urgency": "high", "sentiment": "negative"}'},
    {"role": "user", "content": "Classify: 'Love the new design!'"},
    {"role": "assistant", "content": '{"category": "feedback", "urgency": "low", "sentiment": "positive"}'},
    {"role": "user", "content": f"Classify: '{user_message}'"},
]
```

## Context Window Management

- **Summarize old turns**: for long conversations, summarize older context rather than truncating
- **RAG over long documents**: don't stuff 200-page docs into context; retrieve relevant chunks
- **Tool results**: truncate large tool outputs before returning them to the model
- **Token budgets**: set `max_tokens` conservatively; don't pay for unused output capacity

```python
client = Anthropic()
token_count = client.messages.count_tokens(
    model="claude-sonnet-4-6",
    messages=messages,
    system=system_prompt
)
print(f"Input tokens: {token_count.input_tokens}")
```
