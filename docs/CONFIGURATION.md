# Configuration

## Path conventions

Three tiers, none of them harness-specific:

1. **Component-bundled resources** (templates, scripts, reference docs): referenced relative to the component's own directory. Never hardcoded.
2. **Project-local paths**: resolved from the working repo root at runtime (`git rev-parse --show-toplevel`, or the project-dir variable your harness injects — see `adapters/`).
3. **User-personal locations** (your planning-vault root, handoff directory): environment variables declared below. Export them in your shell profile, or use your harness's per-session env mechanism (see `adapters/`).

## Environment variables

| Variable | Used by | Meaning | Default |
|---|---|---|---|
| `PROJECT_CARDS_ROOT` | `track-project` | Root of your planning-card vault (must contain `SCHEMA.md` and `INDEX.md`; init mode instantiates them from templates) | none — required |
| `AGENT_HANDOFF_DIR` | `handoff` | Where session handoff files are written | `~/.agent/session-handoff` |
| `AGENT_PROJECT_DIR` | `batch-hook` | Repo root the stop-check resolves the sentinel against | harness project dir, else `$PWD` |

## Authorization model

There is no parallel policy engine and no on/off flags. Behaviors ship **enabled and stated in plain text**: the README's "What this authorizes" section is the complete inventory, and each SKILL.md carries its own guardrails (stop-or-confirm rules, staging boundaries, fail-open design) inline. Since these components are plaintext instructions, narrowing an authorization means editing the text — which is exactly as powerful as any config flag, and honest about where the enforcement actually lives.
