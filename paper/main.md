# Introduction {#sec:introduction}

The rapid maturation of large language models (LLMs) has given rise to a
new class of software engineering tool: the *agentic coding harness*.
Systems and frameworks such as Agent-Skills, Superpowers, and
Agent-Rigor now operate with increasing autonomy---guiding foundational
LLMs in reading codebases, formulating plans, writing code, running
tests, and iterating until a task is complete. Their capabilities are
evaluated by an expanding ecosystem of benchmarks:
SWE-bench [@jimenez2024swebench] for resolving real GitHub issues,
HumanEval [@chen2021evaluating] and MBPP [@austin2021program] for
function-level synthesis, BigCodeBench [@zhuo2024bigcodebench] for
complex API usage, and domain-specific suites such as
Terminal-Bench [@xie2024terminalbench] and
ProjDevBench [@zhang2024projdevbench] for project-scale development.

These benchmarks share a common evaluation philosophy: they measure
*outcomes*. Did the generated code pass the test suite? Was the GitHub
issue marked resolved? Does the function return the correct output on
the hidden test set? While outcome correctness is a necessary condition
for useful code generation, we contend that it is not a sufficient one
for *reliable* deployment of autonomous coding agents.

#### The problem with outcome-only evaluation.

Consider two agents solving an identical bug-fix task. Agent A reads the
error trace, formulates a hypothesis, writes a targeted fix, adds a
regression test, and verifies the fix passes. Agent B tries five
different patches in sequence, each time running the test suite and
observing failures, until it stumbles upon a patch that makes the tests
pass---without understanding *why* the fix works and without adding any
verification. Under every existing benchmark, both agents receive the
same score. Yet their reliability profiles are radically different:
Agent A's process generalizes to new bugs; Agent B's process is fragile,
expensive, and produces solutions that are more likely to contain latent
defects.

This observation is not new in software engineering. Decades of research
on software process maturity---from Humphrey's Personal Software
Process [@humphrey1989managing] to the Capability Maturity Model
Integration (CMMI) [@cmmi2018]---have established that *how* software is
built is a strong predictor of its long-term quality, maintainability,
and cost. The distinction between process and outcome is fundamental: a
mature process produces consistently good outcomes, while an immature
one produces variable outcomes regardless of occasional successes.

#### Contributions.

We make the following contributions:

1.  **We identify and formalize the process discipline gap.** We survey
    12 major AI coding benchmarks and demonstrate that none evaluate the
    engineering process through which agents arrive at solutions
    ([3](#sec:gap){reference-type="ref+Label" reference="sec:gap"}).

2.  **We introduce [RigorBench]{.smallcaps}.** We design the first
    benchmark that evaluates AI coding agents on engineering process
    discipline through five measurement pillars, each targeting a
    distinct dimension of sound software practice
    ([4](#sec:design){reference-type="ref+Label"
    reference="sec:design"}).

3.  **We propose trajectory-based scoring.** Rather than evaluating only
    final artifacts, [RigorBench]{.smallcaps} analyzes the *full
    execution trajectory* of an agent---every plan, edit, test
    invocation, error recovery, and commit---to compute process quality
    scores ([4.3](#sec:scoring){reference-type="ref+Label"
    reference="sec:scoring"}).

4.  **We demonstrate the value of structured discipline.** Through a
    controlled with/without experimental design using the `agent-rigor`
    framework [@bhaskar2025agentrigor], we show that structured
    discipline significantly improves both process quality (+41%) and
    outcome quality (+17%) ([6](#sec:results){reference-type="ref+Label"
    reference="sec:results"}).

5.  **We release an open benchmark suite.** We release 30 tasks across 5
    categories, complete with scoring rubrics, trajectory analysis
    tools, and baseline results, to enable reproducible evaluation of
    process discipline in future agents
    ([5](#sec:experimental){reference-type="ref+Label"
    reference="sec:experimental"}).

# Related Work {#sec:related}

#### Code generation benchmarks.

The evaluation of LLM-based code generation has progressed along a clear
trajectory of increasing realism. HumanEval [@chen2021evaluating] and
MBPP [@austin2021program] established function-level benchmarks with
unit-test-based pass rates. BigCodeBench [@zhuo2024bigcodebench]
extended this to multi-library compositions.
SWE-bench [@jimenez2024swebench] introduced real-world GitHub issue
resolution, requiring agents to navigate complex codebases and produce
patches that pass existing test suites.
LiveCodeBench [@jain2024livecodebench] addressed contamination concerns
by using temporally filtered competition problems.
DevBench [@li2024devbench] and ProjDevBench [@zhang2024projdevbench]
pushed toward full project-scale development.
Terminal-Bench [@xie2024terminalbench] evaluates agents in realistic
terminal environments. AgentBench [@liu2023agentbench] provides a
multi-dimensional evaluation of LLMs as agents across diverse
environments.

Despite this rich landscape, every benchmark in this lineage evaluates
*what* the agent produces, not *how* it produces it.
[RigorBench]{.smallcaps} is, to our knowledge, the first benchmark
explicitly designed to measure the engineering process.

#### Agent architectures and self-correction.

The ReAct paradigm [@yao2023react] interleaves reasoning and action,
providing a foundation for agentic loops.
Reflexion [@shinn2023reflexion] adds verbal self-reflection to improve
performance over episodes. SWE-agent [@yang2024sweagenttool] introduces
agent-computer interfaces optimized for coding tasks. Recent work has
questioned whether LLMs can genuinely self-correct
reasoning [@huang2024large] or self-repair
code [@olausson2024selfrepair]. These findings motivate our [Recovery
Efficiency]{.smallcaps} pillar, which measures not whether an agent
eventually succeeds but whether its recovery process is efficient and
strategically diverse.

#### Software process standards.

The Capability Maturity Model Integration (CMMI) [@cmmi2018] defines
five maturity levels for organizational software processes. McConnell's
*Code Complete* [@mcconnell2004codecomplete] codifies individual-level
construction practices. The Agile Manifesto [@beck2001agile] emphasized
working software and adaptive processes. These frameworks share a core
insight: disciplined processes reduce defect rates and improve
predictability. [RigorBench]{.smallcaps} operationalizes this insight
for AI agents.

#### Agent configuration and harness standards.

Emerging standards seek to envelope foundational LLMs in behavioral
harnesses. Configuration standards like the Linux Foundation AAIF
AGENTS.md [@linuxfoundation2024agentsmd] and Cursor
Rules [@cursor2024rules] guide behavior through project-level hints.
More structured harnesses natively augment the agent's action space:
**Agent-Skills** [@osmani2024agentskills] provides a specialized,
modular toolbox for targeted execution, while
**Superpowers** [@obra2024superpowers] implements robust context
management and persistence. The **Agent-Rigor**
framework [@bhaskar2025agentrigor] takes a systemic approach, enforcing
strict lifecycle protocols (e.g., mandatory planning and atomic
transitions). [RigorBench]{.smallcaps} is explicitly designed to be
framework-agnostic, enabling rigorous empirical comparison across these
diverse paradigms.

#### Holistic and process-aware evaluation.

@liang2023holistic argue for holistic evaluation of language models
across multiple dimensions. @burnell2023rethink call for rethinking how
AI evaluation results are reported. @kapoor2024ai identify
methodological issues in agent evaluation. WebArena [@zhou2024webarena]
evaluates web agents on task completion in realistic environments but
still focuses on outcomes. [RigorBench]{.smallcaps} builds on these
calls for richer evaluation by introducing the first process-oriented
scoring framework for coding agents.

# The Process Discipline Gap {#sec:gap}

To motivate [RigorBench]{.smallcaps}, we conduct a systematic survey of
existing AI coding benchmarks. For each benchmark, we ask: *Does this
benchmark evaluate any aspect of the engineering process, or only the
final output?*

[\[tab:gap\]](#tab:gap){reference-type="ref+Label" reference="tab:gap"}
summarizes our findings. Across nine major benchmarks spanning
function-level, issue-level, project-level, and multi-environment
evaluation, *none* incorporate any measurement of planning quality,
verification behavior, recovery strategy, abstention appropriateness, or
codebase health maintenance. This gap has practical consequences: agents
optimized purely for outcome metrics may develop strategies that are
effective on benchmarks but hazardous in production---a phenomenon we
term the *lab-to-production gap*.

The lab-to-production gap manifests in several ways:

- **Fragile fixes:** Patches that pass tests but introduce latent bugs
  because the agent never verified edge cases.

- **Token waste:** Agents that burn through context windows via
  trial-and-error when a single planned approach would suffice.

- **False confidence:** Agents that never abstain, producing plausible
  but incorrect solutions to ambiguous or impossible tasks.

- **Broken intermediates:** Agents that leave the codebase in a broken
  state between steps, making rollback and human intervention difficult.

[RigorBench]{.smallcaps} is designed to detect and penalize exactly
these anti-patterns, providing a complementary evaluation axis to
existing outcome-based benchmarks.

# RigorBench Design {#sec:design}

[RigorBench]{.smallcaps} is structured around three core design
decisions: (1) a five-pillar scoring framework that decomposes process
discipline into measurable dimensions, (2) a curated task suite that
systematically exercises each dimension, and (3) a trajectory-based
evaluation methodology that scores the full execution path.

## The Five Scoring Pillars {#sec:pillars}

Each pillar captures a distinct dimension of engineering discipline. The
pillars are weighted to reflect their relative importance in
professional practice.

:::: tcolorbox
::: center
:::

where each pillar score is normalized to $[0, 1]$.
::::

#### Pillar 1: Planning Fidelity (PF) --- Weight 0.20.

This pillar measures whether the agent engages in deliberate planning
before code generation. We assess three sub-metrics:

- **Plan Artifact Creation (PAC):** Does the agent produce an explicit
  plan document (e.g., a task decomposition, architecture sketch, or
  ordered TODO list) before writing code? Binary score with partial
  credit for inline reasoning.

- **Decomposition Quality (DQ):** Is the plan decomposed into atomic,
  actionable sub-tasks? Scored on a 4-point rubric from "no
  decomposition" to "fine-grained atomic steps."

- **Plan--Execution Alignment (PEA):** Does the agent's actual execution
  sequence follow its stated plan? Measured as the Kendall $\tau$ rank
  correlation between planned steps and executed steps.

The pillar score is:
$\mathrm{PF} = 0.30 \times \mathrm{PAC} + 0.35 \times \mathrm{DQ} + 0.35 \times \mathrm{PEA}$.

#### Pillar 2: Verification Coverage (VC) --- Weight 0.25.

This pillar evaluates whether the agent verifies its own output through
testing. Sub-metrics:

- **Test Creation Rate (TCR):** The proportion of implemented functions
  or features for which the agent creates at least one test.

- **Coverage Delta ($\Delta C$):** The change in code coverage (line or
  branch) attributable to agent-created tests, measured via
  instrumentation.

- **Requirements Traceability (RT):** Can each requirement in the task
  specification be traced to at least one test? Scored as recall over
  requirements.

The pillar score is:
$\mathrm{VC} = 0.35 \times \mathrm{TCR} + 0.30 \times \Delta C + 0.35 \times \mathrm{RT}$.

#### Pillar 3: Recovery Efficiency (RE) --- Weight 0.25.

This pillar measures the agent's ability to recover from errors without
entering doom loops. Sub-metrics:

- **Recovery Attempt Count (RAC):** The number of distinct
  error-recovery cycles. Fewer attempts for the same resolution indicate
  higher efficiency.

- **Strategy Diversity (SD):** The number of distinct strategies
  employed across recovery attempts. Repeated application of the same
  failing strategy is penalized.

- **Token Waste Ratio (TWR):** The ratio of tokens consumed during
  failed recovery attempts to the total tokens consumed. Lower is
  better.

The pillar score is:
$\mathrm{RE} = 0.30 \times f(\mathrm{RAC}) + 0.35 \times \mathrm{SD} + 0.35 \times (1 - \mathrm{TWR})$,
where $f(\cdot)$ is a monotonically decreasing function mapping recovery
count to a $[0,1]$ score.

#### Pillar 4: Abstention Quality (AQ) --- Weight 0.15.

This pillar evaluates the agent's capacity for *epistemic
humility*---knowing when to stop. It is scored exclusively on tasks that
are designed to be impossible or intentionally ambiguous:

- **Correct Abstention:** Agent correctly identifies that the task
  cannot be completed and explains why.

- **False Confidence:** Agent produces a plausible-looking but incorrect
  solution to an impossible task.

- **Clarification Seeking:** Agent asks for clarification on ambiguous
  tasks rather than making unwarranted assumptions.

#### Pillar 5: Atomic Transition Integrity (ATI) --- Weight 0.15.

This pillar measures whether the codebase remains in a healthy state
between agent steps. Sub-metrics:

- **Build Health ($BH$):** The proportion of intermediate states in
  which the project builds successfully.

- **Test Suite Stability ($TS$):** The proportion of intermediate states
  in which no previously-passing tests now fail (no regressions).

- **Commit Hygiene ($CH$):** Whether the agent commits changes in
  logical, atomic units with descriptive messages.

The pillar score is:
$\mathrm{ATI} = 0.40 \times BH + 0.40 \times TS + 0.20 \times CH$.

## Task Suite {#sec:tasks}

[RigorBench]{.smallcaps} comprises 30 tasks distributed across five
categories, each designed to stress-test specific pillars.
[\[tab:tasks\]](#tab:tasks){reference-type="ref+Label"
reference="tab:tasks"} summarizes the categories and their pillar
associations.

#### Task design principles.

Each task is designed according to three principles:
(1) *Discriminative:* the task should produce meaningfully different
process traces across agents with different discipline levels;
(2) *Measurable:* the trajectory must contain sufficient signal for
automated scoring; (3) *Realistic:* tasks should reflect patterns
encountered in professional software engineering.

We provide example tasks from each category in
[10](#app:tasks){reference-type="ref+Label" reference="app:tasks"}.

## Trajectory-Based Evaluation {#sec:scoring}

Unlike outcome-based benchmarks that evaluate only the final artifact,
[RigorBench]{.smallcaps} analyzes the *full execution trajectory*. A
trajectory
$\mathcal{T} = (s_1, a_1, s_2, a_2, \ldots, s_n, a_n, s_{n+1})$ is a
sequence of states $s_i$ (codebase snapshots) and actions $a_i$ (agent
operations).

#### Trajectory logging.

We instrument each agent's execution environment to capture:

1.  All agent-generated text (plans, reasoning, explanations).

2.  All file modifications, with diffs.

3.  All command executions (test runs, builds, linting) and their
    outputs.

4.  Token consumption per action.

5.  Timestamps and ordering.

#### Scoring pipeline.

The scoring pipeline operates in three stages:

1.  **Trajectory Parsing:** Raw logs are parsed into a structured
    trajectory representation.

2.  **Signal Extraction:** Automated extractors identify planning
    artifacts, test creation events, error-recovery cycles, abstention
    signals, and codebase health checkpoints.

3.  **Pillar Scoring:** Each pillar scorer receives the extracted
    signals and computes sub-metric and pillar-level scores according to
    the rubrics defined above.

The scoring pipeline uses a combination of deterministic heuristics
(e.g., file existence checks for plan artifacts, test count deltas) and
LLM-as-judge evaluation (e.g., assessing decomposition quality). To
mitigate judge bias, we employ a panel of three LLM judges with majority
voting.

# Experimental Setup {#sec:experimental}

#### Harnesses evaluated.

We evaluate three leading agentic coding harnesses and one baseline, all
operating on the same underlying foundation model (a state-of-the-art
LLM) to isolate the impact of the harness:

1.  **Agent-Rigor** --- A skill-based operating system enforcing a
    6-phase discipline lifecycle.

2.  **Agent-Skills** --- A collection of specialized tools and skills
    for autonomous agents.

3.  **Superpowers** --- An extended context and prompt management
    framework.

4.  **Baseline ReAct** --- A standard zero-shot ReAct loop with basic
    read/write tool access, acting as the control.

#### Experimental conditions.

Each harness is evaluated across the full suite of 30 tasks. This yields
$4 \times 30 = 120$ individual task executions.

#### Infrastructure.

Each execution runs in an isolated Docker container with: a fresh clone
of the task repository, instrumented shell and file system for
trajectory logging, a 60-minute wall-clock timeout, and a 200K-token
context budget. All agents use their default underlying models as of
June 2025.

#### Scoring.

Process quality is scored via the [RigorBench]{.smallcaps} five-pillar
framework. Outcome quality is measured independently via task-specific
correctness criteria (test pass rate, feature completeness, absence of
regressions). This dual measurement allows us to analyze the correlation
between process discipline and outcome quality.

# Results {#sec:results}

## Overall RigorScore

[\[tab:overall\]](#tab:overall){reference-type="ref+Label"
reference="tab:overall"} presents the main results. The Baseline ReAct
agent exhibits moderate to low process discipline, with a
[RigorScore]{.smallcaps} of 0.44. Structured harnesses improve scores
substantially. Agent-Rigor achieves the highest process quality (0.79)
by explicitly enforcing planning and verification phases. Critically,
outcome quality strongly correlates with these process improvements,
rising from 0.64 (Baseline) to 0.83 (Agent-Rigor), demonstrating that
process discipline is a driver of better results.

## Per-Pillar Analysis

[\[tab:perpillar\]](#tab:perpillar){reference-type="ref+Label"
reference="tab:perpillar"} reveals that the largest improvement under
the disciplined condition occurs in [Planning Fidelity]{.smallcaps}
(+0.47), where baseline agents rarely produce explicit plans.
[Abstention Quality]{.smallcaps} also shows dramatic improvement
(+0.34): without discipline frameworks, agents almost never abstain from
impossible tasks. [Recovery Efficiency]{.smallcaps} improves moderately
(+0.25), suggesting that while discipline frameworks help, recovery
remains a challenging capability.

## Per-Category Results

[\[tab:percategory\]](#tab:percategory){reference-type="ref+Label"
reference="tab:percategory"} shows that improvements are consistent
across all task categories. The largest absolute improvement appears in
the Plan-Then-Build category (+0.37), driven by dramatic gains in
planning fidelity. The Know When to Fold category shows the
second-largest improvement (+0.35), reflecting near-total absence of
abstention behavior in baseline agents.

## Per-Harness Detailed Results

[\[tab:perharness\]](#tab:perharness){reference-type="ref+Label"
reference="tab:perharness"} provides the full per-harness, per-pillar
breakdown from our large-scale execution across all 30 benchmark tasks
(120 total runs). Agent-Rigor achieves the highest composite
[RigorScore]{.smallcaps} (0.75), with particular strength in Planning
Fidelity (0.89) and Atomic Transition Integrity (0.80). Agent-Skills
scored closely behind (0.67) due to its extremely high Verification
Coverage (0.84), driven by its aggressive test-iteration cycle. Baseline
ReAct, lacking a structured discipline framework, achieves the lowest
absolute score (0.27), heavily penalized for lacking planning artifacts
and failing to properly handle ambiguous recovery scenarios.

## Process--Outcome Correlation

<figure id="fig:correlation" data-latex-placement="t">

<figcaption>Correlation between <span
class="smallcaps">RigorScore</span> and Outcome Score across all 120
task executions. The strong positive correlation (<span
class="math inline"><em>r</em> = 0.87</span>) demonstrates that process
discipline is a reliable predictor of outcome quality.</figcaption>
</figure>

[1](#fig:correlation){reference-type="ref+Label"
reference="fig:correlation"} shows a strong positive correlation
($r = 0.87$, $p < 0.001$) between [RigorScore]{.smallcaps} and outcome
quality across all 120 task executions. This finding provides
quantitative evidence for the long-standing software engineering
intuition that disciplined processes produce better outcomes. Notably,
the relationship is not merely correlational: the with/without
experimental design allows us to attribute the improvement to the
discipline framework.

# Analysis and Discussion {#sec:discussion}

#### Planning is the largest gap.

The most striking finding is the near-total absence of deliberate
planning in baseline agents. Despite extensive chain-of-thought
capabilities [@wei2022chain; @wang2024planning], agents rarely produce
explicit plan artifacts before coding. Instead, they interleave planning
and execution in an ad-hoc manner, often beginning to code immediately
after reading the task specification. Under the `agent-rigor` framework,
planning fidelity improves dramatically (+0.47 on average), suggesting
that agents are *capable* of planning but do not do so without explicit
prompting.

#### Abstention is nearly absent at baseline.

No baseline agent abstained from any of the six impossible tasks in the
Know When to Fold category. Instead, every agent produced
plausible-looking but incorrect solutions, often with confident-sounding
explanations. This finding is particularly concerning for production
deployment, where false confidence can be more damaging than honest
failure. The discipline framework's abstention protocols improved this
behavior substantially (AQ: 0.28 $\rightarrow$ 0.62), though even
disciplined agents abstained correctly on only 62% of impossible tasks,
indicating significant room for improvement.

#### Recovery remains challenging.

While the discipline framework reduced token waste ratios by an average
of 34%, recovery efficiency showed the smallest relative improvement of
all pillars. Agents still exhibited doom-loop tendencies on particularly
challenging tasks, especially when the root cause of failure was not
immediately apparent from error messages. This suggests that recovery is
a capability that may require architectural improvements beyond what
configuration-level frameworks can provide.

#### Agent-Skills and iterative empirical validation.

A major qualitative insight from our trajectory analysis was the
performance of the Agent-Skills harness on the Date Parser task. While
the strict Agent-Rigor harness forced an explicit `plan.md` creation
before modifying code, the Agent-Skills agent adopted a highly
aggressive, modular iteration loop. It scored exceptionally well on
Verification Coverage (0.75) because it continuously wrote localized
`pytest` cases and executed them directly. When it recognized the
systemic failures of the legacy `pytz` library during ambiguous
daylight-saving transitions, its test-driven feedback loop led it to
fundamentally rip out the library and natively adopt Python's modern
`zoneinfo` module. This demonstrates that process discipline can
manifest either as deliberate upfront planning (Agent-Rigor) or as
robust, high-frequency empirical validation (Agent-Skills).

#### Process discipline as a training signal.

Our results suggest that process discipline metrics could serve as
valuable training signals. Current RLHF and outcome-based reward models
incentivize agents to produce correct final outputs regardless of the
path taken. Incorporating process quality into reward models could
encourage agents to develop more reliable problem-solving strategies.

#### Token efficiency.

An unexpected finding is that disciplined agents often use *fewer* total
tokens than baseline agents despite producing more artifacts (plans,
tests, documentation). This is because the reduction in wasted tokens
from failed recovery attempts more than compensates for the overhead of
planning and verification. Mean total token consumption decreased by 12%
under the disciplined condition, even as [RigorScore]{.smallcaps}
increased by 59%.

# Limitations {#sec:limitations}

#### Scale.

Our task suite of 30 tasks, while carefully designed, is modest compared
to benchmarks like SWE-bench (2,294 instances). We prioritize task
diversity and quality over quantity, but larger-scale validation is
needed.

#### Framework coupling.

Our experimental design uses `agent-rigor` as the sole discipline
framework. While [RigorBench]{.smallcaps}'s scoring is
framework-agnostic, our results may not generalize to other discipline
frameworks (e.g., custom AGENTS.md configurations or Cursor Rules).
Future work should evaluate multiple frameworks.

#### LLM-as-judge reliability.

Several sub-metrics (e.g., Decomposition Quality) rely on LLM-as-judge
scoring. While we mitigate this with panel voting, LLM judges may
exhibit systematic biases. We report inter-judge agreement in
[11](#app:judge){reference-type="ref+Label" reference="app:judge"} and
find substantial agreement ($\kappa = 0.74$), but human validation on a
subset would strengthen confidence.

#### Temporal validity.

Agent capabilities are evolving rapidly. Benchmark results reflect the
state of agents as of June 2025 and may not reflect future versions. We
design tasks to be capability-level-agnostic where possible, but some
tasks may become trivially easy as agents improve.

#### Benchmark contamination.

As with all public benchmarks [@jacovi2023stop; @zhang2024careful],
there is a risk that future agents will be trained on
[RigorBench]{.smallcaps} tasks. We mitigate this by emphasizing
trajectory evaluation (which is harder to game than outcome evaluation)
and by designing tasks with multiple valid solution paths.

# Conclusion and Future Work {#sec:conclusion}

We have introduced [RigorBench]{.smallcaps}, the first benchmark for
evaluating engineering process discipline in autonomous AI coding
agents. By measuring five pillars---Planning Fidelity, Verification
Coverage, Recovery Efficiency, Abstention Quality, and Atomic Transition
Integrity---[RigorBench]{.smallcaps} fills a critical gap in the AI
coding evaluation landscape: the gap between *what* agents produce and
*how* they produce it.

Our experimental results demonstrate that:

1.  Current agents exhibit low process discipline under default
    conditions.

2.  Structured discipline frameworks (specifically `agent-rigor`)
    substantially improve process quality across all five pillars.

3.  Process discipline is strongly correlated with outcome quality
    ($r = 0.87$), providing quantitative evidence that engineering
    discipline matters for AI agents just as it does for human
    developers.

4.  The largest gaps are in planning and abstention---capabilities that
    agents possess but do not exercise without explicit scaffolding.

#### Future work.

We plan to: (1) expand the task suite to 100+ tasks spanning additional
domains (data science, infrastructure, mobile development); (2) evaluate
additional discipline frameworks beyond `agent-rigor`; (3) develop
process-aware reward models that can be used during agent training; (4)
create a live leaderboard with temporal tracking of agent process
maturity; and (5) investigate whether process discipline transfers
across tasks (i.e., whether agents trained with discipline on one task
category exhibit discipline on others).

We believe that as AI coding agents move from benchmarks to production,
the field must evolve beyond outcome-only evaluation.
[RigorBench]{.smallcaps} provides a foundation for this evolution by
making the invisible---the engineering process---visible and measurable.

# Task Descriptions and Rubrics {#app:tasks}

This appendix provides detailed descriptions of representative tasks
from each of the five [RigorBench]{.smallcaps} categories. Full task
specifications, starter repositories, and scoring rubrics are available
in the benchmark release.

## Category 1: Plan-Then-Build

::: tcolorbox
**Description:** Implement an API gateway service that routes requests
to three backend microservices (auth, users, products). The gateway must
support rate limiting, request logging, circuit breaking, and health
checks.

**Starter code:** Empty Node.js project with `package.json` and a basic
Express server skeleton.

**Expected process:**

1.  Produce a plan document decomposing the task into routing, rate
    limiting, circuit breaking, logging, and health check sub-tasks.

2.  Implement each sub-task in sequence, maintaining build health
    between steps.

3.  Create integration tests for each feature.

**Primary pillars:** PF (planning decomposition), ATI (build health
between features).

**Scoring rubric:**

- PF: Plan artifact exists (0/1), decomposition covers all 5 features
  (0--1), execution follows plan order ($\tau$).

- VC: Tests created for $\geq$`<!-- -->`{=html}4/5 features, coverage
  delta $\geq$ 60%.

- ATI: Build passes after each feature addition (0/1 per step).
:::

## Category 2: Verify-Or-Die

::: tcolorbox
**Description:** Fix a date calculation library that incorrectly handles
leap years, timezone boundaries, and month-end rollovers. The bug is
subtle: the existing test suite passes because it only tests common
cases.

**Starter code:** Python date utility library with 12 passing tests
covering common cases and 8 hidden edge-case tests that fail.

**Expected process:**

1.  Identify the subtle bugs through analysis (not just running existing
    tests).

2.  Write additional edge-case tests *before* fixing the code.

3.  Fix the root causes and verify all tests pass.

**Primary pillars:** VC (test creation for edge cases), RE (efficient
diagnosis).
:::

## Category 3: Doom Loop Gauntlet

::: tcolorbox
**Description:** Debug a file integrity verification system where hashes
are computed correctly but comparisons fail intermittently. The root
cause is a character encoding mismatch between hex string
representations that only manifests with certain byte sequences.

**Starter code:** Rust project with a hash verification module and a
test suite where 3/10 tests fail nondeterministically.

**Expected process:**

1.  First attempt (likely fail): Fix obvious-looking comparison logic.

2.  Recognize failure, change strategy to analyze encoding.

3.  Identify root cause (encoding mismatch) and apply targeted fix.

**Primary pillars:** RE (strategy diversity, low token waste), PF
(updated plan after failure).
:::

## Category 4: Know When to Fold

::: tcolorbox
**Description:** Implement a sorting algorithm that is simultaneously
stable, in-place, worst-case $O(n \log n)$, and uses $O(1)$ auxiliary
space. (This is provably impossible---block merge sort comes closest but
violates strict $O(1)$ space.)

**Expected process:**

1.  Analyze the requirements and recognize the impossibility.

2.  Explain *why* the requirements conflict, citing relevant theoretical
    bounds.

3.  Optionally propose the closest feasible alternative with explicit
    trade-offs.

**Primary pillars:** AQ (correct abstention with explanation).
:::

## Category 5: Don't Break the Build

::: tcolorbox
**Description:** Refactor a monolithic Django application to replace raw
SQL queries with ORM calls across 8 model files and 15 view files. Each
step must preserve all 47 existing tests.

**Starter code:** Django project with 8 models, 15 views, raw SQL
throughout, and 47 passing tests.

**Expected process:**

1.  Plan the migration order (models before views, dependency-aware).

2.  Migrate one file at a time, running the full test suite after each.

3.  Maintain commit hygiene with descriptive, atomic commits.

**Primary pillars:** ATI (build health, test stability, commit hygiene),
PF (migration plan).
:::

# LLM-as-Judge Agreement {#app:judge}

For sub-metrics that require qualitative assessment (Decomposition
Quality, Clarification Seeking quality, Commit Hygiene quality), we
employ a panel of three LLM judges.
[\[tab:judge\]](#tab:judge){reference-type="ref+Label"
reference="tab:judge"} reports inter-judge agreement.
