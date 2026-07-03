# CODING_STANDARD.md

**Project:** AI Swing Breakout Pro Framework
**Version:** 2.0.0-alpha.2
**Last Updated:** 2026-07-03

---

# Purpose

This document defines the coding standards for the AI Swing Breakout Pro Framework.

Its objectives are to:

* Maintain consistent code style.
* Improve readability and maintainability.
* Reduce defects.
* Simplify code reviews.
* Ensure all framework modules follow the same engineering practices.

All source code committed to the repository **must comply with these standards**.

---

# General Principles

The framework follows these engineering principles:

* Keep code simple.
* Prefer readability over cleverness.
* One responsibility per module.
* One responsibility per class.
* Avoid duplicated logic.
* Prefer composition over tightly coupled designs.
* Design for reuse.
* Write code that is easy to test.

---

# Project Structure

```text
Core/
Tests/
Examples/
Documentation/
```

Each folder has a single purpose.

Production code and test code must never be mixed.

---

# Naming Conventions

## Files

Use PascalCase.

Examples

```text
Logger.mqh
TimeUtils.mqh
MathUtils.mqh
RiskManager.mqh
```

---

## Classes

Use PascalCase with the `C` prefix.

Examples

```cpp
class CStringUtils
class CTimeUtils
class CRiskManager
```

---

## Interfaces

Use the `I` prefix.

Examples

```cpp
ITradeSignal
IRiskModel
IExitRule
```

---

## Enumerations

Use PascalCase with an `E` prefix.

Examples

```cpp
enum ETradeDirection
enum EOrderState
```

Enumerator values should be descriptive and consistently prefixed where appropriate.

---

## Methods

Use PascalCase.

Examples

```cpp
CalculateRisk()
NormalizePrice()
FormatDate()
```

Method names should clearly express the action performed.

---

## Variables

### Local Variables

Use camelCase.

```cpp
currentPrice
riskPercent
tradeVolume
```

### Member Variables

Prefix with `m_`.

```cpp
m_symbol
m_magicNumber
m_positionSize
```

### Static Members

Prefix with `s_`.

```cpp
s_instance
s_version
```

### Constants

Use uppercase with underscores.

```cpp
MAX_TRADES
DEFAULT_MAGIC
SECONDS_PER_DAY
```

---

# File Header

Every source file should begin with a standard header.

```cpp
//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : <Module Name>                                          |
//| File    : <File Name>                                            |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0                                                  |
//+------------------------------------------------------------------+
```

---

# Include Rules

* Include only what is required.
* Prefer project-relative includes.
* Avoid unnecessary dependency chains.
* Do not create circular includes.

---

# Class Design

Classes should have a single responsibility.

Utility classes should:

* Contain only static methods.
* Have no instance state.
* Be stateless whenever possible.

Managers should:

* Encapsulate related business logic.
* Hide implementation details.
* Expose a minimal public API.

---

# Error Handling

* Always check return values.
* Validate inputs.
* Return meaningful status values.
* Log unexpected conditions.
* Avoid silently ignoring failures.

---

# Logging

Use the framework logging facilities.

Logging should include:

* Errors
* Warnings
* Important state transitions
* Debug information (when enabled)

Avoid excessive logging inside high-frequency loops.

---

# Comments

Comments should explain **why**, not **what**.

Avoid comments that simply restate the code.

Prefer descriptive function and variable names over excessive comments.

---

# Documentation

Public APIs should include documentation describing:

* Purpose
* Parameters
* Return value
* Side effects
* Usage notes (if applicable)

---

# Formatting

Use consistent formatting throughout the project.

* Indent with spaces (or the team's agreed convention).
* Opening braces on a consistent line style.
* One statement per line.
* Keep functions focused and reasonably short.

---

# Performance

* Avoid unnecessary allocations.
* Cache repeated calculations.
* Minimize repeated indicator calls.
* Prefer early returns to deeply nested conditions.
* Measure performance before optimizing.

---

# Memory Management

* Release resources deterministically.
* Avoid leaks.
* Initialize variables before use.
* Clean up indicator handles and dynamic objects when no longer needed.

---

# Testing Requirements

Every public module should have a corresponding unit test.

Tests should cover:

* Normal behavior
* Boundary conditions
* Invalid input
* Error handling
* Regression scenarios

---

# Code Review Checklist

Before code is merged, verify:

* Compiles successfully
* Zero compiler errors
* Zero compiler warnings
* Coding standards followed
* Public APIs documented
* Unit tests updated
* No duplicated logic
* No unnecessary dependencies
* Documentation updated if required

---

# Definition of Done

A task is complete only when:

* Code compiles successfully.
* Compiler reports zero errors.
* Compiler reports zero warnings.
* Unit tests pass.
* Documentation is synchronized.
* Coding standards are satisfied.
* The architecture remains consistent.

---

# Continuous Improvement

This standard is a living document.

Changes should be proposed whenever they improve readability, maintainability, performance, or consistency across the framework.

All approved changes should be reviewed and adopted consistently throughout the repository.
