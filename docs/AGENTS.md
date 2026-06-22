# AGENTS.md — docs/

> Architecture decisions, runbooks, and technical diagrams.
> Human-readable reference documentation for the system.

## Permissions

```
🟢 AUTO   — Read any doc
🟡 REVIEW — Add or modify any doc
🔴 BLOCK  — Delete any doc without archiving
```

## Subfolders

| Folder | Contents |
|--------|---------|
| `architecture/` | Architecture decision records (ADRs), system diagrams |
| `runbooks/` | Step-by-step ops procedures for humans |

## Docs vs brainstorm

- `brainstorm/` = raw thinking, in-progress, explorations
- `docs/` = settled, reviewed, polished reference material

Nothing goes to `docs/` until it's been decided (in `brainstorm/decisions/` or via a REVIEW PR).
