# Projects

Project-level planning memory. Path expresses membership, YAML expresses state, the body expresses continuity, and the views below render the dashboard.

> These views use [Obsidian Dataview](https://blacksmithgu.github.io/obsidian-dataview/) (DataviewJS enabled). The dashboard is optional — cards are plain markdown + YAML, and any tool that reads frontmatter (`grep`, `yq`, your agent) can query the same state. Replace `"PROJECTS_DIR"` below with your cards directory name relative to the vault root.

## Active

```dataviewjs
const touched = p => p.last_touched ?? p.file.mtime;
const pages = dv.pages('"PROJECTS_DIR"')
  .where(p => p.file?.path && app.vault.getAbstractFileByPath(p.file.path))
  .where(p => p.project && p.activity === "active" && p.phase !== "archived")
  .sort(p => touched(p), 'desc');
if (!pages.length) dv.el("div", "No active projects.");
else dv.table(["Project", "Type", "Phase", "Status", "Next Action"],
  pages.map(p => [p.file.link, p.type, p.phase, p.status_line ?? "—", p.next_action]));
```

## Building but not active

```dataviewjs
const touched = p => p.last_touched ?? p.file.mtime;
const pages = dv.pages('"PROJECTS_DIR"')
  .where(p => p.file?.path && app.vault.getAbstractFileByPath(p.file.path))
  .where(p => p.project && p.phase === "building" && p.activity !== "active")
  .sort(p => touched(p), 'desc');
if (!pages.length) dv.el("div", "—");
else dv.table(["Project", "Type", "Activity", "Last Touched", "Next Action"],
  pages.map(p => [p.file.link, p.type, p.activity, touched(p), p.next_action]));
```

## Blocked

```dataviewjs
const touched = p => p.last_touched ?? p.file.mtime;
const pages = dv.pages('"PROJECTS_DIR"')
  .where(p => p.file?.path && app.vault.getAbstractFileByPath(p.file.path))
  .where(p => p.project && p.blocked_by && dv.array(p.blocked_by).length > 0)
  .sort(p => touched(p), 'desc');
if (!pages.length) dv.el("div", "Nothing blocked.");
else dv.table(["Project", "Type", "Phase", "Blocked By", "Next Action"],
  pages.map(p => [p.file.link, p.type, p.phase, dv.array(p.blocked_by).join(", "), p.next_action]));
```

## Parked / Warm

```dataviewjs
const touched = p => p.last_touched ?? p.file.mtime;
const pages = dv.pages('"PROJECTS_DIR"')
  .where(p => p.file?.path && app.vault.getAbstractFileByPath(p.file.path))
  .where(p => p.project && (p.phase === "parked" || p.activity === "warm"))
  .sort(p => touched(p), 'desc');
if (!pages.length) dv.el("div", "—");
else dv.table(["Project", "Type", "Phase", "Activity", "Last Touched", "Next Action"],
  pages.map(p => [p.file.link, p.type, p.phase, p.activity, touched(p), p.next_action]));
```

## Archived

```dataviewjs
const pages = dv.pages('"PROJECTS_DIR"')
  .where(p => p.file?.path && app.vault.getAbstractFileByPath(p.file.path))
  .where(p => p.project && p.phase === "archived")
  .sort(p => p.archived_at, 'desc');
if (!pages.length) dv.el("div", "—");
else dv.table(["Project", "Type", "Archived", "Reason"],
  pages.map(p => [p.file.link, p.type, p.archived_at, p.archive_reason || "—"]));
```
