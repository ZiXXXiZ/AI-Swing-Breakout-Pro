# AI Swing Breakout Pro Framework

## ARCHITECTURE

**Version:** 2.0.0-alpha.3
**Status:** Active Development
**Last Updated:** July 2026

---

# 1. Overview

AI Swing Breakout Pro is a modular MQL5 trading framework designed around clean architecture principles.

The framework separates infrastructure, business logic, trading logic, indicators, AI, utilities, and tests into independent modules with clear dependencies.

Design goals:

* Modular
* Reusable
* Testable
* Production-ready
* Low coupling
* High cohesion

---

# 2. Project Structure (Actual, Reconciled July 2026)

The structure below was verified against an actual export of the repository and replaces the previous, aspirational-only structure.

```text
AI_SwingBreakout_Pro/
│
├── AI_SwingBreakout_Pro.mq5   ← main EA entry point (root, sibling of Include/ — see Section 7)
│
├── Documentation/
│
├── Include/
│   │
│   ├── Core/
│   │   ├── Base/
│   │   │   └── BaseObject.mqh
│   │   ├── Config.mqh
│   │   ├── Constants.mqh
│   │   ├── Error/
│   │   │   ├── ErrorCodes.mqh
│   │   │   ├── ErrorHandler.mqh
│   │   │   ├── ErrorInfo.mqh
│   │   │   └── TestErrorHandler.mqh
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
│   │
│   ├── Framework/
│   │   ├── Context.mqh
│   │   ├── Module.mqh
│   │   ├── ModuleManager.mqh
│   │   └── Engine.mqh
│   │
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

Note: `Utilities/` and `Error/` and `Logging/` exist nested inside `Core/`, not as separate top-level Include directories as earlier drafts of this document assumed. This document now reflects that nesting.

Note: `Include/Indicators/`, `Include/Trading/`, `Include/Risk/`, `Include/AI/`, and `Include/UI/` do not exist on disk yet — they are future module locations, covered under the Long-Term Roadmap (Section 13) and `ROADMAP.md` Phases 4–8, not part of the current confirmed tree.

---

# 3. Architecture Layers

```text
Application
        │
        ▼
Trading Engine
        │
        ▼
Risk Engine
        │
        ▼
Indicators
        │
        ▼
Core Services
        │
        ▼
Platform (MQL5)
```

Each layer only depends on lower layers.

Higher layers never become dependencies of lower layers.

---

# 4. Core Module

The Core module is the foundation of the framework.

Everything else depends on Core.

Actual current layout:

```text
Core
│
├── Base            (CBaseObject — minimal base type, no logger/config/trading dependency)
├── Config           (global configuration enums/validation)
├── Constants
├── Error             (error codes, structured error info, error handler)
├── InputParameters
├── Logging          (Logger, LogLevel, LogRecord, formatters, outputs, interfaces)
├── MathUtils
├── Structures
├── Types
├── Utilities        (StringUtils, TimeUtils)
└── Version
```

Responsibilities:

* shared types
* constants
* mathematical utilities
* platform abstraction (planned — `Platform.mqh` not yet built)
* common data structures
* error classification and structured error reporting
* logging (formatting + output targets, via interfaces)
* string/time utility functions
* EA input parameter declarations
* global configuration and versioning metadata

Core must not depend on Trading, AI, Indicators or Risk modules.

**Standards note:** the `Base`, `Config`, `InputParameters`, `Version`, `Error/*`, `Logging/*`, and `Utilities/*` modules listed above were authored outside the documented Sprint workflow and have not yet been reviewed against `CODING_STANDARD.md`. Known deviations (include guard style, enum naming, one absolute include path) are tracked in `PROJECT_CONTEXT.md` under **Known Issues** and `DECISIONS.md` ADR-011. They are structurally present and in-scope for the framework, but "Completed" here means "exists," not "standards-verified."

---

# 5. Core Structures

Current shared structures:

```text
Core/Structures/

TradeStructures.mqh
MarketStructures.mqh
RiskStructures.mqh
AccountStructures.mqh
StatisticsStructures.mqh
```

These files contain only data structures.

Business logic must never be implemented inside structure files.

---

# 6. Dependency Rules

Allowed dependency direction:

```text
Core
   ▲
Utilities
   ▲
Indicators
   ▲
Risk
   ▲
Trading
   ▲
AI
```

Never reverse dependencies.

Examples:

✔ Trading → Core

✔ AI → Trading

✔ Risk → Core

✘ Core → Trading

✘ Core → AI

**Target design within Core (ADR-012).** The rules above (Section 6, existing) govern Core vs. higher layers. Within Core itself, the target — not yet fully implemented — is:

```text
Base
   ↓
Types + Constants + Version
   ↓
Logging  +  Error   (parallel, mutually isolated — neither depends on the other)
   ↓
Feature modules (Trading / AI / Risk / UI)
```

Forbidden-dependency table (target, tracked via Sprint 006):

| From | Must not depend on | Status |
|---|---|---|
| Error | Logging | **Not yet true** — `ErrorInfo.mqh` currently includes `LogLevel.mqh` |
| Logging | Error | True today |
| Types | anything | True today |
| BaseObject | anything | True today |
| Config | Logger / Platform | True today |
| Core | Trading / AI / UI | True today |

Do not describe Error/Logging isolation as complete elsewhere in this document or in `PROJECT_CONTEXT.md` until the `ErrorInfo.mqh` refactor (giving it its own severity type instead of `ENUM_LOG_LEVEL`) actually lands.

---

# 7. Include Policy

The project never uses global Include paths.

Correct:

```cpp
#include "../Types.mqh"
```

Incorrect:

```cpp
#include <Core/Types.mqh>
```

Every include must be relative to the current file.

This allows the entire project to remain portable inside the `Experts/AI_SwingBreakout_Pro` directory.

**Known violation:** `Include/Core/Error/TestErrorHandler.mqh` currently uses `#include <Core/Error/ErrorHandler.mqh>` (a global path). This needs correction — see `PROJECT_CONTEXT.md`, Known Issues.

**Confirmed exception — the root EA file.** `AI_SwingBreakout_Pro.mq5` lives at the project root, outside `Include/`. It is the only file in the project that prefixes framework includes with `Include/`:

```cpp
#include "Include/Core/Types.mqh"
```

Every file inside `Include/Core/...` is unaffected by this — it continues to resolve relative to its own folder exactly as described above. See DECISIONS.md, ADR-012.

---

# 8. Coding Principles

The project follows these principles:

* Single Responsibility Principle
* DRY (Don't Repeat Yourself)
* KISS (Keep It Simple)
* Explicit over implicit
* Prefer composition over inheritance
* One responsibility per module

---

# 9. Utility Classes

Utility classes follow a common pattern.

Example:

```cpp
class CMathUtils
{
public:
   static double Clamp(...);
   static double Normalize(...);
};
```

Rules:

* Static methods only
* No global variables
* Stateless implementation
* No hidden side effects

`CMathUtils` (rebuilt this cycle) fully complies. `CStringUtils` and `CTimeUtils` follow the same static-class shape but have not yet been reviewed line-by-line for compliance.

---

# 10. Development Workflow

Development is performed in vertical slices.

Each module is completed before introducing dependent modules.

Workflow:

1. Design
2. Complete implementation
3. Compile verification
4. Integration
5. Documentation update
6. Git commit

Partial implementations should not be committed.

---

# 11. GitHub Workflow

The GitHub repository is the single source of truth.

Development process:

1. Read repository state.
2. Review architecture.
3. Modify complete files.
4. Verify consistency.
5. Commit.
6. Continue with next module.

Repository documentation must always reflect the current implementation. When documentation and an actual repository export disagree, the repository wins, and documentation must be corrected — this is what happened in this revision.

---

# 12. Current Progress (Reconciled)

Completed and standards-compliant:

* Constants.mqh
* Types.mqh
* MathUtils.mqh (rebuilt this cycle)
* Config.mqh (finalized this cycle — header completed, log-level enum renamed to resolve collision with `Logging/LogLevel.mqh`, `VolumeMAPeriod` validation added; considered closed, no further changes planned)
* Platform.mqh (built this cycle — header completed, `Config()` accessor returns `const CConfig*` via `GetPointer()` since MQL5 does not support reference return types)
* TradeStructures.mqh
* MarketStructures.mqh
* RiskStructures.mqh
* AccountStructures.mqh
* StatisticsStructures.mqh

Framework layer — new this cycle, compiled clean:

* Context.mqh, Module.mqh, ModuleManager.mqh, Engine.mqh — `CModule`/`CContext` design per ADR-013. `CContext` injection standardized at the `CModule` base after an Initialize() signature-hiding defect was found and fixed (see CHANGELOG.md). Not yet integrated with a main EA composition root — `AI_SwingBreakout_Pro.mq5` doesn't yet construct or wire a `CContext`/`CModuleManager`.

Present, functional in scope, pending standards review:

* Base/BaseObject.mqh
* InputParameters.mqh
* Version.mqh
* Error/ (ErrorCodes, ErrorHandler, ErrorInfo, TestErrorHandler)
* Logging/ (Logger, LogLevel, LogRecord, DefaultLogFormatter, JournalLogOutput, ILogFormatter, ILogOutput)
* Utilities/ (StringUtils, TimeUtils)
* Tests/ (TestFramework.mqh, TestStringUtils.mq5/.ex5)

Next:

* ValidationUtils.mqh (not yet started)
* Wire Framework layer into `AI_SwingBreakout_Pro.mq5` (construct `CContext`, populate it, build a `CModuleManager`)
* Standards reconciliation pass over the "pending review" modules above

---

# 13. Long-Term Roadmap

Core Foundation

↓

Utilities

↓

Indicators

↓

Risk Engine

↓

Trading Engine

↓

AI Decision Engine

↓

Backtesting

↓

Optimization

↓

Production Release

---

# 14. Architecture Rules

The following rules are mandatory:

* Never use absolute Include paths.
* Never duplicate business logic.
* Keep Core independent.
* Generate complete source files for framework modules.
* Keep documentation synchronized with implementation.
* Treat GitHub as the authoritative project source.
* When documentation and the actual repository diverge, reconcile documentation to match the repository — do not assume prior documentation was correct.