# AI Swing Breakout Pro Framework Architecture

**Project:** AI Swing Breakout Pro
**Version:** 2.0.0-alpha.2
**Status:** Active Development

---

# Overview

The AI Swing Breakout Pro Framework is a modular, reusable MQL5 framework designed for building production-quality Expert Advisors, Indicators, Scripts, and future AI-assisted trading systems.

The framework follows these principles:

* Modular architecture
* Single Responsibility Principle (SRP)
* High cohesion
* Low coupling
* Reusable utility libraries
* Test-driven development
* Compile-first workflow
* Consistent coding standards

---

# Project Structure

```text
AI-Swing-Breakout-Pro/
│
├── Core/
│   ├── Error/
│   ├── Logger/
│   ├── Utilities/
│   ├── Configuration/
│   ├── Market/
│   ├── Trading/
│   ├── Indicators/
│   ├── Risk/
│   ├── Strategy/
│   └── AI/
│
├── Tests/
│   ├── Framework/
│   ├── Utilities/
│   ├── Trading/
│   └── Strategy/
│
├── Examples/
│
├── Documentation/
│
└── README.md
```

---

# Layered Architecture

```
Application Layer
        │
        ▼
Strategy Layer
        │
        ▼
Trading Engine
        │
        ▼
Market Services
        │
        ▼
Core Utilities
```

Each layer depends only on the layer beneath it.

---

# Core Modules

## Logger

Responsibilities

* Logging
* Debug output
* Diagnostic messages

Status

* Complete

---

## Error

Responsibilities

* Error codes
* Error descriptions
* Framework exceptions

Status

* Complete

---

## Utilities

Responsibilities

General-purpose helper functions.

### Current Modules

| Module      |   Status   |
| ----------- | :--------: |
| StringUtils | ✅ Complete |
| TimeUtils   | ✅ Complete |
| MathUtils   |   Planned  |
| ArrayUtils  |   Planned  |

Utilities must remain independent from trading logic.

---

# Infrastructure Layer

## Configuration

Centralized configuration management.

Planned responsibilities

* Runtime configuration
* Constants
* Environment settings

---

## SymbolManager

Responsibilities

* Symbol information
* Tick size
* Contract specifications
* Point value
* Digits

---

## SessionManager

Responsibilities

* Trading sessions
* Holidays
* Market open/close state

---

## IndicatorCache

Responsibilities

* Indicator handles
* Resource reuse
* Automatic cleanup

---

# Trading Layer

## OrderManager

Responsibilities

* Order requests
* Pending orders
* Order validation

---

## PositionManager

Responsibilities

* Position tracking
* Position statistics
* Trade management

---

## RiskManager

Responsibilities

* Position sizing
* Risk calculations
* Drawdown protection
* Exposure limits

---

# Strategy Layer

The Strategy Layer defines trading behavior while remaining independent of execution details.

Responsibilities

* Signal generation
* Entry logic
* Exit logic
* Filters
* Position management rules

Future components include

* StrategyBase
* SignalEngine
* FilterEngine
* TradePipeline

---

# AI Layer

Reserved for AI-assisted components.

Potential modules

* Swing Detection
* Breakout Detection
* Pattern Recognition
* Adaptive Parameters
* Confidence Scoring

---

# Testing Architecture

```
Production Module
        │
        ▼
Unit Test
        │
        ▼
TestFramework
```

Every public API should have corresponding unit tests.

A module is considered complete only after all tests pass successfully.

---

# Coding Standards

The framework follows these conventions:

* Header-only utilities where appropriate.
* Static utility classes for stateless helpers.
* One public responsibility per module.
* Consistent include guard naming.
* Doxygen-compatible documentation.
* Version information in every module.
* Uniform file headers.
* Minimal external dependencies.

---

# Development Workflow

Every module follows the same lifecycle:

1. Define API
2. Implement
3. Compile
4. Resolve compiler errors
5. Add unit tests
6. Review
7. Update documentation
8. Mark complete

Acceptance criteria:

* 0 compiler errors
* 0 compiler warnings
* Unit tests passing
* Documentation updated

---

# Current Project Status

## Completed

Foundation

* Logger
* Error
* StringUtils
* TimeUtils
* TestFramework
* TestStringUtils

## In Progress

* TestTimeUtils

## Planned

Utilities

* MathUtils
* TestMathUtils
* ArrayUtils
* TestArrayUtils

Infrastructure

* Configuration
* SymbolManager
* SessionManager
* IndicatorCache

Trading

* OrderManager
* PositionManager
* RiskManager

Strategy

* Strategy Framework
* AI Swing Breakout Engine

---

# Design Goals

* Production-ready quality
* Consistent APIs
* Modular and reusable components
* Comprehensive unit testing
* High maintainability
* Extensibility for future trading systems
* Clear separation of responsibilities

---

# Long-Term Vision

The framework will become a reusable foundation for:

* AI Swing Breakout Pro
* Additional Expert Advisors
* Custom Indicators
* Scripts
* Portfolio management tools
* Future AI-driven trading strategies

The architecture is intended to support long-term evolution while maintaining backward compatibility and consistent development standards.
