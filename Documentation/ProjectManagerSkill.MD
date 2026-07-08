---
name: ai-swingbreakout-project-manager
description: >
  Expert project manager for the AI Swing Breakout Pro MQL5 framework project.
  Use this skill at the start of every development session, whenever planning
  a sprint, reviewing files, making architecture decisions, updating documentation,
  or deciding what to build next. Also use when the user uploads project files,
  asks "what should we do next?", writes "LDN", or needs a status review.
  This skill governs both the AI assistant's behavior AND gives the human developer
  a clear checklist of their own responsibilities.
---

# AI Swing Breakout Pro — Project Manager Skill

This skill defines how to manage the AI Swing Breakout Pro MQL5 framework project
correctly — for both the **human developer** (owner, decision-maker, quality gate)
and the **AI assistant** (implementer, reviewer, documenter).

Neither role works well without the other. This skill keeps both aligned.

---

## Part 1 — Human Developer Duties

These are things only the human can do or decide. The AI cannot substitute for them.

### 1. Session Startup (Every Session)

Before writing a single line of code, upload the current state:

```
Required uploads every session:
- PROJECT_CONTEXT.md     ← read first
- ARCHITECTURE.md
- CODING_STANDARD.md
- DECISIONS.md
- ROADMAP.md
- CHANGELOG.md
- Any .mqh files being worked on this session
```

Never assume the AI remembers anything from a previous session.
Never start from chat memory — always start from the repository.

### 2. Architecture Decision Authority

The human makes all architecture decisions. The AI proposes, explains tradeoffs, flags risks — but the human approves before implementation begins.

Decisions that always require explicit human approval:

* Any new layer, module, or class that other modules will inherit from
* Any change to an existing interface (method signatures, struct fields)
* Any decision that affects more than one file
* Any ADR (Architecture Decision Record)

When the AI proposes a shape and asks "Does this look right?" — that is the approval checkpoint. Don't skip it.

### 3. Compile Verification

The human runs every file in MetaEditor. The AI cannot compile MQL5.

Rule: a module is not "done" until **you** confirm 0 errors, 0 warnings in MetaEditor.
When compile errors occur, paste the exact error text back to the AI — not a summary.

### 4. Quality Gate Enforcement

Before marking a sprint complete, verify:

- [ ] Every file compiles individually
- [ ] All files compile together (not just in isolation)
- [ ] No "pending" tasks left in the sprint
- [ ] Documentation updated to match what actually exists
- [ ] Git commit made

Never move to the next sprint while the current one has unresolved compile errors.

### 5. Repository Maintenance

The GitHub repository is the single source of truth (ADR-001).

After every sprint:

- [ ] Push all changed `.mqh` files
- [ ] Push all updated `.md` files
- [ ] Verify the repo reflects exactly what's documented

If the repo and the docs ever disagree — the repo wins. Update the docs.

### 6. Deciding "What's Next"

Use ROADMAP.md as the authority. The sequence is:

```
Foundation (Core) → Framework → Risk → Trading → AI → Testing → Production
```

Don't jump layers. Don't start Risk until Framework is wired into the main EA.
Don't start Trading until Risk compiles and integrates.

---

## Part 2 — AI Assistant Duties

These are the AI's responsibilities in every session. Follow them without being asked.

### 1. Read Before Touching Anything

At the start of every session, read (in this order):

1. `PROJECT_CONTEXT.md` — current state, what's done, what's next
2. `ARCHITECTURE.md` — layer structure, dependency rules, folder tree
3. `CODING_STANDARD.md` — naming, headers, include paths, class patterns
4. `DECISIONS.md` — all ADRs, especially the most recent ones
5. `ROADMAP.md` — current sprint, next tasks
6. `CHANGELOG.md` — what changed last cycle and why

Never assume prior context. Never proceed without reading these first.

### 2. Propose Before Implementing (Spine Files)

For any file that other modules inherit from or call through:

1. Propose the interface shape (method signatures, who owns what, data flow)
2. Explain the tradeoffs
3. Wait for explicit human approval
4. Only then implement

This applies to: base classes, context/service bundles, managers, engine contracts.

For self-contained leaf files (a specific formula, a specific struct), implement directly — no approval step needed.

### 3. Cross-Check Before Writing Code

Before writing any `.mqh` file:

- Check `Constants.mqh` and `Types.mqh` for name collisions
- Check all files the new file will include — verify the APIs you'll call actually exist with the signatures you expect
- Check for the two known MQL5 silent-failure patterns (see below)

### 4. MQL5 Gotchas — Check Every File

Two bugs found this project that compile with 0 errors but fail silently at runtime:

**Gotcha 1: No static class members as default parameter values**

```cpp
// WRONG — MQL5 rejects this at compile time
static bool IsEqual(const double a, const double b,
                    const double epsilon = CConstants::EPSILON);

// CORRECT — use overload pairs
static bool IsEqual(const double a, const double b);
static bool IsEqual(const double a, const double b, const double epsilon);
```

**Gotcha 2: Virtual method signature hiding (compiles clean, fails silently)**

```cpp
// Base
virtual bool Initialize() { ... }

// Derived — LOOKS like an override, IS NOT — different parameter list
virtual bool Initialize(CContext *context) { ... }
// This hides the base method. Polymorphic dispatch calls the base, not this.
// Zero errors, zero warnings. m_context stays NULL forever.

// CORRECT — signatures must match exactly, or rename the method
virtual bool Initialize(CContext *context) override { ... }  // override enforces match
```

**Rule:** any new class hierarchy — always verify virtual method signatures match exactly up the entire chain. Use `override` keyword wherever you intend to override.

**Gotcha 3: No reference return types**

```cpp
// WRONG — MQL5 has no reference return types
const CConfig &Config() const { return m_config; }

// CORRECT — return pointer via GetPointer() for member objects
const CConfig *Config() const { return GetPointer(m_config); }
```

### 5. Complete Files Only

Never produce partial implementations. Every file delivered must:

* Have a complete header (Project / Module / File / Purpose / Author / Version)
* Have a correct include guard (`AI_SWINGBREAKOUT_<LAYER>_<NAME>_MQH`)
* Compile as a complete unit
* Follow `CODING_STANDARD.md` naming conventions

### 6. Update Documentation Every Session

After any implementation work, update:

* `CHANGELOG.md` — what was built/fixed/changed and why
* `ROADMAP.md` — sprint status, progress bars, next tasks
* `PROJECT_CONTEXT.md` — completed modules, known issues, current sprint
* `ARCHITECTURE.md` — folder tree, Section 12 current progress

Never leave docs describing a state that no longer exists.

### 7. Respond to LDN Correctly

When the human writes `LDN` ("Let Do Next"):

* Do not re-explain what was just done
* Do not ask clarifying questions unless genuinely blocked
* Read ROADMAP.md current task and proceed immediately

---

## Part 3 — Shared Rules (Both Human and AI)

### The Definition of Done

A module is complete only when ALL of these are true:

- [ ] Source code is production quality (no placeholders, no TODOs)
- [ ] Compiles without errors or warnings in MetaEditor
- [ ] Dependency rules respected (nothing in Core depends on Trading/AI/UI)
- [ ] Include paths are relative, not global (`#include "../Types.mqh"`, not `#include <Core/Types.mqh>`)
- [ ] Header is complete (Project/Module/File/Purpose/Author/Version)
- [ ] Include guard follows `AI_SWINGBREAKOUT_<LAYER>_<NAME>_MQH` format
- [ ] Documentation updated
- [ ] Ready for Git commit

### The Dependency Flow

```
AI
 ↓
Trading
 ↓
Risk
 ↓
Indicators
 ↓
Framework  (Context / Module / ModuleManager / Engine)
 ↓
Core       (Constants / Types / MathUtils / Config / Platform / Structures / Error / Logging / Utilities)
 ↓
MQL5 Platform
```

Nothing may depend on a layer above it.
`Core/Error` and `Core/Logging` must not depend on each other (ADR-012).
`Core` must never depend on Trading, AI, Indicators, or UI (ADR-003).

### Include Path Rules

| From file in...                  | Correct include syntax                    |
|----------------------------------|-------------------------------------------|
| `Core/*.mqh`                     | `#include "Constants.mqh"`                |
| `Core/Error/*.mqh` → `Core/`     | `#include "../Types.mqh"`                 |
| `Core/Error/*.mqh` → `Logging/`  | FORBIDDEN (ADR-012)                       |
| `Core/Logging/Interfaces/*.mqh`  | `#include "../LogLevel.mqh"`              |
| `Framework/*.mqh` → `Core/`      | `#include "../Core/Platform.mqh"`         |
| `AI_SwingBreakout_Pro.mq5`       | `#include "Include/Core/Types.mqh"`       |

### Naming Conventions (Quick Reference)

| Type | Prefix | Example |
|---|---|---|
| Class | `C` | `CMathUtils` |
| Interface | `I` | `ILogFormatter` |
| Struct | `S` | `STradeSignal` |
| Enum type | `ENUM_` | `ENUM_LOG_LEVEL` |
| Enum member | `CATEGORY_` | `LOG_INFO` |
| Member variable | `m_` | `m_context` |
| Constant (`#define`) | UPPER_CASE | `MAX_MODULES` |
| Method | PascalCase | `Initialize()` |

---

## Part 4 — Current Project State (Update Each Session)

> **This section must be updated at the start of each session from PROJECT_CONTEXT.md.**
> What follows is a template — replace with actual current state.

**Current Version:** `2.0.0-alpha.4`

**Current Sprint:** Sprint 007

**Current Task:**
1. Confirm `ValidationUtils.mqh` compiles (0 errors, 0 warnings)
2. Write `AI_SwingBreakout_Pro.mq5` — composition root
3. Propose Risk Engine interface

**Last Completed:**
- Sprint 006 — full standards pass, 3 latent bugs fixed
- Framework layer — Context/Module/ModuleManager/Engine compiled clean
- Platform.mqh, Config.mqh, MathUtils.mqh — done and verified

**Known Open Issues:**
- `ValidationUtils.mqh` compile not yet confirmed
- `AI_SwingBreakout_Pro.mq5` not yet written (no integration test exists yet)
- Three parallel log-level enums (`Types.ELogLevel`, `Logging.ENUM_LOG_LEVEL`, `Config.ENUM_CONFIG_LOG_LEVEL`) — tracked debt, not blocking

**Progress:**
```
Foundation      100%  ██████████
Framework        80%  ████████░░  (wiring pending)
Infrastructure   20%  ██░░░░░░░░
Risk              0%  ░░░░░░░░░░
Trading           0%  ░░░░░░░░░░
AI                0%  ░░░░░░░░░░
Overall          55%  █████░░░░░
```

---

## Part 5 — Session Startup Checklist

Run through this at the start of every session before doing anything else:

**Human:**
- [ ] Upload `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, `CODING_STANDARD.md`, `DECISIONS.md`, `ROADMAP.md`, `CHANGELOG.md`
- [ ] Upload any `.mqh` files relevant to today's work
- [ ] Tell the AI what compile results came back from last session (if any)

**AI:**
- [ ] Read all six docs before responding
- [ ] Confirm current sprint and current task from ROADMAP.md
- [ ] Check for any open compile confirmations from previous session
- [ ] Proceed with next task or ask the one question needed to unblock

---

## Part 6 — Escalation Rules

Stop and explicitly flag before proceeding if:

* A new file would change an existing interface (method signature, struct field, enum)
* A design decision affects more than 3 files
* A file in a higher layer would need to reach into Core (dependency violation)
* A compile error is not understood after one fix attempt
* Documentation and the repository disagree on what exists

When flagging: state the exact problem, state the options with tradeoffs, wait for human decision. Don't guess and proceed.