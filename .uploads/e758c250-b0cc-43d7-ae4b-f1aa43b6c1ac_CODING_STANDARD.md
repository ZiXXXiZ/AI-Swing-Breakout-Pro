# AI Swing Breakout Pro Framework

# CODING_STANDARD

**Version:** 2.0.0-alpha.2
**Status:** Active Development
**Last Updated:** July 2026

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
//| Version : 2.0.0-alpha.2                                          |
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

---

# 6. Dependency Rules

Dependencies always point downward.

```
AI
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
```

Core never depends on higher-level modules.

Circular dependencies are prohibited.

---

# 7. Naming Conventions

## Classes

```cpp
CMathUtils
CLogger
CPlatform
CRiskManager
```

Prefix:

```
C
```

---

## Structures

```cpp
STradeSignal
SPositionInfo
SAccountInfo
```

Prefix:

```
S
```

---

## Enumerations

```cpp
ETradeDirection
EOrderType
ERiskMode
```

Prefix:

```
E
```

---

## Constants

```cpp
MAX_RETRY
DEFAULT_TIMEOUT
INVALID_PRICE
```

UPPER_CASE only.

---

## Member Variables

```cpp
m_balance
m_symbol
m_logger
```

Prefix:

```
m_
```

---

## Static Constants

```cpp
DEFAULT_EPSILON
MAX_HISTORY
```

UPPER_CASE.

---

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

Avoid excessively long functions.

Target:

* 10–40 lines

Maximum:

* ~80 lines

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

# 11. Floating Point Rules

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

# 12. Data Structures

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

# 13. Comments

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

# 14. Performance Guidelines

Avoid:

* unnecessary copies
* repeated calculations
* dynamic allocations inside loops

Prefer:

* const references
* cached values
* stack allocation

---

# 15. Git Workflow

The GitHub repository is the single source of truth.

Every completed feature should follow:

1. Implement
2. Compile
3. Review
4. Update documentation
5. Commit

Do not commit partially completed framework modules.

---

# 16. Development Workflow

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

# 17. Documentation Rules

Whenever architecture or coding practices change, update:

* ARCHITECTURE.md
* CODING_STANDARD.md
* ROADMAP.md
* CHANGELOG.md
* PROJECT_CONTEXT.md

Documentation should always match the implementation.

---

# 18. Project Standards

Mandatory rules:

* Production-quality code only.
* No placeholder implementations.
* No duplicate logic.
* No circular dependencies.
* Use relative include paths only.
* Keep Core independent.
* Build complete source files.
* Maintain repository consistency.
* Keep documentation synchronized.
* Treat GitHub as the authoritative project source.

---

# 19. Code Review Checklist

Before completing any module, verify:

* Compiles without errors.
* Correct include paths.
* No duplicated code.
* Consistent naming.
* Proper formatting.
* Dependency rules respected.
* Documentation updated.
* Ready for Git commit.

Every file merged into the repository should meet this checklist.
