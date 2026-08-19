# Adapter: Claude Code

Wiring for the Claude Code harness. Nothing here changes component logic — it only tells Claude Code where to find things.

## Skills discovery

```bash
ln -s "$(pwd)/skills/workflow-setup" ~/.claude/skills/workflow-setup
ln -s "$(pwd)/skills/track-project" ~/.claude/skills/track-project
# ...repeat per component
```

Invoke `/workflow-setup` after linking the components. Because these are symlinks, its managed configuration edits land in this checkout; copy the component directories instead if that is not desired.

## batch-hook stop-check

Claude Code's enforcement point is a `Stop` hook. Register the predicate script once in `~/.claude/settings.json` (merge with existing hooks, don't overwrite):

```json
"Stop": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "$HOME/.claude/skills/batch-hook/stop-gate.sh",
        "timeout": 10,
        "statusMessage": "batch hard-gate check"
      }
    ]
  }
]
```

Claude Code injects `CLAUDE_PROJECT_DIR`; the script accepts it as a fallback for `AGENT_PROJECT_DIR` automatically.

On Windows, point the hook command at the PowerShell port instead:

```json
"command": "powershell -NoProfile -File %USERPROFILE%\\.claude\\skills\\batch-hook\\stop-gate.ps1"
```

(Use `pwsh` if PowerShell 7+ is installed. Same contract, same exit codes.)

## Environment variables

Set the variables from `docs/CONFIGURATION.md` in `settings.json` → `env` to apply them to every session:

```json
"env": {
  "PROJECT_CARDS_ROOT": "/path/to/your/vault"
}
```
