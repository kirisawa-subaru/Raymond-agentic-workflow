# Project doc-management standard

> Role: **canonical standard text**. Materialized on installation as each repo's `doc/README.md` (standard copy + that repo's index). The repo copy is a snapshot taken at installation time; drifting from this file is expected behavior. Realignment happens by re-running a doc-setup audit, never by automatic sync.

## Core principle

**Partition by lifecycle, not by topic.** Live contracts and frozen records must not share a namespace — when an agent enters the repo to search, the authoritative context must be identifiable by directory in one sentence (`doc/spec/` is the current truth; everything else is history).

## Directory skeleton

```
doc/
  README.md    — repo copy of this standard + Key Specs index
  principle.md — development principles: the minimal set of judgment rules for orchestrator use (living doc)
  spec/        — live contracts: updated in place, filenames carry no date/version
  release/     — release-scope specs (spec-vX.Y.Z.md): reference spec/ without copying contract detail; frozen after release
  batch/       — execution specs / state ledgers (batch-YYYYMMDD-*.md): moved to archive/ after settlement
  archive/     — frozen history: settled batches, parked items, superseded specs
  pic/         — images and attachments (existing repos keep their current name; new repos use assets/)
```

`principle.md` entry criteria: at project start, orchestrator and user negotiate **1–3 initial principles**. What qualifies: **judgment standards and values this project deliberately emphasizes, typically where they differ from default good practice** — the purpose is fitting the software to its actual place in the user's world. What matches default good practice is not written down: that is the consensus baseline of any competent agent, and writing it here is noise. One entry = value judgment + the originating case + entry date; mechanism detail belongs in `spec/`. Whole file fits one screen; later additions and removals require a user ruling.

Near-equivalent existing directories (such as `parked/`) are merged into the corresponding partition during audit, not renamed and rebuilt by force.

## Three disciplines

1. **Naming is lifecycle**: a filename with a date (YYYYMMDD) = frozen at completion, append-only, superseded by writing a new doc that references the old; no date = living doc, updated in place, git history is the version history.
2. **Authority chain**: `principle.md > spec/ > release/ > batch/`. When downstream findings contradict upstream text → stop and escalate; unilateral edits to frozen text are forbidden. Batch docs only need to cite this clause, not restate the full chain.
3. **Settlement actions**: at batch settlement / release — batch docs and state ledgers move into `archive/`, the release spec's header gets its freeze date, and the README index is updated. This runs off the settlement checklist, not from memory.

## Header role declaration

Under every doc's title, a blockquote states: `Role: live contract / release snapshot / execution record` + current status; add the freeze date when frozen.

## Index and pointers

- `doc/README.md` maintains the Key Specs index (one line per entry: path + one-sentence role).
- In the repo's entry file (`project.md` / `AGENTS.md` / `CLAUDE.md` — whichever the repo already has), the repo-layout row for `doc/` points to `doc/README.md`. Working agents read the repo copy; they neither need nor should depend on this canonical file.
