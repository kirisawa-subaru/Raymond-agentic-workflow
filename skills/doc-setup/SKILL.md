---
name: doc-setup
description: >-
  Set up, audit, or close out a repo's doc/ structure per the doc-management standard (lifecycle partitioning, naming-as-lifecycle, authority chain). Use when asked to set up a doc structure, reorganize/audit an existing doc tree, close out and archive batch docs, or freeze a release spec — in any repo regardless of location. Do NOT use for: (a) project cards / planning memory — that's track-project; (b) multi-agent dispatch — that's orchestration; (c) writing or revising the CONTENT of a spec/batch doc — this skill governs structure and lifecycle, not contract substance; (d) user-facing documentation sites.
---

# Doc Setup

Governs project doc structure across repos. The canonical standard lives in [reference/doc-standard.md](reference/doc-standard.md); this skill materializes it per repo. Architecture: this skill is the **installer/auditor** (user-level trigger, works in any directory); the ambient layer that working agents actually read is the **repo-materialized copy** at `doc/README.md` plus a pointer from the repo's entry file. Worker agents never need this skill — they read the repo files.

Always read `reference/doc-standard.md` first; it is the single source of truth for the standard's text. Do not restate a divergent copy from memory.

## Mode 1 — Setup (new or unstructured repo)

1. Survey existing state: `doc/` contents (or absence), entry files (`project.md` / `AGENTS.md` / `CLAUDE.md` / `README.md`), existing naming habits.
2. Create the skeleton from the standard: `doc/{spec,release,batch,archive}` plus `pic/` or `assets/` per the standard's rule. Create empty `doc/principle.md` with a header.
3. Initialize `doc/principle.md`: prompt orchestrator + user to negotiate 1–3 principles per the standard's entry criteria (judgment standards and values where this project deliberately differs from default good practice). Leave blank if the user defers.
4. Materialize `doc/README.md`: the standard's text (a repo copy, not a pointer back to this skill) + a Key Specs index for this repo.
5. Wire the pointer: in whichever entry file the repo already uses, make the `doc/` row/mention point to `doc/README.md`, and add a `Principles:` line pointing to `doc/principle.md` marked "top of the authority chain — read before starting work". Create no new entry file just for this; if none exists, note it and stop.
6. Report what was created and any repo-specific deviations you preserved.

## Mode 2 — Audit / restructure (existing doc tree)

1. Read `doc/README.md` if present (the repo's frozen snapshot) and diff the actual tree against the standard: misplaced lifecycles, dated files outside `batch/`/`archive/`, undated files that are actually frozen records, missing headers, stale index.
2. Propose the migration as a plan (moves, renames, link fixes) **before executing** — moves break relative links.
3. On approval: use `git mv` for tracked files; then grep all `](` relative links across `doc/` and entry files and fix every reference to a moved path. Never edit the content of dated (frozen) docs beyond link paths. **Exempt frozen prompt traces** (`prompts/` directories and the like): they record what was actually sent to workers — rewriting paths there falsifies the archive; leave them and note the exemption in the report.
4. Merge near-equivalent existing dirs (e.g. `parked/` → `archive/`) rather than duplicating partitions.
5. Refresh `doc/README.md` to the current standard text + rebuilt index.

## Mode 3 — Close-out (batch settlement / release)

1. Move the closed batch's `batch-*.md` and state ledgers into `doc/archive/`, fixing inbound links as in Mode 2.
2. Freeze the release spec: add the freeze date to its header blockquote; do not otherwise edit it.
3. Update the `doc/README.md` index.

## Guardrails

- **Materialize, don't symlink.** The repo copy drifting from canonical is expected and correct; upgrading is an explicit audit rerun, never automatic.
- **Frozen means frozen.** Dated docs get moved and link-fixed only; their substance is immutable. Superseding happens by writing a new doc that references the old.
- Respect the repo's existing language and register.
- Keep the materialized `doc/README.md` standard section under ~40 lines — a governance doc too long to skim is a governance doc that gets silently abandoned.
- Structural changes to a git repo: leave them staged-or-committed per the session's git rules; this skill carries no standing commit authorization of its own.
