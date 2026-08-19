# Adapter: pi

Wiring for the [pi coding agent](https://github.com/badlogic/pi-mono). Nothing here changes component logic.

## Skills discovery

Pi implements the Agent Skills standard and scans several locations. Any of these works:

```bash
# per-component symlink into a scanned global dir (also visible to other harnesses that scan ~/.agents)
ln -s "$(pwd)/skills/track-project" ~/.agents/skills/track-project

# or point pi at this repo's skills tree wholesale, in ~/.pi/agent/settings.json
{ "skills": ["/path/to/this-repo/skills"] }
```

Directories containing a `SKILL.md` are discovered recursively; skills also register as `/skill:name` commands.

Invoke the discovered `workflow-setup` skill after wiring the suite. If the suite is referenced in place, its managed configuration edits land in this checkout; copy the component directories first if that is not desired.

## batch-hook enforcement point

Pi has no built-in stop-check hook, but its extension API observes the agent loop and can inject follow-up messages — which is the same contract. Sketch (verify event names against your pi version's `docs/extensions.md`):

```typescript
// batch-stop-gate.ts — run the gate predicate when the agent stops; re-prompt on refusal
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async (_event, ctx) => {
    const script = `${process.env.HOME}/.agents/skills/batch-hook/stop-gate.sh`;
    const { code, stderr } = await pi.exec("sh", [script]);
    if (code === 2) await ctx.sendUserMessage(stderr.trim());
  });
}
```

Start pi with `pi -e ./batch-stop-gate.ts` (or install it per pi's extensions documentation). The gate script is fail-open and sentinel-gated, so the extension is inert outside armed batches. `agent_end` can fire on runs pi auto-continues anyway; the extra message is redundant but harmless — use `agent_settled` if your version has it and you want exactly-once semantics.

## Environment variables

Pi inherits the shell environment; export the variables from `docs/CONFIGURATION.md` in your shell profile:

```bash
export PROJECT_CARDS_ROOT="/path/to/your/vault"
```
