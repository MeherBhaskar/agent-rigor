# Context Snapshot

> Written at session boundaries to enable seamless resumption.
> Read this file at the START of any new session before doing anything else.

**Snapshot Timestamp:** [YYYY-MM-DD HH:MM]
**Session Duration:** [approximate]
**Confidence Level:** HIGH (just written) | MEDIUM (hours old) | LOW (days old — re-verify before acting)

---

## Current State

- **Active Task:** TASK-XXX — [Title]
- **Task Status:** [IN PROGRESS] | [BLOCKED:<reason>]
- **Working Branch:** `feature/xxx`
- **Last Passing Commit:** `abc123f` — "[commit message]"
- **Uncommitted Changes:** YES / NO
- **Test Suite Status:** ALL PASSING / [X] FAILING

## What Was Just Completed

<!-- List the most recent completed work, with evidence -->
1. [Completed item with reference to commit or test output]

## Key Decisions Made This Session

| Decision | Rationale | Reversible? |
|----------|-----------|-------------|
| | | YES / NO |

## Open Questions

<!-- Questions that need answers before proceeding -->
1. [ ] [Question with context about why it matters]

## Next Steps

<!-- Ordered list of what to do next, as specific as possible -->
1. [Exact next action to take]
2. [Following action]
3. [Following action]

## Warnings & Landmines

<!-- Anything the next session should be careful about -->
- ⚠️ [Warning about fragile state, known issue, or gotcha]

## Files Recently Modified

| File | What Changed | Committed? |
|------|-------------|-----------|
| `path/to/file` | [Brief description] | YES / NO |

## Environment Notes

<!-- Any environment-specific state that matters -->
- Node version: X.X
- Database state: [migrated/seeded/empty]
- External services: [running/stopped]
