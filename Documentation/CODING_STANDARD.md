# CODING_STANDARD.md

# AI Swing Breakout Pro v2.0

## Coding Standards & Development Guidelines

Version: **2.0.0-alpha.1**

---

# Purpose

This document defines the mandatory coding standards for the AI Swing Breakout Pro framework.

Every source file, class, function, and module must comply with these standards.

The objectives are:

* Readability
* Maintainability
* Reliability
* Performance
* Consistency
* Production-quality software

---

# Core Principles

Every module should follow:

* Single Responsibility Principle (SRP)
* Separation of Concerns
* Encapsulation
* Defensive Programming
* Low Coupling
* High Cohesion
* Reusable Components

---

# Project Structure

```text
Experts/
Include/
Documentation/
Presets/
Reports/
Tests/
```

Each module belongs in its own folder.

Never place unrelated classes in the same file.

---

# Naming Conventions

## Classes

```cpp
CLogger
CConfig
CSymbolManager
CTradeEngine
```

Always begin with:

```text
C
```

---

## Structures

```cpp
SRiskConfig
SMarketSnapshot
STradeStatistics
```

Always begin with:

```text
S
```

---

## Interfaces

```cpp
ILogger
IRiskModel
ISignalEngine
```

Always begin with:

```text
I
```

---

## Enumerations

```cpp
ENUM_SIGNAL_TYPE
ENUM_MARKET_REGIME
ENUM_LOG_LEVEL
```

Always begin with:

```text
ENUM_
```

---

## Constants

Use:

```cpp
const double
const int
const ulong
```

Avoid unnecessary preprocessor macros when typed constants are appropriate.

---

# Variable Naming

## Member Variables

Private members:

```cpp
m_bid
m_ask
m_spread
m_logger
m_initialized
```

Prefix:

```text
m_
```

---

## Local Variables

Use descriptive camelCase names.

Example:

```cpp
currentPrice
stopLoss
riskAmount
tradeVolume
```

Avoid names like:

```cpp
a
b
temp
x
```

unless used in a very small scope.

---

## Global Variables

Avoid global variables.

Only singleton-style shared services may exist globally when justified.

---

# Function Naming

Functions should describe an action.

Examples:

```cpp
Initialize()
Validate()
LoadInputs()
CalculateATR()
OpenPosition()
ClosePosition()
```

Avoid vague names like:

```cpp
Run()
DoWork()
Process()
```

---

# File Organization

Every file begins with:

```cpp
//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : Logger.mqh                                              |
//| Version : 2.0.0-alpha.1                                           |
//| Purpose : Centralized logging                                     |
//+------------------------------------------------------------------+
```

Then:

* Include guard
* Includes
* Constants
* Enumerations
* Structures
* Classes

---

# Include Guards

Every header must use include guards.

Example:

```cpp
#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

// Code

#endif
```

---

# Header Dependencies

Include only what is required.

Avoid unnecessary includes.

Prefer forward declarations where practical.

---

# Error Handling

Never ignore return values from:

* OrderSend
* PositionSelect
* CopyBuffer
* IndicatorCreate
* File operations

Always validate success and log failures.

---

# Logging

Significant events should be logged.

Examples:

* Initialization
* Configuration errors
* Trade requests
* Order failures
* Position closures
* Critical warnings

Do not flood the Journal with repetitive messages.

---

# Validation

Validate:

* Input parameters
* Indicator handles
* Array bounds
* Symbol properties
* Trade conditions

Never assume values are valid.

---

# Magic Numbers

Avoid unexplained numeric literals.

Instead of:

```cpp
if(spread > 30)
```

use:

```cpp
if(spread > MaxSpreadPoints)
```

---

# Comments

Comment **why**, not **what**.

Good:

```cpp
// Prevent trading during excessive spread
```

Avoid:

```cpp
// Increase i by 1
i++;
```

Only add comments where they improve understanding.

---

# Formatting

Use consistent indentation (4 spaces or one tab throughout the project).

Always use braces:

```cpp
if(condition)
{
    ExecuteTrade();
}
```

Avoid single-line control statements without braces.

---

# Performance

Avoid:

* Repeated indicator creation
* Duplicate calculations
* Excessive memory allocation
* Unnecessary loops

Cache expensive calculations.

---

# Resource Management

Every acquired resource must be released.

Examples:

* Indicator handles
* File handles
* Dynamic objects

Ensure cleanup in `OnDeinit()` or destructors where appropriate.

---

# Compile Quality

Every module must compile with:

* Zero compiler errors
* Zero compiler warnings

Compilation is required before committing changes.

---

# Testing Requirements

Each module must pass:

1. Compile test
2. Unit test (where applicable)
3. Integration test
4. Strategy Tester verification

---

# Git Workflow

After each completed module:

1. Compile successfully
2. Run basic tests
3. Commit changes
4. Push to GitHub

Example commit messages:

```
Complete Config module
Implement Logger
Add Indicator Cache
Fix ATR calculation
```

Keep commits focused on a single logical change.

---

# Documentation

Every public class should include:

* Purpose
* Responsibilities
* Public methods
* Dependencies

Keep documentation synchronized with code changes.

---

# Future Enhancements

These standards may evolve as the framework grows.

Any significant change to coding practices should be documented here and reviewed before adoption.

---

# Guiding Principle

> **Write code that is easy to understand, easy to test, easy to maintain, and safe to extend.**

The goal is not simply to make the EA work today, but to create a framework that remains reliable and maintainable through future versions.
