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