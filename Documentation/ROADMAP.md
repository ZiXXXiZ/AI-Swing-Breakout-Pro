# AI Swing Breakout Pro Framework

# ROADMAP

**Version:** 2.0.0-alpha.13
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
* Grid and Basket Trade Management
* Portfolio Management
* Backtesting
* Optimization
* Future Machine Learning Integration

The framework is designed around a clean, layered architecture so that new trading strategies, execution models, AI components, and analytical tools can be integrated without disrupting existing modules.

---

# Development Principles

The project follows these engineering principles throughout development:

* Production-quality implementation only
* Every source file must compile successfully before development proceeds
* Documentation is updated alongside implementation
* No placeholder implementations in production code
* No duplicated logic
* Complete source files instead of incremental assembly
* Architecture reviewed before implementation of framework-level components
* Stable public interfaces before downstream modules are developed
* Repository remains the single source of truth
* Every completed sprint leaves the project in a releasable state

These principles are enforced through the project's Architecture Decision Records (ADRs) and coding standards.

---

# Overall Progress

```text
Foundation Layer          ██████████ 100%
Framework Layer           ██████████ 100%
Infrastructure Layer      ██████████ 100%
Market Data               ██████████ 100%   (Sprint 012 complete)
Indicators Layer          ██████████ 100%
Signals Layer             ██████████ 100%
Risk Layer                ██████████ 100%
Trading Layer             ██████████ 100%   (logging confirmed complete)
Testing Layer             ████████░░  85%
Analysis Layer            ░░░░░░░░░░   0%   (Phase 9b — planned)
Advanced Trading          ░░░░░░░░░░   0%   (Phase 9b — planned)
AI Layer                  ░░░░░░░░░░   0%   (Phase 10+ — blocked on Phase 9b)
Optimization Layer        ░░░░░░░░░░   0%

Overall Project Progress  ████████░░  80%
```

### Progress Summary

Completed:

* Core framework
* Infrastructure
* Framework layer
* Market Data layer
* Indicator framework
* Signal framework
* Risk framework
* Trading execution pipeline
* Composition root
* Engine orchestration
* Legacy standards reconciliation
* Initial integration testing

Blocked — requires Phase 9b before proceeding:

* AI Data Collection layer
* AI Training pipeline
* AI Veto and confidence-weighted execution

Current Focus:

* Define Phase 9b architecture (ADR-017)
* Build Advanced Strategy Infrastructure
* Insert Analysis layer
* Build Grid and Basket management modules
* Expand BollingerBands and SRDetector into the framework

---

# Phase 1 — Foundation

## Sprint 001 — Project Foundation

**Status:** ✅ Completed

### Deliverables

* Repository structure established
* Documentation structure created
* Initial project architecture defined
* Development workflow established

---

## Sprint 002 — Core Definitions

**Status:** ✅ Completed

### Deliverables

* `Constants.mqh`
* `Types.mqh`

Established the project's fundamental shared definitions used throughout every subsequent module.

---

## Sprint 003 — Core Structures

**Status:** ✅ Completed

### Deliverables

* `TradeStructures.mqh`
* `MarketStructures.mqh`
* `RiskStructures.mqh`
* `AccountStructures.mqh`
* `StatisticsStructures.mqh`

Defined the common data structures shared across Trading, Risk, Indicators, and future AI modules.

---

## Sprint 004 — Core Utilities (MathUtils)

**Status:** ✅ Completed

### Deliverables

* Complete rebuild of `MathUtils.mqh`

Major improvements:

* Structural scope bug corrected
* Full production-quality implementation
* Compile verified
* Zero errors
* Zero warnings

Implemented overload-based solutions to accommodate MQL5 limitations regarding default parameters.

---

## Sprint 004b — Repository Reconciliation

**Status:** ✅ Completed

### Objective

Reconcile documentation with the actual repository contents after a full repository review revealed substantially more completed modules than previously documented.

### Deliverables

* Documentation synchronized with repository
* Legacy modules catalogued
* Standards review initiated
* Project progress corrected to reflect actual implementation

---

# Phase 2 — Framework Wiring

## Sprint 007 — Composition Root + Indicators + Signals + Risk + Engine Wiring

**Status:** ✅ Completed

### Objectives

1. ✅ **Task 1 — `Context.mqh`**

   * Introduced `CMarketSnapshot`
   * Shared runtime market state through `CContext`
   * Foundation established for inter-module communication
   * See **ADR-014**

2. ✅ **Task 2 — Indicators Layer**

   * `IndicatorBase.mqh`
   * `EMAIndicator.mqh`
   * `ATRIndicator.mqh`
   * `ADXIndicator.mqh`
   * Full compile verification

3. ✅ **Task 3 — Signals Layer**

   * `SignalResult.mqh`
   * `SignalBase.mqh`
   * `BreakoutSignal.mqh`
   * Compile verified

4. ✅ **Task 4 — Risk Layer**

   * `RiskResult.mqh`
   * `RiskBase.mqh`
   * `RiskManager.mqh`
   * Compile verified

5. ✅ **Task 5 — Engine Layer**

   * `Engine.mqh`
   * Complete orchestration pipeline implemented
   * Best-effort indicator updates
   * Fixed execution order
   * Context-driven module communication
   * See **ADR-015**

6. ✅ **Task 6 — Composition Root**

   * `AI_SwingBreakout_Pro.mq5`
   * Stage 6 framework wiring completed
   * Full project compilation successful

### Sprint Outcome

Sprint 007 completed the architectural transition from independent modules to a fully connected framework. Every major subsystem now communicates exclusively through `CContext`, providing a clean dependency graph and establishing the production architecture used by subsequent development.

---

# Phase 3 — Execution Layer

## Sprint 008 — Execution + Risk Refinement

**Status:** ✅ Completed

### Objectives

1. ✅ **Task 1 — Risk Refinement**

   * Placeholder stop-loss calculations replaced
   * ATR-driven stop-loss implementation
   * Production-quality risk calculations

2. ✅ **Task 2 — Trade Execution**

   * New `TradeExecutor.mqh`
   * Centralized order submission
   * Clean separation between decision logic and execution

3. ✅ **Task 3 — Engine Integration**

   * `CTradeExecutor` integrated into `CEngine`
   * Execution becomes Stage 4 of the runtime pipeline

4. ✅ **Task 4 — Documentation**

   * `SESSION_CHECKPOINT.md`
   * Development checkpoint recorded

5. ✅ **Task 5 — Full Pipeline**

   * Stage 7 wiring completed
   * Entire execution flow verified

### Build Verification

```text
Compilation:
0 Errors
0 Warnings

Compile Time:
1677 ms
```

### Sprint Outcome

Sprint 008 completed the first end-to-end production execution pipeline:

```text
Indicators
      ↓
Signals
      ↓
Risk
      ↓
Trade Execution
```

The framework could now execute trades using fully integrated production modules rather than placeholder implementations.

---

# Phase 4 — Trading Engine Expansion

## Sprint 009 — Risk Refinement + Trade Quality

**Status:** ✅ Completed

### Objectives

1. ✅ **Task 1 — Dual-Layer Position Guard**

   * Added `PositionTracker.mqh`
   * Prevent duplicate trades
   * Engine integration completed
   * TradeExecutor updated
   * EA integration completed

2. ✅ **Task 2 — SL/TP Architecture Refactor**

   * Stop-loss and take-profit price construction moved entirely into `TradeExecutor`
   * Risk layer now returns logical trade information only
   * Improved separation of responsibilities

3. ✅ **Task 3 — Configuration Improvements**

   * Removed hardcoded execution deviation
   * `request.deviation` now supplied by `CConfig`
   * Runtime configuration centralized

4. ✅ **Task 4 — Engine Runtime Corrections**

   * Fixed sub-module context propagation
   * Corrected `Snapshot.IsReady` gating
   * Eliminated runtime initialization defects

### Validation Results

```text
Initial Balance:  $1,000.00
Final Balance:    $1,140.50
Trades:           550
Instrument:       GOLD.c
Timeframe:        H1
```

### Build Verification

```text
Compilation:
0 Errors
0 Warnings

Compile Time:
1750 ms
```

### Sprint Outcome

Sprint 009 completed the transition from a framework capable of placing trades to one capable of managing production-quality execution with improved trade validation, centralized execution responsibilities, configurable broker parameters, and verified runtime stability.

---

# Phase 5 — Trade Quality and Logging

## Sprint 010 — Trade History, Logging and Framework Cleanup

**Status:** ✅ Completed

### Objectives

1. ✅ Trade history logging integrated into `TradeExecutor.mqh`
2. ✅ Standardized success and failure logging through `CLogger`
3. ✅ Full `SLogRecord` population for execution events
4. ✅ Project version updated to **2.0.0-alpha.9**
5. ✅ Repository-wide documentation synchronization
6. ✅ Sprint 011 testing scope finalized

### Deliverables

* `TradeExecutor.mqh`
* `Logger.mqh`
* `DefaultLogFormatter.mqh`
* Updated project versioning
* Documentation synchronization

### Outcome

The execution layer now records complete trade lifecycle events using the framework logging system. Logging is no longer considered a pending feature of the Trading layer.

---

# Phase 6 — Testing Layer

## Sprint 011 — Integration Testing

**Status:** ✅ Completed

### Objectives

1. ✅ Review existing testing framework
2. ✅ Verify Engine initialization
3. ✅ Verify `CMarketSnapshot` readiness
4. ✅ Verify Risk calculations
5. ✅ Verify framework lifecycle
6. ✅ Confirm compile stability

### Test Coverage

```
Tests/
└── Integration/
    ├── TestEngineInit.mq5
    ├── TestSnapshotReady.mq5
    └── TestRiskCalculation.mq5
```

### Results

* Engine initialization verified
* Module lifecycle verified
* Snapshot readiness verified
* Risk calculations verified
* Compile verification completed
* No architecture changes required

### Outcome

The complete Engine pipeline — from initialization through shutdown — has been verified using the framework testing infrastructure.

---

# Phase 7 — Market Data Layer

## Sprint 012 — MarketData Layer

**Status:** ✅ Completed
**ADR:** ADR-016

### Objectives

1. ✅ Task 1 — `CMarketSnapshot.DataReady` field added — compile verified
2. ✅ Task 2 — `CMarketDataProvider` built — owns all handles (`iMA` x2, `iATR`, `iADX`) — 0 errors, 0 warnings, 36 ms
3. ✅ Task 3 — Indicators refactored — handles removed, read from snapshot — all 4 compile clean
4. ✅ Task 4 — `Engine.mqh` updated — `SetMarketData()` + Step 0 pipeline
5. ✅ Task 5 — Full stack: 0 errors, 0 warnings; backtest $1,000 → $1,157.69, Snapshot.IsReady YES, trades confirmed
6. ✅ Task 6 — Documentation updated

### Outcome

`CMarketDataProvider` introduced as Step 0 in the engine pipeline. All MT5 handle ownership and `CopyBuffer` calls centralized in the MarketData layer. Indicators now read exclusively from `CMarketSnapshot`.

---

# Phase 8 — Production Hardening

## Sprint 013 — Testing Expansion (MarketData + Full Pipeline)

**Status:** ✅ Completed
**Version:** 2.0.0-alpha.13
**Date:** July 2026

### Objectives

1. ✅ Task 1 — `Tests/Integration/TestMarketDataProvider.mq5`
   * 7/7 assertions PASS
   * Verified DataReady → IsReady gating contract
   * 7,177,828 ticks processed, 0 violations

2. ✅ Task 2 — `Tests/Integration/TestIndicatorPipeline.mq5`
   * 9/9 assertions PASS
   * Verified ADR-016 refactor: all three indicators read from snapshot only
   * IsReady gates correctly on DataReady across 7,177,828 ticks

3. ✅ Task 3 — `Tests/Integration/TestSignalEvaluation.mq5`
   * 7/7 assertions PASS
   * Verified `CBreakoutSignal` deterministic BUY/SELL evaluation
   * Verified IsReady gating — zero violations across 7,177,828 ticks

4. ✅ Task 4 — `Tests/Integration/TestFullPipeline.mq5`
   * 8/8 assertions PASS
   * Integration capstone: full composition root wired
   * Pipeline ordering contract (ADR-015 + ADR-016) verified end to end
   * 7,177,828 ticks processed, 0 gating violations

### Results

* Total assertions: 31/31 PASS — 0 failures
* Baseline balance: $1,157.69 held across all four tests — no regression
* Testing Layer coverage: ~85%

### Sprint Outcome

Sprint 013 closed the test coverage gap introduced by Sprint 012. Every module in the MarketData layer and the full engine pipeline now has verified integration test coverage. The ADR-015 and ADR-016 ordering contracts are provably correct across millions of ticks.

---

# Phase 9b — Advanced Strategy Infrastructure

**Status:** 🔲 Next — Sprint 014
**Blocked by:** ADR-017 must be written and approved before implementation begins.

## Prerequisite: ADR-017

Before any Phase 9b module is implemented, ADR-017 must be recorded in `DECISIONS.md`.

ADR-017 covers:

* Grid and Basket Management architecture
* `CBasketManager` ownership and responsibilities
* `CGridRisk` relationship to `CRiskBase`
* Floating Profit Engine design
* `Analysis/` layer introduction and dependency rules
* `SRDetector` snapshot interaction model (CMarketSnapshot extension vs dedicated CAnalysisSnapshot)
* BollingerBands handle ownership model (CMarketDataProvider extended)

---

## Sprint 014 — Indicators Expansion + Analysis Layer

**Status:** 🔲 Planned

### Objectives

1. **Task 1 — `BollingerBands.mqh`**

   * Layer: `Include/Indicators/`
   * Reads from `CMarketSnapshot` — no direct MT5 API calls
   * `CMarketDataProvider` extended to own the Bollinger Bands handle
   * `CMarketSnapshot` extended with BB fields: `BBUpper`, `BBMiddle`, `BBLower`
   * Follows ADR-016 fully
   * Compile verified, 0 errors, 0 warnings

2. **Task 2 — `SRDetector.mqh`**

   * Layer: `Include/Analysis/` — new layer
   * Detects dynamic support and resistance levels
   * Reads from `CMarketSnapshot`
   * Writes to snapshot extension or dedicated `CAnalysisSnapshot` per ADR-017
   * Registered in engine as Step 1.5 (after Indicators, before Signals)
   * Compile verified, 0 errors, 0 warnings

3. **Task 3 — Engine Integration**

   * `CEngine` extended with `SetAnalysis()` setter
   * Step 1.5 added to fixed pipeline between `UpdateIndicators()` and `EvaluateSignal()`
   * Pipeline ordering contract updated per ADR-015 extension

4. **Task 4 — Integration Tests**

   * `TestBollingerBands.mq5`
   * `TestSRDetector.mq5`
   * All assertions PASS
   * No regression on baseline $1,157.69

### Definition of Done

* BollingerBands compiles, integrates, test passes
* SRDetector compiles, integrates, test passes
* Engine pipeline extended and verified
* ADR-017 recorded and synchronized
* Documentation updated

---

## Sprint 015 — Grid and Basket Management

**Status:** 🔲 Planned — depends on Sprint 014

### Objectives

1. **Task 1 — `CBasketManager.mqh`**

   * Layer: `Include/Trading/`
   * Owns: active basket lot counts, opposing basket awareness, `CurrentGridCount`, basket open/close lifecycle
   * Exposes: `CurrentGridCount()`, `ActiveBasketLots()`, `BasketID()`, `FloatingPnL()`
   * Executes: CPO (Close Profitable Order) protocol when floating profit target is breached
   * Express Close (EC) logic for basket-level position unwind
   * Derives from `CModule`
   * Injected into `CEngine` via `SetBasketManager()`

2. **Task 2 — `CGridRisk.mqh`**

   * Layer: `Include/Risk/`
   * Extends `CRiskBase`
   * Owns: `AddLot` calculation mechanics relative to opposing basket sizing
   * Owns: grid step spacing logic
   * Returns grid-aware position sizing to `CEngine`

3. **Task 3 — Floating Profit Engine**

   * Implemented inside `CBasketManager`
   * Calculates combined basket PnL across all open positions in the basket
   * Triggers CPO when floating profit threshold is breached
   * Tracks both BUY basket and SELL basket simultaneously
   * Color-coded threshold lines integration point reserved for future UI layer

4. **Task 4 — Engine Integration**

   * `CEngine` extended with `SetBasketManager()` and `SetGridRisk()` setters
   * Basket update step added to engine pipeline as Step 5 (after Execution)
   * Pipeline: MarketData → Indicators → Analysis → Signal → Risk → Execution → Basket Update

5. **Task 5 — Integration Tests**

   * `TestBasketManager.mq5`
   * `TestGridRisk.mq5`
   * `TestFloatingProfitEngine.mq5`
   * All assertions PASS
   * No regression on baseline

### Definition of Done

* `CBasketManager` compiles, integrates, test passes
* `CGridRisk` compiles, integrates, test passes
* Floating Profit Engine verified
* Engine pipeline extended and verified
* Documentation updated

---

## Phase 9b Exit Criteria

Phase 10 may not begin until all of the following are satisfied:

* ✅ ADR-017 recorded
* ✅ `BollingerBands.mqh` complete and tested
* ✅ `SRDetector.mqh` complete and tested
* ✅ `CBasketManager.mqh` complete and tested
* ✅ `CGridRisk.mqh` complete and tested
* ✅ Floating Profit Engine complete and tested
* ✅ Engine pipeline updated and all integration tests passing
* ✅ Documentation synchronized

---

# Phase 10 — AI Data Collection

**Status:** 📋 Planned — blocked on Phase 9b completion

## Sprint 016 — AITradeLogger and AITradeRecord

### Prerequisite

Phase 9b must be fully complete. `CBasketManager` must be operational and exposing `BasketID`, `CurrentGridCount`, `ActiveBasketLots`, and `FloatingPnL` before this sprint begins.

### Objectives

1. **Task 1 — `AITradeRecord` structure**

   Per-order record written at order close:

   | Field | Description |
   |---|---|
   | `Timestamp` | Bar open time at order entry |
   | `Symbol` | Instrument |
   | `Direction` | BUY or SELL |
   | `EntryPrice` | Order open price |
   | `FastEMA` | Snapshot value at entry |
   | `SlowEMA` | Snapshot value at entry |
   | `ATR` | Snapshot value at entry |
   | `ADX` | Snapshot value at entry |
   | `BBUpper` | Bollinger Band upper at entry |
   | `BBMiddle` | Bollinger Band middle at entry |
   | `BBLower` | Bollinger Band lower at entry |
   | `SRProximity` | Distance from nearest S/R level at entry |
   | `CurrentGridCount` | Active grid order count at entry |
   | `ActiveBasketLots` | Total basket lot size at entry |
   | `BasketID` | Links order to its basket |
   | `OrderPnL` | This order's closed PnL |
   | `BasketOutcome` | Total basket PnL — filled at basket closure |
   | `BasketContribution` | This order's share of basket result |

   Note: `Outcome` (per-order binary WIN/LOSS) is removed. The correct training signal is basket-level.

2. **Task 2 — `AITradeLogger.mqh`**

   * Layer: `Include/AI/`
   * Writes `AITradeRecord` to CSV on each order close
   * Reads basket state from `CBasketManager` at close time
   * Reads snapshot state from `CMarketSnapshot` at entry time (cached)
   * Registered in engine pipeline after Execution stage

3. **Task 3 — Engine Integration**

   * `CEngine` extended with `SetAILogger()` setter
   * Logger step added after Execution stage

4. **Task 4 — Integration Tests**

   * `TestAITradeLogger.mq5`
   * Verify CSV output structure
   * Verify basket linkage correctness
   * Verify no regression

---

# Phase 11 — AI Training Pipeline

**Status:** 📋 Planned — blocked on Phase 10 completion

Modules:

* Feature normalization
* Label generation from `BasketContribution`
* Model training pipeline (offline Python or MQL5 ONNX)
* Model export to ONNX format
* ONNX model import into MQL5 framework

Training target: given indicator features at entry, predict whether this order will contribute positively to its basket outcome.

---

# Phase 12 — AI Execution Layer

**Status:** 📋 Planned — blocked on Phase 11 completion

## Stage 1 — Binary Veto (initial deployment)

* AI model loaded via ONNX
* At signal evaluation time, model scores the proposed trade
* Low-confidence trades are vetoed — execution blocked
* High-confidence trades proceed normally
* Veto threshold configurable via `CConfig`

## Stage 2 — Confidence-Weighted Lot Sizing (evolution)

* Binary veto replaced by confidence multiplier
* High confidence → increase `AddLot` multiplier → larger position
* Low confidence → reduce `AddLot` multiplier → smaller position or skip
* Integrates with `CGridRisk` via multiplier parameter
* Applies independently to BUY basket and SELL basket

Prerequisite for Stage 2: Stage 1 must prove model accuracy over a statistically significant forward-test period before confidence weighting is enabled.

---

# Phase 13 — Optimization

**Status:** 📋 Planned — blocked on Phase 12 completion

Modules:

* Parameter Optimization
* Walk-Forward Analysis
* Monte Carlo Simulation
* Portfolio Optimization
* Performance Analytics
* Robustness Validation

These tasks begin only after the complete AI-augmented trading framework reaches functional stability.

---

# Phase 14 — Production Release

**Target Version:** `2.0.0`

## Release Requirements

Before production release, the project must satisfy all of the following:

* All planned framework modules completed
* Full documentation synchronized
* Stable architecture
* Zero known critical defects
* Zero compilation errors
* Zero compilation warnings
* Complete integration test suite
* Successful long-term forward testing
* Successful walk-forward validation
* Successful Monte Carlo validation
* Production-ready codebase

---

# Current Project Status

**Current Version:** `2.0.0-alpha.13`

**Current Sprint:** Sprint 014

**Current Phase:** Phase 9b — Advanced Strategy Infrastructure

**Current Priority:** Write ADR-017, then begin Sprint 014 (BollingerBands + SRDetector)

**Immediate Blocker:** ADR-017 must be approved before any Phase 9b code is written.

Documentation must continue to remain synchronized with implementation after every completed sprint.

---

# Updated Engine Pipeline (Post Phase 9b)

```text
0. Update MarketData          (CMarketDataProvider)
         │
         ▼
1. Update Indicators          (EMA, ATR, ADX, BollingerBands)
         │
         ▼
1.5 Update Analysis           (SRDetector)          [Phase 9b]
         │
         ▼
2. Evaluate Signal            (CBreakoutSignal)
         │
         ▼
3. Evaluate Risk              (CRiskManager + CGridRisk)
         │
         ▼
4. Execute Trade              (CTradeExecutor)
         │
         ▼
5. Update Basket              (CBasketManager)       [Phase 9b]
         │
         ▼
6. Log AI Record              (CAITradeLogger)       [Phase 10]
```

---

# Long-Term Development Roadmap

Following completion of the current framework, future development will expand into:

* Artificial Intelligence
* Machine Learning integration
* Portfolio optimization
* Institutional-grade execution
* Advanced risk analytics
* Cross-market trading support
* Distributed optimization
* Cloud-assisted testing

These initiatives build upon the stable modular architecture established during the Alpha development cycle.

---

# Definition of Done

A sprint is considered complete only when:

* Production-quality source code is implemented
* Project compiles successfully
* Zero compilation errors
* Zero compilation warnings
* Documentation is fully synchronized
* Architecture remains consistent
* Integration verified
* Tests completed where applicable
* Repository committed to GitHub
* Repository remains in a stable state

---

# Guiding Principle

The objective of AI Swing Breakout Pro is not simply to create another Expert Advisor.

The objective is to build a professional, modular, maintainable trading framework capable of evolving over many years without sacrificing architectural quality, code reliability, or documentation accuracy.

Every sprint should improve both the implementation and the long-term maintainability of the framework.

The architecture is treated as a long-term asset, and every engineering decision should preserve its clarity, modularity, and production readiness.