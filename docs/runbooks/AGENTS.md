# AGENTS.md — docs/runbooks/

> Step-by-step operational procedures for humans.
> Runbooks describe what humans do manually (🔴 BLOCK actions).

## Permissions

```
🟢 AUTO   — Read any runbook
🟡 REVIEW — Draft or update a runbook
🔴 BLOCK  — Execute a runbook (human only)
```

## Runbook naming

`RB-{NNN}-{slug}.md` — e.g., `RB-001-coolify-install.md`

## Runbook template

```markdown
# RB-{NNN}: {Title}
HITL: 🔴 BLOCK — Human executes
Last tested: YYYY-MM-DD

## Prerequisites
## Steps
1. 
2. 
## Expected outcome
## Rollback procedure
## Related scripts
```

## What belongs here vs infra/scripts/

- `infra/scripts/` = shell scripts that can be audited + run
- `docs/runbooks/` = human-readable procedures, including steps that can't be scripted
  (Coolify UI clicks, GitHub settings, DNS changes, etc.)
