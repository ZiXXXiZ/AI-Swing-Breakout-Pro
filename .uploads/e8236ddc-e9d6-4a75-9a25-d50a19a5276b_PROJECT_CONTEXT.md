# AI Swing Breakout Pro Framework

# PROJECT_CONTEXT

**Version:** 2.0.0-alpha.2
**Status:** Active Development
**Last Updated:** July 2026

---

# Purpose

This document is the operational context for the AI Swing Breakout Pro project.

It is intended to be the first document read by any developer or AI assistant before making changes.

The GitHub repository is the single source of truth.

---

# Repository

Repository Name

```
ZiXXXiZ/AI-Swing-Breakout-Pro
```

Repository Type

```
Private
```

---

# Local Project Root

```
C:\Users\kkk\AppData\Roaming\MetaQuotes\Terminal\
829BEA48CFE0CB726192D822F91AD6B5\
MQL5\
Experts\
AI_SwingBreakout_Pro\
```

All project paths are relative to this directory.

---

# Development Philosophy

The framework is designed as a production-quality MQL5 trading framework.

Primary goals:

* Modular architecture
* Clean dependency graph
* High performance
* Production-ready implementation
* Long-term maintainability
* GitHub-driven development

---

# Current Architecture

```
Application
        │
Trading Engine
        │
Risk Engine
        │
Indicators
        │
Utilities
        │
Core
        │
MQL5 Platform
```

Dependencies always point downward.

Core must never depend on upper layers.

---

# Folder Layout

```
Documentation/

Include/
    Core/
    Indicators/
    Trading/
    Risk/
    AI/
    Utilities/
    UI/

Source/

Tests/

Resources/
```

---

# Current Coding Rules

Mandatory rules:

* Production-quality source only.
* Complete source files.
* Never build framework modules from partial snippets.
* One responsibility per file.
* Relative include paths only.
* No placeholder code.
* No duplicated logic.
* Keep Core independent.
* Documentation must remain synchronized with implementation.

---

# Include Policy

Correct

```cpp
#include "../Types.mqh"
```

Correct

```cpp
#include "Constants.mqh"
```

Incorrect

```cpp
#include <Core/Types.mqh>
```

Never use MetaTrader global Include paths.

---

# Current Development Workflow

Every framework module follows:

1. Architecture review
2. Complete implementation
3. Compile verification
4. Integration verification
5. Documentation update
6. Git commit

No partial framework implementations should be committed.

---

# Completed Modules

Core

* Constants.mqh
* Types.mqh

Core Structures

* TradeStructures.mqh
* MarketStructures.mqh
* RiskStructures.mqh
* AccountStructures.mqh
* StatisticsStructures.mqh

Documentation

* REPOSITORY_AUDIT.md
* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md

---

# Current Sprint

Sprint 004

Objective

Rebuild

```
Include/Core/MathUtils.mqh
```

The previous incremental version introduced structural syntax errors.

Decision:

Rewrite the entire file from scratch.

Do not reuse the previous implementation.

---

# Immediate Next Tasks

1.

Rebuild

```
Include/Core/MathUtils.mqh
```

2.

Build

```
Include/Core/Platform.mqh
```

3.

Build

```
Include/Core/Logger.mqh
```

4.

Build

```
Include/Core/ValidationUtils.mqh
```

5.

Continue Risk module.

---

# Future Roadmap

Core

↓

Utilities

↓

Indicators

↓

Risk

↓

Trading

↓

AI

↓

Backtesting

↓

Optimization

↓

Production Release

---

# GitHub Workflow

The repository is authoritative.

Development workflow:

Read repository

↓

Review architecture

↓

Modify complete source file

↓

Compile verification

↓

Update documentation

↓

Commit

↓

Continue

GitHub history should always reflect the latest stable implementation.

---

# Communication Rules

Development conversations should be concise.

Avoid repeating previous explanations.

When the user writes

```
LDN
```

interpret it as

```
Let Do Next
```

Continue directly with the next planned task.

---

# Project Status

Current Phase

```
Foundation Layer
```

Completion Estimate

```
Approximately 20%
```

Foundation modules are prioritized before higher-level trading logic.

---

# Notes for Future AI Sessions

Always read these documents before starting work:

1.

PROJECT_CONTEXT.md

2.

ARCHITECTURE.md

3.

CODING_STANDARD.md

4.

DECISIONS.md

5.

ROADMAP.md

6.

CHANGELOG.md


Treat these documents together with the GitHub repository as the complete project context.

Never assume previous chat history is available.

Always continue from the current repository state.

---

# Definition of Done

A module is considered complete only when:

* Source code is production quality.
* Compiles without errors.
* Dependency rules are respected.
* Documentation is updated.
* Ready for Git commit.

Only then should development continue to the next module.
