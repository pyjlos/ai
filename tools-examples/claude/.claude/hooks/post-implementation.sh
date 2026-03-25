#!/bin/bash

# Post-Implementation Hook
# Runs after senior-engineer completes implementation to ensure:
# - Tests pass
# - Linting passes
# - Code is properly formatted

set -e

echo "[POST-IMPLEMENTATION] Running quality checks..."

# Detect language and run appropriate tests
if [ -f "package.json" ]; then
    echo "[POST-IMPLEMENTATION] JavaScript/TypeScript detected"
    npm run lint 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Linting failed"
    npm test 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Tests failed"
    npm run format -- --check 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Formatting issues found"
fi

if [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    echo "[POST-IMPLEMENTATION] Python detected"
    ruff check . 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Ruff linting failed"
    black --check . 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Black formatting issues found"
    python -m pytest 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Tests failed"
fi

if [ -f "go.mod" ]; then
    echo "[POST-IMPLEMENTATION] Go detected"
    go fmt ./... 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Go formatting failed"
    golangci-lint run ./... 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Linting failed"
    go test -race ./... 2>/dev/null || echo "[POST-IMPLEMENTATION] ⚠️  Tests failed"
fi

echo "[POST-IMPLEMENTATION] ✅ Quality checks complete"
exit 0
