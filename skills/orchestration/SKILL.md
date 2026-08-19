---
name: orchestration
description: Load the cross-model orchestration playbook before coordinating work across different model families or external agent runtimes — worker fleets, mixed-model review/QA lanes, worktree lane management, result review, and escalation decisions. Do NOT use for single-agent tasks, your harness's native same-app subagent dispatch, abstract discussion of orchestration, or project-card updates (use `/track-project`). Also via `/orchestration`.
---

# Orchestration Playbook Loader

This skill loads the cross-model agent orchestration playbook — the policy document that governs how an orchestrator session should decompose, dispatch, verify, and escalate multi-agent work.

## Local configuration

<!-- workflow-setup:begin local-configuration -->
Configuration status: `needs-setup`

- Current orchestrator harness: `UNCONFIGURED`
- Dispatchable external workers: `UNCONFIGURED` — record each worker's identifier, application/runtime, exact model, and invocation route
- Role seats: `UNCONFIGURED` — implementation / QA / review A / review B / style
- Runner primitives: `UNCONFIGURED` — async jobs / resume / ask-answer / sandbox tiers / isolation / terminal-state events
- Prompt-template directory: `UNCONFIGURED`
<!-- workflow-setup:end local-configuration -->

Read this block before dispatch. Do not infer missing workers, seat assignments, invocation routes, or runner capabilities. Ask the user to run `/workflow-setup` when a required value is unresolved. An explicitly `unfilled` role is valid and blocks dispatch to that role only.

## Required reading

Before coordinating cross-model work, read and internalize:

- [reference/playbook.md](reference/playbook.md) — process discipline: decomposition, contract freezing, verification independence, review gates, dispatch rules, multi-orchestrator partitioning, escalation boundaries.

Before writing any worker prompt, also read and internalize:

- [reference/worker-profiles.md](reference/worker-profiles.md) — per-worker temperament, tier selection, prompt stance, and open suspicions live there, not in the playbook.

Authority split: the playbook owns process discipline; this skill's Local configuration owns the current fleet and default role seats; worker-profiles owns per-worker cognition; pasteable prompt text lives in the configured project prompt-template directory (worker template / common clauses / role sections). All are living documents the operator maintains — do not cache or summarize them; read the files fresh each time.

## Fleet-local interpretation

The playbook binds every rule to a **role** (implementation / QA / review / style), never to a model. Treat the dated example snapshot in worker-profiles as an example, not as authority for the configured fleet. Prefer current local calibration data when available; otherwise use the profile method and schema without assuming the dated conclusions still hold. Compare the playbook's assumed dispatch primitives against the configured runner; treat every missing primitive as an explicit risk to compensate manually.

## After loading

Apply the playbook for the remainder of the session. Do not treat it as suggestions — treat dispatch discipline and escalation boundaries as hard constraints.
