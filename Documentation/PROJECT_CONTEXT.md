# AI Swing Breakout Pro Framework

# PROJECT_CONTEXT

**Version:** 2.0.0-alpha.13
**Status:** Active Development
**Last Updated:** July 12, 2026

---

# Purpose

This document is the operational context for the AI Swing Breakout Pro project.

It is intended to be the first document read by any developer or AI assistant before making changes.

The GitHub repository is the single source of truth.

This document summarizes the current repository state, architecture, development workflow, implementation progress, and project conventions. It should always remain synchronized with:

* ARCHITECTURE.md
* DECISIONS.md
* ROADMAP.md
* CHANGELOG.md
* CODING_STANDARD.md

---

# Repository

Repository Name


ZiXXXiZ/AI-Swing-Breakout-Pro


Repository Type


Private


---

# Local Project Root


C:\Users\kkk\AppData\Roaming\MetaQuotes\Terminal\
829BEA48CFE0CB726192D822F91AD6B5\
MQL5\
Experts\
AI_SwingBreakout_Pro\


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
* Compile verification before integration
* Documentation synchronized with implementation
* GitHub-driven development

Every completed module must satisfy the project's Definition of Done before development proceeds.

---

# Current Architecture


Application
      │
Trading (+ CBasketManager + CGridRisk)
      │
Risk
      │
Signals
      │
Analysis [NEW]
      │
Indicators (+ BollingerBands)
      │
MarketData
      │
Framework
(Context / Module / ModuleManager / Engine)
      │
Core
      │
MQL5 Platform


Dependencies always point downward.

Core remains independent from higher-level modules.

Framework coordinates module interaction without owning business logic.

---

# Folder Layout (Confirmed — July 2026)


AI_SwingBreakout_Pro/
│
├── AI_SwingBreakout_Pro.mq5
│
├── Documentation/
│
├── Include/
│   ├── Core/
│   │   ├── Base/
│   │   ├── Error/
│   │   ├── Logging/
│   │   │   └── Interfaces/
│   │   ├── Structures/
│   │   ├── Utilities/
│   │   ├── Config.mqh
│   │   ├── Constants.mqh
│   │   ├── InputParameters.mqh
│   │   ├── MathUtils.mqh
│   │   ├── Platform.mqh
│   │   ├── Types.mqh
│   │   ├── ValidationUtils.mqh
│   │   └── Version.mqh
│   │
│   ├── Framework/
│   │   ├── Context.mqh
│   │   ├── Module.mqh
│   │   ├── ModuleManager.mqh
│   │   └── Engine.mqh
│   │
│   ├── MarketData/
│   │   └── MarketDataProvider.mqh
│   │
│   ├── Indicators/
│   │   ├── IndicatorBase.mqh
│   │   ├── EMAIndicator.mqh
│   │   ├── ATRIndicator.mqh
│   │   ├── ADXIndicator.mqh
│   │   └── BollingerBands.mqh    [NEW]
│   │
│   ├── Analysis/                  [NEW]
│   │   └── SRDetector.mqh        [NEW]
│   │
│   ├── Signals/
│   │   ├── SignalBase.mqh
│   │   ├── SignalResult.mqh
│   │   └── BreakoutSignal.mqh
│   │
│   ├── Risk/
│   │   ├── RiskBase.mqh
│   │   ├── RiskManager.mqh
│   │   └── RiskResult.mqh
│   │
│   ├── Trading/
│   │   ├── PositionTracker.mqh
│   │   ├── TradeExecutor.mqh
│   │   ├── TradeResult.mqh
│   │   ├── BasketManager.mqh     [NEW]
│   │   └── GridRisk.mqh          [NEW]
│   │
│   └── Tests/
│       ├── Framework/
│       │   └── TestFramework.mqh
│       ├── Core/
│       │   └── Utilities/
│       │       └── TestStringUtils.mq5
│       └── Integration/
│           ├── TestEngineInit.mq5
│           ├── TestSnapshotReady.mq5
│           ├── TestRiskCalculation.mq5
│           ├── TestMarketDataProvider.mq5
│           ├── TestIndicatorPipeline.mq5
│           ├── TestSignalEvaluation.mq5
│           └── TestFullPipeline.mq5
│
├── Source/
├── Tests/
└── Resources/


---

# Include Policy

Correct

cpp
#include "../Types.mqh"
#include "Constants.mqh"


Incorrect

cpp
#include <Core/Types.mqh>


Never use MetaTrader global Include paths.

The only exception is the project entry point:

cpp
AI_SwingBreakout_Pro.mq5


Since it resides outside the `Include/` directory, framework headers must be included as:

cpp
#include "Include/Core/Types.mqh"
#include "Include/Framework/Context.mqh"


All files inside `Include/` continue using project-relative paths exactly as defined by ADR-002 and clarified by ADR-012.

---

# Completed Modules

## Core Layer

Completed:

* Constants
* Types
* Config
* Platform
* ValidationUtils
* Version
* InputParameters
* MathUtils
* BaseObject
* TradeStructures
* MarketStructures
* RiskStructures
* AccountStructures
* StatisticsStructures
* Error subsystem
* Logging subsystem
* StringUtils
* TimeUtils

Sprint 006 completed the full standards reconciliation of all legacy Core modules.

## Framework Layer

Completed:

* CContext — DataReady flag added to CMarketSnapshot (Sprint 012, ADR-016)
* CModule
* CModuleManager
* CEngine — CMarketDataProvider wired as Step 0 in pipeline (Sprint 012)

Implements ADR-013, ADR-014 and ADR-015.

## MarketData Layer — Complete (Sprint 012)

* `MarketData/MarketDataProvider.mqh` — owns all MT5 handles (iMA x2, iATR, iADX); writes FastEMA, SlowEMA, ATR, ADX, PlusDI, MinusDI, Spread, Volume into CMarketSnapshot; sets DataReady flag each tick

## Indicators Layer

Completed:

* IndicatorBase — handles removed; IsReady() now checks snap.DataReady (Sprint 012)
* EMAIndicator — refactored to read from snapshot; no MT5 API calls (Sprint 012)
* ATRIndicator — refactored to read from snapshot; no MT5 API calls (Sprint 012)
* ADXIndicator — refactored to read from snapshot; no MT5 API calls (Sprint 012)

Planned additions (Phase 9b):
* BollingerBands — reads from CMarketSnapshot via CMarketDataProvider

## Analysis Layer — Planned (Phase 9b)

* SRDetector — dynamic support/resistance detection

## Signals Layer

Completed:

* SignalBase
* SignalResult
* BreakoutSignal

## Risk Layer

Completed:

* RiskBase
* RiskResult
* RiskManager

Implements ATR-based stop loss, dynamic position sizing, and execution-independent risk calculations.

## Trading Layer

Completed:

* TradeExecutor
* PositionTracker
* TradeResult

Planned additions (Phase 9b):
* CBasketManager — grid and basket lifecycle management
* CGridRisk — AddLot calculation, grid-aware risk

## Testing Layer

Completed:

* TestFramework
* TestStringUtils
* TestEngineInit
* TestSnapshotReady
* TestRiskCalculation
* Tests/Integration/TestMarketDataProvider.mq5
* Tests/Integration/TestIndicatorPipeline.mq5
* Tests/Integration/TestSignalEvaluation.mq5
* Tests/Integration/TestFullPipeline.mq5

---

# Current Repository Status

The repository currently represents a production-quality modular trading framework with all foundational infrastructure completed.

Completed architectural layers:

* Core
* Framework
* MarketData
* Indicators
* Signals
* Risk
* Trading
* Integration Testing (85% complete)

The remaining work is focused primarily on:

* AI layer
* Advanced strategy modules
* Portfolio management
* Optimization
* Production hardening
* Final test coverage expansion

---

# Current Framework State

The framework now operates as a complete dependency-driven pipeline.


CEngine
 ├── MarketData       (CMarketDataProvider)
 ├── Indicators       (EMA, ATR, ADX, BollingerBands [9b])
 ├── Analysis         (SRDetector [9b])
 ├── Signals          (CBreakoutSignal)
 ├── Risk             (CRiskManager, CGridRisk [9b])
 ├── Trading          (CTradeExecutor, CPositionTracker)
 └── Basket           (CBasketManager [9b])


`CEngine` owns the orchestration sequence while individual modules remain responsible only for their own domain logic.

Module ownership and responsibilities remain clearly separated.

---

# Current Engine Pipeline

Every update cycle executes in the following order:


0. Update MarketData
1. Update Indicators
1.5 Update Analysis            [Phase 9b]
2. Evaluate Signal
3. Evaluate Risk
4. Execute Trade
5. Update Basket               [Phase 9b]
6. Log AI Record               [Phase 10]


MarketData updates are handled exclusively by `CMarketDataProvider`, which sets the `DataReady` flag.

Indicators update from the snapshot. Analysis (Phase 9b) consumes indicator outputs to detect support/resistance.

Signal evaluation begins only after the market snapshot reports `IsReady == true`.

Risk evaluation executes only after a valid trading signal exists.

Trade execution occurs only after risk approval.

Basket management (Phase 9b) updates grid state after execution.

This ordering is fixed by ADR-015, ADR-016, and ADR-017.

---

# Shared Framework Services

Every framework module receives a validated `CContext`.

The context provides shared access to:

* Platform
* Logger
* Error Handler
* Market Snapshot

The context itself is non-owning.

Ownership remains with the composition root.

---

# CMarketSnapshot

`CMarketSnapshot` is the shared data container exchanged between MarketData, Indicators, Signals, Risk, and Trading.

Current fields include:

* FastEMA
* SlowEMA
* ATR
* ADX
* PlusDI
* MinusDI
* TrendDirection
* Spread
* Volume
* DataReady (Sprint 012, ADR-016)
* IsReady

Additional market data can be added without changing module interfaces.

Modules communicate through this snapshot instead of directly referencing one another.

---

# Dependency Rules

Every dependency flows downward.


Application
    ↓
Trading
    ↓
Risk
    ↓
Signals
    ↓
Analysis
    ↓
Indicators
    ↓
MarketData
    ↓
Framework
    ↓
Core
    ↓
MQL5 Platform


Forbidden dependencies include:

* Core → Trading
* Core → Risk
* Core → Signals
* Core → Indicators
* Indicators → Trading
* Indicators → Risk
* Risk → Trading
* Analysis → Trading
* Analysis → Risk
* Analysis → Signals
* Indicators → Analysis

Framework coordinates modules but contains no trading strategy.

---

# Architectural Decisions in Effect

The following Architectural Decision Records are currently active:

* ADR-001 — GitHub is the Single Source of Truth
* ADR-002 — Relative Include Paths Only
* ADR-003 — Core Layer Independence
* ADR-004 — Complete Source Files
* ADR-005 — Documentation First Development
* ADR-006 — Production Quality Only
* ADR-007 — Layered Architecture
* ADR-008 — Static Utility Classes
* ADR-009 — Framework Development Workflow
* ADR-010 — LDN Workflow Command
* ADR-011 — Documentation Reconciliation
* ADR-012 — Include Convention & Core Isolation
* ADR-013 — Framework Layer (Context / Module / ModuleManager / Engine)
* ADR-014 — CMarketSnapshot Shared Data Model
* ADR-015 — Engine Orchestration Pipeline
* ADR-016 — MarketData Layer Abstraction
* ADR-017 — Grid and Basket Management Architecture (added July 12, 2026)

All architectural work must remain consistent with these accepted decisions.

---

# Compile Status

Current repository status:

* Core compiles successfully
* Framework compiles successfully
* MarketData compiles successfully
* Indicators compile successfully
* Signals compiles successfully
* Risk compiles successfully
* Trading compiles successfully
* Integration tests compile successfully

No known architectural compile issues remain.

All new development continues from this verified baseline.

---

# Known Issues

There are currently **no known critical architectural or compile issues** in the repository.

Minor future improvements remain planned as part of normal project evolution:

* Expand AI subsystem.
* Increase integration test coverage to 100%.
* Add stress and regression testing.
* Expand strategy implementations.
* Add portfolio management capabilities.
* Continue optimization and production hardening.

These items are planned enhancements rather than defects.

---

# Current Development Workflow

Every framework module follows the same engineering workflow:

1. Architecture review
2. Interface review
3. Complete implementation
4. Compile verification
5. Integration verification
6. Documentation update
7. Git commit

Development proceeds only after the current task satisfies the project's Definition of Done.

---

# Sprint History

## Sprint 001 — Project Foundation

**Status:** ✅ Completed

Project repository established.

Development standards defined.

Initial documentation created.

---

## Sprint 002 — Core Definitions

**Status:** ✅ Completed

Completed:

* Constants
* Types

---

## Sprint 003 — Core Structures

**Status:** ✅ Completed

Completed:

* TradeStructures
* MarketStructures
* RiskStructures
* AccountStructures
* StatisticsStructures

---

## Sprint 004 — Core Utilities

**Status:** ✅ Completed

Completed:

* Complete rebuild of `MathUtils.mqh`
* Structural class-scope repair
* Production-quality implementation
* Compile verified

---

## Sprint 004b — Repository Reconciliation

**Status:** ✅ Completed

Repository reviewed against documentation.

Legacy modules identified.

Documentation synchronized with repository contents.

---

## Sprint 005 — Platform Services

**Status:** ✅ Completed

Completed:

* Platform
* Config
* ValidationUtils

---

## Sprint 005b — Framework Layer

**Status:** ✅ Completed

Completed:

* CContext
* CModule
* CModuleManager
* CEngine

ADR-013 implemented.

---

## Sprint 006 — Legacy Standards Reconciliation

**Status:** ✅ Completed

Completed:

* Legacy module review
* Logging modernization
* Error subsystem cleanup
* Include standardization
* Signature-hiding fixes
* Error/Logging decoupling

ADR-012 fully implemented.

---

## Sprint 007 — Framework Wiring

**Status:** ✅ Completed

Completed:

* Indicators
* Signals
* Risk
* Framework integration
* Composition root wiring

ADR-014 and ADR-015 implemented.

---

## Sprint 008 — Execution Layer

**Status:** ✅ Completed

Completed:

* TradeExecutor
* ATR-based stop loss
* Engine execution stage
* End-to-end trading pipeline

---

## Sprint 009 — Trading Refinement

**Status:** ✅ Completed

Completed:

* PositionTracker
* Execution improvements
* Risk refinement
* Context propagation fixes
* Snapshot readiness gating

---

## Sprint 010 — Trade History & Cleanup

**Status:** ✅ Completed

Completed:

* Trade history logging through `CLogger`
* EA header cleanup
* Documentation synchronization
* Preparation for integration testing

---

## Sprint 011 — Integration Testing

**Status:** ✅ Completed

Completed:

* TestFramework verification
* TestEngineInit
* TestSnapshotReady
* TestRiskCalculation

Integration testing baseline established.

---

## Sprint 012 — MarketData Layer

**Status:** ✅ Completed

Completed:

* CMarketSnapshot.DataReady field added
* CMarketDataProvider built and wired as Step 0
* Indicators refactored to read from snapshot
* Full stack backtest confirmed

---

## Sprint 013 — ✅ Complete

**Phase:** Production Hardening — Testing Expansion
**Version:** 2.0.0-alpha.13
Date: July 2026

Four integration tests added covering the MarketData layer and full engine pipeline:

| File | Assertions | Result |
|------|------------|--------|
| TestMarketDataProvider.mq5  | 7/7  | ✅ PASS |
| TestIndicatorPipeline.mq5   | 9/9  | ✅ PASS |
| TestSignalEvaluation.mq5    | 7/7  | ✅ PASS |
| TestFullPipeline.mq5        | 8/8  | ✅ PASS |
| **Total**                   | **31/31** | ✅ **ALL PASS** |

Baseline balance $1,157.69 held across all four tests. No regression.
Testing Layer coverage: ~85%.

---

# Current Priority

Current Phase: Phase 9b — Advanced Strategy Infrastructure

**Current Sprint:** Sprint 014

Immediate priorities:
1. BollingerBands.mqh — Indicators layer
2. SRDetector.mqh — new Analysis layer
3. CBasketManager.mqh — Trading layer
4. CGridRisk.mqh — Trading layer
5. Floating Profit Engine — inside CBasketManager

Phase 10 (AI Data Collection) cannot begin until Phase 9b is complete.

---

# GitHub Workflow

Every development session follows the same workflow:

1. Pull the latest repository state.
2. Review project documentation.
3. Review architecture before implementation.
4. Implement complete production-quality source files.
5. Verify successful compilation.
6. Execute applicable tests.
7. Update documentation.
8. Commit completed work to GitHub.

The GitHub repository is the authoritative source for:

* Source code
* Documentation
* Architecture
* Development history

Chat history is never considered a permanent project record.

---

# Communication Rules

The project uses the following workflow keyword:


LDN


Meaning:


Let Do Next


When this command is issued, development should immediately continue with the next planned task.

Avoid repeating previous explanations unless clarification is specifically requested.

---

# Project Status

Current Version


2.0.0-alpha.13


Current State


Sprint 013 complete. Extended integration testing done (31/31 tests passing). 
MarketData layer introduced (ADR-016). Full pipeline trading confirmed.
Sprint 014 next.


Current Phase


Phase 9b — Advanced Strategy Infrastructure


### Overall Progress


Foundation & Framework      ██████████ 100%
Trading & Risk              ██████████ 100%
Market Data                 ██████████ 100%
Testing Layer               █████████░  85%
AI & Optimization           ░░░░░░░░░░   0%
Analysis & Advanced Trading ░░░░░░░░░░   0%
Overall Completion          █████████░  ~92%


---

# Notes for Future AI Sessions

Before making any implementation changes, always review the following documents in order:

1. PROJECT_CONTEXT.md
2. ARCHITECTURE.md
3. CODING_STANDARD.md
4. DECISIONS.md
5. ROADMAP.md
6. CHANGELOG.md
7. ProjectManagerSkill.md

Do not assume previous conversation history is available.

Always continue from the current repository state.

Documentation must remain synchronized with implementation.

Repository contents always take precedence over historical conversation.

---

# MQL5-Specific Engineering Notes

The following platform-specific rules have been established during framework development:

1. MQL5 does not support static class members as default parameter values. Use overload pairs instead.
2. Virtual function signatures must match exactly. A different parameter list hides the base method and compiles without warning. Always use `override` where applicable.
3. MQL5 does not support reference return types (`Type&`). Return pointers to class objects instead.
4. `GetPointer()` works only with class instances, not structs. This is why `SMarketSnapshot` was replaced with `CMarketSnapshot`.
5. Call `ArraySetAsSeries(buffer, true)` before using `CopyBuffer()` to ensure index `0` contains the newest value.
6. Indicator handles are created during `Initialize()`, not in constructors.
7. `CLogger` uses `Configure()` for dependency injection rather than `Initialize()`.
8. Use `_Symbol` directly instead of `SymbolInfoString(_Symbol, SYMBOL_NAME)`.
9. `CValidationUtils::IsValidVolume()` accepts parameters in the order `(string symbol, double volume)`.
10. `CEngine::Initialize()` must initialize every registered sub-module individually. Initializing the engine itself does not automatically initialize its owned module pointers.
11. `CMarketSnapshot::IsReady` is explicitly controlled by the engine checking `snap.DataReady` (set by `CMarketDataProvider`) and serves as the synchronization contract between MarketData, Indicators, Signals, Risk, and Trading.

These conventions have been incorporated into the framework architecture and should be followed by all future modules.

---

# Definition of Done

A module is considered complete only when all of the following conditions are satisfied:

* Production-quality implementation.
* Complete source file.
* Successful compilation with zero known compile issues.
* Dependency rules respected.
* Architecture remains consistent.
* Appropriate testing completed.
* Documentation synchronized.
* Ready for Git commit.

Only after these criteria are met should development proceed to the next planned task.

---

# Closing Statement

AI Swing Breakout Pro is developed as a long-term, production-quality MQL5 framework.

Its architecture emphasizes modularity, maintainability, deterministic behavior, and comprehensive documentation.

Every architectural decision, implementation, and documentation update is intended to preserve consistency across future development cycles while enabling continued expansion into advanced trading, portfolio management, optimization, and AI-assisted decision-making.