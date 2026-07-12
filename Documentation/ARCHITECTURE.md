# AI Swing Breakout Pro Framework

# ARCHITECTURE

**Version:** 2.0.0-alpha.13
**Status:** Active Development
**Last Updated:** July 12, 2026

---

# Purpose

This document defines the high-level architecture of the AI Swing Breakout Pro framework.

It describes the framework layers, subsystem responsibilities, dependency rules, lifecycle, and communication boundaries.

Implementation details belong in the source code.

Architectural decisions belong in `DECISIONS.md`.

This document describes **how the framework is organized**.

---

# Architecture Principles

The framework follows several core principles.

* Layered architecture
* Single responsibility
* Dependency inversion
* Composition over inheritance
* Non-owning service references
* Deterministic execution pipeline
* Documentation-first development

Every module has a clearly defined responsibility.

Dependencies always point downward.

No circular dependencies are permitted.

---

# High-Level Architecture

```text
+---------------------------------------------------------+
|              AI_SwingBreakout_Pro.mq5                   |
|             (Composition Root / EA)                     |
+-------------------------------+-------------------------+
                                |
                                v
+---------------------------------------------------------+
|                        Framework                        |
|              CContext / CModule / CModuleManager        |
|                          CEngine                        |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                       MarketData                        |
|                   CMarketDataProvider                   |
|              (owns all MT5 handles + CopyBuffer)        |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                       Indicators                        |
|         CEMAIndicator / CATRIndicator / CADXIndicator   |
|                CBollingerBands [Phase 9b]               |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                    Analysis [NEW — Phase 9b]            |
|                        CSRDetector                      |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                        Signals                          |
|                     CBreakoutSignal                     |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                         Risk                            |
|                      CRiskManager                       |
|                   CGridRisk [Phase 9b]                  |
+---------------------------------------------------------+
                                |
                                v
+---------------------------------------------------------+
|                        Trading                          |
|    CTradeExecutor / CPositionTracker / CTradeResult     |
|          CBasketManager [Phase 9b]                      |
+---------------------------------------------------------+
```

---

# Layer Responsibilities

## Composition Root

The Expert Advisor (`AI_SwingBreakout_Pro.mq5`) is the composition root.

Responsibilities include:

* Creating framework objects
* Constructing modules
* Wiring dependencies
* Injecting shared services
* Registering modules
* Driving lifecycle events
* Receiving MetaTrader events

The composition root owns object lifetimes.

Framework modules do not create each other.

---

## Framework Layer

The Framework layer coordinates the entire application.

Primary components:

* `CContext`
* `CModule`
* `CModuleManager`
* `CEngine`

The Framework layer contains orchestration logic only.

It does not contain trading strategy logic.

---

## CContext

`CContext` provides shared framework services.

Current shared services:

* `CPlatform`
* `CLogger`
* `CErrorHandler`
* `CMarketSnapshot`
* `CAnalysisSnapshot` [Phase 9b]

`CContext` is non-owning.

It stores references to shared services but does not allocate or destroy them.

Modules receive access to shared services through `CContext`.

---

## CModule

`CModule` is the abstract base class for all framework modules.

Responsibilities:

* Standardized initialization
* Standardized shutdown
* Context validation
* Shared service access
* Module identification

Every Trading, Indicator, Signal, Risk, Analysis, and future framework module derives from `CModule`.

---

## CModuleManager

`CModuleManager` coordinates framework lifecycle.

Responsibilities:

* Register modules
* Initialize modules
* Shutdown modules
* Drive update cycle

`CModuleManager` does **not** own registered modules.

Ownership remains with the composition root.

This avoids hidden ownership rules and keeps object lifetime deterministic.

---

## Framework Layer (Detailed)

The Framework layer coordinates all high-level application logic.

Unlike Core, it does not implement trading algorithms or platform abstractions.

Instead, it provides lifecycle management, dependency injection, and orchestration for all modules.

```
Framework
│
├── CContext
├── CModule
├── CModuleManager
└── CEngine
```

### Responsibilities

* Dependency injection
* Module lifecycle
* Shared service access
* Engine orchestration
* Cross-layer coordination

The Framework layer depends only on Core and the feature layers beneath it.

---

## CContext (Detailed)

`CContext` is the shared service container.

It owns no services.

Instead, it stores non-owning pointers to shared framework services that are created elsewhere.

```
CPlatform
CLogger
CErrorHandler
```

It also owns the shared market snapshot buffer.

```
CMarketSnapshot
CAnalysisSnapshot [Phase 9b]
```

This object exists exactly once for the lifetime of the engine.

Modules receive access through:

```cpp
Context()
```

instead of holding direct references to every subsystem.

### Responsibilities

* Share Platform
* Share Logger
* Share Error Handler
* Share Market Snapshot
* Share Analysis Snapshot [Phase 9b]
* Validate required services

### Ownership

```
Composition Root
        │
        ▼
Creates Services
        │
        ▼
CContext
        │
        ▼
Shares Non-owning Pointers
```

No service lifetime is managed by `CContext`.

---

## CMarketSnapshot

The market snapshot is the communication boundary between MarketData, Indicators, and downstream consumers.

MarketData providers populate it every update cycle.

Indicators read from it and may derive additional fields.

Signal, Analysis, Risk, and Trading modules read from it.

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
* DataReady
* IsReady

The snapshot exists by value inside `CContext`.

No heap allocation is required.

MarketData providers receive a writable pointer.

Indicators and downstream modules access it through the shared context.

### Readiness Contract

MarketData providers are responsible for setting:

```
DataReady = true;
```

after all `CopyBuffer()` calls succeed.

Indicators are responsible for setting:

```
IsReady = true;
```

only after every required field has been calculated.

Consumers must always verify:

```
IsReady == true
```

before using snapshot values for trading decisions.

This allows indicator warm-up without generating false engine failures.

---

## CAnalysisSnapshot [Phase 9b]

The analysis snapshot is a dedicated communication boundary for derived analysis outputs.

It sits alongside `CMarketSnapshot` in `CContext`.

`SRDetector` populates it every update cycle.

Signal modules read from it to incorporate support/resistance levels into trade decisions.

Current planned fields include:

* SupportLevel
* ResistanceLevel
* SupportStrength
* ResistanceStrength
* TrendBias

Additional analysis outputs can be added without modifying `CMarketSnapshot`.

This separation preserves the single responsibility of each snapshot type.

### Readiness Contract

`SRDetector` sets:

```
IsReady = true;
```

only after all analysis calculations complete successfully.

Signal modules must verify:

```
CAnalysisSnapshot.IsReady == true
```

before consuming analysis fields.

---

## CModule (Detailed)

Every executable subsystem derives from `CModule`.

Examples include:

* CEngine
* CMarketDataProvider
* CEMAIndicator
* CATRIndicator
* CADXIndicator
* CBollingerBands [Phase 9b]
* CSRDetector [Phase 9b]
* CBreakoutSignal
* CRiskManager
* CGridRisk [Phase 9b]
* CTradeExecutor
* CPositionTracker
* CBasketManager [Phase 9b]

`CModule` provides:

* Initialize(CContext*)
* Shutdown()
* Context()
* Name()
* IsInitialized()

All derived modules inherit the same initialization contract.

This standardization prevents lifecycle inconsistencies across the framework.

---

## CModuleManager (Detailed)

`CModuleManager` coordinates module lifecycle.

Responsibilities include:

* Register modules
* Initialize modules
* Shutdown modules

The manager stores non-owning pointers.

It never deletes registered modules.

Ownership remains with the composition root.

This ensures a single ownership model throughout the framework.

---

## CEngine (Detailed)

`CEngine` is the top-level orchestration module.

It coordinates:

```
MarketData
      ↓
Indicators
      ↓
Analysis [Phase 9b]
      ↓
Signals
      ↓
Risk
      ↓
Trading
      ↓
Basket [Phase 9b]
```

`CEngine` owns no feature modules.

Instead it stores non-owning pointers supplied during application startup.

Current dependencies include:

* CMarketDataProvider
* CEMAIndicator
* CATRIndicator
* CADXIndicator
* CBreakoutSignal
* CRiskManager
* CTradeExecutor
* CPositionTracker

Phase 9b dependencies will include:

* CBollingerBands
* CSRDetector
* CGridRisk
* CBasketManager

These dependencies are injected before initialization.

This keeps construction deterministic and avoids partially configured modules.

---

# Engine Orchestration Pipeline

`CEngine` is the central orchestration module of the framework.

It coordinates the execution of feature modules but does **not** implement trading logic itself.

Its responsibilities are limited to:

* Updating MarketData
* Updating Indicators
* Updating Analysis [Phase 9b]
* Invoking Signal evaluation
* Invoking Risk evaluation
* Coordinating Trade execution
* Coordinating Basket updates [Phase 9b]
* Maintaining deterministic execution order

The engine never performs indicator calculations directly.

Likewise, it never generates trading signals or calculates position sizing.

Those responsibilities remain inside their dedicated modules.

---

## Dependency Injection

Before initialization, the composition root injects all feature modules into `CEngine`.

Current injected modules:

```text
MarketData
└── CMarketDataProvider

Indicators
├── CEMAIndicator
├── CATRIndicator
└── CADXIndicator

Signal
└── CBreakoutSignal

Risk
└── CRiskManager

Trading
├── CTradeExecutor
└── CPositionTracker
```

Phase 9b injected modules:

```text
Indicators
└── CBollingerBands        [Phase 9b]

Analysis
└── CSRDetector            [Phase 9b]

Risk
└── CGridRisk              [Phase 9b]

Trading
└── CBasketManager         [Phase 9b]
```

Injection occurs through dedicated setter methods.

```cpp
void SetMarketDataProvider(CMarketDataProvider*);
void SetIndicators(...);
void SetAnalysis(CSRDetector*);        [Phase 9b]
void SetSignal(...);
void SetRisk(...);
void SetTrading(...);
void SetBasketManager(CBasketManager*); [Phase 9b]
```

`CEngine` stores **non-owning pointers** only.

The composition root retains ownership of every injected object.

This guarantees a single ownership model throughout the framework.

---

## Engine Update Pipeline

Every engine cycle executes in one fixed order.

```text
CEngine::Update()
        │
        ▼
0. Update MarketData
        │
        ▼
1. Update Indicators
        │
        ▼
1.5 Update Analysis         [Phase 9b]
        │
        ▼
2. Evaluate Signal
        │
        ▼
3. Evaluate Risk
        │
        ▼
4. Execute Trade
        │
        ▼
5. Update Basket            [Phase 9b]
```

This execution order is fixed.

Modules must never bypass or reorder the pipeline.

Future extensions insert new functionality into the appropriate stage without changing the overall flow.

---

## MarketData Update Stage

The MarketData stage executes first.

Current module:

* CMarketDataProvider

The provider owns all MT5 indicator handles (iMA x2, iATR, iADX, and future handles).

It executes all `CopyBuffer()` calls each tick.

It writes derived values into `CMarketSnapshot`.

It sets `DataReady = true` on full success.

It resets `IsReady = false` at the start of each tick.

No downstream module executes until `DataReady` is confirmed.

---

## Indicator Update Stage

The indicator stage executes after MarketData.

Current indicator modules:

* CEMAIndicator
* CATRIndicator
* CADXIndicator

Phase 9b additions:

* CBollingerBands

Each indicator reads from the shared `CMarketSnapshot`.

Each indicator derives its values and writes additional fields back to the snapshot.

Indicators execute independently.

Failure of one indicator does **not** prevent the remaining indicators from updating.

This is intentionally a **best-effort** stage.

Indicators commonly require historical bars during startup.

That temporary condition is not considered an engine failure.

---

## Analysis Update Stage [Phase 9b]

The Analysis stage executes after indicators.

Module:

* CSRDetector

Responsibility:

* Detects dynamic support and resistance levels
* Uses recent price action and/or Bollinger Bands
* Writes results to `CAnalysisSnapshot`
* Sets `CAnalysisSnapshot.IsReady = true` on completion

The Analysis layer sits between Indicators and Signals.

It consumes indicator outputs and produces derived spatial geometry.

Signal modules consume analysis outputs to improve trade decisions.

---

## Snapshot Communication Boundaries

### MarketData → Indicators → Analysis → Signals → Risk → Trading

Indicators communicate exclusively through the shared market snapshot.

Analysis communicates through the dedicated analysis snapshot.

```text
MarketData
      │
      ▼
CMarketSnapshot (DataReady)
      │
      ▼
Indicators
      │
      ▼
CMarketSnapshot (IsReady)
      │
      ▼
Analysis [Phase 9b]
      │
      ▼
CAnalysisSnapshot (IsReady)
      │
      ▼
Signal
      │
      ▼
Risk
      │
      ▼
Trading
```

No module communicates directly with modules in adjacent layers.

All cross-layer communication flows through snapshots.

This keeps subsystem coupling low while providing deterministic data flow.

---

## Snapshot Readiness Contract

`CMarketSnapshot` owns the DataReady and IsReady state.

MarketData sets `DataReady = true` after all `CopyBuffer()` calls succeed.

Indicators set `IsReady = true` after every required field has been calculated.

`CAnalysisSnapshot` owns its own IsReady state.

`SRDetector` sets `IsReady = true` after all analysis calculations complete.

Until then:

```cpp
DataReady == false   // MarketData not ready
IsReady == false     // Indicators not ready
CAnalysisSnapshot.IsReady == false   // Analysis not ready
```

Signal, Risk, and Trading modules must always verify snapshot readiness before consuming market data.

Startup synchronization therefore occurs naturally without special engine logic.

The engine itself does not determine whether indicator data is complete.

That responsibility belongs to the snapshot contracts.

---

## Signal Evaluation

After indicator updates complete, the engine evaluates trading signals.

Responsibilities of the Signal layer include:

* Reading `CMarketSnapshot`
* Reading `CAnalysisSnapshot` [Phase 9b]
* Validating snapshot readiness
* Detecting breakout conditions
* Incorporating support/resistance levels
* Producing trading intent

If signal evaluation fails:

```text
EvaluateSignal() == false
```

the engine terminates the current update cycle.

Execution does not continue.

Unlike indicator updates, Signal evaluation is **not** best-effort.

---

## Risk Evaluation

Risk evaluation executes only after a successful Signal evaluation.

Responsibilities include:

* Position sizing
* Risk validation
* Exposure control
* Capital protection
* Trade approval

Phase 9b additions:

* Grid-aware risk calculation via `CGridRisk`
* AddLot mechanics
* Opposing basket lot ratios

If:

```text
EvaluateRisk() == false
```

the update cycle terminates.

Execution is skipped.

This guarantees that no trade proceeds without successful risk validation.

---

## Execution Stage

The execution stage executes approved trades.

Responsibilities include:

* Order creation
* Position management
* Broker execution
* Trade monitoring
* Defensive position protection

Current implementation:

* `CTradeExecutor::Execute()` executes market orders
* `CPositionTracker` provides position existence checks
*  Dual-layer guard architecture (primary filter + defensive assertion)

---

## Basket Update Stage [Phase 9b]

The basket update stage executes after trade execution.

Module:

* CBasketManager

Responsibilities include:

* Tracking active basket lot counts
* Tracking opposing basket awareness
* Updating CurrentGridCount
* Calculating combined basket PnL
* Executing CPO protocol when floating profit targets are breached

CPO variables tracked:

* FLProfitTarget — target floating profit for basket closure
* FLProfitTrailing — trailing threshold for floating profit management

The basket stage runs every tick.

It checks whether floating profit has breached the configured target.

If so, it executes CPO by closing all profitable orders in the basket.

This happens atomically through `CTradeExecutor`.

---

## Pipeline Characteristics

The orchestration pipeline follows these rules:

* Deterministic execution order.
* MarketData updates before all downstream modules.
* Indicator updates are best-effort.
* Analysis [Phase 9b] updates after indicators.
* Signal evaluation is mandatory.
* Risk evaluation is mandatory.
* Execution occurs only after successful Risk evaluation.
* Basket updates [Phase 9b] occur after execution.
* All market data flows through `CMarketSnapshot`.
- All analysis data flows through `CAnalysisSnapshot` [Phase 9b].
* `CEngine` coordinates modules but does not own them.
- Object ownership remains exclusively with the composition root.

These rules establish the permanent orchestration contract defined by ADR-015, ADR-016, and ADR-017.

---

# Current Status

## Documentation Status

| Document           | Status                              |
| ------------------ | ----------------------------------- |
| PROJECT_CONTEXT.md | Up to date                          |
| ARCHITECTURE.md    | Up to date                          |
| DECISIONS.md       | Up to date (ADR-017)                |
| ROADMAP.md         | Pending Sprint alignment            |
| CHANGELOG.md       | Pending latest implementation entry |
| CODING_STANDARD.md | Current                             |

---

# Current Framework Progress

## Completed

* Core foundation
* Platform abstraction
* Error subsystem
* Logging subsystem
* Framework layer
* Context system
* Module system
* Module manager
* Engine orchestration
* Market snapshot
* MarketData layer (ADR-016)
* EMA indicator
* ATR indicator
* ADX indicator
* Breakout signal
*  Risk manager
*  Trade executor
*  Position tracker
*  Integration testing (85%)

---

## In Progress [Phase 9b]

* BollingerBands indicator
*  SRDetector analysis module
*  CBasketManager basket management
*  CGridRisk grid-aware risk calculation
*  Floating Profit Engine & CPO protocol

---

## Planned

### Indicators

* BollingerBands [Phase 9b]
*  Additional indicators (RSI, MACD, Volume profile, VWAP) — future phases

### Analysis Layer [Phase 9b]

* SRDetector — dynamic support/resistance detection
*  Additional analysis modules (pivot points, trend lines) — future phases

### Risk

* CGridRisk — grid-aware risk calculation [Phase 9b]
*  Daily loss limits
*  Exposure limits
*  Portfolio risk

### Trading

* CBasketManager — grid and basket lifecycle management [Phase 9b]
* Floating Profit Engine — CPO protocol [Phase 9b]
*  Partial close
*  Break-even
*  Trailing stop

### AI Layer [Phase 10]

* AITradeLogger — basket-aware logging
* BasketContribution — per-order contribution to basket PnL
*  Machine-learning integration

---

# Architectural Principles

The framework follows these long-term principles:

* Layered architecture
* One-way dependencies
* Composition over inheritance where practical
* Constructor-based immutable configuration
* Dependency injection through `CContext`
* Shared market state through `CMarketSnapshot`
* Shared analysis state through `CAnalysisSnapshot` [Phase 9b]
* Best-effort indicator updates
* Explicit readiness checks (`DataReady`, `IsReady`)
* Non-owning object relationships
* Production-quality implementations only

These principles are governed by the project's Architecture Decision Records (ADRs) and evolve only through new ADRs.

---

# Future Architecture

Planned architectural expansion includes:

* Analysis layer [Phase 9b]
* Basket management [Phase 9b]
* Grid risk calculation [Phase 9b]
* AI decision layer [Phase 10]
* AI data collection and logging [Phase 10]
* Machine-learning integration [Phase 10]
* Portfolio management
* Multi-symbol engine
* Event system
* Scheduler
* Strategy plug-in framework
* Performance profiler
* Backtesting optimization framework

These additions will extend the current layered architecture without violating the dependency rules established by ADR-003, ADR-012, ADR-013, ADR-014, ADR-015, ADR-016, and ADR-017.

---

# Summary

The framework has now progressed beyond a collection of independent modules into a coordinated execution architecture.

`CEngine` serves as the orchestration layer, coordinating MarketData, Indicators, Analysis [Phase 9b], Signal evaluation, Risk evaluation, Execution, and Basket updates [Phase 9b] through a deterministic pipeline. Shared runtime state is centralized in `CContext`, while `CMarketSnapshot` provides a single source of market data and `CAnalysisSnapshot` [Phase 9b] provides derived analysis outputs for downstream modules.

With ADR-015, ADR-016, and ADR-017 complete, the architecture establishes a stable foundation for implementing the remaining trading functionality, grid/basket management, and AI data collection while preserving clear module boundaries, predictable lifecycle management, and long-term maintainability.

---

**End of Document**
```

---

**All updates applied:**

| Update | Section | Action |
|--------|---------|--------|
| 1 | Document Header | Version changed to `2.0.0-alpha.13`, date updated to `July 12, 2026` |
| 2 | High-Level Architecture | Replaced diagram with MarketData and Analysis layers |
| 3 | Engine Update Pipeline | Added Step 1.5 (Update Analysis) and Step 5 (Update Basket); removed phantom "Populate" step |
| 4 | Planned Sections | Added BollingerBands, SRDetector, Analysis layer, CBasketManager, CGridRisk, Floating Profit Engine |
| 5 | Additional updates | Added `CAnalysisSnapshot` to CContext, updated all references to Phase 9b, updated ADR list to include ADR-017 |