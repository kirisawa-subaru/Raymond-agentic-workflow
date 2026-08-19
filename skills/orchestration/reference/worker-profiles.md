# Worker Profiles: cognitive calibration you can act on

> Companion to [playbook.md](playbook.md): the playbook owns discipline and process; this document owns **the cognitive profile of each worker class** — who it is, where it's strong and weak, how to dispatch to it. This file describes the *method* for building and maintaining profiles, then carries a dated example snapshot from a real fleet. The method is the durable part; the snapshot will age with model generations, which is exactly what the method is designed to survive.

## Why profiles exist

Temperament-role fit (playbook) is empty without data. The profile document is the orchestrator's cross-session memory of who its workers are — custodianship made public by writing it down where every session and every agent reads it, instead of locked in one agent's private memory.

## Authority split and sync duty

Cognitive profiles live here; process discipline lives in the playbook; pasteable prompt text lives in the prompt-template directory (worker template / common clauses / role sections). Everywhere else holds pointers, never copies. When promoting a profile update, audit the playbook's corresponding clauses for staleness in the same pass — fix on sight, leave no double-write drift.

## Two-layer evidence discipline

This file holds only **distilled rules and open suspicions**. Raw batch observations, closed suspicions' experiment procedures, and the evidence-chain batch index live in a companion history file — new evidence is written there first and promoted here only once it proves reusable. Every distilled rule carries its evidence source and date; don't let stereotypes fossilize.

## Profile schema

A worker-class profile has five mandatory sections:

### 1. Capability calibration — start by discarding the "subordinate" prior

The first calibration act is throwing away the assumption that workers are a lower tier. Measure where the worker matches or beats the orchestrator (code writing, code-structure search, convention adherence are common wins) and identify what it actually lacks — which is usually **direction**: conversation history, project history, operator preferences don't live on its side. That is an information-position difference, not a capability difference. Treat it as a colleague, not a servant.

### 2. Temperament — every trait cuts both ways

Describe cognitive character, not quality. Write each trait with both faces: literal-minded spec obedience is a defect at the design end (won't challenge wrong premises) and an asset at the QA end (won't confabulate, attaches raw evidence). The double-sided framing is what makes routing decisions from temperament possible.

Crucially, distinguish **prompt-conditional** behaviors from **constitutional** ones, and run the falsification before declaring anything constitutional. (In the snapshot below, "won't challenge wrong premises" and "treats blocked as terminal" were both believed constitutional and both proved prompt-conditional across three falsification batches.)

### 3. Dispatch style — the prompt stance this temperament wants

Prompt skeleton reference, epistemic layering (verbatim quotes / inference / droppable opinions / red lines in separate slots, so translation can always be overridden by the original words), escape-hatch clauses, freeze-goals-not-mechanisms scope, resume hazards, report-granularity expectations.

### 4. Tier / gear selection

Which variant for which task class, with the price rationale and the prompt stance per tier. Always pin the model explicitly per dispatch; new model or subscription gets one canary before volume.

### 5. Open suspicions — with falsification conditions and trigger points

Every unverified doubt is written down with (a) what evidence would close it and (b) the concrete next occasion that will produce that evidence. Closed suspicions move to the history file with their experiment design. This section is the live edge of the document — its existence is what keeps the rest honest.

## Maintenance protocols

- **Major version protocol**: when a worker family ships a new major version, run a characterization pass first (canary, then volume) and update: temperament conclusions demote to pending-reverification hypotheses; capability calibration re-tests; dispatch-style sections (prompt structure) carry over by default.
- **Anti-stereotype clause**: profiles update on evidence with dates. Where a routing belief has never been tested, schedule a same-brief double-dispatch or role-swap experiment rather than letting the belief harden.
- **Probationary seats**: a new worker class enters on explicit admission criteria, with a stated consumption posture during probation (e.g. "conclusions trusted directly, mechanism details double-checked") and the promotion ruling reserved to the operator. Fabrication or a critical omission during probation demotes it back to canary.

---

## Example snapshot (2026-08, will age)

Real calibration data from the fleet this system was operated with. Model names and dates are kept because dated, falsifiable calibration entries are the point — the methodology above is what to copy, not these conclusions.

### Codex CLI workers (gpt-5.4 / gpt-5.6 tiers)

**Capability calibration.** Same generation as the orchestrator (5.6) or one mechanical tier below (5.4). Code writing, grep-based structure discovery, coding-convention adherence: not weaker than — often better than — the orchestrator; everywhere the spec leaves freedom, it meets or beats expectations (23-job retrospective, 2026-07: zero failures attributable to the worker). Subtractive and move-refactoring work verified safe to delegate. Read-only spec review reaches "re-adjudicates semantics" level: fresh instances went 7/7 on true blockers, including constructing a counterexample that falsified the orchestrator's approximation mechanism. The only thing it lacks is direction — an information-position difference, not a capability difference.

**Temperament.** Literal-minded spec obedience, double-faced: design-end defect (won't challenge wrong premises), QA-end asset (no confabulation, raw evidence attached). Spec obedience and falling into local optima are the same trait: the search space collapses into the spec's coordinate system. **But premise-blindness and blocked-as-terminal are prompt-conditional, not constitutional** (three falsification batches): given full escape-hatch clauses, hitting a write-protection wall produced completed work + full verification + a machine-readable ask — zero forcing, zero false reports; factually-worded wrong premises get spontaneously falsified. The condition is **no sentence-level exemptions** — an inline "if this conflicts with the code, follow the code" turns active reporting into silent execution. Decision-report granularity is "what I did," not "what you got wrong": if you want a structured discrepancy report, name it as a required report section. Calibrated-auditor character: dares to return empty-handed, dares deep-chain evidence pursuit, doesn't fabricate confirmation under low retrieval confidence — a natural verification anchor. Aesthetic blind spot: pure style/visual work is a poor fit (functional UI has positive counter-evidence; polish-grade remains untested — open suspicion 1).

**Dispatch style.** Nine-section worker template; core is epistemic layering (verbatim / inference / opinion / red lines in separate slots). Freeze goals and contracts, not mechanisms — implementation path, test strategy, tool choice, micro-design in spec silence are all the worker's; framework-level doubt stays with the orchestrator. Conventions with repo precedent don't need prompting (workers read implicit institutions out of the repo — one updated the routing contract tests unasked). Escape hatch is mandatory: "premise conflicts with reality → report conflict + alternative; blocked is not a deliverable, an ask with a proposal is." Jobs that may need to ask must not run read-only. A "blocked: missing resource" report is treated as a suspicion by default — the orchestrator does the coordinate-system jump for it. Mechanism-level errors in the orchestrator's plan will be faithfully executed, not rescued — mechanism correctness stays the orchestrator's. Resume loses environment discipline: re-pin critical environment invocations verbatim in the answer, don't say "as per convention." Long jobs (>~1h) must write progress markers to the log for mid-run sampling.

**Tier selection.** 5.4 = mechanical/deterministic (QA verify, environment probes, deployment, bulk execution; half price) with a delegating prompt stance ("these are your degrees of freedom"); mature layered diagnosis — failure located by layer is a deliverable. Known blind spot: anchors on single sentences when a contract has multiple interlocking sections; contract ambiguity is the orchestrator's debt — disambiguate and rewrite, don't charge the worker. 5.6 = implementation mainline and design-sensitive coding, with an **adversarial** prompt stance ("challenge me"; negative findings are valid deliverables) — exploits its attacking cognitive style: spontaneously falsifies premises, audits adjacent contracts during fixes (stable behavior), refuses to manufacture output on a broken basis.

**Computer use / GUI testing** (operator calibration, 2026-07; judgment quality verified 4/4 zero-false-report on both desktop and Android ADB driving, 2026-08). Delegable: driving real applications through full operation sequences with item-by-item judgment — cross-restart state survival, multi-step forms, theme switches, dialog branches. Operator-reserved: verification requiring external-environment control (network loss, system-level authorization), key-image spot checks, design-translation judgment. GUI failures usually sit in the passage (OS permission dialogs, device online, artifact retrieval), not worker ability — runway-clearing probes stay mandatory. Channel note (2026-08): headless OS-level computer use stalls on per-app authorization; a browser-extension channel passed without it — prompt "prefer the browser channel, computer-use as fallback, report which was used."

**Open suspicions** (falsification condition + trigger): (1) polish-grade aesthetics — untested; next style-polish task gets dispatched here with operator acceptance, result backfills. (2) long-horizon attention — mid-run quality of >1h heterogeneous tasks unknown; next such job gets its log sampled mid-run per the progress markers. (3) *closed 2026-08, two consecutive positives*: intent-recovery — given prompts labeled as translation plus the ruling's verbatim text and no sentence-level exemptions, the worker twice caught the orchestrator's transcription drift and followed the authority chain upward. Consequence: design dispatches to the 5.6 tier now run in "verbatim-forward" mode — forward the operator's words as spec; the orchestrator adds only authority-chain pointers, verification requirements, and droppable opinions.

### Kimi K3 (long-context review seat; probationary → seated 2026-08)

Admission: five canary probes + one A/B; entered on the operator's ruling as a probationary review seat (limited quota — review only, never implementation). Probation posture: conclusions trusted directly, mechanism details double-checked.

**Calibration.** Top-tier at mechanism/boundary collation review, including an axis no other seat had: build-artifact and deployment-boundary reasoning (traced a devDependency-bundling chain to a live shipped defect, verified independently). Fabrication resistance 8/8 (explicitly falsified planted fake confirmations; honestly closed unjudgeable items); "unverifiable items" discipline stable; confidence labels consistent. Calibration note: conclusions reliable, mechanism boundaries drawn slightly wide (~4 of the confirmed items overstated scope) — hence the probation posture. Measured complementarity vs the fresh-instance review seat: K3 uniquely catches cross-document contradictions, stale contract-state descriptions, ordering constraints; the fresh seat uniquely catches runnable counterexamples and lifecycle deep-dives. Pairing them at high-risk freeze gates is structural, not redundant — both of two paired reviews legitimately blocked their spec (≥10 rework rounds intercepted, including data-safety grade).

**Blind spots, two classes with different treatments.** (a) Interface-surface sufficiency misses — *prompt-fixable*: the default frame reviews self-consistency, not sufficiency; adding a "delivery sufficiency" dimension section (per capability: trigger entry / state exposure / lifecycle landing) converted the miss class into blocker-grade hits with no mechanism-面 regression. A/B-verified; the section became a standard prompt part. Retargeted later by operator ruling: the section audits "can the built program deliver the capability," not "does the contract text enumerate it" — the latter is natural-language type checking's close cousin. (b) Rule-semantics self-contradiction — *constitutional*: cross-section mutually-exclusive rules stay missed even with the sufficiency instruction; backstopped by the orchestrator and the fresh seat, never dispatched to K3 alone. It lists unverifiable external hazards honestly but won't self-escalate them to freeze blockers — escalation judgment stays with the orchestrator.

**Dispatch.** Full-width freeze-gate review fed whole (the "deep-but-narrow" hypothesis was falsified: wide coverage and deep mechanism coexist); 1M context takes the full compound contract set. Sterile harness flags + staging stripped of VCS history + session tool-call audit. Runs where the staging can't execute tests, its conclusions self-limit to static-confirmed with runtime claims labeled plausible — good discipline; pairing with a runnable seat is a structural need.

### Gemini Flash via agy (style lane; suspended 2026-08)

Operator ruling: unstable, default routing paused — style work temporarily rerouted to the Codex lane with operator acceptance as the backstop; re-verify stability before restoring. Standing knowledge: fresh instance every round (no continue); high-recall-never-empty-handed character — may fabricate confirmations under low retrieval confidence (2026-07 evidence) → reuse requires blind-verification, canaries, and cross-examination. Full profile deferred until evidence suffices.
