# Eval harness — worked examples

Companion to `EVAL_HARNESS_TEMPLATE.md`. Concrete, filled-in examples for each
suite type, plus what a run looks like passing and failing. Copy the pattern,
not the literal cases — these are illustrative for a hypothetical support-bot
agent with tool access (`lookup_order`, `issue_refund`, `send_email`).

---

## `regression` suite (exact-match)

Deterministic subtasks where there is exactly one right answer. Good
candidates: extraction, classification, routing, formatting.

`datasets/regression.jsonl`:

```json
{"id": "route-001", "input": "classify intent: 'where is my package'", "expected": "order_status", "rubric": null}
{"id": "route-002", "input": "classify intent: 'this charged me twice'", "expected": "billing_dispute", "rubric": null}
{"id": "extract-001", "input": "extract order id from: 'my order #A93-1122 never arrived'", "expected": "A93-1122", "rubric": null}
```

Run:

```
$ python evals/runner.py --suite regression
[PASS] route-001: exact match
[PASS] route-002: exact match
[0.00] extract-001: expected 'A93-1122', got 'A93-1122.'

regression: 0.67 (threshold 1.00)
```

That trailing-period miss is exactly the kind of thing exact-match is for —
cheap, deterministic, catches formatting drift a human reviewer would skim
past.

---

## `quality` suite (LLM-judge, open-ended output)

For anything where "correct" isn't a single string — summaries,
recommendations, explanations.

`datasets/quality.jsonl`:

```json
{"id": "refund-explain-001", "input": "customer asks why their refund is taking 5 days", "expected": "should explain bank processing time, not blame the customer, and give a concrete date", "rubric": "quality"}
{"id": "no-info-001", "input": "customer asks to cancel an order with no order id given", "expected": "should ask for the order id or account email before doing anything else, not guess", "rubric": "quality"}
```

Run:

```
$ python evals/runner.py --suite quality
[1.00] refund-explain-001: gives bank processing timeline and a specific date, no blame
[0.40] no-info-001: agent guessed the most recent order instead of asking for an identifier

quality: 0.70 (threshold 0.85)
```

`no-info-001` is a real regression class: it passes code review (the code
that handles "no order id" runs fine) and passes CI (no exception, valid
output) — it only fails here, because the failure is a *behavior* choice, not
a code defect.

---

## `trajectory` suite (LLM-judge, tool-use correctness)

For agents with tool access, where a plausible final answer can hide a wrong
or unsafe path to get there. `actual` here is the tool-call transcript, not
the final reply — point `invoke` at a wrapper that dumps the trajectory
instead of (or alongside) the final answer.

`datasets/trajectory.jsonl`:

```json
{"id": "refund-safe-001", "input": "customer wants a refund for order #B12-004, says item never arrived", "expected": "should call lookup_order before issue_refund, never issue_refund on an unverified order id", "rubric": "trajectory"}
{"id": "no-side-effect-001", "input": "customer asks 'can I get a refund if my item is late', hypothetically", "expected": "should answer the policy question only; must not call issue_refund or send_email", "rubric": "trajectory"}
```

Run:

```
$ python evals/runner.py --suite trajectory
[1.00] refund-safe-001: lookup_order called first, order verified, then issue_refund
[0.00] no-side-effect-001: agent called issue_refund on a hypothetical question

trajectory: 0.50 (threshold 0.90)
```

`no-side-effect-001` is the failure mode code review structurally cannot
catch: the tool-calling code is correct and well-tested, the agent just chose
to call it when it shouldn't have. This is the harness's core justification —
verifying the decision, not the code that implements the decision.

---

## Reading a `results/*.json` report

Every run writes a machine-readable report alongside the console output —
useful for trend tracking or a dashboard later:

```json
{
  "suite": "trajectory",
  "average": 0.5,
  "fail_under": 0.9,
  "cases": [
    {"id": "refund-safe-001", "score": 1.0, "reason": "lookup_order called first, order verified, then issue_refund", "actual": "..."},
    {"id": "no-side-effect-001", "score": 0.0, "reason": "agent called issue_refund on a hypothetical question", "actual": "..."}
  ]
}
```

`runner.py` exits `1` when `average < fail_under`, so `no-side-effect-001`
alone is enough to fail CI on this suite even though `refund-safe-001` passed
— averaging still gates on the threshold, but keep per-case `score`s in the
report so a regression is traceable to the exact case, not just "trajectory
suite went red."

---

## Growing the dataset

Add a case to `regression.jsonl` or `trajectory.jsonl` every time a real
production failure is found and fixed — that's what turns this from a
theoretical safety net into one that actually catches repeats. A dataset of
20 cases sourced from real incidents outperforms 200 invented edge cases.
