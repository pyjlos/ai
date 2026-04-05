# Commands

Slash commands are reusable, multi-step workflows you invoke by name in Claude Code. Type `/review-pr main..HEAD` and Claude Code loads the command file, substitutes your argument, and executes the defined procedure — spawning agents, reading files, writing output — without you having to describe the steps each time.

Commands live in `~/.claude/commands/` as markdown files. Each file defines what to do, in what order, and what to produce. You write the workflow once; you invoke it many times.

**Commands vs. agents:** An agent is a specialist persona — it has a role, deep domain expertise, and consistent behavior. A command is a procedure — it orchestrates steps, calls agents, and produces a specific deliverable. The `review-pr` command spawns three agents in parallel; those agents do the expert work.

---

## Install

```bash
bash scripts/install.sh --tool claude
```

Commands are installed to `~/.claude/commands/`. After installation, invoke any command in Claude Code with `/command-name`.

---

## Commands

### `/review-pr`

Orchestrates a parallel code review across three specialist agents and writes a structured report to disk.

**What it does:**

1. Accepts a branch name, file path, or git range as its argument
2. Runs `git diff` if given a branch or range, or reads files directly if given a path
3. Spawns three agents simultaneously against the same target:
   - `pragmatic-reviewer` — complexity and bloat audit
   - `code-reviewer` — vulnerability, bug, and security audit
   - `test-engineer` — coverage and test quality audit
4. Collates all three reviews into a single structured report
5. Writes the report to `outputs/reviews/review-YYYY-MM-DD-HH-MM.md`
6. Prints a one-line summary to the terminal: the three verdicts and the number of action items

**Usage:**

```
/review-pr feature/auth
```

```
/review-pr main..HEAD
```

```
/review-pr src/api/payments.py
```

**Output format:**

The written report includes:
- A 2-3 sentence overall verdict
- A table with each reviewer's verdict (e.g., `clean / low risk / gaps present`)
- The full output from each of the three agents
- A numbered action item list ordered by severity — only blockers and high-value findings, no nitpicks

The terminal output is intentionally brief:

```
Review written to outputs/reviews/review-2026-04-04-14-32.md
Verdicts: lean | low risk | well tested
Action items: 2
```

**What the command does not do:**

- It does not default to `main..HEAD` if you forget the argument — it stops and tells you to re-run with a target
- It does not print the full report to the terminal — the report is in the file
- It does not open a PR or push anything — it is read-only

**Example output file location:**

```
outputs/
  reviews/
    review-2026-04-04-14-32.md
```

The `outputs/reviews/` directory is created automatically if it does not exist. You should add it to `.gitignore` unless you want to commit reviews to the repo.

---

## Best practices for using commands

**Always provide the target argument.**
Commands are designed to be precise. `/review-pr` without an argument will stop and prompt you — this is intentional. Be explicit.

**Use git ranges for PR reviews.**
`/review-pr main..HEAD` reviews exactly what your branch changed relative to main. This is the most useful form for pre-merge review.

**Use file paths for targeted reviews.**
`/review-pr src/api/auth.py` is useful when you have changed one file and want focused feedback without reviewing the entire diff.

**Run `/review-pr` before opening a PR, not after.**
The command is most valuable as a pre-merge gate, not a post-merge retrospective. Make it part of your PR preparation.

**Check the action items list, not just the verdicts.**
Verdicts give you a quick signal; action items tell you what to actually fix. A "low risk" verdict with two action items still means two things to address.

---

## Writing your own commands

A command file is a markdown file in `commands/`. The filename becomes the slash command name. The file body is the instruction set Claude Code follows when the command is invoked. Use `$ARGUMENTS` anywhere in the file to substitute what the user typed after the command name.

**Minimal command structure:**

```markdown
Do X with $ARGUMENTS.

## Guard

If $ARGUMENTS is empty, stop and tell the user: "Usage: /my-command <target>"

## Steps

1. [First step]
2. [Second step]
3. Write output to outputs/my-command/result-YYYY-MM-DD.md

## Report back

Tell the user the output file path and a one-line summary.
```

**Tips for writing effective commands:**

- Add a guard at the top that validates `$ARGUMENTS` and stops early with a usage message if it is missing or malformed — do not let the command proceed with bad input
- Define the output location explicitly — commands that produce files should write to a predictable path under `outputs/`
- Name agents explicitly in the steps rather than letting Claude pick — this makes the command's behavior deterministic
- Keep the terminal output brief; write detail to a file
- Test the command with edge cases: empty argument, a file that does not exist, a branch with no diff

**Installing a new command:**

Drop the `.md` file into `commands/` in this repo, then re-run the installer:

```bash
bash scripts/install.sh --tool claude
```

The installer copies all command files to `~/.claude/commands/` flat — subdirectories are not supported by Claude Code for commands.
