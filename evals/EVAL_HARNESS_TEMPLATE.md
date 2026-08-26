# Eval harness — [Project Name]

Clone this file into the target project as `evals/EVAL_HARNESS.md`, then scaffold
the files it describes below (`config.yaml`, `runner.py`, `judges/`, `datasets/`).
This harness verifies agent *outputs* — CI/CD verifies the code builds, code
review verifies the code is sound, this verifies the agent did the right thing
when it actually ran.

Python 3.12+, stdlib + `pyyaml` only. No framework — keep it a runner script,
not a package, until a second project needs something this one doesn't have.

---

## Layout to scaffold

```
evals/
  config.yaml           — suites, thresholds, which judge each suite uses
  datasets/
    <suite>.jsonl        — one eval case per line
  judges/
    __init__.py          — Judge protocol
    exact_match.py       — deterministic judge
    llm_judge.py         — rubric judge via Claude API
  runner.py               — loads a suite, invokes the agent, scores, aggregates
  results/                — gitignored; runner writes JSON reports here
```

Add to the target project's `.gitignore`:

```gitignore
evals/results/
```

---

## `config.yaml`

```yaml
# How to invoke the agent under test. {input} is substituted with the case's
# input at runtime. Must print the agent's final output to stdout.
invoke: "python -m myagent.cli --prompt '{input}'"

suites:
  regression:
    dataset: datasets/regression.jsonl
    judge: exact_match
    fail_under: 1.0          # every case must pass — wire into CI as a merge gate

  quality:
    dataset: datasets/quality.jsonl
    judge: llm_judge
    fail_under: 0.85         # 85% average rubric score

  trajectory:
    dataset: datasets/trajectory.jsonl
    judge: llm_judge
    rubric: trajectory        # see judges/llm_judge.py — selects rubric text
    fail_under: 0.9
```

---

## Dataset format (`datasets/<suite>.jsonl`)

One JSON object per line. Keep datasets small and curated — a few dozen
high-signal cases beat hundreds of redundant ones.

```json
{"id": "auth-001", "input": "reset password for user with no email on file", "expected": "should ask for an alternate identifier, not fail silently", "rubric": "quality"}
```

- `id` — stable identifier so regressions can be traced to a specific case
- `input` — exact prompt/task given to the agent
- `expected` — for `exact_match`: the literal expected string. For `llm_judge`: a description of what a correct answer looks like
- `rubric` — optional; selects which rubric text the LLM judge uses (see below)

---

## `judges/__init__.py`

```python
from typing import Protocol


class Judge(Protocol):
    def score(self, input: str, expected: str, actual: str) -> tuple[float, str]:
        """Return (score in [0.0, 1.0], reason). Reason is required even for a pass."""
        ...
```

## `judges/exact_match.py`

```python
from . import Judge


class ExactMatchJudge(Judge):
    def score(self, input: str, expected: str, actual: str) -> tuple[float, str]:
        passed = actual.strip() == expected.strip()
        reason = "exact match" if passed else f"expected {expected!r}, got {actual!r}"
        return (1.0 if passed else 0.0), reason
```

## `judges/llm_judge.py`

```python
import json
import os

import anthropic

from . import Judge

RUBRICS = {
    "quality": (
        "Score 0.0-1.0 how well ACTUAL satisfies EXPECTED given INPUT. "
        "Penalize hallucinated facts, missed constraints, or wrong tone. "
        "Respond with JSON: {\"score\": float, \"reason\": str}"
    ),
    "trajectory": (
        "ACTUAL is a transcript of tool calls the agent made for INPUT. "
        "Score 0.0-1.0 whether the tool sequence was correct, minimal, and safe "
        "(no unnecessary side effects, no missing required calls). "
        "Respond with JSON: {\"score\": float, \"reason\": str}"
    ),
}


class LLMJudge(Judge):
    def __init__(self, rubric: str = "quality", model: str = "claude-sonnet-5"):
        self.client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])
        self.rubric = RUBRICS[rubric]
        self.model = model

    def score(self, input: str, expected: str, actual: str) -> tuple[float, str]:
        msg = self.client.messages.create(
            model=self.model,
            max_tokens=200,
            messages=[{
                "role": "user",
                "content": f"{self.rubric}\n\nINPUT: {input}\nEXPECTED: {expected}\nACTUAL: {actual}",
            }],
        )
        result = json.loads(msg.content[0].text)
        return result["score"], result["reason"]
```

Swap `LLMJudge` for a different provider or a human-in-the-loop grader per
project — that's the point of the `Judge` protocol. Don't add a second LLM
judge implementation until a project actually needs two.

---

## `runner.py`

```python
#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys
from pathlib import Path

import yaml

from judges.exact_match import ExactMatchJudge
from judges.llm_judge import LLMJudge

JUDGES = {"exact_match": ExactMatchJudge, "llm_judge": LLMJudge}


def load_cases(path: str):
    with open(path) as f:
        return [json.loads(line) for line in f if line.strip()]


def invoke_agent(invoke_template: str, input_text: str) -> str:
    cmd = invoke_template.format(input=input_text.replace("'", "'\\''"))
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=120)
    return result.stdout.strip()


def run_suite(name: str, cfg: dict, invoke_template: str) -> dict:
    judge_cls = JUDGES[cfg["judge"]]
    judge = judge_cls(rubric=cfg["rubric"]) if "rubric" in cfg else judge_cls()

    cases = load_cases(cfg["dataset"])
    results = []
    for case in cases:
        actual = invoke_agent(invoke_template, case["input"])
        score, reason = judge.score(case["input"], case["expected"], actual)
        results.append({"id": case["id"], "score": score, "reason": reason, "actual": actual})

    avg = sum(r["score"] for r in results) / len(results) if results else 0.0
    return {"suite": name, "average": avg, "fail_under": cfg["fail_under"], "cases": results}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--suite", required=True)
    parser.add_argument("--config", default="evals/config.yaml")
    args = parser.parse_args()

    config = yaml.safe_load(Path(args.config).read_text())
    suite_cfg = config["suites"][args.suite]
    report = run_suite(args.suite, suite_cfg, config["invoke"])

    Path("evals/results").mkdir(parents=True, exist_ok=True)
    Path(f"evals/results/{args.suite}.json").write_text(json.dumps(report, indent=2))

    for case in report["cases"]:
        status = "PASS" if case["score"] >= 1.0 else f"{case['score']:.2f}"
        print(f"[{status}] {case['id']}: {case['reason']}")
    print(f"\n{args.suite}: {report['average']:.2f} (threshold {report['fail_under']:.2f})")

    sys.exit(0 if report["average"] >= report["fail_under"] else 1)


if __name__ == "__main__":
    main()
```

---

## Wiring into CI

Add as a merge-blocking step, same as tests:

```yaml
# .github/workflows/ci.yml
- name: Eval — regression suite
  run: python evals/runner.py --suite regression
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

Run `regression` (exact-match, `fail_under: 1.0`) on every PR — it's cheap and
deterministic. Run `quality` / `trajectory` (LLM-judge) on every PR too if
latency and API cost allow; otherwise run them on merge to main and on a
schedule, and treat a threshold miss as a page, not a blocker.

---

## Adapting per project

- **`invoke`** is the only line most projects need to change — point it at
  however the agent is actually called (CLI, `python -m`, `curl` against a
  local server, whatever prints the final output to stdout).
- **New rubric** → add a key to `RUBRICS` in `llm_judge.py`, reference it via
  `rubric:` in `config.yaml`.
- **New judge type** (e.g. a human-review queue, a second model as judge) →
  implement the `Judge` protocol, register in `JUDGES` in `runner.py`.
- Keep `datasets/regression.jsonl` curated from real production failures as
  they're found — that's what makes the suite catch real regressions instead
  of testing invented edge cases.
