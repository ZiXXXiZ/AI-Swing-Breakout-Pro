# AI Swing Breakout Pro Framework

# ROADMAP

**Version:** 2.0.0-alpha.9
**Status:** Active Development
**Last Updated:** July 10, 2026

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
Framework Layer           ██████████  100%
Infrastructure Layer      ██████████  100%
Indicators Layer          ██████████  100%
Signals Layer             ██████████  100%
Risk Layer                ██████████  100%
Trading Layer             █████████░   90%  (logging pending)
AI Layer                  ░░░░░░░░░░    0%
Testing & Optimization    ░░░░░░░░░░    0%

Overall Project Progress  █████████░   90%
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

Status: ✅ Completed

## Sprint 007 — Composition Root + Indicators + Signals + Risk + Engine Wiring

Objectives:

1. ✅ Task 1 — `Context.mqh` — `CMarketSnapshot` added (ADR-014)
2. ✅ Task 2 — Indicators layer — `IndicatorBase.mqh`, `EMAIndicator.mqh`, `ATRIndicator.mqh`, `ADXIndicator.mqh` — compile-verified
3. ✅ Task 3 — Signals layer — `SignalResult.mqh`, `SignalBase.mqh`, `BreakoutSignal.mqh` — compile-verified
4. ✅ Task 4 — Risk layer — `RiskResult.mqh`, `RiskBase.mqh`, `RiskManager.mqh` — compile-verified
5. ✅ Task 5 — `Engine.mqh` — orchestration pipeline added (ADR-015) — compile-verified
6. ✅ Task 6 — `AI_SwingBreakout_Pro.mq5` — Stage 6 wiring — compile-verified

---

# Phase 3 — Execution Layer (Sprint 008)

Status: ✅ Completed

## Sprint 008 — Execution + Risk Refinement

Objectives:

1. ✅ Task 1 — `RiskManager.mqh` — ATR-based stop loss replaces placeholder — compile-verified
2. ✅ Task 2 — `TradeExecutor.mqh` (new — `Include/Trading/`) — compile-verified
3. ✅ Task 3 — `Engine.mqh` — `CTradeExecutor` wired into Step 4 pipeline — compile-verified
4. ✅ Task 4 — `SESSION_CHECKPOINT.md` — written
5. ✅ Task 5 — `AI_SwingBreakout_Pro.mq5` — Stage 7 wiring, full pipeline end-to-end — **0 errors, 0 warnings, 1677 ms**

---

# Phase 4 — Trading Engine Expansion (Sprint 009)

Status: ✅ Completed

## Sprint 009 — Risk Refinement + Trade Quality

Objectives:

1. ✅ Task 1 — Dual-Layer Position Guard — `PositionTracker.mqh` (new), `Engine.mqh`, `TradeExecutor.mqh`, `AI_SwingBreakout_Pro.mq5` — 0 errors, 0 warnings, 1633 ms
2. ✅ Task 2 — Option C: SL/TP price construction moved to `TradeExecutor` — `RiskResult.mqh`, `RiskManager.mqh`, `TradeExecutor.mqh` — 0 errors, 0 warnings, 1750 ms
3. ✅ Task 3 — `request.deviation` moved from hardcoded `10` to `CConfig`
4. ✅ Task 4 — `Engine.mqh` runtime bug fixes: sub-module context propagation + `IsReady` gating — backtest confirmed profitable ($1000 → $1140.50, 550 trades, GOLD.c H1)

---

# Phase 5 — Trade Quality + Logging (Sprint 010)

Status: 🚧 Next

## Sprint 010 — Trade History + Cleanup

Objectives:

1. ⏳ Task 1 — Trade history logging via `CLogger` ← **NEXT**
2. ⏳ Task 2 — `AI_SwingBreakout_Pro.mq5` file header cosmetic fix (Purpose line still reads Stage 7)
3. ⏳ Task 3 — TBD (review after above)

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

Current Sprint: **Sprint 010**

Current Task:

* ⏳ Task 1 — Trade history logging via `CLogger`

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