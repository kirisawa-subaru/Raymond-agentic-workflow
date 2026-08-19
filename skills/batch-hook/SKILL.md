---
name: batch-hook
description: Arm/disarm a "continuous-execution hard gate" for unattended batch sessions — a global Stop hook + repo sentinel + ledger predicate that refuses to let the session end its turn until the batch ledger is fully checked off or an explicit BLOCKED trace is written. Use when arming before dispatching a batch, disarming after close-out, or troubleshooting "session won't stop / Stop hook refuses to stop". Do NOT use for single tasks, supervised interactive sessions, or timeout management of external (non-Claude) workers.
---

# batch-hook: hard gate for continuous batch execution

Long unattended batches fail in a characteristic way: the model doesn't crash, it *lets go* — ends its turn on a plan, a milestone summary, or a polite "shall I continue?". This gate makes letting go mechanically impossible while work remains.

## Mechanism

Three parts. Installed globally once, armed per batch:

1. **Predicate script** (`stop-gate.sh` in this skill's directory): registered globally as a Stop hook in `~/.claude/settings.json`; runs every time a session tries to end its turn.
2. **Sentinel** `$REPO/tmp/batch-active`: first line = repo-relative path of the batch ledger. Sentinel absent → the gate is fully transparent (millisecond check, then pass). This is the per-batch on/off switch — zero configuration.
3. **Ledger contract**: the batch ledger tracks progress with `- [ ]` checkboxes; a hard-block trace is one line at column 0 at the end of the ledger — `BLOCKED: <reason> <paths tried>`. The gate matches `^BLOCKED:` only, so mentions inside list items don't trigger it.

On refusal the reason is fed back to the model via stderr: keep executing, or write a BLOCKED trace before you may end. Pass conditions = ledger fully checked / column-0 BLOCKED / sentinel absent / ledger path invalid (fail-open — a misconfigured gate must never trap the session).

## Arm (first step of an execution thread)

```bash
mkdir -p tmp && echo 'doc/batch/batch-YYYYMMDD-xxx.md' > tmp/batch-active
```

## Disarm (after close-out or BLOCKED)

```bash
rm tmp/batch-active
```

## Discipline clauses the batch ledger must contain (template)

When writing a batch doc, put these in its "continuous-execution discipline" section:

- Only two legal stopping points: the close-out line, or a hard block (a closed enumeration, defined per batch — e.g. contract contradiction needing a human ruling / external blocker that survives retries / environment that cannot self-heal / safety doubt).
- Milestones are not stopping points: finish a slice → check the box → start the next slice without asking. A turn may not end on a plan or a "shall I continue?".
- Stopping requires a trace: on hard block, append `BLOCKED: <reason> <paths tried>` at column 0, and only then end.
- Prevent mechanical deaths: run jobs longer than ~5 minutes in the background (foreground shells commonly carry a hard timeout that gets misread as a stall); start the session in a non-interactive permission mode — a pending permission dialog is the most common mechanical cause of "stopped halfway".

## Notes

- The gate only prevents the model letting go; it does not survive process death (terminal closed, machine asleep). For truly unattended overnight runs, layer an external re-prompt loop (cron or similar) on top.
- Hook registration is a global standing fixture. If `hooks.Stop` in `~/.claude/settings.json` goes missing, restore it with the snippet below (merge with existing hooks, don't overwrite):

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
