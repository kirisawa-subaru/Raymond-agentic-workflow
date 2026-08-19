# Adapters: harness wiring

Components in this repo are harness-neutral. An adapter never changes component logic — it only answers three wiring questions for one specific harness. If your harness isn't listed here, answer the same three questions from its documentation and you have written the adapter yourself; every mainstream harness has an equivalent for each.

## The three wiring questions

1. **Instruction discovery** — how does the harness find and load a `SKILL.md` on demand?
   Typical shapes: a skills directory it scans (symlink the component in), a settings array of extra skill paths, a rules/instructions directory, or — the universal fallback — a line in the project's agent-instructions file saying *"for task X, read `<path>/SKILL.md` first."* Components only reference their own bundled files by relative path, so linking the component directory is always sufficient.

2. **End-of-turn enforcement point** (needed by `batch-hook` only) — can the harness run a command when the agent tries to end its turn, and feed stderr back to the model on a nonzero exit?
   Typical shapes: a stop/turn-end hook, or an extension API that observes the agent loop and can inject a follow-up message. The contract the gate script expects: run it at end-of-turn; exit 0 → allow; exit 2 → refuse and show stderr to the model. Without such a point the component degrades to prose discipline — the ledger clauses still bind, but nothing enforces them mechanically.

3. **Per-session environment variables** — how do the variables in [docs/CONFIGURATION.md](../docs/CONFIGURATION.md) reach the agent's environment?
   Typical shapes: a settings-level env map, or plain shell-profile exports (works everywhere).

After instruction discovery is wired, run `/workflow-setup`. It records local settings directly in the installed `SKILL.md` files; if discovery uses symlinks, those edits land in the symlink targets.

## Included adapters

| Adapter | Discovery | batch-hook enforcement | Env |
|---|---|---|---|
| [claude-code](claude-code/) | `~/.claude/skills/` symlinks | `Stop` hook in `settings.json` | `settings.json` → `env` |
| [pi](pi/) | skills dirs or `settings.json` `skills` array | extension on the agent loop (sketch included) | shell profile |
| [codex](codex/) | `~/.codex/skills/` symlinks or `AGENTS.md` pointers | none documented — prose-discipline mode | shell profile |
