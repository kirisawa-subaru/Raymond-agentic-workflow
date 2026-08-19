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
| `doc-setup` | Repo documentation lifecycle: structure, naming-as-lifecycle, authority chains | extracted — under review |
| `orchestration` | Cross-model orchestration playbook: task decomposition, contract freezing, review gates, escalation boundaries, worker cognitive profiles | content surgery pending |
| `batch-hook` | Hard gate for unattended batch execution: Stop-hook + sentinel + ledger predicate that refuses to let a session end mid-batch | extracted — under review |
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

Plain skills, deliberately. No plugin manifest, no installer magic — clone and link the components you want:

```bash
git clone <this-repo>
ln -s "$(pwd)/agentic-workflow/skills/batch-hook" ~/.claude/skills/batch-hook
# ...repeat for each component you want
```

`batch-hook` additionally needs its Stop hook registered once in `~/.claude/settings.json`; the snippet is in its SKILL.md.

## What this authorizes — read before installing

Everything here is plaintext markdown; there is no config engine. Each component states its authorizations in its own SKILL.md, **enabled by default**. To narrow one, edit the text. The full list:

- `batch-hook` registers a **global Stop hook** that can refuse to end a session's turn while an armed batch ledger has unchecked items. Fail-open by design; disarm anytime by deleting the sentinel file.
- `track-project` **commits planning-document changes** as part of its contract (scoped staging, project docs only).
- `doc-setup` moves and renames files in `doc/` trees during audits — always as a proposed plan before executing.
- `handoff` writes session-context files to `~/.claude/session-handoff/`, which may include verbatim quotes of your instructions and a candid read of your state during the session.

## Configuration

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md). Skills reference their own bundled files relative to the skill directory. Machine-specific locations (e.g. your planning-vault root) are supplied via environment variables declared there; nothing in this repo hardcodes a personal path.

## Provenance

This system was operated daily for over a year against real projects: multi-lane Codex worker fleets, mixed-model review gates, unattended overnight batches. The playbooks carry dated, falsifiable calibration entries — including the suspicions that are still open. That epistemic hygiene is the point; the specific model versions named in historical entries will age, the methodology does not.
