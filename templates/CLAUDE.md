# CLAUDE.md — [Project Name]

[One sentence: what this project is and what it does.]

## Stack

- **Language:** [e.g. Python 3.12 / TypeScript 5 / Go 1.22]
- **Framework:** [e.g. FastAPI / Next.js / Gin]
- **Database:** [e.g. PostgreSQL 16 via SQLAlchemy]
- **Infra:** [e.g. AWS ECS + RDS, deployed via Terraform]

## Layout

```
src/                — application source
  [module]/         — [what lives here]
tests/              — [unit | integration | e2e] tests
scripts/            — dev/ops scripts
[config file]       — [what it configures]
```

## Dev setup

```bash
# Install dependencies
[command]

# Run locally
[command]

# Run tests
[command]

# Lint + typecheck
[command]
```

## Must Do

- [Project-specific convention to follow, e.g. "Always run migrations before starting the server"]
- [Naming convention, e.g. "Use snake_case for DB columns, camelCase for API responses"]
- [Testing rule, e.g. "Every new endpoint needs an integration test in tests/api/"]

## Must Never Do

- [Hard constraint, e.g. "Never call the payment provider directly — always go through PaymentService"]
- [Anti-pattern to avoid, e.g. "Never use raw SQL — use the ORM"]
- [Safety rule, e.g. "Never log request bodies — they may contain PII"]

## Key files

- `[path]` — [what it does and why it matters]
- `[path]` — [what it does and why it matters]

## External dependencies

- **[Service name]:** [what it's used for, where credentials live]
- **[Service name]:** [what it's used for, where credentials live]

## Environment variables

| Variable | Required | Purpose |
|---|---|---|
| `[VAR_NAME]` | yes | [what it controls] |
| `[VAR_NAME]` | no | [what it controls, default value] |

## Known gotchas

- [Non-obvious constraint, e.g. "The staging DB is shared — destructive queries need a team heads-up first"]
- [Quirk, e.g. "Auth tokens expire after 15 min in dev; set TOKEN_TTL=3600 if that's annoying"]
