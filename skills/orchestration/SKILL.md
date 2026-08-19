---
name: orchestration
description: Load the cross-model orchestration playbook before coordinating work across different model families or external agent runtimes — worker fleets, mixed-model review/QA lanes, worktree lane management, result review, and escalation decisions. Do NOT use for single-agent tasks, your harness's native same-app subagent dispatch, or abstract discussion of orchestration.
---

# Orchestration Playbook Loader

This skill loads the cross-model agent orchestration playbook — the policy document that governs how an orchestrator session should decompose, dispatch, verify, and escalate multi-agent work.

## On trigger

Read and internalize, in order:

1. [reference/playbook.md](reference/playbook.md) — process discipline: decomposition, contract freezing, verification independence, review gates, dispatch rules, multi-orchestrator partitioning, escalation boundaries.
2. [reference/worker-profiles.md](reference/worker-profiles.md) — before writing any worker prompt: per-worker temperament, tier selection, prompt stance, and open suspicions live there, not in the playbook.

Authority split: the playbook owns process discipline; worker-profiles owns per-worker cognition; pasteable prompt text lives in your project's prompt-template directory (worker template / common clauses / role sections). All are living documents the operator maintains — do not cache or summarize them; read the files fresh each time.

## Adapting to your fleet

The playbook binds every rule to a **role** (implementation / QA / review / style), never to a model. The worker-profiles document ships as method + a dated example snapshot: keep the method and the profile schema, replace the snapshot with calibration data from your own fleet as you accumulate it. The playbook's "Dispatch infrastructure" section lists the primitives it assumes your dispatch runner provides — map them onto whatever runner you use, and treat any missing primitive as a known risk to compensate manually.

## After loading

Apply the playbook for the remainder of the session. Do not treat it as suggestions — treat dispatch discipline and escalation boundaries as hard constraints.
