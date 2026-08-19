# Agentic Workflow

> A six-component workflow system for long-horizon, multi-agent development with Claude Code — distilled from a year of daily operation, not designed on a whiteboard.

**Status: pre-release.** Components are being extracted and sanitized from a private, actively used system. Nothing here is published yet.

## Why this exists

Single-agent coding assistants fail at long-horizon work in predictable ways: planning state evaporates between sessions, specs drift, agents report success without evidence, and unattended runs quietly stop halfway. This repo packages the discipline layer that a real multi-agent operation grew to survive those failure modes — as installable Claude Code skills, hooks, and playbooks.

Every rule in here exists because something actually went wrong without it. The incident that motivated each rule is cited inline.

## Components

| Component | Role | Status |
|---|---|---|
| `track-project` | Executable planning memory: project cards with queryable frontmatter, dashboard views, resume-after-compact protocol | extraction pending |
| `doc-setup` | Repo documentation lifecycle: structure, naming-as-lifecycle, authority chains | extraction pending |
| `orchestration` | Cross-model orchestration playbook: task decomposition, contract freezing, review gates, escalation boundaries, worker cognitive profiles | content surgery pending |
| `batch-hook` | Hard gate for unattended batch execution: Stop-hook + sentinel + ledger predicate that refuses to let a session end mid-batch | extraction pending |
| `handoff` | Pre-compact context capture: preserves what automatic compaction systematically loses | extraction pending |
| `decode` | Rewrites dense agent reports into human-readable density | extraction pending |

Together they cover the full lifecycle: **planning memory → doc discipline → dispatch discipline → execution hard gate → context continuity → report consumption.**

## Design principles

<!-- TODO: expand each with the incident that motivated it -->

- **Trust anchors live outside the agent.** Verification is done by independent instances against script exit codes and on-device runs, never by the implementer's self-report.
- **Error diversity over error magnitude.** Review instances are separated from implementation instances; cross-model-family review preferred.
- **Two failed rounds means the spec is the suspect, not the worker.**
- **Inference does not walk naked into a decision.** Plausible-but-unverified claims get a probe job before they enter any ruling.
- **Prompt files are traces.** Frozen at dispatch, committed, never edited retroactively.

## Installation

<!-- TODO: marketplace add instructions once published -->

Planned distribution: Claude Code plugin via this repo's marketplace manifest, with manual `~/.claude/skills` installation as a documented fallback.

## Configuration

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md). Machine-specific locations (e.g. your planning-vault root) are supplied via environment variables or first-run setup; nothing in this repo hardcodes a path outside `${CLAUDE_PLUGIN_ROOT}`.

## Provenance

This system was operated daily for over a year against real projects: multi-lane Codex worker fleets, mixed-model review gates, unattended overnight batches. The playbooks carry dated, falsifiable calibration entries — including the suspicions that are still open. That epistemic hygiene is the point; the specific model versions named in historical entries will age, the methodology does not.
