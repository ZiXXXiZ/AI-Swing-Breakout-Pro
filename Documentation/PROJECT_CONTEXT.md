# AI Swing Breakout Pro Framework

# PROJECT_CONTEXT

**Version:** 2.0.0-alpha.5
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
Signals
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
│   │   ├── ValidationUtils.mqh
│   │   └── Version.mqh
│   ├── Framework/
│   │   ├── Context.mqh             ← CMarketSnapshot added this cycle
│   │   ├── Engine.mqh              ← orchestration pipeline added this cycle
│   │   ├── Module.mqh
│   │   └── ModuleManager.mqh
│   ├── Indicators/
│   │   ├── IndicatorBase.mqh
│   │   ├── EMAIndicator.mqh
│   │   ├── ATRIndicator.mqh
│   │   └── ADXIndicator.mqh
│   ├── Signals/
│   │   ├── SignalResult.mqh
│   │   ├── SignalBase.mqh
│   │   └── BreakoutSignal.mqh
│   ├── Risk/
│   │   ├── RiskResult.mqh
│   │   ├── RiskBase.mqh
│   │   └── RiskManager.mqh
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
* `ValidationUtils.mqh` — built, compile-verified
* `TradeStructures.mqh`
* `MarketStructures.mqh`
* `RiskStructures.mqh`
* `AccountStructures.mqh`
* `StatisticsStructures.mqh`

## Core — Sprint 006 Standards Pass Complete

* `Base/BaseObject.mqh`
* `InputParameters.mqh`
* `Version.mqh`
* `Error/ErrorCodes.mqh`
* `Error/ErrorHandler.mqh`
* `Error/ErrorInfo.mqh` — decoupled from Logging (now uses own `ENUM_ERROR_SEVERITY`)
* `Error/TestErrorHandler.mqh` — rewritten to test current API, absolute include fixed
* `Logging/LogLevel.mqh`
* `Logging/LogRecord.mqh` — 6 fields added
* `Logging/Logger.mqh` — `Initialize()` renamed to `Configure()` (signature-hiding fix)
* `Logging/DefaultLogFormatter.mqh`
* `Logging/JournalLogOutput.mqh`
* `Logging/Interfaces/ILogFormatter.mqh`
* `Logging/Interfaces/ILogOutput.mqh`
* `Utilities/StringUtils.mqh`
* `Utilities/TimeUtils.mqh` — duplicate content removed

## Framework Layer — Complete

* `Framework/Context.mqh` — `CMarketSnapshot` added this cycle (ADR-014)
* `Framework/Module.mqh`
* `Framework/ModuleManager.mqh`
* `Framework/Engine.mqh` — orchestration pipeline added this cycle (ADR-015)

## Indicators Layer — Complete

* `Indicators/IndicatorBase.mqh`
* `Indicators/EMAIndicator.mqh`
* `Indicators/ATRIndicator.mqh`
* `Indicators/ADXIndicator.mqh`

## Signals Layer — Complete

* `Signals/SignalResult.mqh`
* `Signals/SignalBase.mqh`
* `Signals/BreakoutSignal.mqh`

## Risk Layer — Complete

* `Risk/RiskResult.mqh`
* `Risk/RiskBase.mqh`
* `Risk/RiskManager.mqh`

---

# Known Issues

* `Utilities/StringUtils.mqh` uses `ENUM_X`-style enum naming in one internal guard — low priority, no functional impact.
* `RiskManager.mqh` uses `stopLossPips = 50.0` placeholder — ATR-based stop loss integration is a future task (Stage 7).
* `AI_SwingBreakout_Pro.mq5` Stage 6 wiring not yet complete — composition root does not yet instantiate Indicators, Signal, Risk, or wire them into `CEngine`.

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

Sprint 007 — Stage 6

Objectives:

1. ✅ Task 1 — `Context.mqh` — `CMarketSnapshot` added
2. ✅ Task 2 — Indicators layer (Base, EMA, ATR, ADX)
3. ✅ Task 3 — Signals layer (Result, Base, BreakoutSignal)
4. ✅ Task 4 — Risk layer (Result, Base, RiskManager)
5. ✅ Task 5 — `Engine.mqh` orchestration pipeline
6. ⏳ Task 6 — `AI_SwingBreakout_Pro.mq5` Stage 6 wiring ← NEXT

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
Indicators / Signals / Risk — complete. Wiring into main EA next.
```

Completion Estimate

```
Approximately 75%
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
7. ProjectManagerSkill.md

Never assume prior chat history is available. Always continue from the current repository state.

**MQL5-specific gotchas — must know:**

1. No static class members as default parameter values — use overload pairs.
2. Virtual method signature must match exactly — different parameter list hides base, compiles clean, fails silently. Always use `override`.
3. No reference return types (`Type&`) — use `GetPointer()` for class members.
4. `GetPointer()` works on class instances only, not structs — this is why `SMarketSnapshot` became `CMarketSnapshot`.
5. `CopyBuffer()` fills arrays newest-to-oldest by default — always call `ArraySetAsSeries(buffer, true)` first.
6. Indicator handles must be created in `Initialize()`, not constructor.
7. `CLogger` uses `Configure()`, not `Initialize()`.
8. `SymbolInfoString(_Symbol, SYMBOL_NAME)` is invalid — use `_Symbol` directly.
9. `CValidationUtils::IsValidVolume()` signature is `(string symbol, double volume)` — symbol first.

---

# Definition of Done

A module is complete only when:

* Source code is production quality.
* Compiles without errors.
* Dependency rules are respected.
* Documentation is updated.
* Ready for Git commit.