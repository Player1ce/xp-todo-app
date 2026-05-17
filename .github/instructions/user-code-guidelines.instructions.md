---
name: user-code-guidelines
description: "Use when: writing or refactoring code. Provides guidance on clean architecture, testing, documentation, and performance for sustainable development."
applyTo: "**/*.{js,ts,tsx,jsx,py,java,go,rb,rs,php,c,cpp,cs,kt}"
---

# Clean Code Guidelines

Code should be designed for sustainable long-term development with minimal friction for feature additions and refactoring. These guidelines emphasize clean, maintainable code that balances robustness with pragmatism.

## Architecture & Structure

### Design Patterns
- Use established design patterns (Factory, Observer, Dependency Injection, Strategy, etc.) to solve recurring structural problems.
- Choose patterns that match both the language idioms AND the architectural needs of the system.
- Apply patterns consistently across similar problems; inconsistent patterns increase cognitive load.

### Architectural Patterns
- Organize code using proven architectural approaches suitable to the project scale (MVC, layered, hexagonal, etc.).
- Keep separation of concerns clear: data access, business logic, presentation, and external integrations should be independent layers.
- Avoid tight coupling between modules; dependencies should flow inward toward core logic.

### DRY (Don't Repeat Yourself)
- Extract recurring patterns into reusable classes, utilities, or functions **only when**:
  - The pattern is needed across multiple modules or features (not just twice in one place)
  - Extracting provides meaningful domain clarity
  - The extraction follows the language's standard practices
- Over-extraction creates unnecessary indirection; extract when the shared pattern is genuinely significant.

### Folder Organization
- Group related functionality into folders that reflect domain concepts or architectural layers.
- Keep reusable utilities, services, and helpers in dedicated folders.
- Place tests where appropriate for the convention of the project or languge. In most cases, place tests in a dedicated tests folder mirroring the structure of the src or lib folder that hodls the tested code. Folders within the tests folder should have the same name with test preappended or appended to the name depending on the convention of the language.

## Testing

- **Every feature or behavior change requires associated tests** in a folder structure that mirrors the source code.
- Use the language/framework's default testing framework:
  - JavaScript/TypeScript: Jest
  - Python: pytest
  - Java: JUnit5
  - Go: testing (built-in)
  - Ruby: RSpec
  - Rust: Rust's built-in test framework
- The selected framework shoudl be stored in a file called `framework.md` at the top level of the tests folder.
- If a testing framework needs to be selected prompt the user to select it and suggest the common options for the language.
- Tests should verify behavior, not implementation details. Test the contract, not the implementation.
- Test coverage should focus on critical paths, business logic, and error cases—not trivial getters or configuration.

## Documentation

Documentation should be **concise and complete**: every piece of information needed to understand and use the code, with low to medium verbosity.

### When to Document
- **Always document**: public functions, classes, methods, and non-obvious logic sections
- **Skip documentation**: self-evident single-line functions (simple getters, obvious arithmetic operations), trivial wrappers
- **Rule of thumb**: If you'd have to read the implementation to understand what it does, it needs documentation

### How to Document
- **Be precise**: Explain *what* the function does, *why* it exists (if non-obvious), and any important side effects or constraints.
- **Use language conventions**: JSDoc for JavaScript, docstrings for Python, JavaDoc for Java, etc.
- **Keep it short**: Use complete sentences, but avoid filler words and repetition.
- **Include parameters and returns**: Type, meaning, and constraints (e.g., "non-negative integer", "null if not found").
- **Include thrown error**: Type, case, and suggested reactions

Example (good):
```typescript
/** Merges arrays, removing duplicates. Returns the new array; does not change inputs. */
function mergeUnique<T>(a: T[], b: T[]): T[] { ... }
```

Example (bad - overly verbose):
```typescript
/**
 * This function takes two arrays as input and merges them together. 
 * It removes any duplicate values that might appear in either array.
 * The function returns a new array and does not modify the original arrays.
 */
function mergeUnique<T>(a: T[], b: T[]): T[] { ... }
```

## Error Handling

- **No silent failures**: Every error path must be explicit. Errors must be caught, logged, or propagated clearly.
- **Handle all error cases**: Anticipate failure modes (network errors, missing data, invalid input, resource limits) and define behavior for each.
- **Use language conventions**: Exceptions for truly exceptional cases; Result/Optional types or error returns for expected failures.
- **Clear error messages**: Include enough context for debugging (what failed, why, what was expected).

Example:
```typescript
// Good: explicit error handling
async function loadUser(id: string): Promise<User> {
  if (!id) throw new Error("User ID is required");
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) throw new Error(`HTTP ${response.status}: User not found`);
    return response.json();
  } catch (err) {
    console.error(`Failed to load user ${id}:`, err);
    throw err;
  }
}

// Bad: silent failure
function loadUser(id: string): User {
  return fetch(`/api/users/${id}`).json() || {};  // hides errors
}
```

## Naming Conventions

- Follow the language's standard naming conventions and be consistent throughout the project.
- Use descriptive names that reflect intent: `isActive` not `flag`, `calculateTax` not `calc`.
- Constants: UPPERCASE_WITH_UNDERSCORES (or lowerCamelCase if language convention differs).
- Private/internal: prefix with underscore if language supports it (e.g., `_internalHelper`).
- Avoid single-letter variables except for loop counters or mathematical operations.

**Convention Violations**: When existing code violates the project's established conventions, annotate violations in reviews or comments and flag them with TODO for gradual refactoring.

## Performance

- **Prioritize appropriate performance**: Optimize for the actual bottleneck, not premature speculation.
- **Use language/library features effectively**: 
  - Leverage built-in data structures (hash maps, sets, sorted lists) for their algorithmic benefits.
  - Use language idioms that are both fast and readable (e.g., list comprehensions, modern async patterns).
- **Avoid unnecessary work**: 
  - Cache expensive computations
  - Use lazy evaluation where appropriate
  - Avoid repeated iterations over large datasets
- **Profile before optimizing**: Identify actual performance issues with profiling tools before investing in optimization.
- **Suggest possible optimizations**: When planning and after work, suggest possible optimizations to the user that my be useful in the future or if a certain section of code does not meet performance expectations.

Example:
```python
# Good: uses set for O(1) lookup instead of list O(n)
def has_permission(user_id: int, valid_ids: set[int]) -> bool:
  return user_id in valid_ids

# Bad: O(n) search in a list
def has_permission(user_id: int, valid_ids: list[int]) -> bool:
  return user_id in valid_ids  # linear search
```

## Code Conciseness

- **Concise ≠ cryptic**: Code should be short and clear, never at the expense of readability.
- **Remove unused code and imports**: Dead code is visual noise.
- **Avoid unnecessary abstraction**: If a function has one caller, inlining might be clearer.
- **Use language features wisely**: Ternary operators, comprehensions, and higher-order functions should improve clarity, not reduce it.

## Future Proofing

- **Document project decisions**: Include information and decisions that future agents looking at the project need to know in a `future-agents-notes.md` file at the top level of the project.
- **Be concise**: Keep this information extremely concise documenting only what future agents need to see in as few tokens as possible to express the point.
- **Include decisions**: This file should include decisions abotu proejct structure, class design, standards, testing, and structure that are important for cohesive project work.
- **Review this file**: Review the `future-agents-notes.md` file at the top level of the repository when starting a session to see what decisions have been made.

## Summary

**Sustainable code** balances:
- **Robustness**: Proper error handling, tested behavior, explicit contracts
- **Clarity**: Readable names, concise documentation, obvious structure
- **Performance**: Smart data structures, efficient algorithms, measured optimization
- **Maintainability**: DRY principles applied judiciously, consistent patterns, organized folders
- **Pragmatism**: No over-engineering, no edge cases that cannot happen, focus on the actual problem
- **Future Prooding**: document decisions and structural choices for future agents so work is consistent
