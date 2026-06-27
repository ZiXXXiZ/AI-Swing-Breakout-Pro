# USER_GUIDE.md

# AI Swing Breakout Pro v2.0

## User Guide

Version: **2.0.0-alpha.1**

---

# Welcome

Welcome to **AI Swing Breakout Pro**, a professional institutional-grade trading framework developed for **MetaTrader 5 (MT5)**.

This guide explains how to install, configure, optimize, and operate the Expert Advisor safely.

No programming knowledge is required.

---

# System Requirements

Minimum requirements:

* MetaTrader 5
* Windows 10 or later
* Stable Internet connection
* Broker supporting MT5
* AutoTrading enabled

Recommended:

* VPS for 24/7 operation
* Low latency broker
* ECN account
* SSD storage
* Minimum 8 GB RAM

---

# Installation

## Step 1

Copy the project folder into:

```text
MQL5/
Experts/
AI_SwingBreakout_Pro/
```

---

## Step 2

Open MetaEditor.

Compile:

```text
AI_SwingBreakout_Pro.mq5
```

The project should compile with:

* Zero Errors
* Zero Warnings

---

## Step 3

Restart MetaTrader 5 or refresh the Navigator.

The Expert Advisor should appear under:

```text
Navigator
    Experts
        AI Swing Breakout Pro
```

---

# Attaching the EA

1. Open a chart.
2. Select the desired symbol.
3. Choose the preferred timeframe.
4. Drag the EA onto the chart.
5. Enable:

* Algo Trading
* Allow Live Trading

---

# Input Parameters

The EA provides grouped configuration options.

## General

* Magic Number
* Enable Trading
* Buy Enabled
* Sell Enabled

---

## Risk Management

Configure:

* Risk Per Trade
* Maximum Daily Loss
* Maximum Open Positions
* Probability Threshold

Recommended starting values:

```text
Risk Per Trade            1.0%
Maximum Daily Loss        5%
Maximum Positions         3
Probability Threshold     0.70
```

---

## Indicator Settings

Configure:

* Fast EMA
* Slow EMA
* ATR Period
* ADX Period
* Volume MA Period

The default values are suitable for initial testing.

---

## Filters

Optional filters include:

* ATR Filter
* ADX Filter
* Volume Filter
* Spread Filter
* Session Filter

These filters improve trade quality by avoiding unfavorable market conditions.

---

## Trade Management

Available features:

* Break-even
* ATR Trailing Stop
* Partial Close
* Dynamic Stop Management

---

# Recommended Timeframes

The framework is designed to support multiple timeframes.

Recommended:

* M15
* M30
* H1
* H4

Avoid very low timeframes until sufficient testing has been completed.

---

# Recommended Symbols

The framework is intended to work across multiple asset classes.

Examples:

* Major Forex pairs
* Gold
* Silver
* Stock Indices
* Selected CFDs

Always validate performance through backtesting before deploying on a new instrument.

---

# Trading Sessions

The EA supports session-based filtering.

Available sessions:

* Asian
* London
* New York

For most users, enabling the London and New York sessions provides the best balance of liquidity and volatility.

---

# Dashboard

The on-chart dashboard displays key trading information.

Typical metrics include:

* Current Trend
* Market Regime
* ATR
* ADX
* Spread
* Probability
* Daily Profit/Loss
* Open Positions
* Current Risk

The dashboard provides a quick overview of the EA's operating state.

---

# Risk Management

Recommended practices:

* Risk no more than 1–2% per trade.
* Respect the Maximum Daily Loss setting.
* Avoid increasing risk after a losing streak.
* Monitor drawdown regularly.

Sound risk management is essential for long-term consistency.

---

# Optimization

When optimizing the strategy, focus on:

* EMA Periods
* ATR Period
* ADX Threshold
* Probability Threshold
* ATR Trailing Multiplier
* Break-even Trigger

Avoid overfitting by validating optimized settings on unseen historical data.

---

# Backtesting

Before using the EA on a live account:

1. Perform historical backtests.
2. Review performance metrics.
3. Optimize parameters if necessary.
4. Conduct walk-forward testing.
5. Run the EA on a demo account.

---

# Recommended Deployment Process

1. Backtest
2. Optimize
3. Walk-forward Test
4. Demo Forward Test
5. Small Live Account
6. Full Production Deployment

Progress through each stage only after achieving satisfactory results.

---

# Troubleshooting

## EA Does Not Trade

Check:

* Algo Trading is enabled.
* Market is open.
* Spread is within limits.
* Daily loss limit has not been reached.
* Maximum open positions has not been exceeded.
* Session filter allows trading.

---

## Compilation Errors

Verify:

* All project files are present.
* Include paths are correct.
* MetaEditor is up to date.

---

## Poor Performance

Review:

* Broker conditions
* Symbol selection
* Timeframe
* Parameter settings
* Market conditions

Avoid changing multiple parameters simultaneously without controlled testing.

---

# Best Practices

* Test thoroughly before live deployment.
* Maintain a trading journal.
* Keep MetaTrader updated.
* Review logs periodically.
* Use a VPS for uninterrupted execution.
* Back up your project and settings regularly.

---

# Support Documentation

Additional project documents:

* PROJECT_BIBLE.md
* ARCHITECTURE.md
* ROADMAP.md
* CHANGELOG.md
* CODING_STANDARD.md
* DEVELOPER_GUIDE.md
* TEST_PLAN.md

These documents provide technical and operational guidance for advanced users and developers.

---

# Disclaimer

Trading financial markets involves significant risk.

Past performance does not guarantee future results.

The user is solely responsible for testing, configuring, and operating the Expert Advisor in accordance with their risk tolerance and applicable regulations.

---

# Final Recommendation

Treat AI Swing Breakout Pro as a professional trading framework rather than a "set-and-forget" system.

Consistent testing, disciplined risk management, and periodic performance reviews are essential to achieving long-term, sustainable results.
