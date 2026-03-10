# Shared Team Context

> This file is injected into every Q Developer agent session.
> Edit it to reflect your team's actual stack, standards, and conventions.

## Team & Project

- **Team**: [Your team name]
- **Org**: [Your company/org name]
- **Primary repos**: [e.g., monorepo at ~/projects/platform]

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

- [e.g., We use ESLint + Prettier with the Airbnb config]
- [e.g., All functions must have JSDoc if they are exported]
- [e.g., Error handling uses a Result<T, E> pattern, not thrown exceptions]
- [e.g., All API responses follow the { data, error, meta } envelope]

## Branch & PR Standards

- [e.g., Branch naming: feat/, fix/, chore/, refactor/]
- [e.g., PRs require 2 approvals before merge]
- [e.g., Commits follow Conventional Commits spec]

## Testing Standards

- [e.g., Unit tests: Jest/Vitest, target 80% coverage on business logic]
- [e.g., Integration tests: Supertest for API routes]
- [e.g., No mocking of the module under test — only external dependencies]

## Things to Always Flag

- Hardcoded secrets, credentials, or account IDs
- Direct database access outside of the repository/service layer
- Missing input validation on any external-facing API
- IAM policies with `*` resource or action
- Any use of `console.log` in production code (use the logger)

## Things We've Decided (don't re-litigate)

- [e.g., We use DynamoDB for session storage, not ElastiCache]
- [e.g., All services are deployed as ECS Fargate, not EC2 or Lambda]
- [e.g., We do not use AWS Amplify]