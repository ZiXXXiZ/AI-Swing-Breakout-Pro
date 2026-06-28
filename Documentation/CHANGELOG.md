# Changelog

All notable changes to **AI Swing Breakout Pro** are documented in this file.

This project follows semantic versioning during development.

---

# [2.0.0-alpha.2] - 2026-06

## Added

### Project Foundation

* Initial project folder structure
* Documentation framework
* Version management
* BaseObject class
* GitHub project initialization

---

### Logging Framework

Added complete logging infrastructure.

Modules:

* LogLevel
* LogRecord
* ILogFormatter
* ILogOutput
* DefaultLogFormatter
* JournalLogOutput
* Logger

Features:

* Multiple log levels
* Formatter abstraction
* Output abstraction
* Journal logging
* Structured log records
* Dependency Injection support

Status:

Production Ready

---

### Error Framework

Added:

* ErrorInfo
* ErrorCodes

Features:

* Structured error information
* Error category classification
* Error severity classification
* Recoverable flag

Status:

Partially Complete

---

## Changed

### Architecture

* Adopted SOLID principles throughout the project.
* Standardized project folder structure.
* Established dependency injection for reusable services.
* Adopted project-wide `const` correctness.
* Standardized naming conventions for classes, interfaces, structures, and enums.

---

### Development Workflow

Defined a permanent development workflow:

1. Design
2. Production Code
3. Compile Check
4. Unit Test
5. Documentation
6. Git Commit

---

## In Progress

### Error Framework

Currently implementing:

* ErrorHandler

Planned features:

* Binary search lookup
* Centralized error definitions
* Unknown error fallback
* Logger integration

---

## Planned

### Core Infrastructure

* Utilities
* Validation
* Configuration

### Core Services

* SymbolManager
* TimeManager
* SessionManager
* IndicatorCache
* MarketDataCache

### Trading Framework

* Market Engine
* Signal Engine
* Risk Engine
* Trade Engine

### Application

* Dashboard
* Statistics
* Backtesting Tools
* Main Expert Advisor

---

# Development Notes

This release establishes the architectural foundation for AI Swing Breakout Pro.

Future releases will focus on implementing reusable infrastructure before developing trading functionality.

The goal is to create a professional, maintainable, enterprise-quality MQL5 framework suitable for long-term development.
