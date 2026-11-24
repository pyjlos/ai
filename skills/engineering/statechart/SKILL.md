---
name: statechart
description: "Build a TLA+ model of a system that moves between states — a product flow, a protocol, a service — and render it as a Mermaid statechart showing the shortest path to each state that breaks a rule. Use for \"statechart this\", modeling a protocol or state machine, or showing a bug as a path through states."
disable-model-invocation: true
metadata:
  credits:
    skill: statechart
    author: Lauren Tan
    organisation: Cursor (pstack plugin)
    url: "https://github.com/cursor/plugins/blob/main/pstack/skills/statechart/SKILL.md"
---

# Statechart

The chart shows how a system moves between states, in the words of the person who reads it. That person, the reader, decides whether the behavior is right.

## Scope of this port

pstack's own `statechart` skill ships a TypeScript toolchain (a TLC driver, a Mermaid renderer, and a view-module contract) that turns a TLA+ spec and a hand-written view into `chart.mmd` and a bug-path report automatically. That toolchain isn't vendored here: pstack carries no upstream license, and this repo's skills never bundle executable code, only `.md` methodology. Treat the steps below as the method, not an automated pipeline — running it means writing and executing the TLA+ spec and TLC config yourself with whatever TLA+ tooling is available (the TLC model checker), then hand-deriving the Mermaid chart and the bug-path report from TLC's output. That is materially more manual work than pstack's pipeline; say so up front when scoping the task.

## Write the spec

- Write each rule the reader agrees to as an INVARIANT. A rule can be about a screen, a result, a stored value, or a message. If the model has no variable for a rule, add the variable. Never weaken a rule to make it hold.
- Write `Next` as a disjunction of named actions, such as `YouPressPlay \/ YouPressStop`. An unlabeled disjunction makes every step show up as `Next` in TLC's output, which is useless for narration — name each action.
- A state with no step out breaks `NoDeadlock` (or `CHECK_DEADLOCK`, when that name is already taken by another invariant or property), even when it is a correct end state. Add an explicit action that is true only in end states and changes nothing, e.g. `Done == phase \in {"paid", "failed"} /\ UNCHANGED vars`.

## Run TLC and read its output

Run TLC against the spec and config. On a rule violation, TLC prints a counterexample trace: the sequence of states and actions that reaches the violation. That trace is the shortest-path bug report for this port — read it directly rather than through a report-generation step, since none is vendored here.

Keep the model's constants small, or add a CONSTRAINT: TLC explores past a rule violation rather than stopping at it, so an unconstrained model can run without end once a bug is found.

## Translate the trace into a chart

This is the part pstack's `view` module and Mermaid backend automate; do it by hand here:

- Pick the reader's words for each model state (e.g. "Paying" rather than the raw variable assignment). Keep variable names out of the labels.
- Pick the reader's words for each action/step (e.g. "you press play" rather than the TLA+ action name). Two actions that read the same to the reader should share one arrow label.
- When a step only fires under some condition, name that condition in the reader's words, in brackets: `you press play [while the file loads]`.
- Write the chart as Mermaid `stateDiagram-v2` syntax by hand, marking any state TLC's trace shows breaking a rule.
- Aim for roughly 20 arrows or fewer — collapse or omit steps a reader doesn't need (resets, call-in-flight states with no observable effect) rather than drawing every TLC transition.

## Hand off

Show the Mermaid chart as a `mermaid` code block. For each rule that breaks, give the rule, the reader's sentence for it, and the path TLC reported, numbered. Say what the model and chart leave out, and give the TLA+ spec and config so the check can be rerun.

When the model describes real code, replay the bug path against the real code — a test or a live repro, one step per action. If the bug doesn't occur, treat the model as wrong until proven otherwise.
