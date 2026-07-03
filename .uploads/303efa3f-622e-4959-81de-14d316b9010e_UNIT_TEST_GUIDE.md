# UNIT_TEST_GUIDE.md

**Project:** AI Swing Breakout Pro Framework
**Version:** 2.0.0-alpha.2
**Last Updated:** 2026-07-03

---

# Purpose

This guide defines the standards for writing and maintaining unit tests within the AI Swing Breakout Pro Framework.

Its objectives are to:

* Ensure consistent test quality.
* Improve confidence when refactoring.
* Detect regressions early.
* Document expected behavior through executable tests.

Every public API introduced into the framework should have corresponding unit tests.

---

# Testing Philosophy

The framework follows these principles:

* Test behavior, not implementation.
* Keep tests deterministic.
* Make tests independent.
* Keep tests readable.
* Fail fast.
* Prefer many small tests over a few large tests.

---

# Test Project Structure

```text
Tests/
│
├── Framework/
│
├── Utilities/
│   ├── TestStringUtils.mq5
│   ├── TestTimeUtils.mq5
│   ├── TestMathUtils.mq5
│   └── TestArrayUtils.mq5
│
├── Trading/
│
├── Strategy/
│
└── AI/
```

Each production module should have one corresponding test module.

---

# Naming Convention

Test files should begin with `Test`.

Examples:

```text
TestStringUtils.mq5
TestTimeUtils.mq5
TestMathUtils.mq5
TestRiskManager.mq5
```

Test functions should clearly describe the expected behavior.

Examples:

```text
Test_FormatDate_ReturnsExpectedValue()
Test_IsWeekend_ReturnsTrueForSunday()
Test_CalculateRisk_InvalidInput()
```

---

# Test Structure

Each test should follow the Arrange–Act–Assert pattern.

```text
Arrange
    ↓
Act
    ↓
Assert
```

### Arrange

Prepare the required data.

### Act

Execute the function being tested.

### Assert

Verify the result.

---

# Test Categories

Every public API should be tested in the following categories where applicable:

## Normal Cases

Expected input produces expected output.

## Boundary Cases

Test minimum and maximum valid values.

## Invalid Input

Ensure invalid parameters are handled safely.

## Error Conditions

Verify correct behavior when operations fail.

## Regression Tests

Cover previously fixed defects to prevent reoccurrence.

---

# Assertions

Each test should verify one primary behavior.

Avoid combining unrelated assertions in a single test.

Examples:

* Equality
* Inequality
* Boolean state
* Numeric tolerance
* String comparison

---

# Test Independence

Tests must not depend on:

* Execution order
* Shared mutable state
* Previous test results
* External configuration

Each test should be executable in isolation.

---

# Performance

Unit tests should execute quickly.

Avoid:

* Long-running loops
* Network operations
* User interaction
* Unnecessary file access

Performance testing belongs in dedicated benchmark suites.

---

# Logging

Tests should log meaningful diagnostic information only when necessary.

Successful tests should remain concise.

Failures should clearly identify:

* Test name
* Expected value
* Actual value
* Relevant context

---

# Coverage Goals

Target coverage:

| Layer          | Goal |
| -------------- | :--: |
| Utilities      | 100% |
| Infrastructure | 100% |
| Trading        | 100% |
| Strategy       | 100% |
| AI             | 100% |

Every public function should have at least one corresponding unit test.

---

# Continuous Integration

Before a release:

* All unit tests must execute successfully.
* No test should be ignored without documented justification.
* Regression tests must remain in the repository.

---

# Definition of Done

A module is considered tested when:

* All public APIs have unit tests.
* All tests pass consistently.
* Boundary conditions are covered.
* Invalid input is validated.
* Regression tests exist for known defects.

---

# Test Review Checklist

Before approving a test:

* Test name is descriptive.
* Arrange–Act–Assert pattern is followed.
* Only one behavior is verified.
* No hidden dependencies exist.
* Expected results are clearly defined.
* Tests are deterministic and repeatable.

---

# Continuous Improvement

The test suite should evolve alongside the framework.

Whenever a bug is fixed, add or update a regression test to ensure the issue does not reappear.

Testing is a core part of the framework's quality process and should be maintained with the same care as production code.
