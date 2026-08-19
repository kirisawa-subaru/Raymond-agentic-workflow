# Raymond Agentic Workflow

> A six-component workflow system for long-horizon, multi-agent development — distilled from a year of daily operation, not designed on a whiteboard.

**Status: pre-release.** Components are being extracted and sanitized from a private, actively used system. Nothing here is published yet.

## Why this exists

Single-agent coding assistants fail at long-horizon work in predictable ways: planning state evaporates between sessions, specs drift, agents report success without evidence, and unattended runs quietly stop halfway. This repo packages the discipline layer that a real multi-agent operation grew to survive those failure modes.

Every rule in here exists because something actually went wrong without it. The incident that motivated each rule is cited inline.

## Harness-agnostic by design

Nothing in this system is locked to one agent product or one OS. Each component is a plain-markdown operating procedure plus, at most, a tiny script — shipped in both POSIX shell (`.sh`) and PowerShell (`.ps1`) with an identical contract, so Windows is a first-class target rather than a WSL afterthought. That is the lowest common denominator every current harness (Claude Code, Codex CLI, Cursor, or a bare API loop) can consume. Anything harness-specific (how to register a hook, where a skills directory lives) is quarantined in [`adapters/`](adapters/) and is strictly optional wiring, never part of a component's logic.

Inline command examples in the procedures use POSIX syntax for brevity; where a check matters, the **invariant is the contract, not the command** — agents on Windows verify the same invariant with whatever shell they have.

## Components

| Component | Role | Status |
|---|---|---|
| `track-project` | Executable planning memory: project cards with queryable frontmatter, dashboard views, resume-after-compact protocol | extracted — under review |
| `doc-setup` | Repo documentation lifecycle: structure, naming-as-lifecycle, authority chains | extracted — under review |
| `orchestration` | Cross-model orchestration playbook: task decomposition, contract freezing, review gates, escalation boundaries, worker cognitive profiles | extracted — snapshot data under item-level review |
| `batch-hook` | Hard gate for unattended batch execution: stop-check + sentinel + ledger predicate that refuses to let a session end mid-batch | extracted — under review |
| `handoff` | Pre-compact context capture: preserves what automatic compaction systematically loses | extracted — under review |
| `decode` | Rewrites dense agent reports into human-readable density | extracted — under review |

Together they cover the full lifecycle: **planning memory → doc discipline → dispatch discipline → execution hard gate → context continuity → report consumption.**

## Design principles

<!-- TODO: expand each with the incident that motivated it -->

- **Trust anchors live outside the agent.** Verification is done by independent instances against script exit codes and on-device runs, never by the implementer's self-report.
- **Error diversity over error magnitude.** Review instances are separated from implementation instances; cross-model-family review preferred.
- **Two failed rounds means the spec is the suspect, not the worker.**
- **Inference does not walk naked into a decision.** Plausible-but-unverified claims get a probe job before they enter any ruling.
- **Prompt files are traces.** Frozen at dispatch, committed, never edited retroactively.

## Installation

These are plain markdown procedure documents. Wire them into whatever instruction-loading mechanism your harness has — a skills directory, a rules directory, or simply telling the agent to read the file:

```bash
git clone <this-repo>
# then, per component you want, link it where your harness discovers instructions
```

Per-harness wiring (directory locations, hook registration) lives in [`adapters/`](adapters/). Only `batch-hook` has a hard harness requirement: its gate needs a harness capable of running a command when the agent tries to end its turn.

## What this authorizes — read before installing

Everything here is plaintext markdown; there is no config engine. Each component states its authorizations in its own SKILL.md, **enabled by default**. To narrow one, edit the text. The full list:

- `batch-hook` installs a **stop-check** that can refuse to end a session's turn while an armed batch ledger has unchecked items. Fail-open by design; disarm anytime by deleting the sentinel file.
- `track-project` **commits planning-document changes** as part of its contract (scoped staging, project docs only).
- `doc-setup` moves and renames files in `doc/` trees during audits — always as a proposed plan before executing.
- `handoff` writes session-context files to your handoff directory, which may include verbatim quotes of your instructions and a candid read of your state during the session.

## Configuration

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md). Components reference their own bundled files relative to their own directory. Machine-specific locations (e.g. your planning-vault root) are supplied via environment variables declared there; nothing in this repo hardcodes a personal path.

## Provenance

This system was operated daily for over a year against real projects: multi-lane worker fleets across model families, mixed-model review gates, unattended overnight batches. The playbooks carry dated, falsifiable calibration entries — including the suspicions that are still open. That epistemic hygiene is the point; the specific model versions named in historical entries will age, the methodology does not.
