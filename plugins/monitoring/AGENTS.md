# AGENTS.md — plugins/monitoring/

> Lightweight resource monitoring for the VPS.
> Goal: visibility without RAM overhead.

## Permissions
```
🟢 AUTO   — Research monitoring options, draft configs
🟡 REVIEW — Modify install.sh or docker-compose.yml
🔴 BLOCK  — Deploy to prod (human triggers)
```

## Decision

Netdata (Docker, ~150MB RAM) chosen over Prometheus+Grafana (~800MB combined).
Rationale in: brainstorm/sessions/2026-06-22-vps-setup-strategy.md
