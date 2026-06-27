# ARCHITECTURE.md

# AI Swing Breakout Pro v2.0

## Institutional Trading Framework

Version: 2.0.0-alpha.1

---

# 1. Project Vision

Build a production-quality, modular, institutional-grade trading framework for MetaTrader 5.

Primary goals:

* Clean architecture
* Modular design
* High performance
* Risk-first trading
* Easy maintenance
* Extensible for future AI integration

The framework should support multiple trading strategies while sharing a common infrastructure.

---

# 2. Architecture Overview

```
AI Trading Framework

├── Core
├── Interfaces
├── Indicators
├── Market
├── Signal
├── Risk
├── Trade
├── Statistics
├── Dashboard
├── AI
└── Strategies
```

Only the **Strategies** module should contain strategy-specific logic.

Everything else is reusable.

---

# 3. Folder Structure

```
AI_SwingBreakout_Pro/

Experts/
    AI_SwingBreakout_Pro.mq5

Include/

    Core/
        Version.mqh
        InputParameters.mqh
        Config.mqh
        Logger.mqh
        ErrorHandler.mqh
        Utilities.mqh
        SymbolManager.mqh
        MarketSnapshot.mqh
        IndicatorCache.mqh
        Dashboard.mqh

    Interfaces/
    Indicators/
    Market/
    Signal/
    Risk/
    Trade/
    Statistics/
    AI/
    Strategies/
        SwingBreakout/

Documentation/
Presets/
Reports/
Tests/
```

---

# 4. Core Modules

## Version

Stores:

* Project Name
* Version
* Build
* Author

---

## InputParameters

Contains only MT5 input variables.

No logic.

---

## Config

Responsible for:

* Loading configuration
* Validation
* Runtime configuration
* Read-only access after initialization

---

## Logger

Responsible for:

* Information logging
* Warning logging
* Error logging
* Debug logging

Future versions:

* CSV logging
* Log rotation
* Performance timing

---

## ErrorHandler

Converts MT5 error codes into meaningful messages.

Provides centralized error handling.

---

## Utilities

Shared helper functions.

Examples:

* Price normalization
* Pip conversion
* Time helpers
* Lot rounding

---

## SymbolManager

Caches symbol information.

Examples:

* Bid
* Ask
* Spread
* Digits
* Tick Size
* Tick Value
* Contract Size

---

## IndicatorCache

Creates and manages all indicator handles.

Prevents duplicate calculations.

---

## Dashboard

Displays:

* Trend
* Market Regime
* ATR
* ADX
* Spread
* Risk
* Probability
* Daily P/L
* Open Positions

---

# 5. Market Engine

Responsible for detecting:

* Trend
* Swing High/Low
* Breakouts
* Market Structure
* Sessions
* Volatility

Produces one immutable Market Snapshot.

---

# 6. Signal Engine

Combines:

* Trend
* Structure
* Breakout
* Volume
* ADX
* ATR
* Probability

Produces:

* BUY
* SELL
* NONE

---

# 7. Risk Engine

Responsible for:

* Position sizing
* Daily loss protection
* Maximum positions
* Exposure control
* ATR stop calculation
* Break-even
* Partial close
* Trailing stop

---

# 8. Trade Engine

Responsible for:

* Order placement
* Order modification
* Position management
* Retry logic
* Trade validation

No trading decisions are made here.

---

# 9. Statistics Engine

Tracks:

* Win rate
* Profit factor
* Average RR
* Drawdown
* Daily performance
* Monthly performance

---

# 10. AI Module (Future Version 3)

Planned features:

* ONNX inference
* Probability prediction
* Market regime classification
* Adaptive parameter tuning

Version 2.0 remains fully rule-based.

---

# 11. Initialization Flow

```
OnInit()

↓

Version

↓

InputParameters

↓

Config

↓

Validate

↓

Logger

↓

SymbolManager

↓

IndicatorCache

↓

Dashboard

↓

Market Engine

↓

Trading Enabled
```

---

# 12. Shutdown Flow

```
OnDeinit()

↓

Save Statistics

↓

Release Indicators

↓

Close Dashboard

↓

Logger Shutdown
```

---

# 13. Coding Standards

Every class must:

* Have a single responsibility
* Be fully documented
* Compile without warnings
* Avoid unnecessary global variables
* Validate inputs
* Log significant events
* Clean up allocated resources

Naming conventions:

* Classes: `CClassName`
* Structures: `SStructureName`
* Enums: `ENUM_Name`
* Interfaces: `IInterfaceName`

---

# 14. Development Roadmap

## Package 1

* Version
* InputParameters
* Config
* Logger
* ErrorHandler
* Utilities
* SymbolManager
* IndicatorCache
* Dashboard

## Package 2

* Indicators

## Package 3

* Market Engine

## Package 4

* Signal Engine

## Package 5

* Risk Engine

## Package 6

* Trade Engine

## Package 7

* Statistics & Dashboard

## Package 8

* Integration Testing
* Optimization
* Walk-Forward Testing
* Production Release

---

# 15. Long-Term Vision

The project is designed as a reusable trading framework rather than a single Expert Advisor.

Future strategies such as Trend Following, Mean Reversion, Pullback, Scalping, and AI-based systems should reuse the same Core, Risk, Trade, and Statistics modules while implementing only their own strategy logic.
