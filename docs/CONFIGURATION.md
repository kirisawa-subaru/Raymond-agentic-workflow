# Configuration

<!-- Skeleton — filled in as components land. Conventions below are frozen so extraction targets them. -->

## Path conventions

Three tiers, per ecosystem practice:

1. **Plugin-bundled resources** (templates, scripts, reference docs): referenced via `${CLAUDE_PLUGIN_ROOT}`. Never hardcoded.
2. **Project-local paths** (hooks operating on the current repo): `${CLAUDE_PROJECT_DIR}`.
3. **User-personal locations** (your planning-vault root, etc.): environment variables declared below, set in `settings.json` → `env`, or written by first-run setup.

## Environment variables

| Variable | Used by | Meaning | Default |
|---|---|---|---|
| `PROJECT_CARDS_ROOT` | `track-project` | Root of your planning-card vault (must contain `SCHEMA.md` and `INDEX.md`; first-run setup instantiates them from templates) | none — required |

<!-- TODO: add per-component variables as they land -->

## Opt-in behaviors

Potentially intrusive behaviors ship **disabled-by-prose**: each skill states its default scope in `SKILL.md` (e.g. `track-project` commits planning-doc changes as part of its contract) with an explicit note on how to narrow it. Guardrails live in the skill text itself — stop-or-confirm rules, staging boundaries — following ecosystem convention rather than a parallel config engine.
