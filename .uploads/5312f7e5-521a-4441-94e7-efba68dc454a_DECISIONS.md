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
