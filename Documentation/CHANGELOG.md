# AI Swing Breakout Pro Framework

# CHANGELOG

All notable changes to this project are documented in this file.

The format is inspired by **Keep a Changelog**, but adapted for long-term framework development.

Version numbers follow:

**Major.Minor.Patch-Stage**

Example:

```text
2.0.0-alpha.2
```

---

# Version 2.0.0-alpha.5

**Status**

Active Development

**Date**

July 2026

---

# Summary

This release completes Sprint 007 Tasks 1–5: `CMarketSnapshot` added to `Context.mqh`, the full Indicators layer (IndicatorBase, EMAIndicator, ATRIndicator, ADXIndicator), Signals layer (SignalResult, SignalBase, BreakoutSignal), Risk layer (RiskResult, RiskBase, RiskManager), and the `Engine.mqh` orchestration pipeline. Four bugs were found and fixed during implementation — none were compile errors.

---

# Added

## Framework — CMarketSnapshot (Context.mqh)

`CMarketSnapshot` added to `Include/Framework/Context.mqh`. Shared read/write buffer owned by `CContext`; Indicator modules write into it each tick via `CContext::Snapshot()`; Signal and Risk modules read from it. Carries `FastEMA`, `SlowEMA`, `ATR`, `ADX`, `PlusDI`, `MinusDI`, `TrendDirection`, `Spread`, `Volume`, and `IsReady`. `IsReady` must be set true by the Indicator layer only after all fields are populated for the current bar; Signal and Risk modules must check it before consuming any field.

## Indicators Layer (new — `Include/Indicators/`)

```text
IndicatorBase.mqh   — abstract base, owns handle lifecycle (CreateHandle / Shutdown / IsReady)
EMAIndicator.mqh    — dual-handle EMA (fast + slow), writes FastEMA / SlowEMA to snapshot
ATRIndicator.mqh    — ATR, writes ATR to snapshot
ADXIndicator.mqh    — ADX with +DI / -DI, writes ADX / PlusDI / MinusDI to snapshot
```

All four compile-verified: 0 errors, 0 warnings.

## Signals Layer (new — `Include/Signals/`)

```text
SignalResult.mqh    — SSignalResult struct (Direction, Confidence, EntryPrice, IsValid)
SignalBase.mqh      — abstract base CSignalBase, owns GetResult() / Update() contract
BreakoutSignal.mqh  — concrete CBreakoutSignal, reads CMarketSnapshot, produces SSignalResult
```

All three compile-verified: 0 errors, 0 warnings.

## Risk Layer (new — `Include/Risk/`)

```text
RiskResult.mqh      — SRiskResult struct (IsAllowed, LotSize, StopLoss, TakeProfit)
RiskBase.mqh        — abstract base CRiskBase, owns Calculate() contract
RiskManager.mqh     — concrete CRiskManager, reads SSignalResult, produces SRiskResult
```

All three compile-verified: 0 errors, 0 warnings.

Note: `RiskManager.mqh` uses `stopLossPips = 50.0` placeholder. ATR-based stop loss integration is a future task (Stage 7). See PROJECT_CONTEXT.md Known Issues.

## Framework — Engine.mqh orchestration pipeline

`CEngine::Update()` now drives the full per-tick pipeline in fixed sequence:

```text
1. UpdateIndicators()  — best-effort, all three called regardless of individual failures
2. EvaluateSignal()    — reads snapshot (guards IsReady internally), produces SSignalResult
3. EvaluateRisk()      — reads SSignalResult, produces SRiskResult
4. Execution           — placeholder (Stage 7)
```

`CEngine` holds non-owning pointers to `CEMAIndicator`, `CATRIndicator`, `CADXIndicator`, `CBreakoutSignal`, `CRiskManager` — wired by the composition root via `SetIndicators()`, `SetSignal()`, `SetRisk()`.

---

# Fixed

## Context.mqh — CMarketSnapshot must be a class, not a struct

Initial design used `struct SMarketSnapshot`. MQL5's `GetPointer()` works on class instances only — structs are value types and cannot be returned as pointers. `CContext::Snapshot()` must return a writable pointer so Indicator modules can populate fields. Changed to `class CMarketSnapshot`. All field access unchanged; only the type declaration and naming prefix changed (`S` → `C`). See ADR-014.

## IndicatorBase.mqh — `SymbolInfoString(_Symbol, SYMBOL_NAME)` is invalid in MQL5

Initial `Initialize()` used `m_symbol = SymbolInfoString(_Symbol, SYMBOL_NAME)` to read the current symbol. `SYMBOL_NAME` is not a valid `ENUM_SYMBOL_INFO_STRING` property — MQL5 does not expose it via `SymbolInfoString()`. Fixed by assigning `m_symbol = _Symbol` directly. `_Symbol` is the built-in terminal string for the chart symbol and is always correct.

## ValidationUtils.mqh — `IsValidVolume()` argument order

An earlier call site passed arguments as `IsValidVolume(volume, symbol)` — volume first, symbol second. The actual signature is `IsValidVolume(const string symbol, const double volume)` — symbol first. MQL5 does not enforce argument names at call sites, so this compiled silently and produced incorrect results (a double being passed where a string was expected, and vice versa). Fixed: all call sites corrected to `IsValidVolume(symbol, volume)`.

## Engine.mqh — UpdateIndicators() changed from all-or-nothing to best-effort

Initial implementation returned `false` from `Update()` if any single indicator's `Update()` call failed:

```cpp
if(!m_ema.Update()) return false;
if(!m_atr.Update()) return false;
if(!m_adx.Update()) return false;
```

This was too aggressive — a single indicator failing on one tick (e.g. not yet having enough bars calculated) would abort the entire pipeline before the Signal module could check `snapshot.IsReady`. Changed to best-effort: all three indicators are called regardless of individual return values. The Signal module detects incomplete data through `CMarketSnapshot::IsReady`, which the Indicator layer sets only when all fields are populated. Failures are not propagated — the snapshot validity flag is the contract, not the indicator return value.

---

# Engineering Decisions Introduced

* ADR-014: CMarketSnapshot — class vs struct (GetPointer requirement)
* ADR-015: Engine.mqh orchestration pipeline design

---

# Project Status

Current Phase

```text
Indicators / Signals / Risk — complete. Stage 6 wiring of AI_SwingBreakout_Pro.mq5 next.
```

Overall Progress

```text
Approximately 75%
```

Current Sprint

```text
Sprint 007 — Task 6: AI_SwingBreakout_Pro.mq5 Stage 6 wiring
```

---

# Version 2.0.0-alpha.4

**Status**

Active Development

**Date**

July 2026

---

# Summary

This release completes Sprint 005 (Platform.mqh, ValidationUtils.mqh), delivers the Framework layer (Context/Module/ModuleManager/Engine), and executes Sprint 006 — a full standards-compliance pass across all 16 legacy Core modules. Three silent or latent bugs were found and fixed during Sprint 006 that would not have appeared as compile errors.

---

# Added

## Core

```text
Platform.mqh
ValidationUtils.mqh
```

**Platform.mqh** — value-owned `CConfig m_config` (not a raw injected pointer), `Config()` accessor returns `const CConfig*` via `GetPointer()` (MQL5 does not support reference return types), full header, compile-verified.

**ValidationUtils.mqh** — stateless `CValidationUtils`, static-only. Covers pointer safety (template `IsValidPointer`), string/number/handle/ticket/array validation, and broker-data validation (`IsValidSymbol`, `IsValidVolume` using `SymbolInfo` + `CMathUtils::RoundToStep` for step-alignment). Depends only on `Constants.mqh` and `MathUtils.mqh`. Compile pending.

## Framework Layer

```text
Include/Framework/Context.mqh
Include/Framework/Module.mqh
Include/Framework/ModuleManager.mqh
Include/Framework/Engine.mqh
```

New top-level layer for module composition and lifecycle management. See ADR-013 and the Framework Layer bug fix below.

---

# Fixed

## MathUtils.mqh — Structural Scope Bug

The previous implementation's `class CMathUtils { ... }` body closed after the first section, leaving approximately 480 lines of intended methods floating outside the class entirely. The file also hardcoded epsilon instead of referencing `CConstants::EPSILON`. Complete rewrite. Compile-verified: **0 errors, 0 warnings**.

## MathUtils.mqh — "constant expected" (8 errors on first build)

MQL5 does not accept static class members as default parameter values, even when `const`. Fixed by splitting each affected method into a two-overload pair (bare version calls the epsilon-explicit version internally). Re-verified: **0 errors, 0 warnings**.

## ErrorCodes.mqh — Identifier Collision with Built-in Constant

`ERR_TRADE_DISABLED` is a predefined MQL4/5-compat constant — redeclaring it as an enumerator caused "identifier expected". Renamed to `ERR_TRADING_DISABLED`. Re-verified: **0 errors, 0 warnings**.

## Platform.mqh — Reference Return Type Not Supported

MQL5 has no reference return types (`Type&`) at all. `const CConfig &Config() const` failed to compile. Fixed with `const CConfig *Config() const { return GetPointer(m_config); }`. Re-verified: **0 errors, 0 warnings**.

## Config.mqh — Incomplete Indicator Validation

`Validate()` checked all `Indicator` fields except `VolumeMAPeriod`. Added `if(Indicator.VolumeMAPeriod < 1) return false;`. Config.mqh is now finalized — no further changes planned.

## Framework Layer — Initialize() Signature Hiding (CEngine)

`CModule::Initialize()` took no parameters; `CEngine::Initialize(CContext*)` took one. Different parameter lists mean the derived method hides rather than overrides the base — MQL5 compiles this with **zero errors, zero warnings**, but `CModuleManager`'s polymorphic `m_modules[i].Initialize()` call would have dispatched to the inherited no-arg base version forever, leaving `m_context` permanently `NULL` silently.

Fixed architecturally: `CContext` injection moved into `CModule` itself (`m_context`, `Initialize(CContext*)`, `Context()`), so every future Trading/Risk/AI module gets it automatically. `CModule::Initialize()` now validates via `CContext::IsValid()` (checks all three services, not just a null check on context itself). `CEngine` inherits correctly. `CModuleManager` gained `SetContext()` and passes context through. `Context.mqh` getters marked `const`. Re-verified together: **0 errors, 0 warnings**.

**This is the most dangerous bug category found this cycle — it compiled clean and would have failed silently at runtime.** Virtual method signature matching must be reviewed on every class hierarchy going forward. MQL5 will not warn about an accidental overload where an override was intended.

## Sprint 006 — Three Latent Bugs Found During Standards Pass

### Bug 1: TimeUtils.mqh — Entire content duplicated inside one file

The file contained the full implementation pasted twice, back to back, with two nested `#ifndef` blocks sharing only one `#endif`. The outer guard never closed. First copy was also incomplete (missing `Minute`/`Second`/`StartOfDay`/`EndOfDay`/`FormatDate`/`FormatTime`/`FormatDateTime` bodies despite declaring them). Fixed: duplicate removed, single clean copy kept (the complete second paste).

### Bug 2: Logger.mqh — Initialize() signature hiding (same category as CEngine)

`CLogger::Initialize(ILogFormatter*, ILogOutput*)` didn't match `CBaseObject::Initialize()` (no args) — same silent-hiding defect as `CEngine`. Fixed by renaming to `Configure(ILogFormatter*, ILogOutput*)`. No call sites existed yet (no main EA wiring), so zero breakage risk.

### Bug 3: DefaultLogFormatter.mqh — referenced 6 fields not present in SLogRecord

`DefaultLogFormatter.mqh` read `record.Function`, `.Line`, `.Symbol`, `.Timeframe`, `.Ticket`, `.ErrorCode` — none of which existed in `LogRecord.mqh` at the time (only `Timestamp`/`Level`/`Module`/`Message`). Would not have compiled. Fixed by adding all 6 fields to `SLogRecord` rather than gutting the richer formatter — a trading log genuinely benefits from symbol/ticket/error-code context.

## Sprint 006 — Standards Compliance Pass (16 files)

All 16 legacy Core modules brought into compliance. Applied uniformly across all files:

* Include guards: `__NAME_MQH__` → `AI_SWINGBREAKOUT_CORE_NAME_MQH`
* Headers: added missing `Module`, `Author: ZiXXXiZ`, `Purpose`, `Version: 2.0.0-alpha.3` lines
* Version strings: unified to `2.0.0-alpha.3`

Additional per-file fixes:

* `ErrorInfo.mqh` — `SErrorInfo.Severity` changed from `ENUM_LOG_LEVEL` (borrowed from Logging) to `ENUM_ERROR_SEVERITY` (own type, defined in `ErrorCodes.mqh`). This implements the Error/Logging decoupling required by ADR-012, which was previously listed as "not yet implemented." `ErrorInfo.mqh` no longer includes `../Logging/LogLevel.mqh`.
* `TestErrorHandler.mqh` — fully rewritten. Previous version tested a `GetErrorInfo()`/`Category`/`Recoverable` API that no longer existed on `CErrorHandler`. Rewritten to test the actual current API: `SetError()`/`HasError()`/`GetLastError()`/`Clear()`. Absolute include path (`#include <Core/Error/ErrorHandler.mqh>`) replaced with relative path (`#include "ErrorHandler.mqh"`).
* `Config.mqh` — already finalized in a prior pass; not re-touched here.

Files processed:

```text
Include/Core/Base/BaseObject.mqh
Include/Core/InputParameters.mqh
Include/Core/Version.mqh
Include/Core/Error/ErrorCodes.mqh
Include/Core/Error/ErrorHandler.mqh
Include/Core/Error/ErrorInfo.mqh
Include/Core/Error/TestErrorHandler.mqh
Include/Core/Logging/LogLevel.mqh
Include/Core/Logging/LogRecord.mqh
Include/Core/Logging/Logger.mqh
Include/Core/Logging/DefaultLogFormatter.mqh
Include/Core/Logging/JournalLogOutput.mqh
Include/Core/Logging/Interfaces/ILogFormatter.mqh
Include/Core/Logging/Interfaces/ILogOutput.mqh
Include/Core/Utilities/StringUtils.mqh
Include/Core/Utilities/TimeUtils.mqh
```

---

# Engineering Decisions Introduced

* ADR-011: Documentation Reconciliation & Legacy Module Policy
* ADR-012: Root EA Include Convention & Core Subsystem Isolation (Error/Logging)
* ADR-013: Framework Layer — CContext/CModule/CModuleManager/CEngine design

---

# Project Status

Current Phase

```text
Foundation Layer → transitioning to Risk Engine
```

Overall Progress

```text
Approximately 55%
```

Current Sprint

```text
Sprint 007 — Wire Framework + Begin Risk Engine
```

---

# Previous: Version 2.0.0-alpha.3

**Date:** July 2026

**Summary:** Repository reconciliation — documentation brought in line with actual repo contents. `MathUtils.mqh` rebuilt. `Config.mqh` finalized. Framework layer scaffolded. All bugs listed above under Fixed were discovered and resolved across alpha.3 and alpha.4 development cycles.