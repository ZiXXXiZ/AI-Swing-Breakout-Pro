# AI Swing Breakout Pro Framework

# CODING_STANDARD

**Version:** 2.0.0-alpha.13
**Status:** Active Development
**Last Updated:** July 12, 2026

---

# 1. Purpose

This document defines the coding standards for the AI Swing Breakout Pro framework.

The objectives are:

* Consistent code style
* Production-quality source code
* Easy maintenance
* Easy code review
* High performance
* Low coupling
* High readability

Every source file in this project must follow these standards.

---

# 2. General Principles

Follow these principles at all times:

* SOLID
* DRY (Don't Repeat Yourself)
* KISS (Keep It Simple)
* Explicit over implicit
* Readability over cleverness
* Performance with clarity

**Exception to DRY (Safety Redundancy):** In mission-critical execution paths (e.g., final trade validation), safety redundancy supersedes DRY. Intentional duplication is permitted *only* if it mathematically isolates a module from external framework failures to prevent a Single Point of Failure (SPOF). Such exceptions must be accompanied by an explicit `// Intentional defensive copy` comment.

Code should be understandable without additional explanation.

---

# 3. File Organization

Every source file should follow this layout:

```cpp
Header Comment

Include Files

Constants

Enums

Structures

Classes

Implementation

End Guard
```

One responsibility per file.

---

# 4. Header Format

Every file begins with:

```cpp
//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Example.mqh                                            |
//| Purpose : Description                                             |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
```

Header format must remain consistent across the project.

---

# 5. Include Policy

Always use project-relative include paths.

Correct:

```cpp
#include "../Types.mqh"
```

Correct:

```cpp
#include "Constants.mqh"
```

Never use:

```cpp
#include <Core/Types.mqh>
```

Never depend on the MetaTrader global Include folder.

The project must compile entirely inside:

```
Experts/
    AI_SwingBreakout_Pro/
```

**Exception — the root EA file.** `AI_SwingBreakout_Pro.mq5` lives at the project root, a sibling of `Include/`, not inside it. As the only project file outside `Include/`, it prefixes framework includes accordingly:

```cpp
#include "Include/Core/Types.mqh"
#include "Include/Core/Error/ErrorHandler.mqh"
```

Every file inside `Include/Core/...` is unaffected and continues to use ordinary relative paths as shown above (`"Constants.mqh"`, `"../Logging/LogLevel.mqh"`, etc.). See DECISIONS.md, ADR-012.

---

# 6. Dependency Rules

Dependencies always point downward.

```
Application (EA)
         ↓
Trading (+ CBasketManager)     [Phase 9b]
         ↓
Risk (+ CGridRisk)             [Phase 9b]
         ↓
Signals
         ↓
Analysis (SRDetector)          [Phase 9b]
         ↓
Indicators (+ BollingerBands)  [Phase 9b]
         ↓
MarketData (CMarketDataProvider)
         ↓
Framework
         ↓
Core
```

Core never depends on higher-level modules.

Framework never depends on MarketData or any layer above it.

MarketData never depends on Indicators or any layer above it.

Indicators never depend on Analysis or any layer above it.

Analysis never depends on Signals or any layer above it.

Signals never depend on Risk or any layer above it.

Risk never depends on Trading.

Circular dependencies are prohibited.

**Forbidden dependencies include (but are not limited to):**

* Core → any layer above
* Framework → MarketData, Indicators, Analysis, Signals, Risk, or Trading
* MarketData → Indicators, Analysis, Signals, Risk, or Trading
* Indicators → Analysis, Signals, Risk, or Trading
* Analysis → Signals, Risk, or Trading
* Signals → Risk or Trading
* Risk → Trading

**Target design for Core subsystems (ADR-012):** `Core/Error` and `Core/Logging` should not depend on each other, and new subsystems should generally own their own enums rather than importing a sibling subsystem's types. This is the direction new code should follow. It is not yet fully true of the existing codebase — `ErrorInfo.mqh` currently depends on `LogLevel.mqh` — so don't assume this isolation exists elsewhere until `PROJECT_CONTEXT.md`/`ROADMAP.md` mark it done.

---

# 7. Naming Conventions

## Classes

```cpp
CMathUtils
CLogger
CPlatform
CRiskManager
```

Prefix: `C`

## Structures

```cpp
STradeSignal
SPositionInfo
SAccountInfo
```

Prefix: `S`

## Enumerations

```cpp
ETradeDirection
EOrderType
ERiskMode
```

Prefix: `E`

## Constants

```cpp
MAX_RETRY
DEFAULT_TIMEOUT
INVALID_PRICE
```

UPPER_CASE only.

## Member Variables

```cpp
m_balance
m_symbol
m_logger
```

Prefix: `m_`

## Static Constants

```cpp
DEFAULT_EPSILON
MAX_HISTORY
```

UPPER_CASE.

## Functions

Use PascalCase.
Correct:

```cpp
CalculateRisk()
NormalizePrice()
UpdatePosition()
```

Avoid abbreviations unless they are industry standard.

---

# 8. Class Design

Utility classes should:

* be stateless
* expose only static methods
* contain no global state
* avoid hidden side effects

Example:

```cpp
class CMathUtils
{
public:
   static double Clamp(...);
   static double Normalize(...);
   static double Mean(...);
};
```

---

# 9. Function Design

Functions should:

* perform one task only
* return predictable results
* validate inputs
* avoid unnecessary allocations

**No Magic Numbers:** Hardcoded numerical values (e.g., `0.0001`, `10`, `50`) are strictly forbidden inside trading or indicator logic. All parameters, slippage limits, and threshold values must be defined in `Constants.mqh`, `Config.mqh`, or passed dynamically as variables.

Avoid excessively long functions.
Target: 10–40 lines
Maximum: ~80 lines

---

# 10. Error Handling

Never ignore failures.

Validate:

* pointers
* arrays
* division
* broker data
* market data
* symbol information

Prefer safe helper functions.
Example:

```cpp
SafeDivide()
SafeLog()
SafeSqrt()
```

---

# 11. Memory Management & Pointers

MQL5 does not have automated garbage collection for objects created with the `new` keyword.

* **Pointer Ownership:** Clearly distinguish between "Owning" and "Non-owning" pointers. If a class (like `CEngine`) holds a pointer but did not create it via `new`, it must never call `delete` on it.
* **Validation Check:** Always use `CheckPointer(ptr) != POINTER_INVALID` alongside simple `NULL` checks before dereferencing objects passed from outside.

---

# 12. Floating Point Rules

Never compare floating-point values directly.

Incorrect:

```cpp
if(a == b)
```

Correct:

```cpp
if(CMathUtils::IsEqual(a,b))
```

Use a single project-wide epsilon value.

---

# 13. Data Structures

Structure files contain data only.

Allowed:

* members
* constructors
* Reset()
* IsValid()

Not allowed:

* trading logic
* broker access
* order execution
* indicator calculations

---

# 14. Comments

Comment intent, not obvious code.

Good:

```cpp
// Prevent division by zero
```

Bad:

```cpp
// Add one
i++;
```

Every public class should include a brief description.

---

# 15. Logging Standards

Explicitly log system state to ensure the EA is highly debuggable in a live market environment.

* All failed state validations (e.g., invalid signals, rejected risk checks, failed order placements) must generate an explicit log entry containing the symbol, timestamp, and specific rejection reason.

---

# 16. Performance Guidelines

Avoid:

* unnecessary copies
* repeated calculations
* dynamic allocations inside loops

Prefer:

* const references
* cached values
* stack allocation

---

# 17. Git Workflow

The GitHub repository is the single source of truth.

Every completed feature should follow:

1. Implement
2. Compile
3. Review
4. Update documentation
5. Commit

Do not commit partially completed framework modules.

---

# 18. Development Workflow

Large framework files must be developed as complete units.

Workflow:

1. Architecture review
2. Complete implementation
3. Compile verification
4. Integration verification
5. Documentation update
6. Git commit

Avoid assembling files from fragmented snippets.

---

# 19. Documentation Rules

Whenever architecture or coding practices change, update:

* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md
* PROJECT_CONTEXT.md

Documentation should always match the implementation.

---

# 20. Project Standards

Mandatory rules:

* Production-quality code only.
* No placeholder implementations.
* No duplicate logic (except explicit defensive copies).
* No circular dependencies.
* Use relative include paths only.
* Keep Core independent.
* Build complete source files.
* Maintain repository consistency.
* Keep documentation synchronized.
* Treat GitHub as the authoritative project source.

---

# 21. Code Review Checklist

Before completing any module, verify:

* Compiles without errors.
* Correct include paths.
* No duplicated code (unless explicitly marked as a defensive copy).
* Consistent naming.
* Proper formatting.
* Dependency rules respected.
* Documentation updated.
* Ready for Git commit.

Every file merged into the repository should meet this checklist.
```

---

**All required fixes applied:**

| Issue | Section | Action |
|-------|---------|--------|
| Fix 1 | Section 6 — Dependency Rules | Added full layer chain including `Signals`, `Analysis`, and `MarketData`; expanded forbidden dependencies list |
| Fix 2 | Document Header | Version `2.0.0-alpha.3` → `2.0.0-alpha.13`; date updated to `July 12, 2026` |
| Optional | Section 6 — MarketData | Included in chain and forbidden list for completeness |