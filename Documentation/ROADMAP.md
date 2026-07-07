# AI Swing Breakout Pro Framework

# ROADMAP

**Version:** 2.0.0-alpha.4
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

---

# Development Principles

* Production-quality implementation only
* Compiles successfully before proceeding
* Documentation updated with every sprint
* No placeholder implementations
* No duplicated logic
* Interface/contract reviewed before implementation for architecturally central pieces

---

# Overall Progress

```text
Foundation Layer          ██████████  100%
Framework Layer           ████████░░   80%  (wiring into main EA pending)
Infrastructure Layer      ██░░░░░░░░   20%  (Error/Logging/String/Time done via Sprint 006)
Risk Layer                ░░░░░░░░░░    0%
Trading Layer             ░░░░░░░░░░    0%
AI Layer                  ░░░░░░░░░░    0%
Testing & Optimization    ░░░░░░░░░░    0%

Overall Project Progress  █████░░░░░   55%
```

---

# Phase 1 — Foundation

## Sprint 001 — Project Foundation
Status: ✅ Completed

## Sprint 002 — Core Definitions
Status: ✅ Completed
Deliverables: `Constants.mqh`, `Types.mqh`

## Sprint 003 — Core Structures
Status: ✅ Completed
Deliverables: `TradeStructures.mqh`, `MarketStructures.mqh`, `RiskStructures.mqh`, `AccountStructures.mqh`, `StatisticsStructures.mqh`

## Sprint 004 — Core Utilities (MathUtils)
Status: ✅ Completed
Deliverables: `MathUtils.mqh` — full rebuild. Structural scope bug fixed, epsilon default-parameter MQL5 limitation worked around via overload pairs. Compile-verified: 0 errors, 0 warnings.

## Sprint 004b — Repository Reconciliation
Status: ✅ Completed
Trigger: Repository export revealed substantially more implemented code than documentation tracked. All docs reconciled to actual repo state.

## Sprint 005 — Platform Services
Status: ✅ Completed

Deliverables:

* `Platform.mqh` — value-owned config, `GetPointer()` fix for MQL5 reference-return limitation, compile-verified
* `ValidationUtils.mqh` — built, compile pending confirmation

## Sprint 005b — Framework Layer
Status: ✅ Completed

Deliverables: `Context.mqh`, `Module.mqh`, `ModuleManager.mqh`, `Engine.mqh`

Critical bug found and fixed: `CEngine::Initialize(CContext*)` silently hid `CModule::Initialize()` instead of overriding it — compiled with 0 errors, would have left `m_context` NULL forever at runtime. Fixed architecturally by moving `CContext` injection into `CModule` itself. See ADR-013 and CHANGELOG.md.

## Sprint 006 — Legacy Standards Reconciliation
Status: ✅ Completed

All 16 legacy Core modules brought into full `CODING_STANDARD.md` compliance.

Three latent bugs found and fixed (none were compile errors):

1. **TimeUtils.mqh** — entire file content was duplicated, outer `#ifndef` guard never closed.
2. **Logger.mqh** — `CLogger::Initialize(ILogFormatter*, ILogOutput*)` hid `CBaseObject::Initialize()` instead of overriding it (same category as CEngine bug). Renamed to `Configure()`.
3. **DefaultLogFormatter.mqh** — referenced 6 fields on `SLogRecord` that didn't exist. Fixed by adding the fields to `SLogRecord` (`Function`/`Line`/`Symbol`/`Timeframe`/`Ticket`/`ErrorCode`).

Additional notable fixes:

* `ErrorInfo.mqh` — decoupled from Logging subsystem. `SErrorInfo.Severity` now uses `ENUM_ERROR_SEVERITY` (owned by Error) instead of `ENUM_LOG_LEVEL` (borrowed from Logging). Implements ADR-012 target design.
* `TestErrorHandler.mqh` — rewritten to test actual current API. Absolute include path fixed.

---

# Phase 2 — Framework Wiring (Sprint 007)

Status: 🚧 In Progress

## Sprint 007 — Composition Root + Risk Engine Start

Objectives:

1. Confirm `ValidationUtils.mqh` compiles (carry-forward from Sprint 005).
2. Write `AI_SwingBreakout_Pro.mq5` — the composition root. Construct `CPlatform`, `CLogger` (via `Configure()`), `CErrorHandler`, wire all three into a `CContext`, build a `CModuleManager`, and drive `OnInit()`/`OnTick()`/`OnDeinit()` through the module system. This is the first end-to-end integration test — every module built so far gets exercised together for the first time.
3. Begin `Include/Risk/` — position sizing, risk calculator. Salvage the formulas that were in the old broken `MathUtils.mqh` (`PositionSize`, `RiskOfRuin`, `ProfitFactor`, `Expectancy`, `DrawdownPercent`, `RecoveryFactor`) — these were architecturally misplaced in Core, but the math itself is sound and should be reused here.

---

# Phase 3 — Market Data

Status: Planned

Modules: Price Engine, Candle Engine, Market Snapshot, Tick Processing, Multi-Timeframe Cache, History Loader

---

# Phase 4 — Indicator Framework

Status: Planned

Modules: Moving Average, ATR, ADX, RSI, MACD, Bollinger Bands, Volume Analysis, Trend Detection, Custom Indicators

---

# Phase 5 — Risk Engine

Status: Starting (Sprint 007)

Modules:

```text
Position Sizing       ← salvage from old MathUtils.mqh
Risk Calculator       ← salvage from old MathUtils.mqh
Exposure Control
Daily Loss Limit
Drawdown Protection
Correlation Filter
Trade Validation
```

---

# Phase 6 — Trading Engine

Status: Planned

Modules: Trade Manager, Order Manager, Position Manager, Execution Engine, Trade Filters, Order Lifecycle

---

# Phase 7 — Strategy Engine

Status: Planned

Modules: Swing Breakout, Trend Following, Scalping, Reversal, Range Trading, Strategy Interface

---

# Phase 8 — AI Engine

Status: Planned

Modules: Feature Extraction, Market Classification, Signal Scoring, Trade Confidence, Risk Prediction, Adaptive Parameters

Note: `CPlatform::Config()` returns `const CConfig*` intentionally. When Phase 8 begins, runtime parameter adaptation should be implemented as narrow, explicit setters — not by widening this to non-const. See DECISIONS.md, ADR-012.

---

# Phase 9 — Testing

Status: Partially started

Modules:

```text
Unit Tests      — TestFramework.mqh + TestStringUtils.mq5 exist
Integration     — pending (first real integration test is AI_SwingBreakout_Pro.mq5, Sprint 007)
Stress Tests    — planned
Regression      — planned
```

---

# Phase 10 — Optimization

Status: Planned

Modules: Parameter Optimization, Walk Forward Testing, Performance Analysis, Monte Carlo Simulation

---

# Phase 11 — Production Release

Target Version: `2.0.0`

Release Criteria:

* All planned modules completed
* Stable architecture
* Full documentation
* Zero known critical compile issues
* Successful long-term backtesting
* Production-ready codebase

---

# Current Priority

Current Sprint: **Sprint 007**

Current Tasks (in order):

1. Confirm `ValidationUtils.mqh` compile result
2. Write `AI_SwingBreakout_Pro.mq5` (composition root / integration test)
3. Begin `Include/Risk/` — interface proposal first per agreed workflow

Known MQL5 gotchas to check in every new file going forward:

* No static class members as default parameter values → use overload pairs
* Virtual method signature must match exactly → different parameter list hides instead of overrides, compiles clean, fails silently

---

# Definition of Done

A sprint is complete only when:

* Source code is production quality
* Project compiles successfully
* Documentation is synchronized
* Architecture remains consistent
* Changes are committed to GitHub
* Repository is in a stable state