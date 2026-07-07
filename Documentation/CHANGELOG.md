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