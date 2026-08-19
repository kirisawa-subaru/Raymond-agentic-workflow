# Adapter: Codex CLI

Wiring for OpenAI Codex CLI. Nothing here changes component logic.

## Skills discovery

Codex scans `~/.codex/skills/`:

```bash
ln -s "$(pwd)/skills/workflow-setup" ~/.codex/skills/workflow-setup
ln -s "$(pwd)/skills/track-project" ~/.codex/skills/track-project
# ...repeat per component
```

Invoke `/workflow-setup` after linking the components. Because these are symlinks, its managed configuration edits land in this checkout; copy the component directories instead if that is not desired.

Universal fallback if your version predates skills support — pointer lines in `~/.codex/AGENTS.md` (or a project `AGENTS.md`):

```markdown
- Before project-planning work, read ~/agentic-workflow/skills/track-project/SKILL.md and follow it.
- Before coordinating multi-agent work, read ~/agentic-workflow/skills/orchestration/SKILL.md and follow it.
```

## batch-hook enforcement point

Codex's `hooks.json` covers lifecycle events, but as of this writing no documented event can refuse end-of-turn and feed stderr back to the model. Without that enforcement point, `batch-hook` runs in prose-discipline mode: keep the continuous-execution clauses in the batch ledger (they still bind the model textually), and layer an external re-prompt loop for truly unattended runs. Check your version's hooks documentation for a Stop-equivalent event before assuming this is still true.

## Environment variables

Codex inherits the shell environment; export the variables from `docs/CONFIGURATION.md` in your shell profile:

```bash
export PROJECT_CARDS_ROOT="/path/to/your/vault"
```
