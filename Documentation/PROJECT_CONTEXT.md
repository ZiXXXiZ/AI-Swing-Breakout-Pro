# AI Swing Breakout Pro Framework

# PROJECT_CONTEXT

**Version:** 2.0.0-alpha.3
**Status:** Active Development
**Last Updated:** July 2026

---

# Purpose

This document is the operational context for the AI Swing Breakout Pro project.

It is intended to be the first document read by any developer or AI assistant before making changes.

The GitHub repository is the single source of truth.

---

# Repository

Repository Name

```
ZiXXXiZ/AI-Swing-Breakout-Pro
```

Repository Type

```
Private
```

---

# Local Project Root

```
C:\Users\kkk\AppData\Roaming\MetaQuotes\Terminal\
829BEA48CFE0CB726192D822F91AD6B5\
MQL5\
Experts\
AI_SwingBreakout_Pro\
```

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
* GitHub-driven development

---

# Current Architecture

```
Application
        │
Trading Engine
        │
Risk Engine
        │
Indicators
        │
Utilities
        │
Core
        │
MQL5 Platform
```

Dependencies always point downward.

Core must never depend on upper layers.

---

# Folder Layout (Actual, Reconciled July 2026)

A repository audit (upload of the actual `AI_SwingBreakout_Pro` project archive) found substantially more implemented than earlier documentation tracked. This section replaces the previous, outdated layout.

```
AI_SwingBreakout_Pro/
│
├── AI_SwingBreakout_Pro.mq5        ← main EA entry point (root, sibling of Include/)
│
├── Documentation/
│
├── Include/
│   ├── Core/
│   │   ├── Base/
│   │   │   └── BaseObject.mqh
│   │   ├── Config.mqh
│   │   ├── Constants.mqh
│   │   ├── Error/
│   │   │   ├── ErrorCodes.mqh
│   │   │   ├── ErrorHandler.mqh
│   │   │   ├── ErrorInfo.mqh
│   │   │   └── TestErrorHandler.mqh   (test script)
│   │   ├── InputParameters.mqh
│   │   ├── Logging/
│   │   │   ├── DefaultLogFormatter.mqh
│   │   │   ├── Interfaces/
│   │   │   │   ├── ILogFormatter.mqh
│   │   │   │   └── ILogOutput.mqh
│   │   │   ├── JournalLogOutput.mqh
│   │   │   ├── LogLevel.mqh
│   │   │   ├── LogRecord.mqh
│   │   │   └── Logger.mqh
│   │   ├── MathUtils.mqh
│   │   ├── Structures/
│   │   │   ├── AccountStructures.mqh
│   │   │   ├── MarketStructures.mqh
│   │   │   ├── RiskStructures.mqh
│   │   │   ├── StatisticsStructures.mqh
│   │   │   └── TradeStructures.mqh
│   │   ├── Types.mqh
│   │   ├── Utilities/
│   │   │   ├── StringUtils.mqh
│   │   │   └── TimeUtils.mqh
│   │   └── Version.mqh
│   └── Tests/
│       ├── Core/
│       │   └── Utilities/
│       │       ├── TestStringUtils.ex5
│       │       └── TestStringUtils.mq5
│       └── Framework/
│           └── TestFramework.mqh
│
├── Source/
├── Tests/
└── Resources/
```

---

# Current Coding Rules

Mandatory rules:

* Production-quality source only.
* Complete source files.
* Never build framework modules from partial snippets.
* One responsibility per file.
* Relative include paths only.
* No placeholder code.
* No duplicated logic.
* Keep Core independent.
* Documentation must remain synchronized with implementation.

---

# Include Policy

Correct

```cpp
#include "../Types.mqh"
```

Correct

```cpp
#include "Constants.mqh"
```

Incorrect

```cpp
#include <Core/Types.mqh>
```

Never use MetaTrader global Include paths.

**Exception:** `AI_SwingBreakout_Pro.mq5` sits at the project root, outside `Include/`. It is the only file that prefixes framework includes with `Include/`:

```cpp
#include "Include/Core/Types.mqh"
```

Files inside `Include/Core/...` are unaffected — see `ARCHITECTURE.md` Section 7 and `DECISIONS.md` ADR-012.

---

# Completed Modules (Reconciled)

## Core — Compliant with CODING_STANDARD.md

* `Constants.mqh` — `CConstants`, project-relative includes, `AI_SWINGBREAKOUT_CORE_*` guard.
* `Types.mqh` — shared enumerations (`E`-prefixed), `AI_SWINGBREAKOUT_CORE_*` guard.
* `MathUtils.mqh` — rebuilt this cycle. `CMathUtils`, static-only, epsilon comparisons sourced from `CConstants::EPSILON`, no domain (Trading/Risk) logic.

## Core Structures — Compliant

* `TradeStructures.mqh`
* `MarketStructures.mqh`
* `RiskStructures.mqh`
* `AccountStructures.mqh`
* `StatisticsStructures.mqh`

## Core — Present but NOT Yet Reviewed for Standards Compliance

These modules exist in the repository and are functional in scope, but were authored outside the documented workflow (headers credit "OpenAI & Project Team" / "AI Swing Breakout Team" rather than the current process) and use conventions that diverge from `CODING_STANDARD.md`. See **Known Issues** below.

* `Base/BaseObject.mqh`
* `Config.mqh`
* `InputParameters.mqh`
* `Version.mqh`
* `Error/ErrorCodes.mqh`
* `Error/ErrorHandler.mqh`
* `Error/ErrorInfo.mqh`
* `Error/TestErrorHandler.mqh`
* `Logging/Logger.mqh`
* `Logging/LogLevel.mqh`
* `Logging/LogRecord.mqh`
* `Logging/DefaultLogFormatter.mqh`
* `Logging/JournalLogOutput.mqh`
* `Logging/Interfaces/ILogFormatter.mqh`
* `Logging/Interfaces/ILogOutput.mqh`
* `Utilities/StringUtils.mqh`
* `Utilities/TimeUtils.mqh`

## Tests — Present, Not Yet Reviewed

* `Tests/Framework/TestFramework.mqh`
* `Tests/Core/Utilities/TestStringUtils.mq5` (+ compiled `.ex5`)

## Documentation

* REPOSITORY_AUDIT.md
* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md
* DECISIONS.md
* PROJECT_CONTEXT.md (this file)

---

# Known Issues (Standards Compliance)

Identified while reconciling documentation to the actual repository, without a full line-by-line audit:

* **Include guard style mismatch.** Legacy modules use `__NAME_MQH__` (e.g. `__CONFIG_MQH__`, `__BASEOBJECT_MQH__`) instead of the project convention `AI_SWINGBREAKOUT_CORE_NAME_MQH`.
* **Enum naming mismatch.** Legacy modules use `ENUM_SIGNAL_TYPE`, `ENUM_ERROR_CATEGORY` style instead of the `E`-prefixed PascalCase convention (`ESignalType`, `EErrorCategory`) defined in `CODING_STANDARD.md`.
* **Absolute include path violation.** `Error/TestErrorHandler.mqh` uses `#include <Core/Error/ErrorHandler.mqh>` — a global MetaTrader Include path, explicitly prohibited by the Include Policy.
* **Version inconsistency.** Some legacy files self-report `Version: 1.0.0` or `2.0.0-alpha` (without a patch/stage suffix) rather than the current `2.0.0-alpha.2` / `2.0.0-alpha.3` scheme.
* **Header format inconsistency.** Several legacy files omit the `Module` and `Author: ZiXXXiZ` header lines required by `CODING_STANDARD.md` Section 4.
* **Previously undocumented, and therefore never scheduled for review.** These modules were not listed in prior versions of this document, `ARCHITECTURE.md`, `ROADMAP.md`, or `CHANGELOG.md`.
* **`Core/Error` currently depends on `Core/Logging`.** `ErrorInfo.mqh` includes `LogLevel.mqh` and uses `ENUM_LOG_LEVEL` for its `Severity` field. ADR-012 adopts mutual isolation between Error and Logging as target design; this is the concrete gap against that target, tracked for Sprint 006.

None of these are functional/compile blockers by themselves (aside from the absolute-include violation, which should still compile inside a real MetaTrader install but breaks portability). They are tracked here as technical debt. A full correctness/compliance audit has been deliberately deferred — see `DECISIONS.md`, ADR-011 and ADR-012.

---

# Current Development Workflow

Every framework module follows:

1. Architecture review
2. Complete implementation
3. Compile verification
4. Integration verification
5. Documentation update
6. Git commit

No partial framework implementations should be committed.

---

# Current Sprint

Sprint 004

Objective

Rebuild

```
Include/Core/MathUtils.mqh
```

Status: **Completed this cycle.** The previous incremental version had a structural scope bug — the class body closed after its first section, leaving ~480 lines of intended methods (`NormalizePrice`, `PositionSize`, `RiskOfRuin`, statistics functions, etc.) floating outside the class entirely. It also hardcoded its epsilon value instead of using `CConstants::EPSILON`. It has been fully rewritten as a Core-only, static, epsilon-consistent utility class with no Trading/Risk domain logic (per ADR-003).

---

# Immediate Next Tasks

1. Decide disposition of legacy Core modules (Base, Config, InputParameters, Version, Error/*, Logging/*, Utilities/*) — bring into compliance, or formally grandfather with a documented exception. See DECISIONS.md ADR-011.
2. Resolve absolute include path in `Error/TestErrorHandler.mqh`.
3. Decouple `ErrorInfo.mqh` from `LogLevel.mqh` per ADR-012 (give Error its own severity type).
4. Build `Include/Core/Platform.mqh`.
5. Continue Risk module.

Resolved this cycle: main EA file location confirmed (`AI_SwingBreakout_Pro.mq5`, project root) and its include-path convention documented — see ADR-012. `AI_SwingBreakout_Pro.rar` confirmed not part of the project and removed from documentation.

---

# Future Roadmap

Core

↓

Utilities

↓

Indicators

↓

Risk

↓

Trading

↓

AI

↓

Backtesting

↓

Optimization

↓

Production Release

---

# GitHub Workflow

The repository is authoritative.

Development workflow:

Read repository

↓

Review architecture

↓

Modify complete source file

↓

Compile verification

↓

Update documentation

↓

Commit

↓

Continue

GitHub history should always reflect the latest stable implementation.

---

# Communication Rules

Development conversations should be concise.

Avoid repeating previous explanations.

When the user writes

```
LDN
```

interpret it as

```
Let Do Next
```

Continue directly with the next planned task.

---

# Project Status

Current Phase

```
Foundation Layer
```

Completion Estimate

```
Approximately 35–40% (revised upward after reconciliation with actual repository contents; a meaningful portion of this is unreviewed legacy code, not newly built work)
```

Foundation modules are prioritized before higher-level trading logic.

---

# Notes for Future AI Sessions

Always read these documents before starting work:

1. PROJECT_CONTEXT.md
2. ARCHITECTURE.md
3. CODING_STANDARD.md
4. DECISIONS.md
5. ROADMAP.md
6. CHANGELOG.md

Treat these documents together with the GitHub repository as the complete project context.

Never assume previous chat history is available.

Always continue from the current repository state — and treat the repository, not prior documentation claims, as ground truth if the two ever disagree. Re-verify documentation against an actual repository export whenever one is available.

---

# Definition of Done

A module is considered complete only when:

* Source code is production quality.
* Compiles without errors.
* Dependency rules are respected.
* Documentation is updated.
* Ready for Git commit.

Only then should development continue to the next module.