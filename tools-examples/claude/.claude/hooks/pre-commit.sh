#!/bin/bash

# Pre-commit Hook
# Prevents committing:
# - .env files with secrets
# - API keys and credentials
# - Private keys
# - Sensitive configuration

set -e

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only)

# Patterns to block
BLOCKED_PATTERNS=(
    "\.env"
    "\.env\."
    "\.pem$"
    "\.key$"
    "secrets\.yml"
    "credentials"
    "api[_-]key"
)

echo "[PRE-COMMIT] Checking for secrets..."

for file in $STAGED_FILES; do
    # Check filename against blocked patterns
    for pattern in "${BLOCKED_PATTERNS[@]}"; do
        if [[ "$file" =~ $pattern ]]; then
            echo "[PRE-COMMIT] ❌ ERROR: Blocked file detected: $file"
            echo "[PRE-COMMIT] Cannot commit files containing secrets or credentials"
            echo "[PRE-COMMIT] Add $file to .gitignore instead"
            exit 2  # Exit code 2 = block the commit
        fi
    done

    # Check file content for common secret patterns
    if git show ":$file" 2>/dev/null | grep -q "API_KEY\|password\|secret\|token"; then
        echo "[PRE-COMMIT] ⚠️  WARNING: File contains secret-like content: $file"
        echo "[PRE-COMMIT] Please review before committing"
    fi
done

echo "[PRE-COMMIT] ✅ No secrets detected"
exit 0
