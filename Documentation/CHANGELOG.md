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

# Version 2.0.0-alpha.3

**Status**

Active Development

**Date**

July 2026

---

# Summary

This release rebuilds `MathUtils.mqh` and reconciles all project documentation against the actual contents of the repository, after an export of the real project directory revealed significantly more implemented code than previous documentation tracked.

---

# Added

## Core

Rebuilt

```text
MathUtils.mqh
```

Complete rewrite. Static-only `CMathUtils`, epsilon comparisons sourced from `CConstants::EPSILON`/consumer-supplied values, no Trading/Risk domain logic mixed in (per ADR-003). Includes floating-point comparison, range/clamp utilities, safe arithmetic, percentage helpers, angle conversion, and array-based statistics (mean, variance, standard deviation, median).

---

## Documentation

Reconciled to match an actual repository export:

* PROJECT_CONTEXT.md
* ARCHITECTURE.md
* ROADMAP.md
* CHANGELOG.md (this file)
* DECISIONS.md (new ADR-011)

---

# Fixed

## MathUtils.mqh — Structural Scope Bug

The previous implementation was not simply incomplete — its `class CMathUtils { ... }` body closed after the first section (`Basic Math`), leaving approximately 480 subsequent lines (price math, statistics, trading/risk formulas, safe-math helpers) declared as `static` methods **outside any class**. Any call site using `CMathUtils::NormalizePrice(...)` or similar would have failed to compile. The file also hardcoded its epsilon value (`1e-9`) instead of referencing `CConstants::EPSILON`, decoupling it from the rest of Core.

## MathUtils.mqh — Compile Errors on First Build ("constant expected")

The rebuilt file's first compile attempt produced 8 "constant expected" errors, all on methods using `epsilon = CConstants::EPSILON` as a default parameter value. Root cause: MQL5 does not accept a static class member as a default parameter value, even when that member is declared `const`. Only true compile-time literals are accepted in that position.

Resolved by splitting each affected method into a two-overload pair:

```cpp
static bool IsEqual(const double a, const double b);
static bool IsEqual(const double a, const double b, const double epsilon);
```

The no-epsilon overload calls the explicit-epsilon overload, passing `CConstants::EPSILON` as an ordinary argument (legal at any call site — the restriction is specific to default-parameter *declarations*). Applied to `IsEqual`, `IsZero`, `IsGreater`, `IsLess`, `IsGreaterOrEqual`, `IsLessOrEqual`, `IsBetween`, and `Sign`. Caller-facing behavior is unchanged. Re-verified in MetaEditor: **0 errors, 0 warnings**.

---

# Discovered (Repository Reconciliation)

An export of the actual project directory was reviewed this cycle. It contained the following modules, none of which were tracked in any previous version of `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, `ROADMAP.md`, or this file:

```text
Include/Core/Base/BaseObject.mqh
Include/Core/Config.mqh
Include/Core/InputParameters.mqh
Include/Core/Version.mqh
Include/Core/Error/ErrorCodes.mqh
Include/Core/Error/ErrorHandler.mqh
Include/Core/Error/ErrorInfo.mqh
Include/Core/Error/TestErrorHandler.mqh
Include/Core/Logging/Logger.mqh
Include/Core/Logging/LogLevel.mqh
Include/Core/Logging/LogRecord.mqh
Include/Core/Logging/DefaultLogFormatter.mqh
Include/Core/Logging/JournalLogOutput.mqh
Include/Core/Logging/Interfaces/ILogFormatter.mqh
Include/Core/Logging/Interfaces/ILogOutput.mqh
Include/Core/Utilities/StringUtils.mqh
Include/Core/Utilities/TimeUtils.mqh
Include/Tests/Framework/TestFramework.mqh
Include/Tests/Core/Utilities/TestStringUtils.mq5 (+ compiled .ex5)
```

These modules are functional in scope (error handling, logging subsystem, string/time utilities, EA input parameters, configuration, versioning, and a working test framework with one test suite) but were authored outside the documented Sprint workflow — file headers credit "OpenAI & Project Team" / "AI Swing Breakout Team" rather than the current process — and have not been reviewed for `CODING_STANDARD.md` compliance.

A top-level `AI_SwingBreakout_Pro.rar` archive was also found in the project root; its purpose is unverified and it may be a stale backup.

---

# Known Issues

## Newly Identified (Standards Compliance)

* Legacy modules use `__NAME_MQH__` include guards instead of the project's `AI_SWINGBREAKOUT_CORE_NAME_MQH` convention.
* Legacy modules use `ENUM_X`-style enum naming instead of the `EX` PascalCase convention.
* `Error/TestErrorHandler.mqh` uses an absolute/global include path (`#include <Core/Error/ErrorHandler.mqh>`), violating the Include Policy.
* Version strings are inconsistent across legacy files (`1.0.0`, `2.0.0-alpha`, `2.0.0-alpha.2`).
* Several legacy file headers omit the `Module` and `Author: ZiXXXiZ` lines required by `CODING_STANDARD.md`.
* `AI_SwingBreakout_Pro.rar` in the project root is unverified.

A full correctness/compliance audit of these modules was deliberately deferred this cycle — see DECISIONS.md, ADR-011 — in favor of first bringing documentation in line with reality.

## Carried Forward

* None. `MathUtils.mqh` has been compile-verified in MetaEditor (0 errors, 0 warnings) — see **Fixed**, below.

---

# Engineering Decisions Introduced

* ADR-011: Documentation Reconciliation & Legacy Module Policy — see `DECISIONS.md`.

---

# Project Status

Current Phase

```text
Foundation Layer
```

Overall Progress (revised)

```text
Approximately 30% (up from a previously-reported 20%, reflecting reconciliation with actual repository contents — not equivalent new work performed this cycle)
```

Current Sprint

```text
Sprint 005 — Platform Services
```

Current Task

```text
Build Include/Core/Platform.mqh
```

---

# Next Milestone

Version

```text
2.0.0-alpha.4
```

Expected deliverables:

* Platform.mqh
* ValidationUtils.mqh
* Sprint 006 kickoff: legacy module standards reconciliation