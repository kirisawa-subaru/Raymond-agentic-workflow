# Project card schema

> This is your vault's canonical schema. It was instantiated from the track-project template; evolve it freely — your copy is authoritative for your vault.

The cards root is human-readable, maintainable, semi-permanent **project-level planning memory**. It manages projects themselves; where one project ends and another begins is the owner's judgment call.

## Core principles

- Path expresses stable primary membership.
- YAML frontmatter holds only fields that get queried, sorted, filtered, or used for automatic resume.
- The body records purpose, current threads, trajectory, future work, next step, and history references.
- The index is for the owner's management-level reading; a single card is what an agent reads to resume execution.

## File naming

```text
<cards-root>/<type>/<project-slug>.md
```

`project-slug`: lowercase letters, digits, hyphens; identical to the frontmatter `project` field.

## Type directories

| type | for |
|---|---|
| `bot` | bots, bot management surfaces, conversational systems |
| `plugin` | editor/browser/local plugins, or plugin-shaped tools |
| `pipeline` | data import, sync, archival, transformation pipelines |
| `infra` | infrastructure supporting other projects: gateways, management systems |
| `knowledge` | indexes, retrieval, knowledge bases, long-term queryable material |
| `writing` | writing workflows, manuscript production, editing tools |
| `experiment` | exploratory prototypes whose primary membership isn't stable yet |

`type` expresses primary membership only; secondary semantics go in `tags`.

## Frontmatter

```yaml
---
project: project-slug
title: Human readable title
type: pipeline
phase: building
activity: active
status_line: one-line summary of where things stand now
next_action: the single next concrete action
blocked_by: []
unblocks: []
tags: []
---
```

| field | required | semantics |
|---|---|---|
| `project` | yes | stable slug, identical to filename |
| `title` | yes | human-readable title |
| `type` | yes | primary membership directory |
| `phase` | yes | lifecycle position: `idea` / `planning` / `building` / `maintained` / `parked` / `archived` |
| `activity` | yes | owner's current attention heat: `active` / `warm` / `cold` |
| `status_line` | yes | one line of "where things are now" (not "what's next") — dashboard card body |
| `next_action` | yes | the **single concrete action** to take on resume, ≤60 words; narratives belong in `status_line` or the thread |
| `blocked_by` | yes | project slugs blocking this one; `[]` if none |
| `unblocks` | yes | projects/directions this unblocks; `[]` if none |
| `tags` | yes | max 5, retrieval value only — membership is the path's job, summary is `status_line`'s |

Optional fields: `repo`, `local_paths`, `artifacts`, `supersedes`, `split_from`, `merged_into`, `parked_at`, `archived_at`, `archive_reason`.

Date fields:

| field | source | semantics |
|---|---|---|
| `started` | file creation time by default; hand-write only if the real start predates the file | |
| `last_touched` | **hand-written on substantive progress** (thread closure, delivery, major decision) | the clock for lifecycle cooling and archive proposals; cleanup edits must NOT update it. Display fallback: file mtime |

`artifacts` is a handoff surface, not a file manifest: entry files a future agent opens first (status doc, current runbook), high-signal directories, or a project-local artifact index — never per-file inventories of screenshots and logs.

## Lifecycle

States flow **automatically only toward cold**; warming (revival, restart) is always the owner's manual decision.

```text
active --14d--> warm --30d--> cold --60d--> archive proposal --owner ruling--> archived / parked
```

- Clock = days since `last_touched` (fallback: last substantive commit touching the card).
- Proposals are a list, never auto-executed. The owner approves (→ archived) or vetoes (→ `parked` + `parked_at`; re-proposed after 60 days).
- **Archiving is attention isolation, not deletion**: the card compresses to a tombstone in `archived/<type>/` (why it started / how far it got / why it stopped / revival conditions / where the assets are), history files stay put, repos stay untouched. Tombstone + history = full revival capability.

## Body structure

First line is the H1 title, followed by a **cold-start paragraph**: purpose, deliverable, why now, what it unlocks, and a one-time glossary of any project-internal terms — written so a smart reader with zero context understands the rest of the card. Tech-blog prose, not bullet lists. This is stable content; it changes only when the project's shape changes.

```md
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
## History
![[HISTORY/<type>/<project-slug>.history]]
```

| section | role |
|---|---|
| Human View | owner-facing global summary; all thread states aggregate here |
| Overview & Route | motivation, purpose, scope, architecture |
| Current Threads | only work lines that still need attention |
| Thread | one bounded work surface; `Status` and `Scope` control the boundary |
| Trajectory | iteration movement: short "what changed and why" notes, never detail archives |
| Future Work | plausible directions not yet promoted to a thread |
| History | a light embed/link to the canonical history file, never inlined history prose |

### Human View constraints (hard)

First H2 of the body. Its reader is the **owner**, not an agent — a 30-second global summary so they only dive into threads when they need execution detail.

```md
## Human View

**State**: (plain-prose global picture — no internal codenames, no file paths,
no commit hashes, no error-correction logs. A smart reader with zero context
must understand it in one pass.)

**Waiting on you**:
- specific decision or action 1
(omit the list header when nothing is pending — write "none, fully autonomous right now")
```

- State: 3–8 sentences. Telegraphic compression is not brevity; it shifts the cost to the reader.
- Every "waiting on you" item must be self-sufficient: what's needed and why it's stuck on the owner, without chasing references.
- **Maintenance discipline**: any update to threads or trajectory MUST sync the Human View. Stale is worse than absent — it feeds the owner outdated state to decide on.
- Not an append-only panel: delete outdated content first; when it exceeds limits, the first move is deletion, not tighter wording.

### Trajectory granularity

- One note per substantive change, ≤50 words plus a `YYYY-MM-DD HH:mm` timestamp.
- Motivation and logic ("why the mainline switched"), never commands, paths, checksums.
- Fewer, more general notes win; details belong in history files or runbooks. Audit after writing: if it reads like a fact list, compress or move it.

### Thread hygiene (hard)

- Current Threads holds only work that may still need attention.
- Checked to-dos (`[x]`) and `ready-to-archive` threads don't stay — move them to the folded Completed block or the history file.
- If a completed thread produced a durable turn in direction, distill that movement into Trajectory and archive the detail.

## History files

One canonical history file per project, mirroring the type path:

```text
<cards-root>/HISTORY/<type>/<project-slug>.history.md
```

Cards never inline completed history; the History section holds only the embed/link. Agents resuming in Mode B treat the embed as a reference and do not expand it unless the active thread requires it.

## Sidecar references

When a card references a sidecar doc (architecture, runbook), never a bare link — always attach a preview: main content in ≤2 sentences + what changed last time in ≤2 sentences. The preview exists so a reader can decide whether to open it. Whoever edits a sidecar updates its preview on the card.
