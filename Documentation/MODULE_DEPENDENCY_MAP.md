# MODULE_DEPENDENCY_MAP.md

# AI Swing Breakout Pro v2.0

## Module Dependency Map

Version: **2.0.0-alpha.2**

---

# Purpose

This document defines the dependency rules for every module in the AI Swing Breakout Pro framework.

Its objectives are to:

* Prevent circular dependencies
* Maintain a clean layered architecture
* Simplify maintenance
* Improve testability
* Ensure long-term scalability

Every new module must comply with these dependency rules.

---

# Architecture Layers

```text
                    AI Swing Breakout Pro

──────────────────────────────────────────────────────────────

APPLICATION LAYER

AI_SwingBreakout_Pro.mq5
Bootstrap
Dashboard

──────────────────────────────────────────────────────────────

BUSINESS LAYER

Market Engine
Signal Engine
Risk Engine
Trade Engine
Statistics Engine

──────────────────────────────────────────────────────────────

INFRASTRUCTURE LAYER

Core/
├── Config
├── Logging
├── ErrorHandler
├── Utilities
├── SymbolManager
├── IndicatorCache
└── Version

──────────────────────────────────────────────────────────────

STRATEGY LAYER

Strategies/
└── SwingBreakout

──────────────────────────────────────────────────────────────
```

---

# Dependency Flow

Dependencies must always flow downward.

```text
Application
      │
      ▼
Business
      │
      ▼
Infrastructure

Strategy
      │
      ▼
Business
      │
      ▼
Infrastructure
```

Reverse dependencies are **not allowed**.

---

# Allowed Dependencies

## Application Layer

May depend on:

* Business Layer
* Infrastructure Layer

Must **not** contain trading logic.

---

## Strategy Layer

May depend on:

* Signal Engine
* Risk Engine
* Market Engine
* Infrastructure Layer

Must **not** communicate directly with the Trade Engine.

All trade execution should pass through the Signal and Risk workflow.

---

## Market Engine

May depend on:

* IndicatorCache
* SymbolManager
* Utilities
* Config
* Logger

Must **not** depend on:

* Trade Engine
* Statistics Engine
* Dashboard

---

## Signal Engine

May depend on:

* Market Engine
* Config
* Logger

Must **not** depend on:

* Trade Engine
* Dashboard

---

## Risk Engine

May depend on:

* Signal Engine
* Config
* Logger

Must **not** depend on:

* Dashboard

---

## Trade Engine

May depend on:

* Risk Engine
* Logger
* ErrorHandler
* SymbolManager

Must **not** generate trading signals.

---

## Statistics Engine

May depend on:

* Trade Engine
* Logger

Must never influence trading decisions.

---

## Dashboard

May depend on:

* Statistics Engine
* Market Engine
* Config

Dashboard is read-only.

It must never modify trading behavior.

---

# Infrastructure Dependencies

Infrastructure modules should not depend on Business modules.

Allowed relationships:

```text
Logger
   ↑
ErrorHandler

Config
   ↑
SymbolManager

IndicatorCache
   ↑
Market Engine
```

Infrastructure should remain reusable across strategies.

---

# Logging Subsystem

```text
Logger
│
├── LogLevel
├── LogRecord
├── LogFormatter
└── LogOutput
```

Dependency order:

```text
LogLevel
      │
      ▼
LogRecord
      │
      ▼
LogFormatter
      │
      ▼
LogOutput
      │
      ▼
Logger
```

No reverse dependencies are permitted.

---

# Circular Dependency Rules

The following are prohibited:

* Market ↔ Signal
* Risk ↔ Trade
* Dashboard ↔ Trade
* Logger ↔ Business Modules

If a circular dependency appears necessary, redesign the architecture instead.

---

# Future Strategy Integration

New strategy modules should depend only on the public interfaces of the Business and Infrastructure layers.

Example:

```text
Strategies/
├── SwingBreakout
├── TrendFollowing
├── Pullback
├── MeanReversion
├── Scalping
└── AIStrategy
```

Adding a new strategy must not require changes to:

* Core
* Logging
* Risk Engine
* Trade Engine
* Statistics Engine

---

# Dependency Validation Checklist

Before adding a new module:

* Does it belong to the correct layer?
* Does it depend only on permitted modules?
* Does it introduce a circular dependency?
* Can it be unit tested independently?
* Can it be reused by another strategy?

If any answer is **No**, review the design before implementation.

---

# Guiding Principle

> **Dependencies should always point toward stable, reusable infrastructure. Business logic should depend on services—not the other way around.**

Following this rule keeps the framework modular, maintainable, and extensible as new strategies and features are added over time.
