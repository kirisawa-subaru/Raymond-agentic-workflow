---
name: track-project
description: Track, create, rename, resume, and update project cards — the executable planning-memory system (queryable YAML frontmatter + continuity prose + optional dashboard). Use when asked to update a project's status/next-action, continue a project after context compaction ("resume this project"), create or restructure a project card, rename/park/archive a project, maintain SCHEMA.md or INDEX.md, move completed work into history, or keep project tracking state consistent. Do NOT use for: (a) personal task lists unrelated to projects; (b) general project-management advice; (c) writing project code unrelated to the planning card.
---

# Track Project

Maintain a vault of **project cards** as executable planning memory: frontmatter carries queryable state, the body carries project continuity, and an optional dashboard renders live views. The point is that any agent (or you, a month later) can open one card and resume the project without archaeology.

Cards are plain markdown + YAML. The dashboard layer is optional: the bundled `templates/INDEX.md` uses Obsidian Dataview, but nothing in the system depends on it — frontmatter is greppable by any tool.

**Authorization note (default on, edit to narrow):** whenever this skill changes project documentation, it commits the change (scoped staging, project docs only) before finishing the turn. See the Git Boundary section.

## Path resolution

Resolve the cards root before editing. Never assume a stale absolute path is valid.

1. Use `$PROJECT_CARDS_ROOT` if set and it contains `SCHEMA.md` and `INDEX.md`.
2. Otherwise, if the current repo's `./project.md` locator names a valid root (see below), use that.
3. Accept a root only if `SCHEMA.md` and `INDEX.md` both exist there.
4. If no root resolves, offer **Init mode** instead of editing a guessed location.

## Init mode (first run)

When no valid root exists and the user wants one:

1. Ask where the vault should live (any directory; an Obsidian vault if they want the dashboard rendered).
2. Copy `templates/SCHEMA.md` and `templates/INDEX.md` from this skill's directory into the root.
3. Create the type directories from the schema (`bot/ plugin/ pipeline/ infra/ knowledge/ writing/ experiment/`) plus `HISTORY/` and `archived/`.
4. Copy `templates/example-card.md` into the matching type directory so the first real card has a model to follow, and tell the user to delete it once oriented.
5. Tell the user to set `PROJECT_CARDS_ROOT` (shell profile or harness env — see `docs/CONFIGURATION.md`).
6. If the root is not inside a git repo, recommend `git init` — the Git Boundary below assumes version control.

After init, the vault copy of `SCHEMA.md` is authoritative for that vault. The template here is only the starting point; users are expected to evolve their copy.

## Project-local locator

When invoked from inside a concrete project repo, check `./project.md` first. It is a cross-agent locator and handoff index, not a second project card. Treat it as authoritative only when it contains explicit pointers:

```yaml
project: my-project
project_card: <cards-root>/pipeline/my-project.md
cards_root: <cards-root>
status_doc: CURRENT_STATUS.md
```

- Prefer an explicit `project_card` pointer over guessing the target card from repo name or README prose.
- If `./project.md` exists but has no explicit card pointer, do not infer one; continue with normal resolution.
- Do not substitute `README.md` or other repo files for this locator.

## Core model

Keep these distinctions sharp:

```text
Path        owns type membership
YAML        owns queryable state
Body        owns continuity
Dashboard   owns views
```

- Path expresses stable type ownership (one type directory per card).
- Frontmatter contains only state needed for query, sort, filter, or handoff.
- Body explains why the project exists, what threads are active, how to continue, what history matters.
- The dashboard is a projection layer; fix its queries when cards render stale, never the other way around.

## Git Boundary

Whenever this skill changes project documentation, commit the change before finishing the turn. Project documentation = cards, schema/dashboard files, history files under the cards root, plus project-local handoff docs (status docs, runbooks, result summaries) linked from the card.

- Inspect `git status` and the diff before staging.
- One focused commit per git root when changes span several.
- Stage only files inside the project-documentation boundary. Never sweep in unrelated dirty files, raw logs, screenshots, or build artifacts merely because docs reference them.
- Commit messages name the project and the state movement, not generic checkpoint language.
- If the docs directory is not a git repo, report that instead of creating ad-hoc git state.

## Entry modes

Choose before reading project files — the goal is to preserve context for the actual work, not to audit the whole vault on every touch.

### Mode A: create or restructure

For new cards, renames, splits/merges, parking/archiving, schema or dashboard changes. Read: the target card (if any), `SCHEMA.md`, `INDEX.md`, and history only when the task depends on old state.

### Mode B: resume

For continuing existing work after compaction or a handoff, and ordinary status/next-action/thread updates. Read **only**: the target card's frontmatter, its current-threads section, the status doc or runbook the active thread names. Do **not** read schema, dashboard, history, or parked threads. Escalate to Mode A only when the task actually touches structure, the card is malformed enough to block continuation, or the active thread explicitly requires historical trace-back.

Detailed frontmatter semantics and section constraints live in the vault's `SCHEMA.md` — read it whenever a rule is ambiguous.

## Frontmatter rules

Minimum fields (full semantics in SCHEMA.md):

```yaml
---
project: project-slug
title: Human readable title
type: pipeline
phase: building          # idea / planning / building / maintained / parked / archived
activity: active         # active / warm / cold
status_line: one-line "where things stand now" for the dashboard
next_action: the single concrete action to take next
blocked_by: []
unblocks: []
tags: []
---
```

- `next_action` is one action, not a status narrative.
- Don't write `started`/`last_touched` by default — file timestamps back them; hand-write `last_touched` only on substantive progress (it is the archival clock).

## Body structure

```md
# Project title

(cold-start paragraph: purpose, deliverable, why now, and a glossary of any
project-internal terms — written for a smart reader with zero context)

## Human View
## Overview & Route
## Current Threads

### Thread: name

Status: active / warm / blocked / ready-to-archive
Scope: ...

#### Problem
#### Approach
#### To-do

## Trajectory
## Future Work

> [!success]- Completed: summary

## History

![[project-slug.history]]
```

- **Human View** is for the human owner, 30-second read: current state in plain prose (no internal codenames, no paths, no hashes) + a "waiting on you" list where every item is self-sufficiently readable. Update it *every* time threads change — a stale Human View is worse than none. It is not append-only: delete outdated content first.
- **Overview & Route**: stable purpose, scope, architecture.
- **Current Threads**: only work that still needs attention. Checked to-dos and `ready-to-archive` threads move out — into the folded Completed block or the history file.
- **Trajectory**: one short note per substantive change — what moved and why, ≤50 words, timestamped. Motivation and logic, never command output or file inventories.
- **History**: a light embed/link to the external history file under `HISTORY/<type>/<slug>.history.md`; details go there, not inline.

## Thread closure routine

Run when a thread's tasks are done, or when a blocker has survived repeated attempts and the work must be summarized back to the owner:

1. Update the project-local status docs first (observed facts, command results, reproduction notes, handoff detail).
2. Update the card: current thread trimmed to the next actionable step; completed detail moved out; durable conclusions promoted to the stable sections; one trajectory note added.
3. Refresh queryable state: `next_action`, `blocked_by`, `status_line`, `last_touched`.
4. Re-run hygiene checks (below).
5. Commit per the Git Boundary.

Closure is not permission to archive the project. Close the thread, preserve the next work surface, leave the project resumable.

## Hygiene checks

Before finalizing, both of these must print nothing (move offenders to the Completed block):

```bash
awk '/^## Current Threads/{f=1} /^## Trajectory/{f=0} f && /\[x\]/{print NR":"$0}' "<card>"
awk '/^## Current Threads/{f=1} /^## Trajectory/{f=0} f && /^Status: ready-to-archive/{print NR":"$0}' "<card>"
```

When renaming or deleting, grep the vault for old references first; verify dashboard views don't render ghosts afterward.

## Update heuristics

- The card is live workspace state, not documentation. Optimize for a future agent resuming, not for prettiness.
- Don't over-normalize other cards unless asked; touch the target and directly affected schema/dashboard files only.
- Preserve historically useful detail, but fold it.
- No sycophantic language in cards; crisp state and concrete next actions.
- Repo file pointers (paths outside the vault) are written as inline code, never as markdown/wiki links — in Obsidian, clicking an unresolved absolute-path link silently creates an empty file plus its whole directory tree inside the vault. Links are reserved for real vault notes (e.g. the history embed).

## Validation expectations

Before the final response, report: files created/renamed/deleted/updated; commit hash(es) or why commits weren't possible; dashboard/schema changes; old-reference cleanup results; whether the history embed is present, absent (no history file yet), or intentionally unchanged.
