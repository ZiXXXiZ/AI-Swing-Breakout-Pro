# AI Swing Breakout Pro Framework

# SESSION CHECKPOINT

**Version:** 2.0.0-alpha.4
**Date:** July 2026
**Sprint:** 007 — Stage 6
**Prepared by:** Project Manager

---

# Purpose

This document is the single source of truth for resuming this project
in a new session. Read this FIRST before reading any other document.

---

# How to Resume Next Session

## Step 1 — Upload these documents (mandatory)

```
SESSION_CHECKPOINT.md    ← this file, read first
PROJECT_CONTEXT.md
ARCHITECTURE.md
CODING_STANDARD.md
DECISIONS.md
ROADMAP.md
CHANGELOG.md
ProjectManagerSkill.md
```

## Step 2 — Upload these source files (for context)

```
Include/Framework/Context.mqh        ← modified this session (SMarketSnapshot added)
Include/Framework/Module.mqh
Include/Framework/Engine.mqh         ← needs extension (Task 5)
Include/Indicators/IndicatorBase.mqh ← new, 0 errors confirmed
AI_SwingBreakout_Pro.mq5             ← Stage 5 complete, 0 errors confirmed
```

## Step 3 — Tell the AI this exact phrase

> "Resume AI Swing Breakout Pro from SESSION_CHECKPOINT.md.
> We are at Sprint 007, Stage 6, Task 2b — EMAIndicator.mqh.
> Read the checkpoint and all uploaded docs before doing anything."

---

# Exact Current Position

```
Sprint:  007
Stage:   6 — Engine business logic (Indicators → Signals → Risk → Execution)
Task:    2b — EMAIndicator.mqh  ← START HERE NEXT SESSION
```

---

# What Is Complete (Compile-Verified)

## Core Layer — 100% Done

| File | Location | Status |
|---|---|---|
| `Constants.mqh` | `Include/Core/` | ✅ done |
| `Types.mqh` | `Include/Core/` | ✅ done |
| `MathUtils.mqh` | `Include/Core/` | ✅ 0 errors |
| `Config.mqh` | `Include/Core/` | ✅ finalized/closed |
| `Platform.mqh` | `Include/Core/` | ✅ 0 errors |
| `ValidationUtils.mqh` | `Include/Core/` | ✅ 0 errors |
| `BaseObject.mqh` | `Include/Core/Base/` | ✅ done |
| `InputParameters.mqh` | `Include/Core/` | ✅ done |
| `Version.mqh` | `Include/Core/` | ✅ done |
| `ErrorCodes.mqh` | `Include/Core/Error/` | ✅ done |
| `ErrorHandler.mqh` | `Include/Core/Error/` | ✅ done |
| `ErrorInfo.mqh` | `Include/Core/Error/` | ✅ decoupled from Logging |
| `TestErrorHandler.mqh` | `Include/Core/Error/` | ✅ rewritten |
| `LogLevel.mqh` | `Include/Core/Logging/` | ✅ done |
| `LogRecord.mqh` | `Include/Core/Logging/` | ✅ 6 fields added |
| `Logger.mqh` | `Include/Core/Logging/` | ✅ Configure() rename done |
| `DefaultLogFormatter.mqh` | `Include/Core/Logging/` | ✅ done |
| `JournalLogOutput.mqh` | `Include/Core/Logging/` | ✅ done |
| `ILogFormatter.mqh` | `Include/Core/Logging/Interfaces/` | ✅ done |
| `ILogOutput.mqh` | `Include/Core/Logging/Interfaces/` | ✅ done |
| `StringUtils.mqh` | `Include/Core/Utilities/` | ✅ done |
| `TimeUtils.mqh` | `Include/Core/Utilities/` | ✅ duplicate removed |
| `TradeStructures.mqh` | `Include/Core/Structures/` | ✅ done |
| `MarketStructures.mqh` | `Include/Core/Structures/` | ✅ done |
| `RiskStructures.mqh` | `Include/Core/Structures/` | ✅ done |
| `AccountStructures.mqh` | `Include/Core/Structures/` | ✅ done |
| `StatisticsStructures.mqh` | `Include/Core/Structures/` | ✅ done |

## Framework Layer — 100% Done

| File | Location | Status |
|---|---|---|
| `Context.mqh` | `Include/Framework/` | ✅ modified this session — `CMarketSnapshot` added |
| `Module.mqh` | `Include/Framework/` | ✅ done |
| `ModuleManager.mqh` | `Include/Framework/` | ✅ done |
| `Engine.mqh` | `Include/Framework/` | ✅ done — needs extension in Task 5 |

## Composition Root — Done

| File | Location | Status |
|---|---|---|
| `AI_SwingBreakout_Pro.mq5` | Project root | ✅ Stage 5 complete, 0 errors, loads on chart |

## Indicators Layer — In Progress

| File | Location | Status |
|---|---|---|
| `IndicatorBase.mqh` | `Include/Indicators/` | ✅ 0 errors confirmed |
| `EMAIndicator.mqh` | `Include/Indicators/` | ⏳ NEXT TASK |
| `ATRIndicator.mqh` | `Include/Indicators/` | ⏳ pending |
| `ADXIndicator.mqh` | `Include/Indicators/` | ⏳ pending |

## Signals Layer — Not Started

| File | Location | Status |
|---|---|---|
| `SignalResult.mqh` | `Include/Signals/` | ⏳ pending |
| `SignalBase.mqh` | `Include/Signals/` | ⏳ pending |
| `BreakoutSignal.mqh` | `Include/Signals/` | ⏳ pending |

## Risk Layer — Not Started

| File | Location | Status |
|---|---|---|
| `RiskResult.mqh` | `Include/Risk/` | ⏳ pending |
| `RiskBase.mqh` | `Include/Risk/` | ⏳ pending |
| `RiskManager.mqh` | `Include/Risk/` | ⏳ pending |

---

# Critical Design Decisions — Must Know Before Resuming

## Decision 1 — Shared Market Snapshot (confirmed)

Indicators write output into `CMarketSnapshot` stored inside `CContext`.
Signal and Risk modules read from the snapshot.
No module holds a pointer to another module.

```
CATRIndicator::Update() → context.Snapshot().ATR = value
CBreakoutSignal::Update() → reads context.Snapshot()
```

## Decision 2 — CEngine Orchestrates (confirmed)

`CEngine::Update()` controls the exact sequence:

```
1. Indicators update  → populate CMarketSnapshot
2. Signal evaluates   → reads snapshot → SSignalResult
3. Risk evaluates     → reads signal → SRiskResult
4. Execution          → Stage 7 (not yet started)
```

## Decision 3 — Constructor Parameters (confirmed)

Indicator periods and timeframes are set via constructor, not setters.

```cpp
CEMAIndicator g_ema(50, 200, PERIOD_CURRENT);
CATRIndicator g_atr(14,     PERIOD_CURRENT);
CADXIndicator g_adx(14,     PERIOD_CURRENT);
```

## Decision 4 — Rollback on CreateHandle() failure (confirmed)

If `CreateHandle()` fails inside `CIndicatorBase::Initialize()`,
call `CModule::Shutdown()` before returning false to roll back
`m_initialized` and `m_context`.

---

# Next Task — Exact Specification

## Task 2b — `EMAIndicator.mqh`

**File location:** `Include/Indicators/EMAIndicator.mqh`

**Include path:**
```cpp
#include "IndicatorBase.mqh"
#include "../Core/Types.mqh"
#include "../Core/MathUtils.mqh"
```

**Class structure:**

```cpp
class CEMAIndicator : public CIndicatorBase
{
private:
   int    m_fastPeriod;
   int    m_slowPeriod;
   int    m_handleFast;   // separate from m_handle (base owns one handle)
   int    m_handleSlow;
   double m_fastValue;
   double m_slowValue;

public:
   CEMAIndicator(const int fastPeriod,
                 const int slowPeriod,
                 const ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
      : CIndicatorBase("CEMAIndicator", timeframe)
   {
      m_fastPeriod = fastPeriod;
      m_slowPeriod = slowPeriod;
      m_handleFast = INVALID_HANDLE;
      m_handleSlow = INVALID_HANDLE;
      m_fastValue  = 0.0;
      m_slowValue  = 0.0;
   }

   double FastValue() const { return m_fastValue; }
   double SlowValue() const { return m_slowValue; }

   virtual bool Update() override;
   virtual void Shutdown() override;   // MUST release both handles
   virtual bool IsReady() const override;

protected:
   virtual bool CreateHandle() override;
};
```

**Key rules for implementation:**

1. `CreateHandle()` creates BOTH handles:
```cpp
m_handleFast = iMA(m_symbol, m_timeframe, m_fastPeriod, 0, MODE_EMA, PRICE_CLOSE);
m_handleSlow = iMA(m_symbol, m_timeframe, m_slowPeriod, 0, MODE_EMA, PRICE_CLOSE);
m_handle = m_handleFast;   // base IsReady() checks m_handle
return (m_handleFast != INVALID_HANDLE && m_handleSlow != INVALID_HANDLE);
```

2. `Shutdown()` releases BOTH handles (base only releases `m_handle`):
```cpp
if(m_handleSlow != INVALID_HANDLE)
{
   IndicatorRelease(m_handleSlow);
   m_handleSlow = INVALID_HANDLE;
}
CIndicatorBase::Shutdown();   // releases m_handleFast via m_handle
```

3. `Update()` uses `CopyBuffer()` with `ArraySetAsSeries()`:
```cpp
double bufFast[], bufSlow[];
ArraySetAsSeries(bufFast, true);
ArraySetAsSeries(bufSlow, true);
if(CopyBuffer(m_handleFast, 0, 0, 1, bufFast) < 1) return false;
if(CopyBuffer(m_handleSlow, 0, 0, 1, bufSlow) < 1) return false;
m_fastValue = bufFast[0];
m_slowValue = bufSlow[0];
// Write to snapshot:
CMarketSnapshot *snap = m_context.Snapshot();
snap.FastEMA = m_fastValue;
snap.SlowEMA = m_slowValue;
return true;
```

4. `IsReady()` checks BOTH handles:
```cpp
return (m_handleFast != INVALID_HANDLE &&
        m_handleSlow != INVALID_HANDLE &&
        BarsCalculated(m_handleFast) > 0 &&
        BarsCalculated(m_handleSlow) > 0);
```

**Warning — `CopyBuffer` array direction:**
MQL5 fills buffers newest-to-oldest by default.
`ArraySetAsSeries(buffer, true)` makes index `[0]` = current bar.
Always set this before calling `CopyBuffer`. Without it, `[0]` is
the oldest bar — wrong value, no error.

---

# Remaining Task Order (Sprint 007, Stage 6)

```
✅ Task 1  — Context.mqh (CMarketSnapshot added)
✅ Task 2a — IndicatorBase.mqh
⏳ Task 2b — EMAIndicator.mqh          ← START HERE
⏳ Task 2c — ATRIndicator.mqh
⏳ Task 2d — ADXIndicator.mqh
⏳ Task 3a — SignalResult.mqh
⏳ Task 3b — SignalBase.mqh
⏳ Task 3c — BreakoutSignal.mqh
⏳ Task 4a — RiskResult.mqh
⏳ Task 4b — RiskBase.mqh
⏳ Task 4c — RiskManager.mqh
⏳ Task 5  — Engine.mqh (extended with orchestration)
⏳ Task 6  — AI_SwingBreakout_Pro.mq5 (Stage 6 wiring)
```

---

# MQL5 Gotchas — Never Forget

```
1. No static class members as default parameter values
   → use overload pairs

2. Virtual method signature must match exactly
   → different parameter list hides base, compiles clean, fails silently
   → always use override keyword

3. No reference return types (Type&)
   → use GetPointer() instead

4. GetPointer() works on class instances only, not structs
   → this is why SMarketSnapshot became CMarketSnapshot

5. CopyBuffer() fills arrays newest-to-oldest by default
   → always call ArraySetAsSeries(buffer, true) first
   → index [0] = current bar only after this call

6. Indicator handles must be created in Initialize(), not constructor
   → EA is not attached to chart during object construction

7. CLogger uses Configure(), not Initialize()
   → renamed to avoid signature-hiding defect (see CHANGELOG.md)
```

---

# Files Produced This Session (Push to GitHub)

## Documentation
```
SESSION_CHECKPOINT.md    ← this file (new)
PROJECT_CONTEXT.md       ← updated
ARCHITECTURE.md          ← updated
ROADMAP.md               ← updated
CHANGELOG.md             ← updated
DECISIONS.md             ← ADR-012, ADR-013 added
CODING_STANDARD.md       ← updated
ProjectManagerSkill.md   ← new
```

## Source Files
```
Include/Core/MathUtils.mqh              (rebuilt)
Include/Core/Config.mqh                 (finalized)
Include/Core/Platform.mqh               (built)
Include/Core/ValidationUtils.mqh        (built)
Include/Core/Base/BaseObject.mqh        (Sprint 006)
Include/Core/InputParameters.mqh        (Sprint 006)
Include/Core/Version.mqh                (Sprint 006)
Include/Core/Error/ErrorCodes.mqh       (Sprint 006)
Include/Core/Error/ErrorHandler.mqh     (Sprint 006)
Include/Core/Error/ErrorInfo.mqh        (Sprint 006 — decoupled)
Include/Core/Error/TestErrorHandler.mqh (Sprint 006 — rewritten)
Include/Core/Logging/LogLevel.mqh       (Sprint 006)
Include/Core/Logging/LogRecord.mqh      (Sprint 006 — 6 fields)
Include/Core/Logging/Logger.mqh         (Sprint 006 — Configure())
Include/Core/Logging/DefaultLogFormatter.mqh (Sprint 006)
Include/Core/Logging/JournalLogOutput.mqh    (Sprint 006)
Include/Core/Logging/Interfaces/ILogFormatter.mqh (Sprint 006)
Include/Core/Logging/Interfaces/ILogOutput.mqh    (Sprint 006)
Include/Core/Utilities/StringUtils.mqh  (Sprint 006)
Include/Core/Utilities/TimeUtils.mqh    (Sprint 006 — duplicate removed)
Include/Framework/Context.mqh           (CMarketSnapshot added)
Include/Framework/Module.mqh            (built)
Include/Framework/ModuleManager.mqh     (built)
Include/Framework/Engine.mqh            (built — needs Task 5 extension)
Include/Indicators/IndicatorBase.mqh    (new — 0 errors)
AI_SwingBreakout_Pro.mq5                (Stage 5 complete)
```

---

# Project Progress

```
Foundation Layer    ██████████  100%
Framework Layer     ██████████  100%
Infrastructure      ██████████  100%
Indicators          ██░░░░░░░░   20%  (base done, 3 concrete pending)
Signals             ░░░░░░░░░░    0%
Risk                ░░░░░░░░░░    0%
Trading             ░░░░░░░░░░    0%
AI                  ░░░░░░░░░░    0%

Overall             ██████░░░░   60%
```