# AI Swing Breakout Pro Framework

# PROJECT_CONTEXT

**Version:** 2.0.0-alpha.4
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
Framework (Context / Module / ModuleManager / Engine)
        │
Core
        │
MQL5 Platform
```

Dependencies always point downward.

Core must never depend on upper layers.

---

# Folder Layout (Confirmed, July 2026)

```
AI_SwingBreakout_Pro/
│
├── AI_SwingBreakout_Pro.mq5        ← main EA entry point (root, sibling of Include/)
│
├── Documentation/
│
├── Include/
│   ├── Core/
│   │   ├── Base/
│   │   │   └── BaseObject.mqh
│   │   ├── Config.mqh
│   │   ├── Constants.mqh
│   │   ├── Error/
│   │   │   ├── ErrorCodes.mqh
│   │   │   ├── ErrorHandler.mqh
│   │   │   ├── ErrorInfo.mqh
│   │   │   └── TestErrorHandler.mqh
│   │   ├── InputParameters.mqh
│   │   ├── Logging/
│   │   │   ├── DefaultLogFormatter.mqh
│   │   │   ├── Interfaces/
│   │   │   │   ├── ILogFormatter.mqh
│   │   │   │   └── ILogOutput.mqh
│   │   │   ├── JournalLogOutput.mqh
│   │   │   ├── LogLevel.mqh
│   │   │   ├── LogRecord.mqh
│   │   │   └── Logger.mqh
│   │   ├── MathUtils.mqh
│   │   ├── Structures/
│   │   │   ├── AccountStructures.mqh
│   │   │   ├── MarketStructures.mqh
│   │   │   ├── RiskStructures.mqh
│   │   │   ├── StatisticsStructures.mqh
│   │   │   └── TradeStructures.mqh
│   │   ├── Types.mqh
│   │   ├── Utilities/
│   │   │   ├── StringUtils.mqh
│   │   │   └── TimeUtils.mqh
│   │   └── Version.mqh
│   ├── Framework/
│   │   ├── Context.mqh
│   │   ├── Module.mqh
│   │   ├── ModuleManager.mqh
│   │   └── Engine.mqh
│   └── Tests/
│       ├── Core/Utilities/
│       │   ├── TestStringUtils.ex5
│       │   └── TestStringUtils.mq5
│       └── Framework/
│           └── TestFramework.mqh
│
├── Source/
├── Tests/
└── Resources/
```

---

# Include Policy

Correct

```cpp
#include "../Types.mqh"
#include "Constants.mqh"
```

Incorrect

```cpp
#include <Core/Types.mqh>
```

Never use MetaTrader global Include paths.

**Exception:** `AI_SwingBreakout_Pro.mq5` sits at the project root, outside `Include/`. It is the only file that prefixes framework includes with `Include/`:

```cpp
#include "Include/Core/Types.mqh"
#include "Include/Framework/Context.mqh"
```

Files inside `Include/` are unaffected — see ADR-012.

---

# Completed Modules

## Core — Standards-Compliant

* `Constants.mqh`
* `Types.mqh`
* `MathUtils.mqh` — rebuilt, compile-verified
* `Config.mqh` — finalized, closed
* `Platform.mqh` — built, compile-verified
* `ValidationUtils.mqh` — built (compile pending)
* `TradeStructures.mqh`
* `MarketStructures.mqh`
* `RiskStructures.mqh`
* `AccountStructures.mqh`
* `StatisticsStructures.mqh`

## Core — Sprint 006 Standards Pass Complete

All 16 files below were brought into full compliance this cycle. No longer "pending review."

* `Base/BaseObject.mqh`
* `InputParameters.mqh`
* `Version.mqh`
* `Error/ErrorCodes.mqh`
* `Error/ErrorHandler.mqh`
* `Error/ErrorInfo.mqh` — decoupled from Logging (now uses own `ENUM_ERROR_SEVERITY`)
* `Error/TestErrorHandler.mqh` — rewritten to test current API, absolute include fixed
* `Logging/LogLevel.mqh`
* `Logging/LogRecord.mqh` — 6 fields added (`Function`/`Line`/`Symbol`/`Timeframe`/`Ticket`/`ErrorCode`)
* `Logging/Logger.mqh` — `Initialize()` renamed to `Configure()` (signature-hiding fix)
* `Logging/DefaultLogFormatter.mqh`
* `Logging/JournalLogOutput.mqh`
* `Logging/Interfaces/ILogFormatter.mqh`
* `Logging/Interfaces/ILogOutput.mqh`
* `Utilities/StringUtils.mqh`
* `Utilities/TimeUtils.mqh` — duplicate content removed (file was pasted twice, outer `#ifndef` never closed)

## Framework Layer — New This Cycle

* `Framework/Context.mqh`
* `Framework/Module.mqh`
* `Framework/ModuleManager.mqh`
* `Framework/Engine.mqh`

All compile-verified together. `CContext` injection standardized at `CModule` base — see ADR-013.

---

# Known Issues

* `Utilities/StringUtils.mqh` uses `ENUM_X`-style enum naming in one internal guard — low priority, no functional impact.
* `AI_SwingBreakout_Pro.mq5` (main EA) has not yet been written — no composition root exists. `CContext` is not yet populated, `CModuleManager` is not yet wired. This is the next concrete task.
* `ValidationUtils.mqh` compile result not yet confirmed — pending MetaEditor verification.

---

# Current Development Workflow

Every framework module follows:

1. Architecture review / interface proposal
2. Complete implementation
3. Compile verification
4. Integration verification
5. Documentation update
6. Git commit

---

# Current Sprint

Sprint 007

Objectives:

1. Confirm `ValidationUtils.mqh` compiles.
2. Write `AI_SwingBreakout_Pro.mq5` — composition root: construct `CPlatform`, `CLogger`, `CErrorHandler`, wire into `CContext`, build `CModuleManager`, drive `OnInit`/`OnTick`/`OnDeinit`.
3. Begin Risk Engine (`Include/Risk/`).

---

# GitHub Workflow

Read repository → Review architecture → Implement complete file → Compile → Update documentation → Commit → Continue.

---

# Communication Rules

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
Foundation Layer → transitioning to Risk Engine
```

Completion Estimate

```
Approximately 55%
```

---

# Notes for Future AI Sessions

Always read these documents before starting work:

1. PROJECT_CONTEXT.md
2. ARCHITECTURE.md
3. CODING_STANDARD.md
4. DECISIONS.md
5. ROADMAP.md
6. CHANGELOG.md

Never assume prior chat history is available. Always continue from the current repository state.

**Two MQL5-specific gotchas discovered this cycle that future sessions must know:**

1. MQL5 does not accept static class members (`CConstants::EPSILON`) as default parameter values — use two-overload pairs instead.
2. MQL5 does not warn when a derived method hides a virtual base method instead of overriding it (different parameter list = new overload, not an override). Always verify virtual method signatures match exactly across the entire inheritance chain.

---

# Definition of Done

A module is complete only when:

* Source code is production quality.
* Compiles without errors.
* Dependency rules are respected.
* Documentation is updated.
* Ready for Git commit.