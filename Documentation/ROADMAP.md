# ROADMAP.md

# AI Swing Breakout Pro v2.0

## Development Roadmap

Current Version: **v2.0.0-alpha.2**

---

# Project Status

**Phase:** Active Development

**Goal:** Build a production-quality institutional trading framework for MetaTrader 5.

---

# Development Milestones

## Milestone 1 — Core Foundation

**Status:** In Progress

We'll complete the Core Foundation first. This establishes a reusable foundation for every future module.

### Core Modules

**Completed:**

* ✅ Version.mqh
* ✅ InputParameters.mqh
* ✅ Config.mqh
* ✅ LogLevel.mqh

**In Progress:**

* 🔄 BaseObject
* 🔄 LogRecord
* 🔄 ILogFormatter
* 🔄 ILogOutput
* 🔄 LogFormatter
* 🔄 JournalOutput
* 🔄 Logger

**Pending:**

* ⏳ ErrorHandler
* ⏳ Utilities
* ⏳ SymbolManager
* ⏳ IndicatorCache

Once these are finished, we'll have a reusable foundation for every future module.

---

## Milestone 2 — Market Engine

**Status:** Pending

Then the framework starts becoming a trading system.

### Trend Detection

* Trend Detection
* Swing Detection
* Breakout Detection

### Session Engine

* Market Structure
* Volatility Analysis

---

## Milestone 3 — Signal Engine

**Status:** Pending

### Signal Generation Pipeline

1. Market Snapshot
2. Rule Evaluation
3. Probability Score
4. Signal Generation

---

## Milestone 4 — Risk Engine

**Status:** Pending

### Risk Management Pipeline

1. Risk %
2. Position Size
3. Exposure Check
4. Trade Permission

---

## Milestone 5 — Trade Engine

**Status:** Pending

### Trade Execution Pipeline

1. Signal
2. Validation
3. Execution
4. Management
5. Statistics

---

# Repository Structure

Our End Goal: By the end of Version 2.0, the repository should look like something a professional development team could maintain.

```
AI_SwingBreakout_Pro/
├── Experts/
├── Include/
├── Documentation/
├── Tests/
├── Reports/
├── Presets/
├── Scripts/
├── Tools/
├── README.md
├── LICENSE
└── CHANGELOG.md
```

---

# Module Quality Standards

Every module will have:

* ✅ Professional documentation
* ✅ Clear architecture
* ✅ Unit tests (where practical)
* ✅ Consistent coding standards
* ✅ Clean compile
* ✅ Production-ready quality

---

# Development Commitment

We're going to hold ourselves to a very high standard throughout this project.

Before writing code, we'll recommend improvements in:

* Architecture
* Performance
* Memory usage
* MQL5 best practices
* Maintainability
* Testability
* Extensibility

We'll be careful to avoid unnecessary complexity so we keep delivering working, production-quality modules.

---

# Version Roadmap

## Version 2.0

Focus:

* Stable
* Modular
* Rule-Based
* Fully Tested
* Production Ready

Version 2.0 intentionally excludes AI decision making. The objective is to establish a robust and reliable trading framework.

---

## Version 3.0 (Future)

Planned enhancements:

* ONNX AI Integration
* Machine Learning Probability Engine
* Adaptive Market Regime Detection
* Portfolio Management
* Multi-Strategy Engine
* Cloud Configuration
* AI Optimization

---

# Testing Roadmap

## Unit Testing

Each module must compile and function independently.

---

## Integration Testing

Verify communication between modules.

---

## Strategy Testing

Validate entry and exit logic.

---

## Backtesting

Run historical tests across multiple symbols and timeframes.

---

## Optimization

Optimize key parameters:

* Risk %
* EMA Periods
* ATR Period
* ADX Threshold
* Probability Threshold
* Break-even Settings
* ATR Trailing Multiplier

---

## Walk-Forward Testing

Split historical data into:

* Training Period
* Validation Period
* Forward Period

Repeat across multiple market conditions.

---

## Demo Forward Testing

Minimum recommended duration:

* 30–90 trading days

Monitor:

* Stability
* Drawdown
* Win Rate
* Profit Factor
* Execution Reliability

---

# Release Plan

## Alpha

Core framework completed.

---

## Beta

All modules implemented.

---

## Release Candidate (RC)

Only bug fixes permitted.

---

## Production

Official Version 2.0 release.

---

# Long-Term Vision

Build a reusable institutional trading framework where new strategies can be added without modifying the Core, Risk, Trade, or Statistics modules.

Future strategy modules may include:

* Swing Breakout
* Trend Following
* Pullback
* Mean Reversion
* Scalping
* AI Strategy

The framework will serve as the foundation for all future trading systems.
