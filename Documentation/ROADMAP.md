# AI Swing Breakout Pro Framework

# ROADMAP

**Version:** 2.0.0-alpha.3
**Status:** Active Development
**Last Updated:** July 2026

---

# Vision

Build a production-quality, modular MQL5 trading framework capable of supporting:

* Swing Trading
* Breakout Trading
* Scalping
* Multi-Timeframe Analysis
* AI-assisted Trade Decisions
* Portfolio Management
* Backtesting
* Optimization
* Future Machine Learning Integration

The framework should be reusable, extensible, maintainable, and production-ready.

---

# Development Principles

Every milestone must satisfy the following requirements:

* Production-quality implementation
* Compiles successfully
* Documentation updated
* GitHub committed
* No placeholder implementations
* No duplicated logic

Development proceeds module-by-module rather than feature-by-feature.

---

# Overall Progress (Reconciled July 2026)

A repository export reviewed this cycle showed materially more implemented than previous roadmap versions tracked. Progress bars below have been revised. Note that a meaningful share of "Foundation Layer" progress is **existing, unreviewed code** discovered during reconciliation, not newly built work — see Known Issues in `PROJECT_CONTEXT.md`.

```text
Foundation Layer          ██████▌░░░  65%
Infrastructure Layer      ░░░░░░░░░░   0%
Trading Layer             ░░░░░░░░░░   0%
Risk Layer                ░░░░░░░░░░   0%
AI Layer                  ░░░░░░░░░░   0%
Testing & Optimization    ░░░░░░░░░░   0%

Overall Project Progress  ███▎░░░░░░  32%
```

---

# Phase 1 — Foundation

## Goal

Build a stable and reusable framework foundation.

### Sprint 001 — Project Foundation

Status: ✅ Completed

Deliverables:

* Repository initialization
* Documentation structure
* Folder structure
* Repository audit

---

### Sprint 002 — Core Definitions

Status: ✅ Completed

Deliverables:

* Constants.mqh
* Types.mqh

---

### Sprint 003 — Core Structures

Status: ✅ Completed

Deliverables:

* TradeStructures.mqh
* MarketStructures.mqh
* RiskStructures.mqh
* AccountStructures.mqh
* StatisticsStructures.mqh

---

### Sprint 004 — Core Utilities (MathUtils)

Status: ✅ Completed this cycle

Objective:

Rebuild:

```text
Include/Core/MathUtils.mqh
```

What was found:

The previous file had a structural scope bug, not just "compile errors": its class body closed after the first section (`Basic Math`), and roughly 480 subsequent lines of intended methods — price math, statistics, trading/risk math, safe-math helpers — were left floating outside the class entirely. It also hardcoded its epsilon value instead of sourcing it from `CConstants::EPSILON`.

What was done:

Rewrote the file completely as a Core-only, static, epsilon-consistent utility class (`CMathUtils`). Deliberately excluded Trading/Risk-domain formulas (`PositionSize`, `RiskOfRuin`, `ProfitFactor`, `WinRate`, `DrawdownPercent`, etc.) that existed in the broken version — those belong in the future Risk module per ADR-003, not in Core.

Deliverables:

* MathUtils.mqh — done
* Compile verification — **done** (MetaEditor: 0 errors, 0 warnings)
* Documentation update — done (this cycle)

Note: initial compile attempt surfaced 8 "constant expected" errors. Root cause was an MQL5 limitation, not a logic error: static class members (`CConstants::EPSILON`) are not accepted as default parameter values, even though `EPSILON` is `const`. Fixed by splitting each affected method (`IsEqual`, `IsZero`, `IsGreater`, `IsLess`, `IsGreaterOrEqual`, `IsLessOrEqual`, `IsBetween`, `Sign`) into a two-overload pair — one explicit-epsilon version, one convenience version that calls it with `CConstants::EPSILON` passed as a normal argument. Re-verified: 0 errors, 0 warnings.

---

### Sprint 004b — Repository Reconciliation (NEW)

Status: ✅ Completed this cycle

Trigger:

An export of the actual project directory was reviewed and found to contain substantially more than prior documentation tracked, including a full Error-handling subsystem, a full Logging subsystem, `Config.mqh`, `InputParameters.mqh`, `Version.mqh`, `BaseObject.mqh`, `StringUtils.mqh`, `TimeUtils.mqh`, and a `Tests/` directory with a working test framework and one test suite — none previously documented.

Deliverables:

* PROJECT_CONTEXT.md — reconciled to actual repository contents
* ARCHITECTURE.md — reconciled folder structure and module inventory
* ROADMAP.md — this file, progress bars and sprint history corrected
* CHANGELOG.md — new entry documenting the reconciliation
* DECISIONS.md — ADR-011 recording the reconciliation decision and legacy-module policy

Explicitly deferred:

* Full line-by-line compliance audit of the newly-documented legacy modules (deferred by decision, not oversight — see ADR-011)

---

### Sprint 005 — Platform Services

Status: 🚧 In Progress — Platform.mqh done, ValidationUtils.mqh pending

Deliverables:

```text
Include/Core/Platform.mqh          ✅ done, compiled clean
Include/Core/ValidationUtils.mqh   pending — next task
```

Platform.mqh notes: built with value-owned `CConfig m_config` (not a raw injected pointer — safer, no dangling-pointer risk), a `Config()` accessor returning `const CConfig*` via `GetPointer()` (MQL5 has no reference return types), and a full header. Compiled clean.

Note: `Include/Core/Logging/Logger.mqh` already exists (pending standards review), so a new `Logger.mqh` is no longer a Sprint 005 deliverable — it has been replaced with a review/reconciliation task for the existing file instead.

Goal:

Create the platform abstraction layer used by all higher-level modules, and bring the existing Logging subsystem into documented, standards-verified status.

---

### Sprint 005b — Framework Layer (NEW, not originally planned)

Status: ✅ Completed this cycle

Trigger:

Built directly (outside the documented sprint-by-sprint workflow) as `Include/Framework/Context.mqh`, `Module.mqh`, `ModuleManager.mqh`, `Engine.mqh` — a new top-level layer for module composition and lifecycle management, sitting above Core.

What was found:

`CModule::Initialize()` took no parameters; `CEngine::Initialize(CContext*)` took one. Different signatures meant `CEngine` never actually overrode the base — it hid it. This compiled with zero errors and zero warnings, and would have silently left `CEngine.m_context` as `NULL` forever whenever driven through `CModuleManager`'s polymorphic dispatch. See CHANGELOG.md for the full explanation.

What was done:

`CContext` handling moved into the `CModule` base itself (`Initialize(CContext*)`, `m_context`, `Context()`), so every future Trading/Risk/AI module inherits consistent context injection rather than each reimplementing it. `CModuleManager` gained `SetContext()` and now passes context through to every registered module. `CModuleManager` explicitly does not own registered modules (no deletion in `Shutdown()` or a destructor) — documented, not just assumed. See DECISIONS.md, ADR-013.

Deliverables:

* Context.mqh, Module.mqh, ModuleManager.mqh, Engine.mqh — done, compiled clean together
* ARCHITECTURE.md, ROADMAP.md, CHANGELOG.md, DECISIONS.md — reconciled to include this layer

Explicitly deferred:

* Wiring the Framework layer into `AI_SwingBreakout_Pro.mq5` (constructing an actual `CContext`, populating it with a real `CPlatform`/`CLogger`/`CErrorHandler`, building a `CModuleManager`) — no composition root exists yet.

---

### Sprint 006 — Legacy Standards Reconciliation

Status: Planned (new)

Goal:

Bring the "present but not yet reviewed" Core modules into compliance with `CODING_STANDARD.md`, or formally document an exception per module.

Candidates:

```text
Base/BaseObject.mqh
InputParameters.mqh
Version.mqh
Error/ (4 files)
Logging/ (7 files)
Utilities/StringUtils.mqh
Utilities/TimeUtils.mqh
```

Note: `Config.mqh` has been removed from this candidate list — it was finalized directly (header, include guard, enum collision, and validation completeness all addressed) and is considered closed, not pending review.

Known concrete issues to resolve:

* Include guard style (`__NAME_MQH__` → `AI_SWINGBREAKOUT_CORE_NAME_MQH`)
* Enum naming (`ENUM_X` → `EX`)
* Absolute include in `Error/TestErrorHandler.mqh`
* Header format consistency (Module/Author lines)
* Version string consistency
* Decouple `ErrorInfo.mqh` from `LogLevel.mqh` — give `SErrorInfo.Severity` its own type instead of borrowing `ENUM_LOG_LEVEL` (per ADR-012, target design: Error and Logging must not depend on each other)

---

# Phase 2 — Infrastructure

Status: Partially started (unreviewed)

Modules:

```text
Configuration        — Config.mqh exists, pending review
File System           — not started
Logging                — Logger.mqh + subsystem exists, pending review
Serialization          — not started
Time Utilities          — TimeUtils.mqh exists, pending review
Symbol Utilities         — not started
Session Utilities         — not started
Error Handling             — ErrorHandler.mqh + subsystem exists, pending review
Event System                — not started
```

Deliverable:

Complete and standards-verify infrastructure services.

---

# Phase 3 — Market Data

Status: Planned

Modules:

```text
Price Engine
Candle Engine
Market Snapshot
Tick Processing
Multi-Timeframe Cache
History Loader
```

Deliverable:

Reliable market data abstraction.

---

# Phase 4 — Indicator Framework

Status: Planned

Modules:

```text
Moving Average
ATR
ADX
RSI
MACD
Bollinger Bands
Volume Analysis
Trend Detection
Custom Indicators
```

Deliverable:

Reusable indicator framework.

---

# Phase 5 — Risk Engine

Status: Planned

Modules:

```text
Position Sizing
Risk Calculator
Exposure Control
Daily Loss Limit
Drawdown Protection
Correlation Filter
Trade Validation
```

Note: the broken legacy `MathUtils.mqh` contained several formulas belonging here (`PositionSize`, `RiskOfRuin`, `ProfitFactor`, `Expectancy`, `BreakEvenWinRate`, `RecoveryFactor`, `WinRate`, `DrawdownPercent`). These are logically sound as formulas but were misplaced in Core. They should be salvaged into this module rather than re-derived from scratch, once this phase begins.

Deliverable:

Production-grade risk management.

---

# Phase 6 — Trading Engine

Status: Planned

Modules:

```text
Trade Manager
Order Manager
Position Manager
Execution Engine
Trade Filters
Order Lifecycle
```

Deliverable:

Reliable trade execution framework.

---

# Phase 7 — Strategy Engine

Status: Planned

Modules:

```text
Swing Breakout
Trend Following
Scalping
Reversal
Range Trading
Strategy Interface
```

Deliverable:

Plug-in strategy architecture.

---

# Phase 8 — AI Engine

Status: Planned

Modules:

```text
Feature Extraction
Market Classification
Signal Scoring
Trade Confidence
Risk Prediction
Adaptive Parameters
```

Deliverable:

AI-assisted decision engine.

---

# Phase 9 — Testing

Status: Partially started (unreviewed)

Modules:

```text
Unit Tests            — TestFramework.mqh + one test suite (StringUtils) exist
Integration Tests      — not started
Stress Tests             — not started
Regression Tests          — not started
```

Deliverable:

Verified framework stability.

---

# Phase 10 — Optimization

Status: Planned

Modules:

```text
Parameter Optimization
Walk Forward Testing
Performance Analysis
Monte Carlo Simulation
```

Deliverable:

Optimized trading system.

---

# Phase 11 — Production Release

Target Version:

```text
Version 2.0.0
```

Release Criteria:

* All planned modules completed
* Stable architecture
* Full documentation
* Zero known critical compile issues
* Successful long-term backtesting
* Production-ready codebase

---

# Current Priority

Current Sprint:

```text
Sprint 005 (Platform.mqh done; ValidationUtils.mqh pending)
```

Current Task:

```text
Build Include/Core/ValidationUtils.mqh
```

Next Tasks:

1. Build `Include/Core/ValidationUtils.mqh`
2. Wire Framework layer (Context/Module/ModuleManager/Engine) into `AI_SwingBreakout_Pro.mq5`
3. Begin Sprint 006 (Legacy Standards Reconciliation) — includes decoupling `ErrorInfo.mqh` from `LogLevel.mqh` per ADR-012
4. Resolve absolute include in `Error/TestErrorHandler.mqh`
5. Begin Infrastructure Layer standards review
6. Build Risk Engine foundation (salvage formulas from legacy MathUtils.mqh)

Resolved this cycle: `Platform.mqh` built and compiled clean; `Config.mqh` finalized (closed, not pending review); Framework layer (Context/Module/ModuleManager/Engine) built, critical Initialize() signature-hiding bug found and fixed, compiled clean together — see ADR-013.

Note: when reviewing legacy modules in Sprint 006, specifically check for the same static-member-as-default-parameter pattern that caused MathUtils.mqh's compile errors — any legacy file using `SomeClass::CONST` as a default argument will fail the same way. Also check any class hierarchy for virtual method signature mismatches like the one found in Engine.mqh — these compile clean and fail silently, so they won't show up in a "0 errors, 0 warnings" build.

---

# Definition of Done

A sprint is complete only when:

* Source code is production quality.
* The project compiles successfully.
* Documentation is synchronized.
* Architecture remains consistent.
* Changes are committed to GitHub.
* The repository is in a stable state.

Only then should development continue to the next sprint.