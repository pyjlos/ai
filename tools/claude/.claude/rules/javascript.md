# JavaScript & TypeScript Code Style Rules

Applies to: `src/**/*.ts`, `src/**/*.tsx`, `src/**/*.js`, `src/**/*.jsx`

## Formatting

Use Prettier for all formatting:
- Line length: 100 characters
- Tab width: 2 spaces
- No semicolons
- Single quotes for strings
- Trailing commas in multiline

Configuration in `package.json` or `.prettierrc`.

Format before committing:
```bash
npm run format
```

## Linting

Use ESLint with TypeScript support and strict configuration:
- TypeScript strict mode enabled
- No `// eslint-disable` comments without reason
- All warnings treated as errors in CI

Fix linting errors:
```bash
npm run lint          # Check
npm run lint -- --fix # Fix automatically
```

## TypeScript Strict Mode

Always use TypeScript strict mode:
- No `any` type (except with explicit comment explaining why)
- Strict null checking
- No implicit return types
- Proper typing for generics
- strictPropertyInitialization enabled

```typescript
// DO: Explicit typing
function processData<T extends { id: string }>(item: T): T {
  return { ...item };
}

// DON'T: Implicit or any
function processData(item: any) {
  return item;
}

// DO: Explicit types for generics
const cache: Map<string, Cache> = new Map();

// DON'T: Implicit generic types
const cache: Map = new Map();
```

## Import Organization

Import statement order:
1. External packages
2. Type imports
3. Relative imports (parent directories)
4. Relative imports (current directory)
5. Side effects (CSS, etc.)

Within groups, sort alphabetically and separate types.

```typescript
import { describe, it } from 'vitest'; // External
import type { User } from '../types'; // External (types)
import { userService } from '../services/userService'; // Parent
import { helper } from './helper'; // Current
import './styles.css'; // Side effects
```

## Naming Conventions

- **camelCase**: Variables, functions, parameters, methods
- **PascalCase**: Classes, types, interfaces, enums, React components
- **SCREAMING_SNAKE_CASE**: Constants only
- **kebab-case**: File names, directory names

```typescript
const MAX_RETRIES = 3; // Constant
const currentRetries = 0; // Variable
function validateEmail(email: string) {} // Function
class UserService {} // Class
interface User {} // Type (don't use I prefix)
enum Role {} // Enum
const UserCard = () => <div /> // React component
```

## Function Length

- Prefer short functions (< 20 lines)
- Functions > 30 lines need justification
- Extract complex logic into helper functions
- Each function should have single responsibility

## Async/Await

Always prefer async/await over Promise chains:

```typescript
// DO: Async/await
async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}

// DON'T: Promise chains
function fetchUser(id: string): Promise<User> {
  return fetch(`/api/users/${id}`)
    .then(r => r.json());
}
```

## Complexity

- Cyclomatic complexity < 8
- Avoid deeply nested code (< 4 levels)
- Use early returns to reduce nesting
- Break complex conditions into named variables

```typescript
// DO: Early returns reduce nesting
function processUser(user: User | null): string {
  if (!user) return 'Invalid user';
  if (!user.email) return 'Missing email';
  return user.email.toLowerCase();
}

// DON'T: Nested pyramid of doom
function processUser(user: User | null): string {
  if (user) {
    if (user.email) {
      return user.email.toLowerCase();
    } else {
      return 'Missing email';
    }
  } else {
    return 'Invalid user';
  }
}
```

## Comments

- Explain *why*, not *what*
- Self-documenting code needs fewer comments
- Use JSDoc for public APIs, avoid comments for obvious code
- Remove commented-out code (version control tracks it)

```typescript
// DO: Explain reasoning
// Use ISO format because our API returns ISO 8601 timestamps
const date = parseISO(dateString);

// DON'T: Restate the code
const date = parseISO(dateString); // Parse the date string to ISO format

// DO: JSDoc for public APIs
/**
 * Validates an email address format.
 * @param email - The email to validate
 * @returns true if valid, false otherwise
 */
export function validateEmail(email: string): boolean {
  // implementation
}
```

## File Organization

- One main export per file
- Related utilities in the same directory
- Tests colocated with source

```
src/
├── services/
│   ├── userService.ts
│   ├── userService.test.ts
│   ├── authService.ts
│   └── authService.test.ts
├── types/
│   ├── user.ts
│   └── auth.ts
└── utils/
    ├── validation.ts
    └── validation.test.ts
```

## Avoid Anti-Patterns

- ❌ Single-letter variables (except i, j in loops)
- ❌ Comments that describe obvious code
- ❌ Functions with side effects hidden in the name
- ❌ Boolean parameters to functions (use object param)
- ❌ Global state or mutable singletons
- ❌ Magic numbers (use named constants)
- ❌ Optional chaining without null check (when it matters)

```typescript
// DO: Named constant instead of magic number
const PASSWORD_MIN_LENGTH = 8;
if (password.length < PASSWORD_MIN_LENGTH) { ... }

// DON'T: Magic number
if (password.length < 8) { ... }

// DO: Object param instead of boolean
function updateUser(user, { isActive, sendEmail } = {}) { ... }

// DON'T: Boolean parameters
function updateUser(user, isActive, sendEmail) { ... }

// DO: Named constants
const RETRY_DELAY_MS = 1000;
setInterval(retry, RETRY_DELAY_MS);

// DON'T: Magic numbers
setInterval(retry, 1000);
```

## Null Checking

Be explicit about null/undefined handling:

```typescript
// DO: Explicit null checks
if (user !== null && user !== undefined) {
  console.log(user.email);
}

// OK: Nullish coalescing for defaults
const name = user?.name ?? 'Unknown';

// DON'T: Trust that it's not null without checking
console.log(user.email); // What if user is null?
```

## Testing

- Unit tests with Vitest or Jest
- E2E tests with Cypress or Playwright
- 80%+ code coverage for critical paths
- Test names describe behavior, not implementation

```typescript
describe('UserService', () => {
  describe('validateEmail', () => {
    it('should return true for valid email addresses', () => {
      expect(validateEmail('user@example.com')).toBe(true);
    });

    it('should return false for invalid email addresses', () => {
      expect(validateEmail('not-an-email')).toBe(false);
    });
  });
});
```

## React Components

For `.tsx` files:

```typescript
// DO: Functional component with hooks
interface UserCardProps {
  user: User;
  onDelete?: () => void;
}

export const UserCard: React.FC<UserCardProps> = ({ user, onDelete }) => {
  return (
    <div className="card">
      <h2>{user.name}</h2>
    </div>
  );
};

// DO: Use hooks properly
const [count, setCount] = useState(0);
useEffect(() => {
  // Setup
  return () => {
    // Cleanup
  };
}, [dependencies]);
```
