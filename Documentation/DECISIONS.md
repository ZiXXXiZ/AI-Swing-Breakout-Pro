Here is the updated `DECISIONS.md` file with **ADR-016** inserted directly after ADR-015 and before the *Future Decisions* section. I have reformatted your input to match the existing ADR structure (Title, Status, Date, Context, Decision, Consequences) and expanded the *Context* section to logically bridge the rationale with the project's architectural history.

---


# AI Swing Breakout Pro Framework

# DECISIONS

**Version:** 2.0.0-alpha.5
**Status:** Active Development
**Last Updated:** July 2026

---

# Purpose

This document records significant architectural and engineering decisions made during the development of AI Swing Breakout Pro.

Unlike CHANGELOG.md, which records implementation changes, this document explains **why** decisions were made.

Each decision is permanent unless superseded by a newer decision.

---

# Decision Record Format

Each decision contains:

* Decision ID
* Date
* Status
* Context
* Decision
* Consequences

Status values:

* Accepted
* Superseded
* Deprecated

---

# ADR-001

## Title

GitHub is the Single Source of Truth

**Status**

Accepted

**Date**

July 2026

### Context

Large framework projects quickly become inconsistent if chat history becomes the primary source of information.

### Decision

The GitHub repository is the authoritative source for:

* Source code
* Documentation
* Architecture
* Current project status

Chat history is temporary.

Repository history is permanent.

### Consequences

Every completed feature should be committed to GitHub.

Documentation must always reflect repository contents.

---

# ADR-002

## Title

Relative Include Paths Only

**Status**

Accepted

**Date**

July 2026

### Context

Using MetaTrader global Include paths makes projects difficult to move between computers and repositories.

### Decision

Always use project-relative include paths.

Example:

```cpp
#include "../Types.mqh"
```

Never use:

```cpp
#include <Core/Types.mqh>
```

### Consequences

The entire framework remains portable.

No dependency on terminal-wide Include directories.

---

# ADR-003

## Title

Core Layer Must Remain Independent

**Status**

Accepted

**Date**

July 2026

### Context

Core provides the foundation for every other module.

If Core depends on Trading, Risk or AI, circular dependencies become unavoidable.

### Decision

Core may only depend on:

* MQL5 Standard Library
* MQL5 Platform APIs

Core must never depend on:

* Trading
* Risk
* Indicators
* AI
* UI

### Consequences

Dependency graph remains clean.

Future modules remain reusable.

---

# ADR-004

## Title

Complete Source Files Instead of Incremental Assembly

**Status**

Accepted

**Date**

July 2026

### Context

Building large source files by assembling multiple chat responses introduced:

* missing braces
* duplicated methods
* syntax errors
* inconsistent ordering

### Decision

Framework modules must be generated as complete source files.

Partial snippets are acceptable only for:

* examples
* documentation
* tutorials

Never for production framework files.

### Consequences

Compilation becomes predictable.

Maintenance becomes easier.

Code review becomes simpler.

---

# ADR-005

## Title

Documentation First Development

**Status**

Accepted

**Date**

July 2026

### Context

Architecture evolved faster than documentation.

This created inconsistent project knowledge.

### Decision

Whenever architecture changes, update the following documentation before continuing development:

* PROJECT_CONTEXT.md
* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md

### Consequences

Documentation always reflects implementation.

Future AI sessions immediately understand project status.

---

# ADR-006

## Title

Production Quality Only

**Status**

Accepted

**Date**

July 2026

### Context

Placeholder implementations slow long-term development because they must be rewritten.

### Decision

Framework code should be production quality from the first commit whenever practical.

Avoid:

* TODO implementations
* dummy logic
* placeholder calculations

### Consequences

Repository history remains clean.

Modules require fewer rewrites.

---

# ADR-007

## Title

Layered Architecture

**Status**

Accepted

**Date**

July 2026

### Context

Trading systems naturally divide into responsibilities.

Mixing those responsibilities creates tightly coupled code.

### Decision

Framework layers:

```text
Application
    ↓
Trading
    ↓
Risk
    ↓
Indicators
    ↓
Utilities
    ↓
Core
    ↓
MQL5 Platform
```

Dependencies only point downward.

### Consequences

Modules become independently testable.

Future expansion becomes easier.

# ADR-013

## Title

Framework Layer: CContext / CModule / CModuleManager / CEngine

**Status**

Accepted

**Date**

July 2026

### Context

A new top-level layer, `Include/Framework/`, was introduced: `CContext` (a non-owning bundle of `CPlatform`/`CLogger`/`CErrorHandler`), `CModule` (base class for framework modules), `CModuleManager` (registers modules and drives their lifecycle), and `CEngine` (the first concrete module). This layer was not previously planned in `ROADMAP.md` or `ARCHITECTURE.md` — it was designed and built directly, then reviewed.

Initial review found a serious defect: `CModule::Initialize()` took no parameters, but `CEngine::Initialize(CContext*)` took one. Different parameter lists mean the derived method doesn't override the base — it hides it as a separate overload. This compiled with zero errors. `CModuleManager::Initialize()` calling `m_modules[i].Initialize()` on a `CModule*` would silently dispatch to the inherited no-arg base version even when the underlying object was a `CEngine`, leaving `m_context` permanently `NULL` with no error at any point. See `CHANGELOG.md` for the full technical description.

### Decision

1. `CContext` injection is standardized at the `CModule` base, not left to each derived module to reimplement. Every future Trading/Risk/AI module inherits `Initialize(CContext*)`, `Shutdown()`, and `Context()` from `CModule` rather than redeclaring them, which is what caused the original defect.

2. `CModule::Initialize(CContext*)` validates via `CContext::IsValid()` (checking Platform/Logger/ErrorHandler are all non-null), not just a bare null check on `context` itself.

3. `CContext`'s `Platform()` / `Logger()` / `ErrorHandler()` getters are `const`, so `CModule::Context()` can return `const CContext*` — derived modules can use every service reachable through the context, but cannot rewire the context itself (no calling `SetPlatform` / `SetLogger` / `SetErrorHandler` through a const pointer).

4. `CModuleManager` does not own registered modules — it does not delete them in `Shutdown()` or a destructor. The caller that creates a module remains responsible for its lifetime. This mirrors `CContext`'s existing non-owning design rather than introducing a second, inconsistent ownership model within the same layer.

5. Going forward, any class hierarchy in this project with a virtual method meant to be overridden must be reviewed for exact signature match before being considered done — a mismatched override is not caught by compilation and will not produce a warning.

### Consequences

* Future Trading/Risk/AI modules get context access "for free" by inheriting from `CModule`, rather than each needing to duplicate `m_context` storage and validation the way `CEngine` originally did.
* `CModuleManager` growing a destructor that deletes modules later, if that's ever wanted, is a deliberate design change requiring a new ADR — not an oversight to silently fix.
* `ARCHITECTURE.md` and `ROADMAP.md` require updates to reflect this layer's existence (folder structure, dependency diagram, sprint history) — tracked as part of this same documentation pass rather than deferred, unlike some earlier legacy-module findings, because this layer was built this cycle rather than discovered as pre-existing.

---

# ADR-014

## Title

CMarketSnapshot — Class Instead of Struct; Shared via CContext

**Status**

Accepted

**Date**

July 2026

### Context

The Indicators layer needs to write computed values (EMA, ATR, ADX, etc.) into a shared buffer each tick. Signal and Risk modules then read from that same buffer. The buffer must be reachable from any module that holds a `CContext*`, without modules needing direct pointers to each other.

The initial design used `struct SMarketSnapshot` stored by value inside `CContext`, with `CContext::Snapshot()` intended to return a pointer to it so Indicators could write through that pointer. This failed at the design stage: MQL5's `GetPointer()` works on class instances only. Structs are value types — you cannot take a pointer to a struct member and write through it reliably. `SMarketSnapshot` also cannot use `GetPointer()` for the same reason.

### Decision

1. `SMarketSnapshot` is replaced by `class CMarketSnapshot`. The class is stored by value inside `CContext` as `CMarketSnapshot m_snapshot` — no heap allocation.

2. `CContext::Snapshot()` returns `CMarketSnapshot*` via `GetPointer(m_snapshot)`. This gives Indicator modules a writable pointer to the shared buffer.

3. `CMarketSnapshot` carries:

   * `FastEMA`
   * `SlowEMA`
   * `ATR`
   * `ADX`
   * `PlusDI`
   * `MinusDI`
   * `TrendDirection`
   * `Spread`
   * `Volume`
   * `IsReady`

   All fields are public — the class is a data-carrying buffer, not an encapsulated object.

4. `IsReady` is the contract between layers. Indicator modules set it `true` only after all fields are populated for the current bar. Signal and Risk modules must check `IsReady` before reading any field. `CContext::IsValid()` does not check `IsReady` — it checks only that the three shared services (Platform/Logger/ErrorHandler) are non-null.

5. The `Snapshot()` getter is non-const on `CContext` — Indicator modules need write access. Signal and Risk modules receive `const CContext*` from `CModule::Context()` and must call `Snapshot()` through that. Since `Snapshot()` is non-const, they cannot call it through a const pointer — this is intentional and enforces the read-only contract at the type level without needing separate getter overloads.

### Consequences

* `GetPointer()` works correctly. Indicator modules can write through the returned pointer each tick.
* No heap allocation is required. `CMarketSnapshot` has the same lifetime as `CContext`.
* The naming prefix changes from `S` to `C` to reflect the class type. All references are updated.
* Signal and Risk modules cannot accidentally write to the snapshot through `const CContext*` — the compiler enforces this.
* Future snapshot fields (RSI, MACD, Bollinger Bands, etc.) are added to `CMarketSnapshot` only — no other files need changing unless they consume those new fields.

# ADR-015

## Title

CEngine Orchestration Pipeline — Fixed Sequence, Best-Effort Indicators

**Status**

Accepted

**Date**

July 2026

### Context

`CEngine` is the top-level orchestration module. It holds non-owning pointers to three Indicator modules (`CEMAIndicator`, `CATRIndicator`, `CADXIndicator`), one Signal module (`CBreakoutSignal`), and one Risk module (`CRiskManager`). These are wired by the composition root via `SetIndicators()`, `SetSignal()`, and `SetRisk()` before `Initialize()` is called.

Several design questions arose during implementation:

**(a) Constructor vs setter for indicator periods.**

Indicator subclasses could receive their period parameters either through their constructor or via post-construction setter methods.

**(b) Rollback on `CreateHandle()` failure.**

If `CIndicatorBase::Initialize()` calls `CreateHandle()` and that operation fails, the base class (`CModule`) has already completed its own initialization, meaning `m_initialized` is `true` and `m_context` has been assigned. Leaving the object in this partially initialized state would violate the framework's initialization contract.

**(c) `UpdateIndicators()` failure policy.**

If one indicator fails to update because it does not yet have enough historical bars, should the entire engine stop processing for that tick, or should the remaining indicators continue updating while downstream modules determine whether the snapshot is usable?

### Decision

#### 1. Constructor Parameters for Indicator Configuration

Indicator configuration is immutable after construction.

Each indicator receives its required parameters through its constructor.

Examples:

```cpp
CEMAIndicator(fastPeriod, slowPeriod, timeframe)
CATRIndicator(period, timeframe)
CADXIndicator(period, timeframe)
```

Setter methods for periods are intentionally not provided.

This guarantees that an indicator cannot enter `Initialize()` with incomplete or inconsistent configuration and follows the same construction pattern already established by `CModule(name)`.

---

#### 2. Rollback on Initialization Failure

If `CreateHandle()` fails inside `CIndicatorBase::Initialize()`:

```cpp
CModule::Shutdown();
return false;
```

must be executed before returning.

This guarantees the object returns to the exact same state it had before initialization began.

A partially initialized indicator—with a valid context but an invalid indicator handle—is not considered a valid object state.

---

#### 3. Best-Effort Indicator Updates

`UpdateIndicators()` is a **best-effort** stage.

It returns:

```cpp
void
```

rather than:

```cpp
bool
```

Every registered indicator is updated each engine cycle regardless of whether another indicator reports failure.

This behavior is intentional.

During startup an indicator commonly lacks sufficient historical bars.

That situation is expected and should **not** be treated as an engine failure.

Instead:

* Indicators populate `CMarketSnapshot`.
* Indicators set `IsReady = true` only after every required value has been successfully calculated.
* Signal and Risk modules use `IsReady` to determine whether processing should continue.

Readiness is therefore communicated through the shared snapshot rather than through the engine pipeline itself.

---

#### 4. Fixed Engine Pipeline

`CEngine::Update()` always executes in the following order:

```
1. UpdateIndicators()
2. EvaluateSignal()
3. EvaluateRisk()
4. Execution (Stage 7 placeholder)
```

Pipeline behavior:

* Indicator stage is best-effort.
* Signal stage is mandatory.
* Risk stage is mandatory.

If:

```cpp
EvaluateSignal() == false
```

the engine stops processing.

Likewise:

```cpp
EvaluateRisk() == false
```

terminates the update cycle.

Only indicator updates tolerate temporary failures because snapshot readiness is already represented by `CMarketSnapshot::IsReady`.

### Consequences

* Indicator configuration is fixed at construction time, preventing incomplete initialization.
* Initialization is transactional—objects either initialize successfully or roll back completely.
* Engine startup no longer reports false failures while indicators accumulate enough historical data.
* The orchestration pipeline has a single deterministic execution order that every future module must follow.
* Adding another indicator requires only:

  * adding a member pointer to `CEngine`,
  * extending `SetIndicators()`,
  * invoking the new indicator inside `UpdateIndicators()`.
* Stage 7 (trade execution) already has a reserved position in the pipeline and can be implemented later without changing the surrounding architecture.

# ADR-016

## Title

MarketData Layer Boundary

**Status**

Implemented (Sprint 012)

**Date**

July 11, 2026

### Context

The Indicators layer originally made direct MT5 API calls for indicator handle creation (`iMA`, `iATR`, `iADX`) and data copying (`CopyBuffer()`). This mixed I/O responsibilities with business logic, making unit testing difficult and tying the framework directly to the MT5 platform. As the framework evolves, a clear separation between data acquisition and data processing is required to support future data sources (e.g., historical data replays, simulated data, or alternative broker APIs).

### Decision

A dedicated MarketData layer is introduced between Framework and Indicators.

`CMarketDataProvider` exclusively owns:
* All MT5 handle creation (`iMA`, `iATR`, `iADX`)
* All `CopyBuffer()` calls for raw data retrieval

Indicators are strictly forbidden from calling MT5 APIs directly.

A two-stage readiness model is implemented:
* `DataReady` (set by `CMarketDataProvider`) — raw market data has been successfully populated into `CMarketSnapshot` for this tick.
* `IsReady` (set by `CEngine`) — all indicator business logic has completed processing the raw data.

### Consequences

* Indicator constructors no longer take period or timeframe arguments, as they no longer create their own handles.
* `CEngine` gains a `SetMarketData()` setter and a new Step 0 in its `Update()` pipeline to drive the MarketData provider.
* `CMarketSnapshot` gains a `DataReady` field, complementing the existing `IsReady` field to clearly delineate raw data availability from processed indicator readiness.
* Testing indicators is simplified — they now only require a populated `CMarketSnapshot` instance, completely decoupling them from the MT5 runtime.

# Future Decisions

Add new decisions instead of modifying historical ones.

If a decision changes:

* mark the previous decision as **Superseded**
* create a new ADR
* explain the reason for the change

This preserves the architectural history of the project.

# ADR-017: Grid and Basket Management Architecture

**Date:** 2026-07-12  
**Status:** Accepted  
**Implementation Sprint:** Sprint 014 (Phase 9b)

---

## Context

The current `Trading` layer consists of `CTradeExecutor` and `CPositionTracker`, which handle single‑order execution and basic position existence checks. There is no concept of grids, baskets, or opposing‑side position awareness. Phase 10 of the project requires the AI data collection system to capture runtime basket state—including current grid count, basket lot sizes, and outcome contribution—to enable meaningful per‑basket performance logging and future AI training.

Without explicit grid and basket management:
- The system cannot safely scale to multiple simultaneous orders (baskets) with opposing sides.
- Floating profit/loss cannot be aggregated at a basket level.
- The `AITradeLogger` will lack the necessary fields (`CurrentGridCount`, `ActiveBasketLots`, `BasketID`, etc.) to produce high‑quality training labels.
- There is no clean way to implement a CPO (Close Profitable Order) protocol based on combined basket PnL.

The grid/basket infrastructure must exist before Phase 10 AI logging begins, and it must be designed with clear separation of concerns to avoid polluting existing core modules.

---

## Decision

We will introduce **Phase 9b (Advanced Strategy Infrastructure)** to formally implement grid mechanics, advanced risk calculation, and market analysis into the object‑oriented framework.

The following new modules and layers will be added:

### 1. Basket Management — `CBasketManager.mqh`

**Layer:** `Include/Trading/`

**Responsibility:**
- Owns active basket lot counts (total long and short lots in the current basket).
- Opposing‑basket awareness (detects if both sides are present).
- `CurrentGridCount` (number of grid levels active).
- Basket open/close lifecycle (start, update, close).

**Scope Restrictions:** This module will maintain a strictly modernized architecture. Deprecated legacy logic—specifically **Survival Net**, **Time Restrictions**, and **PartialClose** parameters—are **explicitly excluded** from this module and the wider framework.

**Behavior:**
- Maintains a single active basket per symbol; when a basket is closed, it resets state.
- Contains the **Floating Profit Engine** logic:
  - Calculates combined basket PnL (floating profit/loss) in real time.
  - Tracks `FLProfitTarget` and `FLProfitTrailing` variables to manage basket closures.
  - Triggers CPO (Close Profitable Order) protocol when floating profit reaches a predefined target (configurable).
  - CPO execution calls `CTradeExecutor` to close all orders in the basket atomically, scanning and closing only profitable buy/sell orders when bid/ask prices breach specific, designated color‑coded threshold lines.

### 2. Grid Risk Calculation — `CGridRisk.mqh`

**Layer:** `Include/Risk/` (extends `CRiskBase`)

**Responsibility:**
- Replaces static lot sizing with a dynamic, four‑step conditional logic formula.
- Determines position sizes based on current grid counts, `AddLot` variables, and precise lot ratios relative to the opposing active basket.
- Outputs `SRiskResult` with the computed lot size and stop‑loss/take‑profit distances, just like `RiskManager`, but using grid‑specific logic.

**Note:** The composition root will decide whether to use `CRiskManager` (single‑order mode) or `CGridRisk` (grid mode) based on configuration.

### 3. Advanced Indicators — `BollingerBands.mqh`

**Layer:** `Include/Indicators/`

**Responsibility:**
- Calculates middle, upper, and lower Bollinger Bands.
- Strictly adheres to **ADR‑016**: `CMarketDataProvider` retains exclusive ownership of the indicator handle; the module issues no direct MT5 API calls and reads purely from `CMarketSnapshot`.

### 4. Analysis Layer & S/R Detection — `SRDetector.mqh`

**Layer:** `Include/Analysis/` (a newly established layer sitting precisely between `Indicators/` and `Signals/`)

**Responsibility:**
- Detects dynamic support and resistance (S/R) levels using recent price action and/or Bollinger Bands.

**State Management Decision (Option B selected):**
Two options were considered:
- **Option A:** Extend `CMarketSnapshot` with S/R fields (e.g., `SupportLevel`, `ResistanceLevel`). This would keep all market data in one snapshot but may bloat the struct.
- **Option B:** Create a dedicated snapshot, e.g., `CAnalysisSnapshot`, inside `Context.mqh` alongside `CMarketSnapshot`. This separates concerns and is future‑proof for additional analysis outputs.

**Decision:** We choose **Option B** — a new `CAnalysisSnapshot` class in `Context.mqh`. This keeps the market data snapshot focused on raw/derived price data, while analysis results are stored separately. The engine will update both snapshots in sequence (market data first, then analysis). Signals can read from both via the context.

The `SRDetector` is owned and updated by `CEngine` in the per‑tick pipeline (after indicators, before signal evaluation).

---

## Layer Placement Summary

| Module | Layer | Notes |
|--------|-------|-------|
| `CBasketManager` | `Trading` | Co‑exists with `TradeExecutor` and `PositionTracker`. |
| `CGridRisk` | `Risk` | Extends `CRiskBase`; placed alongside `RiskManager`. |
| `BollingerBands.mqh` | `Indicators` | New indicator module; follows ADR‑016. |
| `SRDetector.mqh` | `Analysis` | New layer, positioned between `Indicators` and `Signals`. Directory: `Include/Analysis/`. |

---

## Ownership

- **Composition root** (`AI_SwingBreakout_Pro.mq5`) owns all new modules as global value‑owned instances.
- **`CEngine`** receives non‑owning pointers via setter injection:
  - `SetBasketManager(CBasketManager*)`
  - `SetGridRisk(CGridRisk*)`
  - `SetBollingerBands(CBollingerBands*)`
  - `SetSRDetector(CSRDetector*)`
- `CEngine::Initialize()` will require these new pointers to be non‑null (in addition to existing ones) to ensure the pipeline is fully wired.
- `CBasketManager` will hold a pointer to `CTradeExecutor` to execute CPO closes; this pointer is injected via setter as well.
- All new modules are `CModule` derivatives so they automatically receive the `CContext` pointer.

---

## Consequences

### Positive
- Phase 10 `AITradeLogger` gains all required fields:
  - `CurrentGridCount`
  - `ActiveBasketLots` (total lots in the basket)
  - `BasketID` (a unique identifier for the basket, e.g., timestamp or incrementing counter)
  - `BasketOutcome` (profit/loss contribution at basket close)
  - `BasketContribution` (percentage or risk‑adjusted contribution to overall PnL)
- The system can now operate in grid mode with proper risk scaling and CPO protocol.
- `AITradeRecord` outcome label changes from per‑order binary (win/loss) to basket‑level PnL contribution, providing richer training signals for future AI models.
- Clear separation of concerns: basket logic, grid risk, and analysis are each in dedicated modules.
- The new `Analysis` layer makes it easy to add more technical analysis components (e.g., pivot points, trend lines) without polluting the core Framework or Indicators.

### Negative / Risks
- Increased complexity in the composition root and engine initialization (seven new setters, more null checks).
- The CPO protocol may introduce additional latency if many orders must be closed simultaneously; we need to ensure `CTradeExecutor` can batch close orders efficiently.
- The `CAnalysisSnapshot` adds another shared state object; careful concurrency handling is required (no simultaneous writes; engine updates in a defined sequence).
- Migration from single‑order mode to grid mode requires configuration flags; we must ensure backward compatibility for non‑grid users.

### Mitigations
- Keep the engine pipeline strictly sequential: MarketData → Indicators → Analysis → Signal → Risk → Execution → Basket update (after execution).
- Use the existing `CModule` lifecycle and dependency injection pattern to keep modules testable and loosely coupled.
- Write integration tests specifically for grid/basket scenarios (Sprint 014) to validate CPO, AddLot calculations, and state consistency.

---

## Related ADRs

- ADR‑013: Framework Layer (CContext / CModule / CModuleManager / CEngine)
- ADR‑015: Engine Orchestration Pipeline
- ADR‑016: MarketData Architectural Boundary

---

## Status

**Accepted** — July 12, 2026. Implementation planned for Sprint 014 (Phase 9b).