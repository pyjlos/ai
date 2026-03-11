# Go Code Style Rules

Applies to: `**/*.go`, `cmd/**/*.go`, `internal/**/*.go`

## Formatting

Use gofmt (built-in) for all formatting:
- Standard Go formatting (4-space indents)
- gofmt is enforced in pre-commit
- golangci-lint for additional checks

Format before committing:
```bash
go fmt ./...
```

## Linting

Use golangci-lint with strict configuration:
- All warnings treated as errors in CI
- Format, vet, lint all enabled
- Race detector on (for concurrent code)

Run checks:
```bash
golangci-lint run ./...  # Check
golangci-lint run --fix ./...  # Fix if possible
go test -race ./...  # Include race detector
```

## Naming Conventions

- **camelCase**: Variables, functions, package names
- **PascalCase**: Exported functions, types, interfaces
- **lowercase**: Unexported functions, types
- **SCREAMING_SNAKE_CASE**: Constants (rarely used, prefer CamelCase)
- **Acronyms**: Keep together (HTTPServer not HttpServer)

```go
// Exported
func ProcessUser(user User) error { }
type User struct { }
var MaxRetries = 3

// Unexported
func validateEmail(email string) bool { }
type userCache struct { }
const minPasswordLength = 8
```

## Interfaces

Small, focused interfaces:

```go
// DO: Small interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// DON'T: Fat interfaces
type DataStore interface {
    Create(data interface{}) error
    Read(id string) (interface{}, error)
    Update(id string, data interface{}) error
    Delete(id string) error
    // ... 20 more methods
}

// DO: Compose interfaces
type ReadWriter interface {
    Reader
    Writer
}
```

## Error Handling

Always check errors explicitly:

```go
// DO: Explicit error handling
file, err := os.Open("file.txt")
if err != nil {
    return fmt.Errorf("open file: %w", err)
}
defer file.Close()

// DON'T: Ignore errors
file, _ := os.Open("file.txt")

// DO: Wrap errors for context
if err != nil {
    return fmt.Errorf("process user %d: %w", userID, err)
}

// DON'T: Lose error context
return err
```

## Function Length

- Short functions (< 30 lines preferred)
- Functions > 50 lines need justification
- Extract complex logic
- Early returns to reduce nesting

## Complexity

- Cyclomatic complexity < 10
- Avoid deeply nested code (< 4 levels)
- Use early returns and guard clauses
- Named return variables for clarity

```go
// DO: Early returns
func processUser(user *User) (string, error) {
    if user == nil {
        return "", errors.New("invalid user")
    }
    if user.Email == "" {
        return "", errors.New("missing email")
    }
    return user.Email, nil
}

// DON'T: Nested conditions
func processUser(user *User) (string, error) {
    if user != nil {
        if user.Email != "" {
            return user.Email, nil
        } else {
            return "", errors.New("missing email")
        }
    } else {
        return "", errors.New("invalid user")
    }
}
```

## Pointers

Use carefully:

```go
// DO: Return values for small types
func increment(n int) int {
    return n + 1
}

// DO: Use pointers for large structs or when mutation needed
func updateUser(u *User) error {
    u.LastUpdated = time.Now()
    return nil
}

// DON'T: Unnecessary pointers
func getName(p *string) string { }  // Use string instead

// DON'T: Pointer receivers for value types
func (n *int) Double() { }  // Use (n int) instead
```

## Comments

- Explain *why*, not *what*
- All exported types and functions need comments
- Comment should start with name
- No commented-out code (version control tracks it)

```go
// DO: Comments for exported items
// User represents a user in the system.
type User struct {
    // Email is the user's unique email address.
    Email string
}

// ProcessUser updates the user in the database.
func ProcessUser(user *User) error { }

// DON'T: Missing comments on exported items
func ValidateEmail(email string) bool { }

// DON'T: Comments that restate code
user := getUser()  // Get the user
```

## Package Organization

- One package per directory
- Keep related functionality together
- Use internal/ for unexported packages
- cmd/ for executables

```
project/
├── cmd/
│   ├── server/
│   │   └── main.go
│   └── cli/
│       └── main.go
├── internal/
│   ├── user/
│   │   ├── service.go
│   │   └── service_test.go
│   └── api/
│       ├── handler.go
│       └── handler_test.go
├── pkg/
│   ├── client/
│   │   └── client.go
│   └── models/
│       └── user.go
└── go.mod
```

## Testing

Always write tests:
- Table-driven tests for multiple cases
- Use *testing.T parameter
- Test both happy and error paths
- Coverage goal: 80%+

```go
func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name    string
        email   string
        want    bool
        wantErr bool
    }{
        {
            name:  "valid email",
            email: "user@example.com",
            want:  true,
        },
        {
            name:    "invalid email",
            email:   "not-an-email",
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ValidateEmail(tt.email)
            if (err != nil) != tt.wantErr {
                t.Errorf("ValidateEmail() error = %v, wantErr %v", err, tt.wantErr)
            }
            if got != tt.want {
                t.Errorf("ValidateEmail() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Concurrency

Use goroutines and channels safely:

```go
// DO: Proper context usage
func fetchData(ctx context.Context) (string, error) {
    select {
    case <-ctx.Done():
        return "", ctx.Err()
    case result := <- fetchChan:
        return result, nil
    }
}

// DO: Use sync.WaitGroup for coordination
var wg sync.WaitGroup
wg.Add(1)
go func() {
    defer wg.Done()
    // work
}()
wg.Wait()

// DON'T: Goroutines without proper cleanup
go func() {
    // What if this leaks?
}()
```

## Defer

Use defer for cleanup:

```go
// DO: Defer for cleanup
file, err := os.Open("file.txt")
if err != nil {
    return err
}
defer file.Close()

// DON'T: Manual cleanup (easy to forget)
file, err := os.Open("file.txt")
if err != nil {
    return err
}
// ... lots of code ...
file.Close()  // What if we return early?
```

## Avoid Anti-Patterns

- ❌ ignore errors (use `_` explicitly only when sure)
- ❌ Shadowing variables
- ❌ Using panic for normal errors (return error instead)
- ❌ Bare return in large functions
- ❌ Global variables
- ❌ Making the zero value invalid (always make zero value usable)

```go
// DO: Zero value is usable
type User struct {
    Name  string
    Email string
}

// DON'T: Zero value is invalid
type Config struct {
    Port int  // 0 is not a valid port
}

// DO: Explicit error handling
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}

// DON'T: Panic for normal errors
if err != nil {
    panic(err)
}
```
