# Configuration

## Path conventions

Three tiers:

1. **Skill-bundled resources** (templates, scripts, reference docs): referenced relative to the skill's own directory — the harness injects the skill's base directory at invocation time. Never hardcoded.
2. **Project-local paths** (hooks operating on the current repo): `${CLAUDE_PROJECT_DIR}`, provided by the harness to hooks.
3. **User-personal locations** (your planning-vault root, etc.): environment variables declared below. Set them in `settings.json` → `env` (applies to every session), or export them in your shell profile.

## Environment variables

| Variable | Used by | Meaning | Default |
|---|---|---|---|
| `PROJECT_CARDS_ROOT` | `track-project` | Root of your planning-card vault (must contain `SCHEMA.md` and `INDEX.md`; first-run setup instantiates them from templates) | none — required |

<!-- TODO: add per-component variables as remaining components land -->

## Authorization model

There is no parallel policy engine and no on/off flags. Behaviors ship **enabled and stated in plain text**: the README's "What this authorizes" section is the complete inventory, and each SKILL.md carries its own guardrails (stop-or-confirm rules, staging boundaries, fail-open design) inline. Since skills are plaintext instructions, narrowing an authorization means editing the text — which is exactly as powerful as any config flag, and honest about where the enforcement actually lives.
