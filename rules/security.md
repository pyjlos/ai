# Security
 
These are non-negotiable. No exceptions.
 
## Hard rules
 
- NEVER hardcode secrets, API keys, tokens, or credentials anywhere in code or comments
- NEVER commit `.env` files or any file containing real credentials
- NEVER build SQL queries or shell commands by concatenating user input — always use parameterised queries or safe APIs
- NEVER use `eval()`, `exec()`, or equivalent on any untrusted input
- NEVER log passwords, tokens, PII, or session identifiers
- NEVER expose raw stack traces or internal error details to end users or API consumers
- NEVER use MD5 or SHA1 for anything security-sensitive — use SHA-256 or better
- NEVER use `pickle.loads()` (Python) or `deserialize()` on untrusted data
- NEVER use `yaml.load()` without `Loader=yaml.SafeLoader`
 
## Always do
 
- Validate and sanitise all input at the boundary, before it touches business logic
- Use environment variables for all configuration that differs between environments
- Use the principle of least privilege — request only the permissions actually needed
- Prefer well-maintained libraries for crypto, auth, and serialisation over rolling your own
- Check that authentication and authorisation are enforced on every endpoint that touches sensitive data
 
## Dependencies
 
- Pin dependency versions in lockfiles — never leave them open-ended in production
- Do not add a new dependency to solve something the stdlib handles in under 10 lines
 