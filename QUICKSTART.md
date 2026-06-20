# Quick Start Guide

Get Agent Rigor working in your project in under 5 minutes.

---

## Step 1: Copy the Kernel

```bash
# Option A: Clone into your project
git clone <repo-url> .agents/kernel/

# Option B: Copy specific files
cp -r agent-rigor/SYSTEM_CORE.md .agents/
cp -r agent-rigor/skills/ .agents/skills/
cp -r agent-rigor/templates/ .agents/templates/
```

## Step 2: Bootstrap Your Project

Create these files in your project root:

```bash
# Initialize the progress log
cp .agents/templates/PROGRESS_LOG_TEMPLATE.md progress_log.md

# Create the docs directory structure
mkdir -p .docs/{architecture,decisions,context}
```

## Step 3: Configure Your Agent

### Claude Code
Add to `CLAUDE.md`:
```markdown
Read and follow the operating protocols in `.agents/SYSTEM_CORE.md`.
For every task, route through the phase system defined there.
```

### Cursor
Create `.cursor/rules/kernel.mdc`:
```markdown
---
description: Core engineering protocols for AI development
alwaysApply: true
---
Read and follow `.agents/SYSTEM_CORE.md` for all development tasks.
```

### Gemini CLI / Antigravity
Add to `.agents/AGENTS.md`:
```markdown
Read and follow the operating protocols in `SYSTEM_CORE.md`.
Skills are located in `.agents/skills/`.
```

### Generic (Any Agent)
Include in your system prompt:
```
Before starting any task, read SYSTEM_CORE.md and follow the phase routing system it defines. Each phase has specific skills in the skills/ directory that you must execute.
```

## Step 4: Start Your First Task

Tell your agent:
```
I need to [describe your task]. Follow the kernel protocols:
1. Start with Phase 1 (Mission Synthesis) to create a specification and plan
2. Then execute through Phase 2, 3, and 4 as defined in SYSTEM_CORE.md
```

The agent will:
1. ✅ Create a specification with acceptance criteria
2. ✅ Decompose into atomic tasks in `PLAN.md`
3. ✅ Implement each task with test-first discipline
4. ✅ Commit atomically with rollback on failure
5. ✅ Self-review across 5 quality axes
6. ✅ Update architecture docs and session context

## Step 5: Verify It's Working

Check for these artifacts after the first task cycle:
- [ ] `PLAN.md` exists with structured tasks
- [ ] `progress_log.md` has entries
- [ ] Git log shows atomic, well-formatted commits
- [ ] `.docs/` directory has architecture notes

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Agent ignores the kernel | Move SYSTEM_CORE.md content into the agent's primary rules file |
| Agent skips planning phase | Add "You MUST create PLAN.md before any implementation" to rules |
| Agent doesn't commit atomically | Add explicit git workflow to your rules file |
| Context too long | Only reference the specific skill files needed for the current phase |

---

## Next Steps

- Read through `SYSTEM_CORE.md` to understand the full protocol
- Browse the `skills/` directory to see all available skill protocols
- Customize skill files for your team's specific conventions
- Add domain-specific skills (e.g., database migrations, API design)
