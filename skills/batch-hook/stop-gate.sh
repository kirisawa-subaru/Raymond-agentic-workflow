#!/usr/bin/env bash
# Continuous-execution hard gate (Claude Code Stop hook, registered globally in ~/.claude/settings.json) — companion to the batch-hook skill.
# Sentinel: $CLAUDE_PROJECT_DIR/tmp/batch-active; first line = repo-relative path of the batch ledger.
# Sentinel absent = fully transparent to the session (millisecond check, then pass).
# Predicate: ledger still has unchecked checkboxes and no column-0 "BLOCKED:" line -> refuse stop (exit 2, stderr fed back to the model).
# Exits: all boxes checked / column-0 BLOCKED trace / sentinel deleted. Always fail-open: on any config anomaly, pass — never trap the session.
set -u

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
SENTINEL="$ROOT/tmp/batch-active"

cat >/dev/null  # consume the hook's stdin payload; this gate doesn't need it

[[ -f "$SENTINEL" ]] || exit 0

LEDGER_REL="$(head -n1 "$SENTINEL" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
[[ -n "$LEDGER_REL" ]] || exit 0
LEDGER="$ROOT/$LEDGER_REL"
[[ -f "$LEDGER" ]] || exit 0

grep -q '^[[:space:]]*- \[ \]' "$LEDGER" || exit 0   # no unchecked items = close-out line reached, pass
grep -q '^BLOCKED:' "$LEDGER" && exit 0              # column-0 BLOCKED trace (start of line only, so discipline prose doesn't match), pass

echo "Batch execution hard gate: ${LEDGER_REL} still has unchecked items and no BLOCKED trace. Continue with the next step (read the ledger's execution-discipline section). If genuinely hard-blocked, append a column-0 line 'BLOCKED: <reason> <paths tried>' at the end of the ledger, then end normally. If this session is not a batch-execution thread (false trigger), delete tmp/batch-active to disarm." >&2
exit 2
