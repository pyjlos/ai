# Security Rules

Applies to: `**/*`

## Sensitive File Protection

Files containing secrets, credentials, or PII must never be committed:

- `.env*` files (local, dev, staging, production)
- `*.key`, `*.pem` (private keys)
- `.aws/*` (AWS credentials)
- `.ssh/*` (SSH keys)
- Any file with credentials, API keys, or tokens
- Database dumps with real data

If you need to read these files to understand configuration, that's fine. Never commit them.

## Hardcoded Secrets

Never hardcoded:
- API keys or secrets
- Database passwords
- Authentication tokens
- Private URLs or internal IPs
- AWS access keys

Pattern to use instead:
```typescript
const apiKey = process.env.EXTERNAL_API_KEY;
if (!apiKey) {
  throw new Error('EXTERNAL_API_KEY environment variable is required');
}
```

## Input Validation

All user-provided input must be validated:
- Type checking
- Length/format validation
- Whitelist approach (allow known good, not blacklist known bad)
- Sanitize before using in queries

```typescript
// DO: Whitelist validation
function parseUserAge(input: string): number {
  const age = parseInt(input, 10);
  if (isNaN(age) || age < 0 || age > 150) {
    throw new ValidationError('Age must be a number between 0 and 150');
  }
  return age;
}

// DON'T: Trust user input
const age = parseInt(userInput, 10);
```

## Authentication & Authorization

- All non-public endpoints require authentication
- Check authorization _before_ accessing data
- Use middleware for centralized checks
- Session tokens should have reasonable expiration (< 24 hours for API tokens)
- Implement rate limiting on auth endpoints

## Error Messages

Never expose sensitive information in error messages:

```typescript
// DO: Generic error
throw new NotFoundError('User not found');

// DON'T: Information leakage
throw new Error('User john@example.com not found in database');
```

## Dependency Vulnerabilities

- Run `npm audit` before committing
- Fix critical and high vulnerabilities immediately
- Medium/low should be prioritized in sprints
- Review advisories, don't just auto-patch

## Logging

Never log sensitive data:
- User passwords or authentication tokens
- API keys or secrets
- Credit card numbers or other PII
- Internal system details that could aid attacks

Safe logging pattern:
```typescript
logger.info('User login', { userId, email });  // Good
logger.debug('Auth token', { token: token.substring(0, 10) + '...' }); // Safe truncation
```
