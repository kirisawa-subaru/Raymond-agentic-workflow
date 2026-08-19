# Configuration

## Plaintext is the compatibility layer

The suite does not assume a harness will discover or inject a sidecar JSON/YAML configuration file. Every runtime setting is written directly into a bounded `Local configuration` block in the installed component's `SKILL.md`, which the agent already has to read.

Run `/workflow-setup` after installation. The setup agent discovers local facts first, asks the user only for unresolved choices, and edits text between these markers:

```html
<!-- workflow-setup:begin local-configuration -->
...
<!-- workflow-setup:end local-configuration -->
```

Text outside those markers is upstream procedure and is not setup-owned.

## Configurable components

| Component | Local settings |
|---|---|
| `orchestration` | harness, workers, role seats, runner primitives, prompt-template directory |
| `track-project` | cards root, automatic scoped documentation commits |
| `handoff` | handoff output directory |
| `batch-hook` | harness, hard-gate/prose-only mode, registered stop-check, project-root resolution |
| `decode` | none |
| `doc-setup` | none |

## Path conventions

1. **Component-bundled resources** are referenced relative to the component's own directory.
2. **Project-local paths** are resolved from the working repo root at runtime.
3. **Machine-local paths** are absolute values in the component's managed block.
4. **Environment variables** are explicit runtime overrides and take precedence over configured paths.

| Variable | Used by | Meaning | Fallback |
|---|---|---|---|
| `PROJECT_CARDS_ROOT` | `track-project` | Root of the planning-card vault | configured Cards root, project locator, then Init mode |
| `AGENT_HANDOFF_DIR` | `handoff` | Handoff output directory | configured Handoff directory |
| `AGENT_PROJECT_DIR` | `batch-hook` | Repo root used by the stop predicate | harness project directory, then `$PWD` |

## Symlinks and upgrades

When a harness discovers a component through a symlink, editing its `SKILL.md` edits the physical source checkout. `/workflow-setup` must resolve and report that target before writing. Use materialized component copies instead of symlinks when local configuration must not dirty the upstream clone.

During upgrades, preserve managed blocks only when their field meanings are unchanged. A missing marker or changed field contract requires reconfiguration; do not paste old values into a new semantic shape blindly.

## Authorization model

There is no parallel policy engine. Authorizations remain plain instructions in each skill. Setup may fill an existing authorization field, such as `track-project`'s automatic commit setting, but it may not invent new authority or edit outside its managed blocks. Global harness changes such as installing a stop hook require explicit approval of the exact target and diff.
