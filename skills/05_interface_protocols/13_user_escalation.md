# User Escalation Protocol

**Objective:** Safely interrupt autonomous execution to escalate critical blockers, ambiguities, or destructive decisions to the human user.

---

## Operational Protocol

1. **The Escalation Threshold:**
   You MUST halt execution and escalate to the user if you encounter:
   - A destructive action (e.g., dropping a production database, deleting uncommitted files).
   - An unresolvable dependency conflict that requires downgrading core libraries.
   - A fundamental contradiction in the requirements discovered mid-execution.
   - A Third-Strike Failure (as defined in Adaptive Protocols) where the architecture needs a complete rewrite.

2. **The Escalation Format:**
   When escalating, your message to the user MUST follow this exact structure:
   - **[BLOCKED]** or **[DECISION REQUIRED]** header.
   - **Context:** 1-2 sentences explaining exactly what you were doing.
   - **The Blocker:** 1-2 sentences explaining exactly why you stopped.
   - **Options:** Present 2-3 concrete paths forward. Give your recommendation.
   - **Question:** A direct, unambiguous question asking the user which path to take.

3. **Example Escalation:**
   ```markdown
   ### [DECISION REQUIRED]: Dependency Conflict
   **Context:** I am attempting to install `package-x` for the new feature.
   **The Blocker:** `package-x` requires `lib-y v2.0`, but our project currently uses `lib-y v1.0`. Upgrading `lib-y` might break the existing authentication module.
   **Options:**
   1. Upgrade `lib-y` and run the test suite to fix any downstream auth breaks. (Recommended)
   2. Find an alternative to `package-x` that supports `lib-y v1.0`.
   3. Refactor the auth module first.

   Which path would you like me to take?
   ```

4. **The "No Silent Halts" Rule:**
   Never stop execution without explicitly telling the user *why* you stopped and *what* you need from them. Do not let the task simply end in a failure state without prompting for human intervention.

---

## Post-Escalation Resumption

When the user responds to an escalation, you MUST follow this resumption sequence:

1. **Re-read the context snapshot.** Do NOT rely on memory of the pre-escalation state. Load the saved context from `09_context_lifecycle` to reconstruct your exact position.
2. **Verify the user's answer resolves the blocker.** Confirm that the chosen option directly addresses the stated blocker. If the user's response introduces new ambiguity, escalate again — do not guess.
3. **Update the plan.** Amend `progress_log.md` and the active task list to reflect the user's decision. Record the decision as a captured requirement, not as a transient note.
4. **Resume from the blocked step.** Do NOT restart from the beginning. Do NOT skip ahead. Continue execution from the exact step that triggered escalation.
5. **Confirm resumption.** State to the user: "Resuming from [step description] with your decision to [chosen option]." This closes the escalation loop visibly.

---

## Timeout / Non-Response Protocol

If the user does not respond to an escalation within a reasonable time:

1. **Save a context snapshot.** Invoke `09_context_lifecycle` to preserve the full execution state — current step, blocker details, options presented, and all in-progress work.
2. **Document the blocker.** Append the escalation details to `progress_log.md` with status `BLOCKED_AWAITING_USER` and a timestamp.
3. **Pause work on the blocked task.** Do NOT proceed with any option speculatively. Do NOT silently pick the "recommended" option. The user must decide.
4. **Attempt other non-blocked tasks.** If the current plan has independent tasks that do not depend on the blocked decision, continue with those. Document which tasks were advanced and which remain blocked.
5. **If no non-blocked tasks exist**, halt execution cleanly. State: "All remaining tasks depend on the blocked decision. Awaiting your response to resume."

---

## Anti-Rationalization Table

| Agent Excuse | Architectural Rebuttal |
|---|---|
| "I didn't want to bother the user, so I just picked an option." | Guessing on architectural pivot points or destructive actions is forbidden. The cost of interrupting the user is lower than the cost of reverting a catastrophic assumption. Escalate. |
| "I gave the user a status update but didn't ask a clear question." | A status update is not an escalation. If you need the user's input, you must force a decision by giving concrete options and asking a direct question. |
| "The recommended option is obviously correct, so I'll just proceed." | "Obviously correct" is how agents rationalize skipping escalation. If it were truly obvious, the protocol would not have triggered. The threshold was met — follow it. Escalate. |
| "The user didn't respond, so I'll assume they agree with my recommendation." | Silence is not consent. Non-response means the user has not seen, has not decided, or is unavailable. Proceeding without explicit confirmation violates the protocol. Wait, or work on unblocked tasks. |
| "Escalating this minor issue will make me look incompetent." | Escalation is a professional protocol, not a weakness signal. Agents that escalate appropriately build user trust. Agents that silently make wrong decisions destroy it. Escalate. |

---

## Evidence Requirement

Execution of this skill is proven by ALL of the following:

- [ ] Every escalation message follows the exact format: header, context, blocker, options, direct question — no deviations
- [ ] The user's decision was recorded in `progress_log.md` with a timestamp and the chosen option clearly stated
- [ ] A context snapshot was saved before escalation AND restored upon resumption — verified by `09_context_lifecycle` artifacts
- [ ] No autonomous decision was made on any item that met the escalation threshold — zero silent overrides
- [ ] Post-resumption, the plan was updated to reflect the user's decision before any further implementation proceeded

---

## Failure Modes

| # | Failure Mode | Detection Signal | Recovery Action |
|---|---|---|---|
| 1 | **Silent Halt** — execution stops without any escalation message, leaving the user unaware of the blocker. | Task status shows incomplete but no `[BLOCKED]` or `[DECISION REQUIRED]` message exists in the conversation. | Retroactively generate the escalation message. Apply the full escalation format. Ensure the user sees the blocker and options before any further action. |
| 2 | **Over-Escalation** — asking the user about decisions the agent should handle autonomously (e.g., variable naming, import ordering, test structure). | Escalation message concerns a non-destructive, non-ambiguous, non-architectural decision that falls within the agent's competence. | Withdraw the escalation. Make the decision autonomously. Reserve escalation for true blockers — destructive actions, requirement contradictions, and three-strike failures. |
| 3 | **Under-Escalation** — proceeding with a destructive or irreversible action without escalating, rationalizing it as "probably fine." | A destructive command (delete, drop, force-push, overwrite) was executed without a preceding `[DECISION REQUIRED]` message. | Immediately halt. Attempt to reverse the action if possible. Escalate retroactively with full context of what was done and what damage may have occurred. |
| 4 | **Vague Escalation** — escalating without concrete options, dumping the problem on the user without actionable paths forward. | Escalation message lacks the Options section, or options are abstract ("we could try something else") rather than concrete actions. | Rewrite the escalation. Research 2-3 specific, implementable options. Include a recommendation with reasoning. The user should choose, not brainstorm. |
| 5 | **Premature Resumption** — continuing execution before the user has explicitly confirmed their decision, treating partial acknowledgment as approval. | Implementation resumes after a user message that does not contain a clear selection among the presented options (e.g., "hmm interesting" or "let me think"). | Pause execution. Re-present the options. Ask again: "Which option would you like me to proceed with?" Do not resume until an unambiguous selection is received. |

---

## Integration Points

| Skill | Relationship |
|---|---|
| `17_recursive_self_correction` | The three-strike rule is a primary escalation trigger. When three consecutive attempts at the same approach fail, self-correction hands control to this escalation protocol with a documented failure pattern. |
| `18_scope_containment` | Decisions that would expand or alter the defined scope MUST be escalated. The agent cannot unilaterally change scope boundaries — only the user can authorize scope changes. |
| `09_context_lifecycle` | Context snapshots are saved immediately before escalation and restored immediately upon resumption. This ensures zero context loss across the escalation boundary, regardless of elapsed time. |
| `11_bounded_observation` | Destructive commands detected by bounded observation (e.g., `rm -rf`, `DROP TABLE`, `git push --force`) trigger mandatory escalation before execution. Observation flags the risk; escalation obtains permission. |
| `03_convergent_iteration` | Three-strike failures during convergent iteration trigger escalation when the agent's rethink phase fails to produce a new approach. The iteration log accompanies the escalation to give the user full diagnostic context. |
