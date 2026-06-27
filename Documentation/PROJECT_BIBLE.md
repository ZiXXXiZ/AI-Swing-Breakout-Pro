# PROJECT_BIBLE.md

# AI Swing Breakout Pro v2.0

## Institutional Trading Framework

**Project Bible**

Version: **2.0.0-alpha.1**

---

# Purpose

This document is the master reference for the AI Swing Breakout Pro project.

It defines the project's vision, architecture, engineering standards, coding conventions, roadmap, and long-term goals.

All developers should consult this document before making architectural or design changes.

---

# Project Vision

Build a professional, modular, production-quality trading framework for MetaTrader 5 that is:

* Stable
* Fast
* Maintainable
* Extensible
* Fully documented
* Thoroughly tested

The framework must support multiple trading strategies while sharing the same Core infrastructure.

---

# Design Philosophy

We are **not** building a single Expert Advisor.

We are building a reusable **Trading Framework**.

The trading strategy is only one module within the framework.

Everything else should be reusable.

---

# Engineering Principles

* Single Responsibility Principle (SRP)
* Modular Architecture
* Defensive Programming
* Encapsulation
* Separation of Concerns
* Configuration Validation
* Centralized Logging
* Performance-Aware Design
* Clean Code
* Incremental Development

---

# Project Structure

```text
AI_SwingBreakout_Pro/

Experts/
Include/
Documentation/
Presets/
Reports/
Tests/
```

---

# Framework Modules

## Core

Shared infrastructure used by every strategy.

Modules include:

* Version
* InputParameters
* Config
* Logger
* ErrorHandler
* Utilities
* SymbolManager
* MarketSnapshot
* IndicatorCache
* Dashboard

---

## Indicators

Indicator wrappers and caching.

Examples:

* EMA
* ATR
* ADX
* Volume
* Spread

---

## Market Engine

Responsible for market analysis.

Includes:

* Trend Detection
* Swing Detection
* Market Structure
* Breakout Detection
* Session Filter
* Volatility Analysis

Produces a unified Market Snapshot.

---

## Signal Engine

Generates trading signals.

Combines:

* Trend
* Structure
* Breakout
* Volume
* ATR
* ADX
* Probability

Outputs:

* BUY
* SELL
* NONE

---

## Risk Engine

Responsible for:

* Position Sizing
* Daily Loss Protection
* Exposure Limits
* Break-even
* ATR Trailing Stop
* Partial Close

---

## Trade Engine

Responsible for:

* Order Execution
* Position Management
* Trade Validation
* Retry Logic
* Error Recovery

Contains no strategy logic.

---

## Statistics Engine

Tracks:

* Win Rate
* Profit Factor
* Drawdown
* Average R:R
* Daily Results
* Monthly Results

---

## Dashboard

Displays:

* Market Regime
* Trend
* Probability
* ATR
* ADX
* Spread
* Risk
* Daily P/L
* Open Positions

---

## AI Module (Version 3)

Future enhancements:

* ONNX Inference
* AI Probability Model
* Market Classification
* Adaptive Parameters

Version 2.0 remains fully rule-based.

---

# Development Workflow

1. Design
2. Architecture Review
3. Implementation
4. Compilation
5. Unit Testing
6. Integration Testing
7. Backtesting
8. Optimization
9. Walk-Forward Testing
10. Demo Forward Testing
11. Production Release

---

# Coding Standards

Every module must:

* Compile with zero errors
* Compile with zero warnings
* Be fully documented
* Validate inputs
* Log important events
* Release resources correctly
* Avoid duplicated code

Naming conventions:

* Classes: `CClassName`
* Structures: `SStructureName`
* Enums: `ENUM_Name`
* Interfaces: `IInterfaceName`

---

# Versioning

Semantic Versioning:

* v2.0.0-alpha.x
* v2.0.0-beta.x
* v2.0.0-rc.x
* v2.0.0

---

# Git Workflow

Repository Structure:

* `main` — Stable releases
* `develop` — Active development
* `feature/*` — Individual modules
* `release/*` — Release preparation

Commit after every completed module.

Tag each milestone.

---

# Documentation

The project documentation includes:

* PROJECT_BIBLE.md
* ARCHITECTURE.md
* ROADMAP.md
* CHANGELOG.md
* CODING_STANDARD.md
* DEVELOPER_GUIDE.md
* USER_GUIDE.md
* TEST_PLAN.md

These documents must be kept synchronized with the codebase.

---

# Long-Term Vision

The framework should become a reusable platform capable of supporting multiple trading strategies without modifying the Core modules.

Future strategies may include:

* Swing Breakout
* Trend Following
* Pullback
* Mean Reversion
* Scalping
* AI Strategy

The objective is to evolve the framework into a professional institutional trading platform while maintaining clean architecture, rigorous testing, and comprehensive documentation.
