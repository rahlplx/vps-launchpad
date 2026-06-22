# AGENTS.md — governance/

> Rules, policies, and approval checklists.
> This folder is the highest-trust zone in the repo.

## Permissions

```
🟢 AUTO   — Read any governance file
🟡 REVIEW — Propose additions to policies/ or checklists/
🔴 BLOCK  — Modify rules/core-rules.md
🔴 BLOCK  — Modify agents/hitl/gates.md (cross-reference)
🔴 BLOCK  — Override any 🔴 BLOCK gate — not possible programmatically
```

## What lives here

| Folder | Contents |
|--------|----------|
| `rules/` | Hard governance rules (R01–R0N) |
| `policies/` | Softer operational policies |
| `checklists/` | PR and deploy checklists |
