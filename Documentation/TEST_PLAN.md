# TEST_PLAN.md

# AI Swing Breakout Pro v2.0

## Test Plan

Version: **2.0.0-alpha.1**

---

# Purpose

This document defines the testing methodology for the AI Swing Breakout Pro framework.

The objective is to ensure that every module is:

* Correct
* Stable
* Reliable
* Performant
* Production Ready

Testing is mandatory before code is merged into the main branch or included in a release.

---

# Testing Philosophy

The framework follows a layered testing approach:

1. Compile Verification
2. Static Validation
3. Unit Testing
4. Integration Testing
5. Strategy Testing
6. Backtesting
7. Optimization
8. Walk-Forward Testing
9. Demo Forward Testing
10. Production Monitoring

Each stage must be completed successfully before advancing to the next.

---

# Test Environment

## Software

* MetaTrader 5 (Latest Stable Version)
* MetaEditor
* Windows 10 or later

---

## Broker

Recommended:

* ECN Broker
* Low latency
* Stable execution
* Real tick historical data

---

## Hardware

Recommended:

* 8 GB RAM minimum
* SSD storage
* Stable Internet connection
* VPS for long-term testing

---

# Stage 1 – Compile Verification

Objective:

Verify that the project compiles successfully.

Requirements:

* Zero compiler errors
* Zero compiler warnings
* All include files found
* No missing dependencies

Pass Criteria:

✔ Build succeeds without warnings or errors.

---

# Stage 2 – Static Validation

Verify:

* Configuration validation
* Input ranges
* Indicator handles
* Resource initialization
* File paths
* Symbol information

Expected Result:

Initialization succeeds without runtime errors.

---

# Stage 3 – Unit Testing

Each module is tested independently.

Modules include:

* Version
* Config
* Logger
* ErrorHandler
* Utilities
* SymbolManager
* IndicatorCache
* Dashboard

For every module verify:

* Initialization
* Expected outputs
* Error handling
* Boundary conditions
* Resource cleanup

---

# Stage 4 – Integration Testing

Verify interaction between modules.

Examples:

Config → Logger

Logger → ErrorHandler

Market → Signal

Risk → Trade

Trade → Statistics

Dashboard → Statistics

Expected Result:

Modules communicate correctly without dependency conflicts.

---

# Stage 5 – Strategy Testing

Verify trading logic.

Test:

* Buy signals
* Sell signals
* No-signal conditions
* Breakout detection
* Trend filtering
* Session filtering
* Risk validation

Expected Result:

Signals match the strategy rules defined in the project documentation.

---

# Stage 6 – Backtesting

Run historical simulations using MetaTrader Strategy Tester.

Recommended data quality:

* Real ticks
* Maximum available history

Test multiple:

* Symbols
* Timeframes
* Market conditions

Collect metrics:

* Net Profit
* Profit Factor
* Win Rate
* Drawdown
* Recovery Factor
* Average R:R
* Trade Count

---

# Stage 7 – Optimization

Optimize selected parameters only.

Recommended parameters:

* Fast EMA
* Slow EMA
* ATR Period
* ADX Threshold
* Probability Threshold
* ATR Trailing Multiplier
* Break-even Trigger

Guidelines:

* Change a limited number of parameters at once.
* Avoid excessive optimization.
* Preserve robustness over peak performance.

---

# Stage 8 – Walk-Forward Testing

Divide historical data into:

* Training Period
* Validation Period
* Forward Period

Procedure:

1. Optimize on the Training Period.
2. Validate on unseen data.
3. Repeat using rolling windows.

Objective:

Evaluate parameter stability across different market conditions.

---

# Stage 9 – Demo Forward Testing

Operate the EA on a demo account.

Recommended duration:

30–90 trading days.

Monitor:

* Stability
* Execution quality
* Drawdown
* Win Rate
* Profit Factor
* Daily Loss Protection
* Error logs

No code changes should be introduced during the evaluation period unless correcting verified defects.

---

# Stage 10 – Production Monitoring

Deploy initially on a small live account.

Monitor continuously:

* Slippage
* Execution latency
* Spread behavior
* Drawdown
* Daily performance
* Error frequency

Increase capital only after sustained, satisfactory performance.

---

# Regression Testing

Whenever code changes:

Re-test:

* Existing functionality
* Trading logic
* Risk controls
* Position management
* Dashboard
* Statistics

Regression testing ensures new features do not break existing behavior.

---

# Performance Testing

Measure:

* Initialization time
* Tick processing time
* Memory usage
* Indicator update frequency
* Dashboard refresh performance

Performance targets:

* Fast initialization
* Minimal CPU usage
* Efficient memory management

---

# Stress Testing

Test under challenging conditions:

* High volatility
* Wide spreads
* Rapid tick rates
* Multiple open positions
* Consecutive losses
* Trading session transitions

The EA should remain stable and recover gracefully where possible.

---

# Acceptance Criteria

A release is considered production-ready when:

* All modules compile successfully.
* No compiler warnings remain.
* Unit tests pass.
* Integration tests pass.
* Backtests meet predefined performance objectives.
* Walk-forward tests demonstrate stable results.
* Demo testing completes successfully.
* Documentation is complete and current.

---

# Test Documentation

Record the following for each test cycle:

* Test date
* MT5 build
* Broker
* Symbol
* Timeframe
* Parameter set
* Test period
* Results
* Observations
* Issues found
* Corrective actions

Maintain these records in the `Reports/` directory.

---

# Release Checklist

Before tagging a release:

* Compile verification complete.
* Regression testing complete.
* Backtesting complete.
* Walk-forward testing complete.
* Demo forward testing complete.
* Documentation updated.
* CHANGELOG.md updated.
* Version number incremented.
* Git tag created.

---

# Continuous Improvement

Testing is an ongoing process.

Every enhancement, optimization, or bug fix should trigger an appropriate level of re-testing to maintain confidence in the framework's reliability and long-term maintainability.

---

# Guiding Principle

> **A strategy is not production-ready because it compiles. It is production-ready because it has been rigorously tested, validated across diverse market conditions, and demonstrated consistent, reliable behavior over time.**
