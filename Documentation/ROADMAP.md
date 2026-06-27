# ROADMAP.md

# AI Swing Breakout Pro v2.0

## Development Roadmap

Current Version: **v2.0.0-alpha.1**

---

# Project Status

**Phase:** Active Development

**Goal:** Build a production-quality institutional trading framework for MetaTrader 5.

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

# Development Milestones

## Milestone 1 — Core Framework

Status: **In Progress**

### Completed

* ✅ Version.mqh
* ✅ InputParameters.mqh
* ✅ Config.mqh

### In Progress

* 🔄 Logger.mqh

### Pending

* ⏳ ErrorHandler.mqh
* ⏳ Utilities.mqh
* ⏳ SymbolManager.mqh
* ⏳ IndicatorCache.mqh
* ⏳ MarketSnapshot.mqh
* ⏳ Dashboard.mqh

---

## Milestone 2 — Indicator Engine

Status: Pending

Modules:

* EMA
* ATR
* ADX
* Volume
* Spread
* Indicator Cache Integration

---

## Milestone 3 — Market Engine

Status: Pending

Modules:

* Trend Detector
* Swing Detector
* Breakout Detector
* Market Structure
* Session Filter
* Volatility Filter
* Market Regime Detection

---

## Milestone 4 — Signal Engine

Status: Pending

Modules:

* Entry Validation
* Probability Calculation
* Buy Signal
* Sell Signal
* Signal Confirmation

---

## Milestone 5 — Risk Engine

Status: Pending

Modules:

* Position Sizing
* Maximum Daily Loss
* Maximum Open Positions
* Break-even
* ATR Trailing Stop
* Partial Close
* Exposure Control

---

## Milestone 6 — Trade Engine

Status: Pending

Modules:

* Order Execution
* Order Validation
* Pending Orders
* Position Management
* Retry Logic
* Error Recovery

---

## Milestone 7 — Statistics & Dashboard

Status: Pending

Modules:

* Dashboard
* Trade Statistics
* Daily Performance
* Monthly Performance
* CSV Export
* Journal Export

---

## Milestone 8 — Production Release

Status: Pending

Tasks:

* Full Integration
* Compile Verification
* Strategy Testing
* Parameter Optimization
* Walk-Forward Testing
* Demo Forward Test
* Production Release

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
