# CONTRIBUTING.md

**Project:** AI Swing Breakout Pro Framework

Thank you for contributing to AI Swing Breakout Pro.

This document describes the workflow, standards, and expectations for contributing to the project.

---

# Development Philosophy

The framework is designed to be:

* Modular
* Maintainable
* Testable
* Reusable
* Well documented

Every contribution should improve one or more of these qualities.

---

# Engineering Principles

Contributors should follow these principles:

* Keep changes focused.
* Prefer readability over cleverness.
* Maintain backward compatibility whenever practical.
* Avoid unnecessary complexity.
* Update documentation alongside code.

---

# Repository Structure

```text
Core/
Tests/
Documentation/
Examples/
```

Each directory has a single responsibility.

---

# Branch Strategy

The recommended branch model is:

```text
main
│
├── feature/<feature-name>
├── fix/<issue-name>
├── refactor/<module-name>
└── release/<version>
```

Examples:

```text
feature/math-utils
feature/risk-manager
fix/time-utils-overflow
refactor/logger
release/v2.0.0-beta
```

Do not commit unfinished work directly to `main`.

---

# Commit Message Convention

Use concise, descriptive commit messages.

Recommended format:

```text
<type>: <description>
```

Examples:

```text
feat: add MathUtils module
feat: implement RiskManager
fix: correct TimeUtils timezone handling
refactor: simplify Logger implementation
docs: update architecture documentation
test: add unit tests for ArrayUtils
style: apply coding standards
chore: reorganize documentation
```

---

# Pull Request Checklist

Before opening a pull request, ensure:

* Code compiles successfully.
* Zero compiler errors.
* Zero compiler warnings.
* Unit tests pass.
* Documentation is updated.
* Coding standards are followed.
* Public APIs are documented.
* Changelog is updated when applicable.

---

# Code Review Guidelines

Reviewers should verify:

* Architecture consistency.
* API consistency.
* Readability.
* Test coverage.
* Performance impact.
* Documentation quality.
* Backward compatibility.

Reviews should focus on improving the code, not criticizing the contributor.

---

# Documentation Requirements

Documentation must be updated whenever changes affect:

* Public APIs
* Architecture
* Development workflow
* Project roadmap
* Release notes

At a minimum, review:

* CHANGELOG.md
* PROJECT_STATUS.md
* ROADMAP.md
* ARCHITECTURE.md

---

# Testing Requirements

Every new public feature should include:

* Unit tests
* Boundary tests
* Invalid input tests
* Regression tests (where applicable)

Code without appropriate tests should not be considered complete.

---

# Definition of Done

A contribution is considered complete when:

* It compiles successfully.
* Compiler reports zero warnings.
* All relevant unit tests pass.
* Documentation is updated.
* Coding standards are satisfied.
* Architecture remains consistent.
* The change has been reviewed.

---

# Issue Reporting

When reporting an issue, include:

* Framework version
* MetaTrader 5 build
* Operating system
* Steps to reproduce
* Expected behavior
* Actual behavior
* Relevant logs or screenshots

Clear reports help resolve issues more quickly.

---

# Security

Do not commit:

* Account credentials
* API keys
* Personal data
* Broker-specific secrets
* Proprietary configuration files

Report security concerns privately to the project owner.

---

# Release Process

Each release should follow this sequence:

1. Complete implementation.
2. Run all unit tests.
3. Resolve compiler warnings.
4. Update documentation.
5. Update CHANGELOG.md.
6. Tag the release.
7. Publish the release.

---

# Project Ownership

Project Owner

* Defines product vision.
* Approves major architectural decisions.
* Prioritizes development.
* Approves releases.

Technical Lead

* Maintains architecture.
* Reviews code quality.
* Ensures consistency.
* Guides implementation.
* Maintains engineering standards.

---

# Continuous Improvement

This document is expected to evolve with the project.

Suggestions that improve development workflow, code quality, testing, or documentation are encouraged and should be discussed before adoption.
