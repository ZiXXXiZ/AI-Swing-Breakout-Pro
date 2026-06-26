# AI-Swing-Breakout-Pro

AI Swing Breakout Pro v2.0 – Institutional Edition is a professional-grade algorithmic trading framework for MetaTrader 5 (MQL5). The project is designed using a modular, object-oriented architecture with a strong emphasis on reliability, maintainability, performance, and risk management.

This project is intended to evolve beyond a single Expert Advisor into a reusable trading framework capable of supporting multiple trading strategies.

---

## Project Objectives

- Develop a production-quality Expert Advisor for MetaTrader 5.
- Maintain clean, modular, and scalable architecture.
- Prioritize capital preservation through advanced risk management.
- Optimize execution speed and resource usage.
- Support multi-symbol and multi-timeframe trading.
- Provide comprehensive logging, diagnostics, and performance statistics.
- Create a solid foundation for future AI and machine learning integration.

---

## Target Platform

- MetaTrader 5
- MQL5 (Build 4000+)
- Windows VPS Ready
- Hedging Account Support
- Multi-Symbol Support

---

## Supported Markets

- Bitcoin (BTCUSD / XBTUSD)
- Gold (XAUUSD)
- Major Forex Pairs
- Stock Indices

---

## Architecture

```
AI_SwingBreakout_Pro/

├── Source/
├── Include/
│   ├── Core/
│   ├── Indicators/
│   ├── Market/
│   ├── AI/
│   ├── Risk/
│   ├── Trade/
│   ├── Statistics/
│   └── Common/
│
├── Presets/
├── Documentation/
├── Tests/
├── Reports/
├── Logs/
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## Core Components

### Core
- Configuration Manager
- Logger
- Error Handler
- Utilities
- Symbol Manager
- Market Snapshot
- Indicator Cache
- Dashboard

### Indicators
- EMA
- ATR
- ADX
- Volume
- Spread

### Market Engine
- Swing Detector
- Structure Detector
- Trend Detector
- Breakout Detector
- Session Filter
- Market Regime Detector

### AI Engine
- Probability Engine
- Score Calculator
- Signal Engine

### Risk Engine
- Position Sizer
- Dynamic Risk
- Daily Protection
- Drawdown Guard
- Exposure Manager
- Portfolio Manager

### Trade Engine
- Entry Engine
- Pending Order Manager
- Position Manager
- Break-even Manager
- Partial Close Manager
- ATR Trailing Stop
- Exit Manager

### Statistics
- Trade Journal
- CSV Export
- Performance Analyzer
- Optimization Tools
- Walk-Forward Support

---

## Trading Philosophy

The strategy follows four priorities:

1. **Protect Capital**
2. **Avoid Low-Quality Trades**
3. **Manage Winning Positions**
4. **Generate Consistent Profits**

The EA only trades when multiple independent conditions align, including trend, market structure, volatility, volume, and probability.

---

## Coding Standards

- `#property strict`
- Zero compiler warnings
- Zero compiler errors
- Object-Oriented Programming (OOP)
- Single Responsibility Principle
- Configurable parameters
- Minimal work per tick
- Cached indicator calculations
- Comprehensive logging
- Broker-independent implementation

---

## Development Workflow

```
Architecture
    ↓
Implementation
    ↓
Compilation
    ↓
Module Testing
    ↓
Backtesting
    ↓
Optimization
    ↓
Walk-Forward Validation
    ↓
Forward Demo Testing
    ↓
Live Deployment
```

---

## Definition of Done

A module is considered complete only when it:

- Compiles without errors
- Compiles without warnings
- Properly releases all resources
- Includes documentation
- Includes logging
- Uses configurable parameters
- Has no duplicated logic
- Passes planned testing

---

## Version Roadmap

### Version 2.0
- Institutional Swing Breakout EA
- Dynamic Risk Engine
- Probability Engine
- Professional Trade Management

### Version 2.1
- Portfolio Manager
- Strategy Health Monitor
- Performance Dashboard

### Version 2.2
- Adaptive Market Regime Engine
- Correlation Filter
- Enhanced Optimization

### Version 3.0
- ONNX Machine Learning Integration
- AI Probability Filter
- Advanced Feature Engineering

---

## Performance Goals

| Metric | Target |
|--------|--------|
| Compiler Errors | 0 |
| Compiler Warnings | 0 |
| CPU Usage | <2% per chart |
| Memory Usage | <50 MB |
| Maximum Drawdown | <10% (target) |
| Profit Factor | >1.70 (target) |
| Recovery Factor | >2.50 (target) |

*Performance targets are objectives for validation through testing, not guarantees.*

---

## Long-Term Vision

The long-term objective is to create a reusable institutional-grade trading framework capable of supporting multiple strategies while sharing common infrastructure such as:

- Risk Management
- Execution Engine
- Portfolio Management
- Statistics
- Logging
- AI Integration

Future strategy modules can then be developed without rewriting the underlying framework.

---

## License

This project is currently under active development. Licensing terms will be defined upon completion of Version 2.0.

---

## Acknowledgements

This project is being developed collaboratively with a strong focus on software engineering best practices, disciplined testing, and continuous improvement. The objective is to build a maintainable, transparent, and professional algorithmic trading system suitable for long-term evolution.
