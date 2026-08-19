# Continuous-execution hard gate — PowerShell port of stop-gate.sh; identical contract.
# Register as your harness's end-of-turn stop-check (see adapters/); exit 2 + stderr = refuse stop, message fed back to the model.
# Sentinel: <project root>/tmp/batch-active; first line = repo-relative path of the batch ledger.
# Project root: $env:AGENT_PROJECT_DIR, else the harness-injected project dir, else the current directory.
# Always fail-open: on any config anomaly, pass — never trap the session.
# Works on Windows PowerShell 5.1 and pwsh 7+; no external dependencies.

$ErrorActionPreference = "SilentlyContinue"

$root = if ($env:AGENT_PROJECT_DIR) { $env:AGENT_PROJECT_DIR }
        elseif ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR }
        else { (Get-Location).Path }
$sentinel = Join-Path $root "tmp/batch-active"

if ([Console]::IsInputRedirected) { [void][Console]::In.ReadToEnd() }  # consume the hook's stdin payload; this gate doesn't need it

if (-not (Test-Path -LiteralPath $sentinel)) { exit 0 }

$ledgerRel = Get-Content -LiteralPath $sentinel -TotalCount 1
if ($null -eq $ledgerRel) { exit 0 }
$ledgerRel = $ledgerRel.Trim()
if ($ledgerRel -eq "") { exit 0 }
$ledger = Join-Path $root $ledgerRel
if (-not (Test-Path -LiteralPath $ledger)) { exit 0 }

$lines = Get-Content -LiteralPath $ledger
if ($null -eq $lines) { exit 0 }
if (-not ($lines -match '^\s*- \[ \]')) { exit 0 }   # no unchecked items = close-out line reached, pass
if ($lines -match '^BLOCKED:') { exit 0 }            # column-0 BLOCKED trace (start of line only), pass

[Console]::Error.WriteLine("Batch execution hard gate: $ledgerRel still has unchecked items and no BLOCKED trace. Continue with the next step (read the ledger's execution-discipline section). If genuinely hard-blocked, append a column-0 line 'BLOCKED: <reason> <paths tried>' at the end of the ledger, then end normally. If this session is not a batch-execution thread (false trigger), delete tmp/batch-active to disarm.")
exit 2
