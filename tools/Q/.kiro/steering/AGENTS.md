# Team Context

> This file is always loaded into every Kiro session globally.
> Edit it to reflect your actual team stack, standards, and conventions.

## Team & Project

- **Team**: [Your team name]
- **Org**: [Your company/org name]
- **Primary repos**: [e.g., ~/repos/platform]

## Tech Stack

- **Languages**: [e.g., TypeScript, Python, Go]
- **Frameworks**: [e.g., React, FastAPI, Express]
- **Cloud**: AWS
- **IaC**: [e.g., CDK (TypeScript), Terraform]
- **Databases**: [e.g., Aurora PostgreSQL, DynamoDB]
- **Messaging**: [e.g., SQS, EventBridge]
- **CI/CD**: [e.g., GitHub Actions, AWS CodePipeline]
- **Containers**: [e.g., ECS Fargate, EKS]

## Coding Conventions

- [e.g., ESLint + Prettier with the Airbnb config for TypeScript]
- [e.g., All exported functions require JSDoc]
- [e.g., Error handling uses a Result<T, E> pattern, not thrown exceptions]
- [e.g., All API responses follow the { data, error, meta } envelope]

## Branch and PR Standards

- [e.g., Branch naming: feat/, fix/, chore/, refactor/]
- [e.g., PRs require 2 approvals before merge]
- [e.g., Commits follow Conventional Commits spec]

## Testing Standards

- Unit tests: 80% minimum coverage on business logic
- Integration tests for all API routes
- No mocking of the module under test — only external dependencies

## Always Flag

- Hardcoded secrets, credentials, or account IDs
- Direct database access outside the repository/service layer
- Missing input validation on any external-facing API
- IAM policies with `*` resource or action
- `console.log` in production code (use the structured logger)

## Settled Decisions (do not re-litigate)

- [e.g., We use DynamoDB for session storage, not ElastiCache]
- [e.g., All services deploy as ECS Fargate, not EC2 or Lambda]
- [e.g., We do not use AWS Amplify]
