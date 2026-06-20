# Agentic Kernel

**A self-sufficient operating system for autonomous coding agents.**

Agentic Kernel encodes production-grade software engineering discipline into structured, actionable workflows that any AI coding agent can follow. It is not documentation — it is an executable framework that transforms how agents plan, build, verify, and remember.

---

## Why This Exists

Most AI coding agents fail not because they lack intelligence, but because they lack **discipline**. They:
- Skip planning and jump straight to implementation
- Write plausible-looking code that doesn't actually work
- Accumulate uncommitted changes across multiple tasks
- "Fix forward" through compound errors instead of reverting
- Forget what they learned between sessions
- Make silent assumptions that turn into silent bugs

Agentic Kernel solves this by providing a **structured operating system** — a set of mandatory protocols, verification gates, and anti-rationalization safeguards that force empirical discipline at every step.

---

## Architecture

The system is organized into a 3-tier hierarchy:

| Tier | Purpose | Example |
|------|---------|---------|
| **L1: Apex Kernel** | The master router and non-negotiable laws | `SYSTEM_CORE.md` |
| **L2: Phase Domains** | Five operational domains covering the full lifecycle | `skills/01_mission_synthesis/` |
| **L3: Skill Protocols** | Individual, actionable skill files with verification gates | `01_requirement_distillation.md` |

### The Five Phases

```
Phase 1: Mission Synthesis     → Requirements & Planning
Phase 2: Execution Engine      → Implementation & Testing
Phase 3: Verification Matrix   → Review & Quality Gates
Phase 4: Cognitive Persistence → Memory & Knowledge Management
Phase 5: Interface Protocols   → Safe Environment Interaction
```

### Operational Loop

```
┌─────────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────────┐
│   MISSION   │────▶│  EXECUTION   │────▶│ VERIFICATION  │────▶│  COGNITIVE   │
│  SYNTHESIS  │     │   ENGINE     │     │   MATRIX      │     │ PERSISTENCE  │
└─────────────┘     └──────┬───────┘     └───────────────┘     └──────────────┘
       ▲                   │                                          │
       │                   │ (on failure)                             │
       │                   ▼                                          │
       │            ┌──────────────┐                                  │
       │            │   ROLLBACK   │                                  │
       │            │   & RETHINK  │                                  │
       │            └──────────────┘                                  │
       │                                                              │
       └──────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
/
├── SYSTEM_CORE.md                                        # L1: Apex Router & Meta-Skill
├── README.md                                             # This file
├── templates/                                            # Reusable templates
│   ├── PLAN_TEMPLATE.md                                  # Task plan template
│   ├── PROGRESS_LOG_TEMPLATE.md                          # Progress logging template
│   └── CONTEXT_SNAPSHOT_TEMPLATE.md                      # Session handoff template
└── skills/
    ├── 01_mission_synthesis/                              # L2: Requirements & Planning
    │   ├── 01_requirement_distillation.md                 # L3: Spec Synthesis
    │   └── 02_strategic_decomposition.md                  # L3: Task Decomposition
    ├── 02_execution_engine/                               # L2: Implementation Loops
    │   ├── 03_convergent_iteration.md                     # L3: Build-Test-Fix Cycle
    │   ├── 04_state_checkpoint_protocol.md                # L3: Git-Backed State Machine
    │   └── 05_incremental_proof_cycles.md                 # L3: Test-Driven Synthesis
    ├── 03_verification_matrix/                            # L2: Quality & Review
    │   ├── 06_pentagonal_audit.md                         # L3: 5-Axis Code Review
    │   └── 07_entropy_reduction.md                        # L3: Complexity Reduction
    ├── 04_cognitive_persistence/                          # L2: Memory Architecture
    │   ├── 08_structural_cartography.md                   # L3: Architecture Mapping
    │   ├── 09_context_lifecycle.md                        # L3: Session Memory Management
    │   └── 10_source_verification.md                      # L3: Source-Grounded Development
    └── 05_interface_protocols/                            # L2: Environment Interfaces
        ├── 11_bounded_observation.md                      # L3: Safe I/O & Truncation
        └── 12_semantic_navigation.md                      # L3: Codebase Traversal
```

---

## How to Use

### For Individual Developers

1. **Copy this repository** into your project's `.agents/` or `.docs/agent-kernel/` directory
2. **Reference `SYSTEM_CORE.md`** in your agent's system prompt, rules file, or context
3. **The agent will route itself** through the appropriate phases and skills based on the current task

### For Teams

1. **Fork this repository** and customize the skill files for your team's conventions
2. **Add to your CI/CD pipeline** as a linting step that verifies agent outputs meet the evidence requirements
3. **Extend with domain-specific skills** by adding new L3 files to the appropriate L2 directory

### Supported Agent Platforms

Agentic Kernel is platform-agnostic. It works with any agent that can read Markdown files:

| Platform | Integration Method |
|----------|-------------------|
| Claude Code | Add to `CLAUDE.md` or `.claude/` rules |
| Cursor | Reference in `.cursor/rules/` |
| Gemini CLI | Add to `.agents/skills/` |
| GitHub Copilot | Reference in `.github/copilot-instructions.md` |
| Aider | Include via `--read` flag |
| Any LLM | Include in system prompt or context |

---

## Every Skill Includes

Each L3 skill file follows a strict template:

| Section | Purpose |
|---------|---------|
| **Objective** | One-sentence purpose statement |
| **Operational Protocol** | Numbered, imperative steps |
| **Anti-Rationalization Table** | Common agent excuses + architectural rebuttals |
| **Evidence Requirement** | Verifiable proof of execution |
| **Failure Modes** | Common failures and recovery |
| **Integration Points** | How it connects to other skills |

---

## Core Principles

1. **Actionable Protocols** — Every instruction is an actionable step with a verifiable output, not an essay
2. **Empirical Sovereignty** — Claims require evidence. "Seems right" is never sufficient
3. **Surgical Scope** — Touch only what the task demands. No speculative improvements
4. **Atomic State Transitions** — The codebase moves between known-good states. Broken states are never committed
5. **Anti-Rationalization** — Every skill anticipates and rebuts the excuses agents use to skip discipline
6. **Reversibility by Default** — Every action must be undoable. Commit before transforming

---

## Contributing

To add a new skill:

1. Identify which L2 phase domain it belongs to
2. Create a new `.md` file following the L3 template (Objective → Protocol → Anti-Rationalization → Evidence → Failure Modes → Integration)
3. Assign the next sequential number in the domain
4. Update this README's structure diagram
5. Verify the skill passes the "actionability test" — would a junior engineer know exactly what to do after reading it?

---

## License

MIT — Use freely. Build better agents.
