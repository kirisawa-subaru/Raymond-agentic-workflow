---
name: batch-hook
description: Arm/disarm a "continuous-execution hard gate" for unattended batch sessions — a harness stop-check + repo sentinel + ledger predicate that refuses to let the session end its turn until the batch ledger is fully checked off or an explicit BLOCKED trace is written. Use when arming before dispatching a batch, disarming after close-out, or troubleshooting "session won't stop / stop-check refuses to stop". Do NOT use for single tasks, supervised interactive sessions, or timeout management of external worker processes.
---

# batch-hook: hard gate for continuous batch execution

Long unattended batches fail in a characteristic way: the model doesn't crash, it *lets go* — ends its turn on a plan, a milestone summary, or a polite "shall I continue?". This gate makes letting go mechanically impossible while work remains.

## Mechanism

Three parts. Installed globally once, armed per batch:

1. **Predicate script** (`stop-gate.sh` in this skill's directory): registered with your harness as a stop-check — a command the harness runs every time a session tries to end its turn. Exit 2 with a stderr message means "refuse, feed the message back to the model". Wiring per harness lives in `adapters/`; the script itself is harness-neutral POSIX shell.
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
- Stop-check registration is a global standing fixture of your harness config. If it goes missing, re-register per your harness's adapter in `adapters/`.
- The script resolves the repo root from `AGENT_PROJECT_DIR`, falling back to the harness-injected project dir, then `$PWD`.
- Hard requirement: a harness that can run a command at end-of-turn and feed its stderr back to the model on a nonzero exit. Without that enforcement point this component degrades to prose discipline — still useful in the ledger, but no longer a hard gate.
