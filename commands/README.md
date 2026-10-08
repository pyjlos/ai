# Commands

Slash commands are reusable, multi-step workflows you invoke by name in Claude Code. Type `/review-pr main..HEAD` and Claude Code loads the command file, substitutes your argument, and executes the defined procedure — spawning agents, reading files, writing output — without you having to describe the steps each time.

Commands live in `~/.claude/commands/` as markdown files. Each file defines what to do, in what order, and what to produce. You write the workflow once; you invoke it many times.

**Commands vs. agents:** An agent is a specialist persona — it has a role, deep domain expertise, and consistent behavior. A command is a procedure — it orchestrates steps, calls agents, and produces a specific deliverable. The `review-pr` command spawns a core set of reviewer agents in parallel, plus domain specialists where the diff calls for them; those agents do the expert work.

---

## Install

```bash
bash scripts/install.sh --tool claude
```

Commands are installed to `~/.claude/commands/`. After installation, invoke any command in Claude Code with `/command-name`.

---

## Commands

### `/review-pr`

Reviews a GitHub PR against a local clone of the repo and writes a severity-bucketed report to disk.

**What it does:**

1. Accepts a GitHub PR URL as its only argument (`https://github.com/<owner>/<repo>/pull/<number>`)
2. Locates a local clone of the repo — checks the current directory's git remote first, then searches `~/repos/**`; if none is found, it stops and asks you to clone it or give it a path
3. Pulls the PR's diff and changed-file list via `gh pr diff` / `gh pr view`
4. Spawns reviewer agents in parallel, scoped to the changed files only:
   - **Core agents, always run:** `pragmatic-reviewer` (complexity/bloat), `code-reviewer` (security and vulnerability audit)
   - **Core skill, always applied by the orchestrator:** `ponytail` (decision-ladder/shortest-diff) — a skill, not a spawnable agent
   - **Domain specialists, added deterministically by path** — e.g. `terraform` for `*.tf`, `docker` for `Dockerfile*`, `kubernetes` for manifests, `api-designer` for routes/OpenAPI/proto, `typescript-agent` for `*.tsx`/components, `sql-agent` for migrations, `aws-expert` for AWS infra, `cicd-architect` for workflow files
   - **Judgment pass:** for changed files none of the above rules cover, the orchestrator may add one more agent from the roster if the file content unambiguously belongs to that domain — it must log why in the report
5. Merges all findings into one list and buckets each as Critical / High / Medium / Low
6. Writes the report to `outputs/reviews/review-pr-<number>-YYYY-MM-DD-HH-MM.md`
7. Prints a one-line summary to the terminal: which reviewers ran and the finding counts per severity

**Usage:**

```
/review-pr https://github.com/acme/widgets/pull/482
```

**Output format:**

The written report includes:
- A 2-3 sentence overall verdict
- The list of reviewers that ran, including any domain specialist or judgment-pass addition and why
- Findings grouped under `## Findings by severity` (Critical / High / Medium / Low)
- A numbered action item list of Critical + High findings only

The terminal output is intentionally brief:

```
Review written to outputs/reviews/review-pr-482-2026-04-04-14-32.md
Reviewers: pragmatic-reviewer, code-reviewer, ponytail (skill), terraform (matched *.tf)
Critical: 0, High: 2, Medium: 3, Low: 1
```

**What the command does not do:**

- It does not accept anything other than a PR URL — no branch names, file paths, or git ranges
- It does not clone the repo for you — it asks first
- It does not print the full report to the terminal — the report is in the file
- It does not open a PR or push anything — it is read-only

**Example output file location:**

```
outputs/
  reviews/
    review-pr-482-2026-04-04-14-32.md
```

The `outputs/reviews/` directory is created automatically if it does not exist. You should add it to `.gitignore` unless you want to commit reviews to the repo.

---

## Best practices for using commands

**Always provide the PR URL.**
Commands are designed to be precise. `/review-pr` without a PR link will stop and prompt you — this is intentional. Be explicit.

**Make sure you have a local clone before running it.**
The command looks for one automatically, but if it can't find it, it will ask you to clone or point it at a path rather than guessing.

**Run `/review-pr` once the PR is open, before merging.**
The command needs `gh` to resolve the PR's diff and metadata, so it's a pre-merge gate rather than a local pre-push check.

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
