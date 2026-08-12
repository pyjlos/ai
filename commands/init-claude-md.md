Generate a project-level `CLAUDE.md` for the current repository by interviewing the user, then writing the file using the template structure defined below.

## Guard

- Run `git rev-parse --show-toplevel` to confirm the current directory is inside a git repository. If it is not, stop and tell the user this command must be run from inside a repo.
- If `CLAUDE.md` already exists at the repo root, show its current contents and ask the user whether to overwrite it, merge into it, or abort. Do not overwrite silently.
- Never write outside the current repository root.

---

## Step 1 — Survey the repo before asking questions

Do not ask the user anything that you can determine yourself by reading the repo:

- Read the top-level directory listing and any existing README to infer the project's purpose and stack
- Detect the language(s), package manager, test runner, and lint/typecheck commands from config files (`package.json`, `pyproject.toml`, `go.mod`, `Makefile`, CI config, etc.)
- Note the layout of top-level directories

Bring this to Step 2 as your best-guess draft — the interview should confirm or correct it, not start from a blank slate.

---

## Step 2 — Interview the user

Ask the following, proposing your best-guess answer from Step 1 as a default the user can accept or override. Ask one question at a time if using AskUserQuestion, or batch them if asking in plain text — whichever fits the number of open questions.

1. **Purpose** — What does this project do, in one or two sentences?
2. **Must Do** — What conventions must always be followed here (naming, structure, required steps after certain edits, required checks before commit)?
3. **Must Never Do** — What actions are off-limits in this repo (files never to edit directly, patterns to avoid, things that have caused problems before)?
4. **Layout** — Confirm or correct the directory layout you inferred in Step 1.
5. **Build/test/lint commands** — What commands do you run to build, test, and lint this project?
6. **Cross-repo collaboration** — Does this project's work ever span other repositories (shared libraries, a monorepo sibling, an API contract with another service, a design system consumed elsewhere)? If yes, ask for:
   - The name/path of each related repo
   - What kind of collaboration crosses the boundary (shared types, API contracts, shared config, etc.)
   - Where those repos live relative to this one (sibling directory, separate clone path, submodule)

   If there are no cross-repo dependencies, skip this section in the generated file entirely — do not include a placeholder.

Do not proceed to Step 3 until the user has answered or explicitly skipped each question.

---

## Step 3 — Write CLAUDE.md

Use this structure (mirrors this repo's own `CLAUDE.md` conventions):

```markdown
# CLAUDE.md — <project name>

<1-2 sentence purpose, from Step 2.1>

## Must Do

- <bullet per Must Do item from Step 2.2>

## Must Never Do

- <bullet per Must Never Do item from Step 2.3>

## Layout

\`\`\`
<directory tree from Step 2.4>
\`\`\`

## Build, test, lint

- Build: `<command>`
- Test: `<command>`
- Lint/typecheck: `<command>`

## Cross-repo collaboration

<Only include this section if Step 2.6 surfaced any related repos.>

- `<repo name/path>` — <what crosses the boundary and where it lives>

When comparing against or reading code in these repos, always pull the latest `main` first — see `rules/git.md`. Do not treat a stale local checkout of another repo as ground truth.
```

Omit any section with no content rather than leaving a placeholder (e.g., if there are no cross-repo dependencies, drop that section entirely).

Write the file to `<repo-root>/CLAUDE.md`.

---

## Step 4 — Report back

Tell the user:
- The path written
- A one-line summary of what sections were included
- Any question they skipped that they may want to fill in later
