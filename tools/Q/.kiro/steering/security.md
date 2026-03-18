---
inclusion: always
---

# Security Standards

## Never Do

- Hardcode secrets, API keys, database passwords, or authentication tokens
- Commit `.env*`, `*.key`, `*.pem`, `.aws/`, or `.ssh/` files
- Log sensitive data: passwords, tokens, SSNs, credit card numbers
- Trust user input without validation

## Always Do

- Use environment variables for all secrets
- Validate all user input: type, length, format — whitelist, not blacklist
- Sanitize inputs before use in queries or HTML
- Expose generic error messages to callers; log detail internally
- Run `npm audit` / `pip audit` / `go list -m all` before committing
- Fix critical and high severity vulnerabilities immediately

## IAM (AWS)

- All policies must follow least privilege — no `*` actions or resources without justification
- Review and document any wildcard permission explicitly as an accepted risk
