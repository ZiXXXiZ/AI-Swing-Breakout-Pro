# DEVELOPER_GUIDE.md

# AI Swing Breakout Pro v2.0

## Developer Guide

Version: **2.0.0-alpha.1**

---

# Purpose

This guide explains how developers should work on the AI Swing Breakout Pro framework.

It provides standards for:

* Project organization
* Development workflow
* Coding practices
* Module integration
* Testing
* Version control
* Documentation

Every contributor should read this guide before modifying the codebase.

---

# Framework Philosophy

The project is built as a reusable trading framework rather than a single Expert Advisor.

Only the strategy module should contain strategy-specific logic.

Everything else should remain reusable.

---

# Repository Structure

```text
AI_SwingBreakout_Pro/

Experts/
│   AI_SwingBreakout_Pro.mq5

Include/
│
├── Core/
├── Interfaces/
├── Indicators/
├── Market/
├── Signal/
├── Risk/
├── Trade/
├── Statistics/
├── AI/
└── Strategies/

Documentation/
Presets/
Reports/
Tests/
```

Each module belongs in its designated folder.

---

# Development Workflow

Every new feature should follow this process:

1. Review the PROJECT_BIBLE.md.
2. Review the ARCHITECTURE.md.
3. Implement a single module.
4. Compile successfully.
5. Run module tests.
6. Integrate with the framework.
7. Update documentation.
8. Commit changes to Git.
9. Push to GitHub.

Do not begin a new module until the current module compiles without errors.

---

# Module Development

Each module should include:

* Header comment
* Include guard
* Required includes only
* Public interface
* Private implementation
* Input validation
* Error handling
* Logging
* Resource cleanup

Every module should have a single, well-defined responsibility.

---

# Coding Standards

All code must comply with:

* CODING_STANDARD.md

Key requirements:

* Zero compiler errors
* Zero compiler warnings
* Descriptive naming
* Consistent formatting
* Defensive programming
* No duplicated logic

---

# Dependency Rules

Dependencies should flow in one direction.

Preferred dependency order:

```text
Core
   ↓
Indicators
   ↓
Market
   ↓
Signal
   ↓
Risk
   ↓
Trade
   ↓
Dashboard
```

Avoid circular dependencies between modules.

---

# Configuration

All configurable values must originate from:

```text
InputParameters.mqh
        ↓
Config.mqh
```

Business logic should never read MT5 input variables directly.
Always access configuration through the Config object.

---

# Logging

Use the Logger module for:

* Initialization
* Warnings
* Errors
* Important trading events

Avoid excessive logging inside frequently executed loops.

---

# Error Handling

Always check:

* Indicator handles
* Trade requests
* Position selection
* CopyBuffer calls
* File operations

Never ignore return values.

Log meaningful error messages.

---

# Resource Management

Release all allocated resources during shutdown.

Examples:

* Indicator handles
* File handles
* Dynamic objects

Clean up in `OnDeinit()` or appropriate destructors.

---

# Testing

Every module must pass:

1. Compile verification
2. Unit testing (where applicable)
3. Integration testing
4. Strategy Tester validation

No module should be merged until it passes these checks.

---

# Git Workflow

Recommended branch strategy:

```text
main
develop
feature/*
release/*
```

Typical workflow:

1. Create a feature branch.
2. Implement one logical change.
3. Compile and test.
4. Commit with a clear message.
5. Push to GitHub.
6. Merge after review.

Example commit messages:

```text
Implement Logger module
Add ATR indicator cache
Fix trade validation
Improve risk calculation
```

---

# Documentation

Whenever code changes:

* Update CHANGELOG.md
* Update ROADMAP.md (if milestones change)
* Update PROJECT_BIBLE.md (for architectural changes)
* Update ARCHITECTURE.md (if module relationships change)

Documentation should evolve alongside the code.

---

# Release Process

Development stages:

1. Alpha
2. Beta
3. Release Candidate (RC)
4. Production

Only bug fixes are permitted after entering the RC stage.

---

# Future Expansion

The framework is designed to support additional strategies without changing the Core modules.

Examples:

* Trend Following
* Pullback
* Mean Reversion
* Scalping
* AI-Based Strategy

Each strategy should reuse the existing Core, Risk, Trade, and Statistics infrastructure.

---

# Developer Checklist

Before committing code:

* Code compiles successfully.
* No compiler warnings.
* Resources are released correctly.
* Inputs are validated.
* Logging is appropriate.
* Documentation is updated.
* Tests have been completed.

---

# Guiding Principle

> **Develop every module as if it will be maintained and extended for many years.**

Well-structured, readable, and thoroughly tested code is the foundation of a reliable institutional trading framework.
