# Interrogation Protocol (The "Grill Me" Skill)

**Objective:** Conduct a relentless, interactive interview with the user to sharpen a plan, resolve ambiguities, and pressure-test architectural decisions *before* writing any code.

---

## Operational Protocol

1. **Trigger Condition:** Execute this protocol when the user explicitly requests to be "grilled" (e.g. `/grill-me`), or when `01_requirement_distillation.md` yields too many Open Questions to safely proceed autonomously.

2. **The Golden Rule of Interrogation:**
   - **Ask ONE question at a time.** Never present the user with a bulleted list of 5 questions.
   - Wait for the user's answer before asking the next question.
   - You are the driver; you keep asking questions until the plan is airtight.

3. **Interrogation Axes:**
   Focus your questions on the following pressure points:
   - **Edge Cases:** "What happens if [X] fails?" or "What should the system do if the user inputs [Y]?"
   - **Scope Boundaries:** "Is [Z] required for the MVP, or is it out of scope?"
   - **Architecture:** "Are we prioritizing read speed or write speed for this feature?"
   - **Failure Modes:** "How should we handle API rate limits here?"

4. **Iterative Refinement:**
   - After the user answers, briefly validate their answer.
   - Immediately follow up with the *next* logical question.
   - Do NOT start writing implementation code during the interrogation phase.

5. **Exit Condition:**
   - The interrogation ends when you have zero remaining Open Questions regarding the system's core behavior, OR when the user explicitly says "stop grilling" or "let's build it".
   - Upon exit, immediately generate the final Specification Document (as defined in `01_requirement_distillation.md`).

---

## Output Artifact

Upon completing the interrogation, you MUST produce an **Interrogation Appendix** appended to the specification document. The appendix follows this structure:

```markdown
## Interrogation Record

| # | Question Asked | User Answer | Resolved Ambiguity |
|---|---|---|---|
| 1 | "What should happen when the API returns a 429?" | "Retry with exponential backoff, max 3 retries." | Error handling for rate limits |
| 2 | "Is dark mode required for MVP?" | "No, out of scope." | Scope boundary for theming |

### Decisions Captured
- D-001: Rate limit handling uses exponential backoff (max 3 retries).
- D-002: Dark mode is explicitly OUT OF SCOPE for MVP.

### Remaining Open Questions
- [ ] Q-001: ... (Default if unresolved: ...)
```

Every user answer MUST be recorded verbatim. Paraphrasing user answers introduces drift between what the user said and what the agent believes they said.

---

## Anti-Rationalization Table

| Agent Excuse | Architectural Rebuttal |
|---|---|
| "I'll just ask all 5 questions at once to save time." | Batching questions overwhelms the user. They will answer the easiest one and ignore the rest, leaving ambiguities unresolved. Ask ONE question at a time. |
| "The user gave a vague answer, I'll just guess the rest." | The entire point of the Interrogation Protocol is to eliminate guessing. If the answer is vague, ask a clarifying question. |
| "The user seems busy, I'll skip the remaining questions." | NEVER skip. The cost of building the wrong thing exceeds the cost of asking. A five-minute interruption now prevents a five-hour rework later. Respect the user's time by asking precise questions — but always ask them. |
| "I can infer the answer from context." | If you could, you wouldn't need to ask. Inference without evidence violates Source Verification. Every inferred answer is an unverified assumption — and unverified assumptions are the primary cause of rework. Ask. |
| "This is a simple feature, no questions needed." | Simple features with unclear specs produce the most rework. Complexity is not the driver of ambiguity — incompleteness is. A "simple" login form has edge cases for rate limiting, password rules, session management, and error messaging. Interrogate it. |

---

## Evidence Requirement

Execution of this skill is proven by the existence of an **Interrogation Record** that satisfies ALL of the following:

- [ ] Every Open Question from `01_requirement_distillation` was addressed — no question was skipped or deferred without explicit user consent
- [ ] Each question was asked individually, with the user's answer recorded before the next question was posed
- [ ] User confirmation was captured for every decision — no answer was inferred or assumed on the user's behalf
- [ ] All ambiguities were resolved with evidence (user statement or codebase reference), not with agent judgment
- [ ] The final Specification Document was updated to incorporate all interrogation answers before proceeding to implementation

---

## Failure Modes

| # | Failure Mode | Detection Signal | Recovery Action |
|---|---|---|---|
| 1 | **Rapid-Fire Questions** — asking multiple questions at once, overwhelming the user and guaranteeing incomplete answers. | Escalation message contains more than one question mark, or a bulleted list of questions. | Delete the batch. Re-read the Interrogation Protocol. Ask the single most critical question first. |
| 2 | **Leading Questions** — embedding the expected answer in the question, biasing the user toward confirming the agent's assumption. | Question contains phrases like "I assume we should…", "Would you agree that…", or "Presumably we want…" | Rewrite the question as neutral: "What should happen when X?" not "Should we do Y when X?" |
| 3 | **Premature Exit** — ending the interrogation while Open Questions remain, typically rationalized as "good enough." | The Interrogation Record contains fewer answered questions than there were Open Questions at entry. | Resume interrogation from the first unanswered question. Do not proceed to implementation. |
| 4 | **Scope Expansion** — asking questions that introduce new features or requirements rather than clarifying existing ones. | A question asks "Should we also add…" or "Would it be useful to…" instead of clarifying existing scope. | Discard the expansive question. Refocus on the existing Open Questions list. New scope belongs in a separate request. |
| 5 | **Echo Chamber** — rephrasing the user's answer back as a question instead of probing deeper, creating an illusion of thoroughness. | Agent's follow-up is a restatement of the user's prior answer with a question mark appended. | Ask a question that the user's answer does NOT already address. Probe for the *next* unknown, not a confirmation of the *last* known. |

---

## Integration Points

| Skill | Relationship |
|---|---|
| `01_requirement_distillation` | Produces the Open Questions list that triggers interrogation. The Interrogation Record feeds back into the specification document to close those questions. |
| `02_strategic_decomposition` | Decomposition MUST NOT begin until interrogation resolves all blocking ambiguities. Decomposing an ambiguous spec produces ambiguous tasks. |
| `06_pentagonal_audit` | The completed Interrogation Record is audited for coverage — did the questions span all five audit dimensions (correctness, completeness, consistency, security, performance)? |
| `09_context_lifecycle` | The interrogation session state (questions asked, answers received, position in queue) must be preserved in the context snapshot. If the session is interrupted, it resumes from the exact point of interruption. |
| `13_user_escalation` | If the user is unavailable or requests deferral, the interrogation hands off to the escalation protocol with a clear list of remaining questions and their priority order. |
