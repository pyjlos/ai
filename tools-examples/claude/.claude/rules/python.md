# Python Code Style Rules

Applies to: `**/*.py`, `src/**/*.py`, `tests/**/*.py`

## Formatting

Use Black for all formatting:
- Line length: 100 characters
- Double quotes for strings
- Normalized whitespace

Configuration in `pyproject.toml` or `setup.cfg`.

Format before committing:
```bash
black .
```

## Linting

Use Ruff for linting with strict configuration:
- Type checking enabled (pyright)
- All warnings treated as errors
- Docstring requirements enforced

Check and fix:
```bash
ruff check --fix .
ruff format .
```

## Type Hints

Always use type hints (PEP 484):
- All function parameters and returns
- Class attributes
- Module-level constants

```python
# DO: Full type hints
def process_data(items: list[dict[str, Any]]) -> dict[str, int]:
    """Process items and return counts."""
    return {}

# DON'T: Missing types
def process_data(items):
    return {}
```

## Import Organization

Order by:
1. Standard library
2. Third-party packages
3. Local/relative imports
4. Alphabetical within groups

```python
import json
from typing import Any

import numpy as np
import pandas as pd

from .utils import helper
from .models import User
```

## Naming Conventions

- **snake_case**: Variables, functions, parameters, modules
- **SCREAMING_SNAKE_CASE**: Constants only
- **PascalCase**: Classes, exceptions
- **_private**: Lead with underscore for private

```python
MAX_RETRIES = 3  # Constant
def validate_email(email: str) -> bool:  # Function
class UserService:  # Class
    _internal_cache = {}  # Private
```

## Function Length

- Prefer short functions (< 20 lines)
- Functions > 30 lines need justification
- Extract complex logic into helpers
- Single responsibility principle

## Complexity

- Cyclomatic complexity < 8
- Avoid deeply nested code (< 4 levels)
- Use guard clauses for early returns
- Extract complex conditionals into methods

```python
# DO: Early returns
def process_user(user: User) -> str:
    if not user:
        return "Invalid user"
    if not user.email:
        return "Missing email"
    return user.email.lower()

# DON'T: Nested pyramid
def process_user(user: User) -> str:
    if user:
        if user.email:
            return user.email.lower()
        else:
            return "Missing email"
    else:
        return "Invalid user"
```

## Docstrings

Use Google-style docstrings for all public functions/classes:

```python
def validate_email(email: str) -> bool:
    """Validate email address format.

    Args:
        email: The email address to validate

    Returns:
        True if valid, False otherwise

    Raises:
        TypeError: If email is not a string
    """
```

## Comments

- Explain *why*, not *what*
- Self-documenting code needs fewer comments
- Use type hints instead of type comments
- Remove commented-out code (version control tracks it)

```python
# DO: Explain reasoning
# Use ISO format because API returns ISO 8601 timestamps
date = datetime.fromisoformat(date_string)

# DON'T: Restate the code
date = datetime.fromisoformat(date_string)  # Parse the ISO date string
```

## File Organization

- One main class/function per file (or closely related)
- Related utilities in the same package
- Tests colocated with source

```
src/
├── services/
│   ├── user_service.py
│   ├── user_service_test.py
│   ├── auth_service.py
│   └── auth_service_test.py
├── models/
│   ├── user.py
│   └── auth.py
└── utils/
    ├── validation.py
    └── validation_test.py
```

## Avoid Anti-Patterns

- ❌ Single-letter variables (except i, j in loops)
- ❌ Comments that describe obvious code
- ❌ Global mutable state
- ❌ Bare except clauses
- ❌ Magic numbers (use named constants)
- ❌ Mutable default arguments

```python
# DO: Named constant instead of magic number
MIN_PASSWORD_LENGTH = 8
if len(password) < MIN_PASSWORD_LENGTH:
    raise ValueError("Password too short")

# DON'T: Magic number
if len(password) < 8:
    raise ValueError("Password too short")

# DO: Immutable defaults
def add_item(items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    return items

# DON'T: Mutable defaults
def add_item(items: list[str] = []) -> list[str]:  # Bug!
    return items
```

## Context Managers

Use context managers for resource management:

```python
# DO: Automatic cleanup
with open("file.txt") as f:
    data = f.read()

# DON'T: Manual cleanup (error-prone)
f = open("file.txt")
data = f.read()
f.close()
```

## Comprehensions

Prefer comprehensions for simple transformations:

```python
# DO: Comprehensions are more readable
squares = [x**2 for x in range(10)]
filtered = [x for x in items if x > 5]

# OK for complex logic, extract to function
results = [expensive_operation(x) for x in items]
# Better:
results = [transform(x) for x in items]
```

## Testing

All code must have tests:
- Unit tests for functions/classes
- Pytest is the testing framework
- Use fixtures for setup/teardown
- Mocking for external dependencies

```python
def test_validate_email_valid():
    """Valid emails should return True."""
    assert validate_email("user@example.com") is True

def test_validate_email_invalid():
    """Invalid emails should return False."""
    assert validate_email("not-an-email") is False
```
