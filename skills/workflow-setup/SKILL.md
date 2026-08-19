---
name: workflow-setup
description: Configure this installed workflow skill suite in one pass by discovering the local harness, runtimes, models, paths, and supported enforcement primitives; asking the user only for unresolved choices; and writing the results directly into bounded Local configuration blocks inside each installed SKILL.md. Use immediately after installation, after changing harnesses/models/paths, when a skill reports UNCONFIGURED local settings, or via `/workflow-setup`. Do NOT use for ordinary project work.
---

# Workflow Setup

You are the top-level setup agent for the installed suite. Configure every present component in one session. The configuration substrate is the skill text itself: do not create a sidecar configuration system or assume the harness loads files other than those each `SKILL.md` explicitly requires.

## Ownership boundary

- Edit only text between `<!-- workflow-setup:begin local-configuration -->` and `<!-- workflow-setup:end local-configuration -->` in sibling skills.
- Never put credentials, tokens, private keys, or copied environment values containing secrets into a skill.
- Preserve every rule outside the marked block byte-for-byte unless the user separately asks to change the skill itself.
- Treat symlinks explicitly: resolve and report the physical target before editing. Editing a symlinked skill changes its source checkout, not merely the harness's discovery directory.
- Do not write harness-global settings silently. Installing a stop hook, changing a global environment map, or altering a harness settings file requires the user's explicit approval of the exact target and change.

## Suite discovery

Resolve the physical directory containing this skill, then inspect its parent as the suite's `skills/` root. Configure each sibling component that is present and contains the managed block. Current inventory:

| Component | Configuration to settle |
|---|---|
| `orchestration` | current harness; dispatchable external workers (application/runtime, model, invocation); role-to-worker seat map; runner primitives; prompt-template location |
| `track-project` | cards root; whether project-document changes are committed automatically |
| `handoff` | handoff output directory |
| `batch-hook` | harness; hard-gate vs prose-only mode; registered stop-check command and settings location; project-root resolution |
| `decode` | none |
| `doc-setup` | none |

Skip absent components. If a present configurable skill lacks the markers, report it as an incompatible or older version; do not guess an insertion point.

## Setup procedure

### 1. Discover before asking

Inspect read-only local evidence first:

- current harness and version;
- installed skill paths and whether each is a symlink;
- available external agent CLIs/app integrations and their local `--help` or capability listings;
- model identifiers the installed runtimes actually expose;
- existing environment variables and already configured block values;
- existing cards roots named by `$PROJECT_CARDS_ROOT` or an explicit project locator;
- the current handoff directory or its existing default;
- available stop/end-of-turn hooks and whether a batch gate is already registered;
- prompt-template directories explicitly named by current project material.

Do not search broad personal directories speculatively. Do not use web documentation for locally installed command behavior while a local help/version/capability interface can answer it.

### 2. Build one decision set

Separate discovered facts from user rulings. Consolidate all unresolved choices into one short setup exchange rather than interviewing once per skill. Ask only for decisions such as:

- which discovered worker occupies each orchestration role;
- whether a missing role should remain explicitly unfilled;
- which valid cards root to use, or whether to initialize one later;
- whether `track-project` may commit its scoped documentation changes automatically;
- whether to keep the default handoff directory;
- whether to install an available hard stop gate or use prose-only batch discipline;
- which prompt-template directory is authoritative when several real candidates exist.

Never ask the user to transcribe a model name, path, version, or command you can inspect directly. Never invent a worker or mark a runner primitive supported because the playbook wants it.

### 3. Write the managed blocks

After the user rules on the unresolved choices, replace only the contents inside each managed block:

- Set `Configuration status` to `configured` only when every field required for that component's selected mode is resolved.
- Preserve explicit absences such as `Style: unfilled` or `batch-hook: prose-only`; absence is configuration, not a reason to fabricate a seat or capability.
- Use absolute paths for machine-local directories and executable paths when resolved. Paths inside a project may remain repo-relative when the block says which repo owns the coordinate system.
- Record application/runtime, exact model identifier, and invocation route separately. A model name alone is not a dispatch route.
- Keep the block concise. It is hot runtime context, not an installation log.

If setup requires a global harness change, finish the skill blocks first with that dependency marked `pending`, obtain explicit approval, then make and verify the harness change before marking it configured.

### 4. Validate from the runtime reader's position

For every configured component:

- re-open its `SKILL.md` as a fresh runtime agent would;
- confirm the block contains no `UNCONFIGURED` value required by the selected mode;
- confirm configured paths and commands exist or are explicitly deferred;
- confirm orchestration seats reference workers actually defined in the same block;
- confirm claimed runner primitives were observed locally;
- confirm batch-hook's claimed mode matches the harness's real enforcement point;
- inspect the diff and verify no text outside managed blocks changed.

## Reconfiguration and upgrades

- Re-running this skill is the supported way to change local configuration.
- Preserve still-valid decisions and ask only about missing, stale, or contradicted values.
- When a configured app, executable, model, directory, or harness feature no longer exists, demote that component to `needs-reconfiguration`; do not silently substitute a similar value.
- After an upstream skill update, inspect the managed markers and reapply existing local values only when their meaning is unchanged.

## Completion report

Report configured, intentionally unfilled, pending, and incompatible components separately. List every edited physical file, every harness-global file changed with approval, and the evidence used to validate commands, paths, models, and hook support. End with the exact remaining action when any component is not fully configured.
