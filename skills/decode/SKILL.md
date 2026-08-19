---
name: decode
description: Rewrite raw agent output into human-readable density. Compressed orchestrator output → syntactic decompression + reference expansion; audience-mixed worker output → decision/execution triage + folded summaries. Use when a human needs to consume agent reports without drowning in information density or irrelevant implementation detail.
---

# Decode — agent output → human-readable

## Why this skill exists

An agent's working memory is far larger than a human's. Expression optimized by an agent is efficient for the agent itself (or for the next instance resuming its context), but exceeds what a human can parse in one read. Two styles of agent output hit this bottleneck differently, and the fixes are different.

## Trigger

The user gives you a piece of agent output (pasted text, a file path, or "decode X"). Rewrite it by the rules below. If the user doesn't name the source style, judge it yourself — compressed-orchestrator output is marked by high-density noun phrases and omitted causal connectives; worker-report output is marked by decision content and implementation specs interleaved in the same document.

## Style A: double-compressed orchestrator output

(Typical of high-density orchestrator models writing ledgers, close-out notices, and handoffs.) The problem is two layers of compression stacked:

1. **Context compression**: lane IDs, commit hashes, incident codenames, and term abbreviations are used as known quantities, never expanded.
2. **Syntactic compression**: multiple independent assertions squeezed into one comma-separated clause, causal connectives omitted.

### Rules

- **One assertion per line.** Independent facts joined by commas or semicolons in the source get their own lines.
- **Make causality explicit.** A causal chain implied by juxtaposition ("A, B, C") becomes "A. Because B, therefore C." If the causal direction is uncertain, keep the juxtaposition but split the lines.
- **Expand compressed references.** On first occurrence of a lane ID, incident codename, or abbreviation, append a one-sentence parenthetical of context — e.g. "the PRIM2 incident (a git checkout inside a clone wiped an unharvested implementation)". Keep commit hashes but add a sentence on what each did. If you don't know what a reference points to, mark it `[?]` rather than guessing.
- **Fix cross-language syntax.** Orchestrators often write one language with another language's syntax (front-loaded modifiers, passive voice, nested parentheticals). Rewrite into natural subject-verb-object order for the output language.
- **Add blank lines** at logical topic switches. None within a topic.
- **Delete nothing.** This is decompression, not summarization. Every fact survives.

### Example

Source:

> K3 payload findings 5/5 verified-true, session audit zero overreach, noise 1/8 (COMMON path misjudgment, matches profile "mechanism slightly wide")

Rewritten:

> All 5 of K3's payload findings were personally verified by the orchestrator and confirmed true.
>
> The session audit was clean — no out-of-scope access.
>
> Noise rate was 1/8: the single false positive judged COMMON.md's path to be "another machine's path". This matches the K3 profile trait "conclusions reliable, mechanism boundaries occasionally drawn wide".

## Style B: audience-mixed worker output

(Typical of spec-oriented worker models writing reports.) The problem is not too much detail but **no audience separation** — content the human needs for a decision and specs the next worker needs for execution sit in the same document, forcing the human to read implementation detail irrelevant to their ruling.

### Rules

- **Identify each paragraph's real audience.** Ask: does this help the human judge direction, or tell a worker how to implement?
- **Present only the decision layer.** Direction judgments, risk warnings, key constraints, recommended options — keep these verbatim (worker-model prose aimed at humans is usually fine as written).
- **Demote the execution layer to folded summaries.** Replace omitted implementation detail with 2–3 sentences stating what was compressed, appended to the relevant section:

  > **[execution detail omitted]** Omitted here: the four commit preconditions of AgreedTextStore and the five scenarios that must share one commit path. See §3, second half, when you need the implementation spec.

- **Preserve the source's section numbering** so the reader can jump back to omitted parts by number.
- **Acceptance checklists, interface definitions, hash-verification timing** and similar pure-execution content get folded whole, never itemized.

### Example

Source (second half of a worker report's §3):

> The later three-way merge requires a new `AgreedTextStore`, which may only advance once all of the following hold:
> - Both sides' target text written or verified.
> - Both sides' UID/content digests re-acquired.
> - The sync record committed.
> - The corresponding pending operation completed.
>
> Upload, download, equal-content AddRecord, manual resolution, and auto-merge must all go through the same commit path. When the base is missing or untrusted, always fall back to keep-both — never degrade to latest-wins.

The whole passage becomes:

> **[execution detail omitted]** Omitted here: AgreedTextStore's four write preconditions and the unified-commit-path constraint across its five scenarios. The core conclusion is above: the current base is untrusted, and a trustworthy ancestor store must be built before enabling. See §3 for the concrete constraints.

## Mixed or uncertain sources

If one document contains both styles (e.g. an orchestrator ledger embedding worker reports), handle it per paragraph. Mark each switch with one line: "The following is [source]'s output."

## Never do

- **No analysis or opinion of your own.** You are a translator, not an advisor. The reader wants the original information made readable, not your take on it.
- **No merging or reordering of sections.** Keep the source's logical flow; change only the density.
- **No vague fold summaries.** "Some implementation details omitted" is useless — state which categories of what were omitted, enough for the reader to decide whether to expand.
- **No audience triage on Style A output.** An orchestrator's human-facing content (status views, ruling summaries) is already filtered; its internal documents (ledgers, handoffs) need decompression, not deletion.
- **No syntactic decompression on Style B output.** Worker prose aimed at humans reads fine; the problem is not the syntax.
