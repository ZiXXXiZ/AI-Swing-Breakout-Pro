# API_GUIDELINES.md

**Project:** AI Swing Breakout Pro Framework
**Version:** 2.0.0-alpha.2
**Last Updated:** 2026-07-03

---

# Purpose

This document defines the standards for designing public APIs within the AI Swing Breakout Pro Framework.

Its goals are to:

* Provide a consistent developer experience.
* Minimize breaking changes.
* Improve discoverability.
* Simplify maintenance.
* Encourage reusable and testable components.

These guidelines apply to all public classes, methods, enumerations, and constants.

---

# API Design Principles

Every public API should be:

* Simple
* Predictable
* Consistent
* Reusable
* Testable
* Backward compatible whenever practical

Avoid exposing internal implementation details.

---

# Class Design

Each class should have a single responsibility.

Examples:

* `CStringUtils` → String operations
* `CTimeUtils` → Date and time operations
* `CRiskManager` → Risk calculations

Avoid "god classes" that combine unrelated responsibilities.

---

# Public Interface

Expose only the methods required by consumers.

Keep helper methods private or protected whenever possible.

Minimize the public surface area.

---

# Static Utility Classes

Utility classes should:

* Contain only static methods.
* Maintain no internal state.
* Be safe to call from anywhere.

Examples:

* `CStringUtils`
* `CTimeUtils`
* `CMathUtils`

---

# Method Naming

Use clear action-oriented names.

Good examples:

* `NormalizePrice()`
* `CalculateRisk()`
* `FormatDate()`
* `IsTradingDay()`

Avoid abbreviations unless they are well-known in the MQL5 ecosystem.

---

# Parameters

Parameter order should follow a consistent pattern:

1. Required inputs
2. Optional inputs
3. Configuration flags
4. Output parameters (if unavoidable)

Use descriptive parameter names.

---

# Return Values

Prefer returning meaningful values directly.

Use `bool` to indicate success or failure where appropriate.

Avoid returning ambiguous sentinel values.

---

# Error Reporting

Functions should:

* Validate input.
* Return predictable results.
* Log unexpected conditions through the framework logger.
* Never fail silently.

---

# Enumerations

Expose enums instead of magic numbers.

Example:

```cpp
enum ETradeDirection
{
   TRADE_BUY,
   TRADE_SELL
};
```

---

# Constants

Shared constants should be centralized.

Avoid duplicating values across modules.

---

# Backward Compatibility

Public APIs should remain stable.

If a breaking change is necessary:

* Document it.
* Update the changelog.
* Revise dependent modules.

---

# Documentation Requirements

Every public API should document:

* Purpose
* Parameters
* Return value
* Preconditions
* Side effects (if any)

---

# Testing Requirements

Every public API should have unit tests covering:

* Expected behavior
* Boundary conditions
* Invalid input
* Regression scenarios

---

# Review Checklist

Before introducing or modifying a public API:

* Is the name clear?
* Does it have a single responsibility?
* Is the parameter order consistent?
* Is the return type appropriate?
* Is the API documented?
* Are unit tests included?
* Is backward compatibility preserved?

---

# Continuous Improvement

API design should evolve carefully.

Any proposed changes should improve consistency, usability, or maintainability without introducing unnecessary breaking changes.
