---
name: handoff
description: Capture pre-compact context that automatic compaction systematically loses (conversation register, reasoning chains, ephemeral resources, user state). Run BEFORE compacting, or any time session continuity should survive a context boundary.
---

# Session handoff

Write a complementary session handoff to `$AGENT_HANDOFF_DIR/<filename>.md` (default `~/.agent/session-handoff/`).

Automatic compaction is optimized for facts: files changed, errors fixed, pending tasks. What it systematically drops is everything *relational and epistemic* — how the conversation was being conducted, why decisions went the way they did, what's still alive outside the transcript, and how much each shipped claim deserves to be trusted. This skill captures exactly that complement.

## Filename convention

`<YYYY-MM-DD-HHMM>_<cwd-slug>_<short-topic>.md`

- `cwd-slug`: current cwd with `/` replaced by `-`, leading slash dropped. Example: `/Users/you/dev/my-project` → `-Users-you-dev-my-project`.
- `short-topic`: 2–4 hyphenated words capturing what the session was about.
- `YYYY-MM-DD-HHMM`: hour-minute precision so multiple handoffs in one day sort cleanly.

## File body — what to capture

Automatic compaction already preserves files changed, errors and fixes, user messages, pending tasks, current work. **Do NOT duplicate that.** Focus on what it drops:

### 1. Conversation register & implicit contracts

- Primary language? Code-switching pattern?
- Tone register established (formal / casual / meta / playful / blunt)?
- Implicit dos and don'ts that emerged this session — quoted if from explicit user feedback, paraphrased if implicit
- Any explicit corrections the user gave that should persist
- "Active permissions" — what kind of interaction is okay right now (pushback, profanity, persona moves, depth of meta)

### 2. Reasoning chains (why, not what)

For each non-trivial decision in the session, record cause→effect. Compaction turns these into result-bullets and loses the *why*. Format:

> **Decision**: <what was chosen>
> **Why**: <the reasoning chain — including the alternatives ruled out>

Example:

> **Decision**: kill().wait() now wrapped in 5s timeout
> **Why**: macOS asyncio SIGCHLD investigation — discovered orphan process with PPID=1 while parent's wait() never returned. Acceptable to leak the proc reference; OS will reap. Alternatives ruled out: signal-based reaping (added complexity), forced os.waitpid (escapes asyncio abstraction).

### 3. Ephemeral resources still alive

State with a lifetime *between* sessions that the resumed model needs to know about:

- **Subagent IDs** that can be continued — note what each agent has cached and what to ask it
- **Background processes** started this session (PIDs, purpose, when to clean up)
- **Temp files / scratch artifacts** not yet integrated
- **External state the user changed** (config flips, feature flags, env vars)
- **Open browser sessions / attached devices / tunnels**

### 4. User cognitive/emotional state at handoff point

- Energy level (fresh / tired / wired / fading)?
- Frustration / excitement / curiosity vector — and about what?
- Any unresolved emotional signal worth picking up next session
- Topics the user seemed to want to return to but didn't finish
- Mid-thought threads (the user was building toward something and didn't land it)

### 5. Self-confidence calibration on outputs

For each fix / change / claim shipped this session: confidence level + verification method. Format:

- **<artifact>**: SHIPPED + <how verified> + <residual unknown>

Example:

- **llm.py kill().wait() timeout fix**: SHIPPED + smoke-restart verified PID stable + production behavior under hang scenario UNVERIFIED until the next timeout occurs
- **LESSONS.md entry 7**: documentation only, no behavior change; high confidence

Don't let next-session-you treat unverified work as confirmed. Mark it explicitly.

### 6. Meta-framework state

- Mid-experiment? (e.g. "model-as-instrument: model reads harness source while introspecting its own context")
- Cross-session research threads
- Skills/tools the user is still building or evaluating
- Any "we're operating under method X" framing that should persist

### 7. One-line directive to the resumed model

End the file with a literal directive to the resumed model. Example:

> You (resumed me) should: continue directly in the established register — next step is Z by default. Don't perform "I'm continuing".

## After writing

Output the absolute path of the file created and a one-line summary of its contents. The user compacts next; the resumed session picks the handoff up from the path.
