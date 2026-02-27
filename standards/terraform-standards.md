# Terraform Standards

## Module Design
- Modules must be reusable.
- No environment-specific logic inside modules.
- No hardcoded ARNs, IDs, or regions.

## State Management
- Remote state required.
- State locking required.
- No local state in production environments.

## Security
- IAM policies must follow least privilege.
- No wildcard actions unless justified.
- S3 buckets must have encryption enabled.

## Networking
- Compute must run in private subnets.
- Public exposure requires justification.
- Security groups must not allow 0.0.0.0/0 unless required.

## Versioning
- Providers must be pinned.
- Terraform version must be pinned.

## Tagging
- All resources must include:
  - Environment
  - Service
  - Owner
  - Cost Center