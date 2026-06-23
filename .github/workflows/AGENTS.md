# AGENTS.md — .github/workflows/

> CI/CD pipeline definitions. GitHub Actions workflows.

## Permissions

```
🟢 AUTO   — Read workflows, analyze CI results
🟡 REVIEW — Add/modify workflows
🔴 BLOCK  — Modify secrets, deploy triggers, or workflow permissions
```

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| hitl-governance.yml | PR events | Original HITL checks (label, secrets, AGENTS.md) |
| full-pipeline.yml | PR + push to main | Extended pipeline (shellcheck, R08, ports, telemetry) |
| retro-pipeline.yml | Weekly cron + manual | Automated retrospective data collection |
