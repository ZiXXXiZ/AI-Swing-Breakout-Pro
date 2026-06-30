# CONTRIBUTING

## 1. Project Philosophy

* Build production-quality software from the beginning.
* Prefer simplicity over cleverness.
* Design for maintainability, extensibility, and testability.
* Finish one module completely before starting the next.

---

## 2. Directory Structure

* Organize the project by **packages**, not individual files.
* Each package should contain:

  * Source files
  * Tests
  * `README.md`
* Shared documentation belongs in the `Docs/` directory.

---

## 3. Coding Standards

* Write compile-ready MQL5 code.
* No placeholder or pseudocode in production files.
* Keep functions focused on a single responsibility.
* Use consistent formatting and naming throughout the project.
* Avoid duplicated logic.

---

## 4. Naming Conventions

| Item            | Convention     |
| --------------- | -------------- |
| Class           | `C` prefix     |
| Interface       | `I` prefix     |
| Struct          | `S` prefix     |
| Enum            | `ENUM_` prefix |
| Global Object   | `g_` prefix    |
| Member Variable | `m_` prefix    |
| Constant        | `UPPER_CASE`   |

---

## 5. Package Architecture

A package is the unit of development.

Each package contains:

* Source code
* Tests
* Documentation

A package is considered complete only after all three are finished.

---

## 6. Dependency Rules

Dependencies flow only in one direction:

```text
Strategy
    ↓
Trading
    ↓
Core Services
    ↓
Utilities
```

Lower-level packages must never depend on higher-level packages.

---

## 7. Development Workflow

Every module follows this workflow:

1. Design
2. Complete production source
3. Compile
4. Fix compiler issues
5. Unit tests
6. Documentation update
7. Code review
8. Git commit

---

## 8. Testing Standards

* Test public behavior, not implementation details.
* Every public method must have unit tests.
* Each assertion produces one log line.
* Every test file prints a final summary.
* Use consistent assertion helpers across the project.

---

## 9. Documentation Standards

Every package must provide:

* `README.md`
* Public API overview
* Dependencies
* Example usage
* Revision history (when appropriate)

---

## 10. Definition of Done

A module is complete only when:

* Source code is complete.
* Compiles with zero errors.
* Compiles with zero warnings.
* Unit tests pass.
* Documentation is updated.
* Ready for Git commit.

---

## 11. Git Commit Guidelines

* Keep commits focused on a single logical change.
* Ensure the project compiles before committing.
* Update documentation when public APIs change.
* Write clear, descriptive commit messages.

---

## 12. Versioning Policy

* Follow semantic versioning.
* Increment:

  * Patch for fixes
  * Minor for new backward-compatible features
  * Major for breaking changes
* Tag stable milestones in Git.
