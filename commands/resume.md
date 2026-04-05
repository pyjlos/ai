Resume a session from a handoff document. $ARGUMENTS is the path to the handoff file.

## Guard

If $ARGUMENTS is empty or was not provided, look for the most recent handoff file in `outputs/handoffs/`. If none exists, stop and respond:

"No handoff file found. Either provide a path: `/resume outputs/handoffs/handoff-YYYY-MM-DD-HH-MM.md`, or start fresh and describe the task."

---

## Step 1 — Load the handoff

Read the handoff file at $ARGUMENTS (or the most recent one found).

Do not summarize it back to the user — internalize it.

---

## Step 2 — Verify current state

The handoff describes what the code state *was*. Verify it matches *now*:

1. Run the build/test check appropriate for this repo to confirm the state matches what was described in "Current state of the codebase"
2. Read each file listed under "Relevant files" in the handoff
3. If the actual state does not match the handoff description, flag the discrepancy before doing anything else

If the state is inconsistent (e.g., handoff says tests were passing but they're not), stop and report the discrepancy. Do not proceed until the user confirms how to handle it.

---

## Step 3 — Confirm context

After reading the handoff and verifying state, output a single confirmation block:

```
Resume confirmed.

Goal: <one sentence from the handoff>
Phase: <Research | Plan | Execute | Review>
Last completed: <most recent bullet from "what was done">
Immediate next action: <exact text from handoff>

Ready to proceed. Confirm or redirect.
```

Do not begin the next action until the user confirms. They may want to redirect or add new information.

---

## Step 4 — Execute the next action

Once confirmed, execute exactly what "Immediate next action" says.

Follow the workflow phases from rules/workflow.md. If the handoff says we are in Execute phase, do not re-do Research or re-derive a plan — trust the handoff unless you find a contradiction when reading the files.

---

## Notes

- If the handoff has open questions that are unanswered, surface them before executing
- If the handoff says "Blocked", ask the user how to unblock before doing anything
- If this is a multi-agent handoff (status: "Ready for next agent"), read "Next agent" and behave as that agent for this session
