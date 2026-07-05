# AI Swing Breakout Pro Framework

# DECISIONS

**Version:** 2.0.0-alpha.2
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

### Context

Architecture evolved faster than documentation.

This created inconsistent project knowledge.

### Decision

Whenever architecture changes:

Update:

* PROJECT_CONTEXT.md
* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md

before continuing development.

### Consequences

Documentation always reflects implementation.

Future AI sessions immediately understand project status.

---

# ADR-006

## Title

Production Quality Only

**Status**

Accepted

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

---

# ADR-008

## Title

Static Utility Classes

**Status**

Accepted

### Context

Utility classes maintain no state.

Creating instances provides no benefit.

### Decision

Utility classes should expose only static methods.

Example:

```cpp
class CMathUtils
{
public:
   static double Clamp(...);
};
```

### Consequences

No unnecessary object creation.

Cleaner API.

Simpler usage.

---

# ADR-009

## Title

Framework Development Workflow

**Status**

Accepted

### Decision

Every module follows:

1. Architecture review
2. Complete implementation
3. Compile verification
4. Integration verification
5. Documentation update
6. Git commit

Development proceeds to the next module only after the current module reaches Definition of Done.

### Consequences

Repository remains stable.

Each commit represents a usable state.

---

# ADR-010

## Title

LDN Workflow Command

**Status**

Accepted

### Context

Repeated explanations reduced development efficiency.

### Decision

The keyword:

```
LDN
```

means:

```
Let Do Next
```

The AI should immediately continue with the next planned task without repeating previous explanations unless clarification is required.

### Consequences

Development becomes faster.

Conversation remains focused on implementation.

---

# ADR-011

## Title

Documentation Reconciliation & Legacy Module Policy

**Status**

Accepted

**Date**

July 2026

### Context

An export of the actual `AI_SwingBreakout_Pro` project directory was reviewed and found to contain substantially more implemented code than `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, `ROADMAP.md`, and `CHANGELOG.md` tracked at the time — including a full Error-handling subsystem, a full Logging subsystem, `Config.mqh`, `InputParameters.mqh`, `Version.mqh`, `BaseObject.mqh`, string/time utilities, and a working test framework with one test suite.

These modules were authored outside the documented Sprint workflow (file headers credit different authorship than the current process) and use conventions that diverge from `CODING_STANDARD.md` in several concrete ways: non-standard include guards, non-standard enum naming, at least one absolute include path, and inconsistent version strings.

Separately, the previously-tracked `Include/Core/MathUtils.mqh` was found to have a structural scope bug — its class body closed early, leaving roughly 480 lines of intended methods floating outside the class — confirming the rebuild that ADR-004 and prior Sprint 004 planning anticipated.

### Decision

1. Documentation is reconciled to match the actual repository state whenever the two are found to disagree. The repository is ground truth; documentation is corrected to it, not the reverse.
2. Newly-discovered legacy modules are recorded in documentation as **"present, pending standards review"** — a distinct status from "Completed." They are not deleted, rewritten wholesale, or silently accepted as compliant.
3. A full line-by-line correctness/compliance audit of these legacy modules is explicitly deferred to a dedicated future sprint (Sprint 006), rather than performed reactively during reconciliation. Reconciliation's job is to make documentation honest about what exists; it is not a substitute for review.
4. Known, concretely-observed deviations (include guard style, enum naming, the absolute include in `Error/TestErrorHandler.mqh`) are logged now, even though a full audit has not been performed, so they aren't lost before Sprint 006 begins.
5. Formulas discovered in the broken legacy `MathUtils.mqh` that are logically sound but architecturally misplaced (e.g. `PositionSize`, `RiskOfRuin`, `ProfitFactor`) are earmarked for salvage into the future Risk module rather than being discarded or re-derived from scratch later.

### Consequences

Documentation temporarily reports lower confidence ("pending review") for a larger share of the codebase than before, even though more code exists. This is intentional — it is more accurate than the previous state, where undocumented code carried an implicit, unverified assumption of correctness.

Progress percentages increase to reflect real repository contents, but are annotated to make clear that the increase reflects discovery, not new work performed in this cycle.

Sprint 006 (Legacy Standards Reconciliation) is added to the roadmap as a prerequisite to treating these modules as equivalent in trust to the modules built under the documented workflow.

---

# ADR-012

## Title

Root EA Include Convention & Core Subsystem Isolation (Error / Logging)

**Status**

Accepted — partially implemented (see Consequences)

**Date**

July 2026

### Context

Two related items surfaced this cycle:

**(a) Main EA file location.** `AI_SwingBreakout_Pro.mq5` lives at the project root (`AI_SwingBreakout_Pro/AI_SwingBreakout_Pro.mq5`), a sibling of `Include/`, `Documentation/`, `Source/`, `Tests/`, `Resources/` — not inside `Include/`. This was not previously documented anywhere.

**(b) A proposed "Core Architecture Lock."** A set of stricter dependency rules was proposed for Core: a one-way flow (`Base → Types/Constants/Version → Logging/Error (parallel) → feature modules`), a forbidden-dependency table, and a rule that `Core/Error` and `Core/Logging` must never include each other. The original proposal also stated includes should never use `../` backtracking, giving `#include "Logging/LogLevel.mqh"` as a correct example.

That specific example is incorrect for this project's actual folder layout and must not be adopted as written. MQL5 resolves relative `#include` paths against the *including file's own directory*, not against `Include/` as a project root. A file in `Core/Error/` reaching into the sibling folder `Core/Logging/` requires `../Logging/LogLevel.mqh` — `"Logging/LogLevel.mqh"` from that location would resolve to the nonexistent `Core/Error/Logging/...` and fail to compile. Banning `../` outright would break every legitimate sibling-folder include already in use across `Structures/`, `Utilities/`, `Base/`, and `Logging/Interfaces/`.

Separately, `Core/Error/ErrorInfo.mqh` currently includes `../Logging/LogLevel.mqh` and uses `ENUM_LOG_LEVEL` for its `Severity` field. This is a real, present-day dependency of Error on Logging — the forbidden-dependency table's "Error must not depend on Logging" rule is not yet true of the actual codebase.

### Decision

1. **Root EA include rule (adopted and in effect):** `AI_SwingBreakout_Pro.mq5`, being the one project file that lives outside `Include/`, must prefix every framework include with `Include/` — e.g. `#include "Include/Core/Types.mqh"`. Every file *inside* `Include/Core/...` continues to use ordinary relative paths (`"Constants.mqh"`, `"../Logging/LogLevel.mqh"`, etc.) exactly as ADR-002 already established. This is a clarification of ADR-002 for the one file it didn't previously cover, not a change to ADR-002 itself.
2. **One-way dependency flow and forbidden-dependency table (adopted as target design):** `Base → Types/Constants/Version → Logging/Error (parallel, mutually isolated) → feature modules (Trading/AI/Risk/UI)`. This extends ADR-003 (Core independence) with finer-grained rules *within* Core.
3. **Error/Logging mutual isolation (adopted as target design, NOT yet implemented):** `Core/Error` must not depend on `Core/Logging` and vice versa. Since `ErrorInfo.mqh` currently violates this, the rule is accepted as a goal, tracked as a concrete Sprint 006 task (give `SErrorInfo.Severity` its own type instead of borrowing `ENUM_LOG_LEVEL`), and is not to be described as already true in any other document until that refactor lands.
4. **The "no `../`" include rule from the original proposal is rejected as written**, since it does not match how MQL5 resolves relative includes and would break existing, correct code. The project's include rule remains what ADR-002 and `CODING_STANDARD.md` already specify: relative to the including file, with `../` used freely for sibling/parent traversal. The only addition is item 1, above.
5. **No cross-module enum sharing (adopted as target design for new code):** new subsystems should own their own enums rather than reaching into a sibling subsystem's types. This is a preference for new work, not a mandate to immediately refactor already-shared types outside of the specific Error/Logging case in item 3.

### Consequences

- `AI_SwingBreakout_Pro.mq5` can be written correctly today using the rule in item 1 — no code currently depends on this being fixed later.
- Items 2–3 are **design intent, not current fact**. `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, and `ROADMAP.md` reflect this distinction explicitly (see their "planned" / "not yet implemented" language) so a future session doesn't assume the isolation already exists.
- Sprint 006 (Legacy Standards Reconciliation) gains a concrete, scoped task: decouple `ErrorInfo.mqh` from `LogLevel.mqh`.
- No file's actual include statements change as a result of this ADR alone, except future new code being written to the target design from now on.

---

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
3. `CContext`'s `Platform()`/`Logger()`/`ErrorHandler()` getters are `const`, so `CModule::Context()` can return `const CContext*` — derived modules can use every service reachable through the context, but cannot rewire the context itself (no calling `SetPlatform`/`SetLogger`/`SetErrorHandler` through a const pointer).
4. `CModuleManager` does not own registered modules — it does not delete them in `Shutdown()` or a destructor. The caller that creates a module remains responsible for its lifetime. This mirrors `CContext`'s existing non-owning design rather than introducing a second, inconsistent ownership model within the same layer.
5. Going forward, any class hierarchy in this project with a virtual method meant to be overridden must be reviewed for exact signature match before being considered done — a mismatched override is not caught by compilation and will not produce a warning.

### Consequences

- Future Trading/Risk/AI modules get context access "for free" by inheriting from `CModule`, rather than each needing to duplicate `m_context` storage and validation the way `CEngine` originally did.
- `CModuleManager` growing a destructor that deletes modules later, if that's ever wanted, is a deliberate design change requiring a new ADR — not an oversight to silently fix.
- `ARCHITECTURE.md` and `ROADMAP.md` require updates to reflect this layer's existence (folder structure, dependency diagram, sprint history) — tracked as part of this same documentation pass rather than deferred, unlike some earlier legacy-module findings, because this layer was built this cycle rather than discovered as pre-existing.

---

# Future Decisions

Add new decisions instead of modifying historical ones.

If a decision changes:

* mark the previous decision as **Superseded**
* create a new ADR
* explain the reason for the change

This preserves the architectural history of the project.

---

# Guiding Principle

A good architecture is not defined only by the code that exists.

It is also defined by the reasoning behind every important decision.

This document preserves that reasoning so the project can evolve consistently over time.