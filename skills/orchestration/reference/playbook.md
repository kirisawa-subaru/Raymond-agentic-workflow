# Cross-Model Orchestration Playbook

> Load before any dispatch that coordinates work across model families or external agent runtimes. Authority split: **this playbook owns process discipline**; [worker-profiles.md](worker-profiles.md) owns per-worker cognition (read it before writing any worker prompt); pasteable prompt text lives in your prompt-template directory. All three are living documents — read them fresh each time, never cache or summarize. When updating one side, audit the other for drift; no double-write.

Every rule below is bound to a **role**, never to a model. Incidents that motivated a rule are cited inline with dates; project identifiers are anonymized, the mechanics are not.

## Roles and routing

Roles are constant; seat assignments (which model sits in which role) drift with every model generation. All rules bind to roles — changing a model edits only the Local configuration seat map in `../SKILL.md`. Worker-profiles supplies the cognitive evidence used to choose those seats; it does not own the current mapping.

A working fleet needs at least these roles:

```text
Operator       — direction, taste, dangerous decisions, escalation response, on-device acceptance
Orchestrator   — contract freezing, adversarial-test authorship, prompts, merge rulings + spot checks, context continuity
Implementation — logic / data / API / build / test execution, resumable threads
QA             — verification scripts, deployment, evidence-based reports, independent threads
Review A       — large-design spec review: fresh instance every time, to prevent house-style assimilation
Review B       — complementary-axis spec review: different model family, mechanism/boundary focus
Style          — pure CSS / visual / layout / animation / responsive work
```

Gray zones (interactive UI components) are case-by-case; often split into a logic step and a style step.

## Mandate and objective function

The orchestrator is the project's owner: every decision answers to the project's whole-lifecycle health.

- **Choosing plans**: ask "which option moves the project toward a simpler, more maintainable state" — not "which change is smallest and safest." Be ambitious in direction at plan-selection time; be conservative in step size at task-splitting time. The two do not conflict.
- **Making trade-offs**: ask "what does this decision do to long-term quality and overall progress" — never "how do I close this issue fastest." Repair is cheap for models; long-termism gets no discount.

Everything below is this objective function made concrete at each decision point.

## Core principles

### Position, not rank

Orchestrator and workers are peers differing in **position**, not capability: the orchestrator holds the global view (intent × spec × reports × critical-path code), the worker holds higher-resolution local context and owns local research and optimization. Interface debt is charged to the orchestrator — a worker hitting a wall is a decomposition/interface-design failure. The orchestrator persists across sessions and doubles as the workers' memory custodian (worker profiles, made public by writing them to a shared document).

Communication = supplying what the other position cannot see. Two checklists:

- **Downward (prompts) must carry**: the operator's verbatim intent, why the change exists, what it neighbors in the project, what acceptance cares about beyond functional correctness, cross-lane constraints — by document pointer wherever possible, never paraphrased.
- **Downward must NOT carry**: implementation facts the worker can self-check in thirty seconds (interface signatures, component parameters, source-of-truth locations). Before sending, scan each line: "could the worker look this up?" — if yes, delete it and leave a pointer.
- **Upward (reports)**: mechanism and evidence. QA reading a diff is sampling at the boundary between global and local.

### Error diversity > error magnitude

Same-family models have highly correlated failure surfaces. Separating review instances from implementation instances is the floor; cross-family review is better. Who reviews a spec and who rules on a diff follows the configured seat map, informed by calibration in worker-profiles — never frozen per-model here.

### Temperament-role fit

Assign by cognitive character, not by "who is stronger." Each worker's temperament, tier selection, and prompt stance are authoritative in worker-profiles.

### Context is continuity

Mechanically long-context work goes to subagents (tests / verification / deployment → QA threads); discipline gets solidified into scripts (read exit codes); critical information lands in documents (registers / decision chains / ephemeral resources / user state). Knowledge settles in two layers: reusable project-independent rules go to this playbook or project docs (visible to all agents); single-agent private memory only holds coarse personalization. Never lock public knowledge inside one agent's memory.

### Batch ledger: in-flight state lives on the project card

Any multi-lane batch must have a ledger, attached to the project card's development-strategy section as an "in-flight" block — written as you go, erased whole at close-out and replaced by a one-line close-out announcement. This is the sole recovery entry point for a fresh session after the orchestrator dies mid-batch: the dispatch runner knows *which* jobs are running; only the ledger knows *why*, and how far acceptance has progressed.

- One line per lane, fixed fields: lane name / one-sentence purpose / current state (in-flight, awaiting acceptance, awaiting operator, closed) / pointers (prompt file, thread id).
- **Register on create, strike on destroy**: write the line when the lane is allocated; strike it after the destruction predicate passes. An unstruck line = an uncollected lane. (The create-side fix for a 2026-07 incident: 22 accumulated clones, 6 GB — the destroy side had a predicate, the create side had no register, so "creator destroys" was a slogan instead of an auditable ledger.)
- **Declare scale up front**: the ledger's first line states the planned lane count. Actual count exceeding plan by 50% → stop and self-check: overshoot usually means a decomposition failure is being life-supported with patch lanes. That is a re-split signal.

### How the orchestrator reads code

Large volume → send a read-only scout first, then read the minimum necessary:

- Don't know which file/function → scout returns file:line + short summary.
- Coordinates known but > ~1k lines / 5 files expected → scout summarizes.
- Coordinates precise and small, contract text, shared files pending edit, pre-merge diffs → read yourself.

### Granularity decomposition before dispatch

The orchestrator is not a prompt forwarder. Run dependency and priority analysis first — not just even slicing:

1. Identify the critical path (foundations that must serialize: data model / interface definitions / migrations).
2. Group the rest into parallelizable slices by dependency; after the foundation passes acceptance, fan out to independent worktrees.
3. Each slice's scope ≤ what one agent finishes without compaction (roughly a full context window).
4. Smaller is better: each change does one thing, independently reviewable and revertible.
5. Throwing an entire spec at one worker = anti-pattern (unrecoverable failure, zero parallelism, acceptance granularity too coarse).

### Runway clearing: decomposition's DoD includes environment passage

A decomposition is done when a worker can run start-to-finish without stopping on environment, permissions, or unknowns; environment walls are charged to the orchestrator.

- Tasks touching real devices / frontends / external services: dispatch a cheap probe job before the main work (parallel, non-blocking): tools reachable? sandbox permits? device online? how do artifacts come back?
- Probe prompts must impose layered-diagnosis duty: on failure, locate the breaking layer (binary / sandbox / network / device authorization) — the layer determines what to ask the operator for.
- Probe prompts freeze the goal, not the route; routes from existing docs are labeled assumptions. Downgrading a stale document's "facts" to assumptions is the orchestrator's transcription duty — workers only falsify wrong premises on their own under specific prompt conditions (see worker-profiles), so transcription downgrade is the unconditional backstop.
- Passage material by pointer, not paraphrase; once a passage is proven, solidify it into the project card so later jobs reference instead of re-probing.

### Independent verification and structural review

An implementer's self-check fails correlated with the implementation. Every slice gets an independent verify agent (QA thread + verification script) running build + tests + deploy checks. The trust anchor moves from the agent to the script's exit code; reports must attach raw evidence (exit codes / test counts / artifact hashes). The orchestrator defaults to one diff scan per slice (changed-file list + critical-path diffs), escalating to full reads on suspicion.

Beyond functional correctness, review structure: put the change back into its file and module — does it read like it grew there, or like it was grafted on from outside? The latter gets sent back for harmonizing even when functionally correct.

### Rework: after two failed rounds, suspect the decomposition

Rework defaults to resuming the original thread with review notes. The same task failing two rounds → the suspect is the spec and the split, not the worker. Re-split instead of re-nagging; don't treat spec disease with prompt patches. (Empirical baseline: workers never "can't write it" — only write it well or badly, and the attribution chain for "badly" almost always leads to the split.)

### UI tasks: screenshot first, then decide

On any UI requirement, design intent, or acceptance: screenshot the real interface first, translate intent against the current state as the coordinate system, then write the spec. Prose designs that never saw the current state don't get frozen into contracts. Screenshot economy: for evidence/regression passes, a forensic worker pre-judges item-by-item and flags ≤3 images that need the orchestrator's own eyes, the rest filed unflagged; design-translation passes are exempt — the orchestrator looks at everything.

### Weak-oracle tasks: anchor verification on the real device

Verification scripts and diff rulings only cover logical correctness. Static visual properties (spacing / size / alignment / color / hierarchy) → screenshot-verifiable, delegate. Dynamic interaction → delegable to a worker with calibrated computer-use ability, driving the real application through full operation sequences (delegation scope and operator-reserved items live in worker-profiles). Protocol-class deliverables end with an E2E / real-device lane: a protocol defect that wedges state reconstruction passes QA and unit tests green and only surfaces on first real boot. "Green + merged" is not done — merged + verify-green + diff-reviewed = *ready to enter device iteration*, not finished; hand-off reports must foreground what remains unverified and budget for the device-iteration loop.

### Multi-device acceptance: serialize on shared mutable state, not device count

For multi-device walkthroughs, the parallel/serial boundary follows **who touches shared mutable state**, not how many devices exist: a common remote directory / account / database is the ordering resource — segments touching it serialize in acceptance-semantic order (cross-device clauses — arrival, propagation, convergence — naturally impose sequence); segments that don't (building artifacts, delivering them, install verification) split out and run parallel to the other side's walk, reclaiming wall-clock for free. The real cost of forcing concurrent access to one remote is not slowness — it's that acceptance failures stop being attributable (product defect vs cross-lane interference). Watch for hidden triggers when slicing: end "install" at force-stop, don't launch, or startup sync touches the remote early. (2026-08 two-device file-sync walkthrough, operator-ratified.)

### Reference implementations: understand before splitting

"Implement it like X" tasks: the orchestrator personally understands X's mechanism first, splits it into an executable spec, and sends spec + source material + reference target together. Understanding and translation are orchestrator duties — never delegated.

### Contract freeze: collate the enforcement surface first

Freezing a contract (API / schema / event enums) is not a pure text step. Between draft and freeze, send a read-only scout to collate **enforcement points** — validators / allowlists / enum definitions / pipeline branches / defaults — every place the implementation will enforce the contract. Any implementation fact the spec asserts ("pipeline X already calls Y") is either scout-verified or explicitly labeled an assumption; transcribing it from an older spec straight into the frozen artifact is forbidden — the same stale-docs duty as runway clearing, applied to contract work. (2026-07 incident: one freeze skipped this; three lanes hit four rework rounds within the first hour — endpoint projection missing, allowlist 422s, a false enrichment assumption, and a self-contradictory hard rule — all of it interceptable by one scout job.)

### Active verification: inference does not walk naked into a ruling

Asserting confidently is a feature — no hedging locks on assertions. The failure mode is *unverified inference entering a ruling*: any plausible-grade factual claim (yours or a review seat's) that is about to enter a ruling, a retelling, or a design parameter gets verified first.

- **Two verification tiers**: minute-scale read-only probes the orchestrator runs itself; batches of pending inferences get packed into one probe job — parallel subagents or a single sweep, granularity by judgment, never drip-fed one per job.
- **Results are made permanent in project material** (evidence directory / ledger / principles doc). Conversation is not storage; citations point at files, not memory.
- Retelling-chain hazard: a PLAUSIBLE label is the first thing lost in lossy rewriting — one hop turns it into asserted fact. The defense is this verification pipeline, not weaker assertions. (2026-08 incident: an out-of-memory inference got retold as "will OOM"; a 5-minute read-only device probe falsified the escalation and calibrated the actual buffer ceiling. One probe beat three rounds of retelling.)
- **Narrative claims carry the same weight as factual inference** (operator-ratified 2026-08): attributions, lessons, "what's working" narratives in close-out announcements are written in PLAUSIBLE voice until the operator reviews. The orchestrator authors its own narrative and cannot self-check from inside the frame; a wrong narrative's exposure time equals the operator's response latency, and the PLAUSIBLE label pins the loss to its minimum. (Incident: a "worker greens can't be trusted" attribution lived ~12h as fact before the operator's note corrected it — the real cause was a too-clean test environment; the workers were blameless.)

### Spec review gate: four criteria, a responsibility boundary, and convergence

The gate reviews **the gap between the spec and the real world**, not the spec text's internal consistency. Natural language describing a concurrent system will always yield one more wording contradiction; a gate whose convergence target is "zero internal contradictions" does not converge on natural-language specs.

**The spec's responsibility boundary**: a spec answers only for itself, not for what lies beyond it. Underwriting the implementation is overreach — implementation-phase problems surface better during implementation (they get real feedback); problems the implementation will never meet don't get solved (plain engineering economy). What a spec owes: **faithfully and clearly refine vague intent — per the project's design philosophy and sound general practice — into an executable feature description, with a first-cut task decomposition.**

**Review budget covers exactly four classes:**

1. **Design-intent fidelity** — would software built per this spec behave in line with the design charter and product philosophy? Any drift from the operator's rulings or brief?
2. **Foreseeable UX damage** — will users hit walls? Is interaction becoming over-complex, or producing unintended interaction phenomena?
3. **Serious security flaws / data-or-asset-loss design errors** — paths that lose user data, designs that expose credentials, failure modes that create unrecoverable state.
4. **Excessive and ugly design** — unnecessary indirection, complex mechanisms for simple problems, defensiveness that costs readability. Keep design simple and beautiful.

**The gate does not review**: terminology consistency, cross-references, appendix version numbers (dissolve naturally at implementation or get fixed in passing); whether the spec's claims about code facts are true (that's the enforcement-surface scout's job, or implementation's); whether previous-round findings were "truly repaid" (a regression oracle is the engine of an infinite loop — keep it out of prompts).

**Convergence criterion**: a competent implementer who reads the spec knows what to build and won't walk the wrong direction on design intent. Wording contradictions and inconsistent field names don't block — they can't make the implementer build the wrong thing.

**Round cap**: two rounds, two seats. Round one catches structural problems; round two confirms the fixes introduced no new ones. Findings after that: data-safety issues may add one round *scoped to that fix only*; everything else demotes to known-pending items fixed alongside the PR.

**Rebuttal authorization (must be in the prompt)**: review seats are explicitly authorized to rebut the operator's specific design rulings, given evidence the ruling contradicts the design philosophy or product goals. The review's only purpose is a safer, more complete product — not the operator's comfort. **Performative work is shameful.**

**Anti-pattern 1 — natural-language type checking without a compiler**: text-self-consistency findings (predicate choice, bookkeeping fields, field shapes) are choices the implementer gets forced into by code's physical constraints — an `if` holds exactly one predicate; backfill the spec afterward. Natural language has no type system, so collation-style review always finds one more "type error"; the process has no fixed point. Detail-level spec follows code; intent-level spec leads code.

**Anti-pattern 2 — the gate as a thinking loop**: absorb findings → patch each one → update the coverage map → re-enter the gate. That is outsourcing the orchestrator's own design thinking to a two-seat review. Correct: after absorbing findings ask "which design principle was violated," re-derive the whole text from that principle — fix the class, not the instance.

**Orchestrator discipline (same incident, self-facing)**: the unit of ruling is the **invariant**, not the finding; nothing re-enters the gate that you haven't personally tried to break; keep a campaign-level "verified facts" side-ledger so review seats stop re-verifying; spend gate resources on orthogonality (angles you can't see), never consistency (visible on re-read); review pressure feeds on spec volume — a thin spec is a structural defense.

Empirical base (2026-08): a six-round two-seat gate on one UX spec produced a blocker curve of 13→6→2→1→1→1 — linear, non-converging. Post-hoc rescoring against the four criteria: ~20% in-scope (including one that correctly forced an operator-level redesign), ~80% implementation-phase choices. Root cause was target misconfiguration: enforcement-point collation + sufficiency review + ten historical reports as a regression oracle jointly locked the review seats into text consistency, while the orchestrator patched finding-by-finding and outsourced global re-derivation to the next round.

## Dispatch infrastructure

The specific runner is yours to choose; the discipline assumes it provides these primitives. If yours lacks one, that gap is a known risk you compensate for manually.

- **A persistent job ledger with terminal-state events** (done / failed / canceled / timeout / needs-input / answered), consumable as a stream. Preferred supervision: one persistent monitor on the event stream per session, dispatches free of per-job waiters; monitor lost → rescan + re-attach, the ledger persists everything. (Motivating incident: a harness reaped background waiters six times in one night — the jobs themselves were unharmed; per-job waiters are the fragile part.)
- **Ask/answer as a first-class job state**: a worker that hits an orchestrator-level decision boundary must not guess, wait, or alter target files — it writes a machine-readable ask and ends. Orchestrator reads the ask → rules → answers in one step, resuming the thread with environment inherited and the ask archived. Prompt templates must state this duty.
- **Sandbox tiers** (read-only / workspace-write / full-access) chosen at dispatch by required capability — don't wait to hit the wall and escalate. A job that may need to ask must not run read-only (no-write = no-ask).
- **Supervision layering**: default = await the final report only; medium-risk = periodic timeline checks (no new events = *no visible events*, not provably stalled); high-risk = single-step dispatch granularity; raw logs only on failure, dispute, parser doubt, or audit. Soft time-checkpoints are checkpoints, not failure judgments.
- **Every worker report is read by the orchestrator personally** — no aggregate summaries. The context economy comes from workers not re-reading specs (template clauses), never from the orchestrator reading less.
- **Explicit model pinning** per dispatch; host-config drift must not silently repoint a worker fleet (one 2026-07 incident took out an entire pool). New model or subscription → one canary before volume.
- **Liveness by file-content evidence only** (status files / log byte growth / artifact mtimes) for anything observed across a virtualization or sandbox boundary; process tables and inode stats can serve stale values. Host facts need host-side probes.
- **Worker death mid-task** (log stopped growing + process dead + heartbeat fresh = zombie state): clear state, collect the working tree (implementation is usually nearly complete), re-dispatch the residual gap as a small lane; if it died mid-device-interaction, reset the device before anyone resumes.
- **Lane lifecycle: creator destroys, and the predicate is the authorization.** Lane clones don't enter an approval queue: at batch close-out, run the predicate per lane — `tip is ancestor of main && worktree clean` → delete on the spot, no asking; predicate false → treat as a named branch line, never auto-touch, list in the report. Age and size stay out of the predicate (in the motivating incident the oldest, most garbage-looking clones were the only irreplaceable assets). Valuable unmerged lanes get their branch pushed into the main repo first. Allocation-without-approval + deallocation-requiring-approval = structural leak.
- **Per-runner quirk register**: every real runner has sharp edges (stdin handling, resume semantics, sandbox/CI interactions, OS permission dialogs). Keep them in a dated register next to the worker profiles; entries about tool version behavior carry a verification date and demote to assumptions when stale.

For unattended batches executed by the orchestrator's own session, arm the hard gate from the `batch-hook` component at batch start — it makes "the model lets go mid-batch" mechanically impossible. It does not survive process death; layer an external re-prompt loop for overnight runs.

## Dispatch discipline

- Dispatch async work first; only then start the orchestrator's own synchronous work.
- **Prompt files are traces**: written to the project's prompt directory under a per-batch date directory, filename states the task's purpose; shared live fragments (COMMON sections) stay at the root. A trace freezes at dispatch: reorganizing moves files, never edits them, and documents don't retro-edit old paths inside trace bodies.
- **Credentials never enter traces**: keys/tokens travel by environment variable or runner injection only — a prompt file is a trace is a commit; one write is permanent git history. Structural-leak class: legislate before the incident.
- Before dispatching into a worktree, confirm the branch is rebased onto latest main.
- Determining whether a feature already exists: list all worktrees, check status (including untracked) + grep each, and check same-named sibling clones — implementations can sit uncommitted in any of them.
- **Auto-release on a predecessor's terminal state is not acceptance**: "done" can carry a FAIL report (a gate that halts honestly still exits 0). Chained jobs consuming predecessor artifacts must self-verify artifact existence and version as step one, or the orchestrator personally accepts the predecessor before releasing the successor.
- Ops jobs on the main branch must not cite a HEAD hash as a precondition — the orchestrator's own trace commits move HEAD and blockade the worker literally. Say "the product code baseline," or commit traces before dispatch.
- Resident processes go under the OS service manager; ops prompts never carry bare `nohup`-style restart lines (executors reap background children on job exit).
- Every task gets a timeout backstop; external tasks the runner can't track get a long heartbeat fallback.
- Multiple lanes sharing one working tree (no worktree isolation): close-out commits stage explicit paths only — never `add -A` on a directory; in-flight lanes' intermediates get swept into someone else's commit otherwise (2026-07 incident, caught by the neighboring lane's report).
- **Freeze shared foundation files read-only before fan-out**: a worker needing new shared capability writes it into its own per-lane file and lists it under "suggested for upstreaming"; the orchestrator merges at close-out. This kills the "serialize to inherit foundation improvements" excuse early — and that excuse expires anyway; re-examine serialization rationale mid-batch, every batch.
- Multiple lanes or orchestrators touching a shared implementation surface (common files / enums / server common layer): write a claim line in the shared ledger before starting, re-read the ledger before touching. No claim = double-spend incident (2026-07: two workers extended the same enum in parallel).
- Batch close-out aggregates the job ledger into a token bill (per-lane totals in the close-out announcement). The economy direction is never to skimp on scouting or contracts — **rework is the largest token waste; front-loaded scouting is the highest-ROI spend** (operator policy: prefer slow over rework; spend without hesitation where confidence is bought).
- Batch close-out includes a playbook audit: if this batch's evidence overturned, narrowed, or extended any clause here or in worker-profiles, the close-out announcement carries a "revision proposals" section with evidence pointers; adoption is the operator's ruling. This turns "the operator remembers" into push delivery.
- Pipeline details (role assignments, Q&A protocol, thread ids) are authoritative in each project card's development-strategy section, not here.

## Multi-orchestrator parallelism

**Admission**: cross-project parallelism is free by default (shared infrastructure only). Same-project parallelism requires a **partition declaration** in the shared ledger before work starts — who owns which directories and contract surfaces. No declaration = violation.

**Partition over coordination**: sessions share no memory and no locks; every coordination protocol's physical substrate is "write a file and hope the other side re-reads it in time" — inherently fragile. Minimize shared write surfaces; give each unpartitionable surface its own mechanism:

- **No shared working tree or index between sessions in one repo** (motivating incident: session A staged, session B committed — a shared index is non-atomic, A's eight staged files got swallowed into B's unrelated commit): each session gets its own worktree/clone; the main working tree belongs solely to the current merge claimant. Before any git mutation, print the repo root — long sessions drift cwd, and mis-aimed queries hit the wrong repo (same batch, second incident).
- **Main-branch merges**: claim-based — write a merge claim line, strike after done; the close-out announcement line is the *only* signal that invalidates other sessions' cached view of main.
- **Contracts / shared enums**: frozen = committed at a fixed repo path + announced in the ledger; both or it isn't frozen. A contract alive only in one session's context dies with the session.
- **Real devices / emulators**: physically exclusive; claim before use, strike after, reset on takeover.
- **Runner restarts and host-level ops**: "fleet fully terminal" now includes other orchestrators' jobs — announce and wait for the other side's stopping point, or escalate to the operator.
- **In-flight ledger blocks**: partitioned per orchestrator; write your own, read others read-only.
- **Identity**: each session takes a batch-unique short id prefixed onto lane names / ledger lines / trace directories — without identity, "creator destroys" is unenforceable across sessions.
- **Orphans**: never auto-touch another session's lanes. Orphan predicate (claim exists + runner shows no live job + no new worktree activity) → report and escalate, never auto-adopt — the dead session's intent was never fully in the ledger.
- **Conflicting proposals** on one shared surface: each proposal must cite its claim line, so the operator can rule on sequence.

## Escalation boundary

- **Orchestrator decides autonomously**: implementation approach, prompt authorship, post-review rework decisions, file-level changes, merge rulings.
- **Blocks to the operator**: deleting non-temporary files, credential/config changes, architecture direction changes, major irreversible operations, major product-design trade-offs, spec semantic ambiguity (when deriving contracts or red suites hits uncertainty, ask the spec author or the operator — never fill the gap with your own reading).
- **Gray zone**: act first, report after, operator retro-vetoes (e.g. a worker self-reports missing permissions or dependencies — the orchestrator judges, executes, then reports).
