# Session: Full Autonomous Pipeline — MCP SSH + Telemetry + Retro + Evolution
Date: 2026-06-22
Agent: agent:architect
Status: DRAFT

---

## Context

Goal: Transform vps-launchpad from a static governance repo into a self-evolving autonomous pipeline. Claude Code manages the Contabo VPS (13.140.188.74) via MCP SSH Manager, with telemetry feeding into automated retrospectives that produce learnings, which feed back into improved governance rules and scripts.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code Session                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────────┐ │
│  │ MCP SSH  │  │ GitHub   │  │ Hooks    │  │ Skills     │ │
│  │ Manager  │  │ MCP      │  │ Engine   │  │ Auto-fire  │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └─────┬──────┘ │
└───────┼──────────────┼──────────────┼──────────────┼────────┘
        │              │              │              │
        ▼              ▼              ▼              ▼
┌──────────────┐ ┌──────────┐ ┌────────────┐ ┌────────────┐
│ Contabo VPS  │ │ GitHub   │ │ Telemetry  │ │ Retro      │
│ 13.140.188.74│ │ PRs/CI   │ │ Langfuse + │ │ Pipeline   │
│              │ │ Actions  │ │ Netdata    │ │ Learnings  │
└──────────────┘ └──────────┘ └────────────┘ └────────────┘
                                    │              │
                                    ▼              ▼
                              ┌──────────────────────┐
                              │   Evolution Engine    │
                              │ Rules update, script  │
                              │ improvement, gate     │
                              │ recalibration         │
                              └──────────────────────┘
```

## Pipeline stages

### Stage 1: Observe (Telemetry)
- Netdata on VPS → system metrics (RAM, CPU, disk, Docker) — 256MB cap
- MLflow → LLM/agent observability (traces, experiments, cost) — 128MB cap, SQLite backend
- GitHub Actions → CI/CD metrics (pass/fail, duration)
- All feed into `telemetry/snapshots/` as timestamped JSON
- Total observability RAM: ~384MB (vs Langfuse's 2GB+)

### Stage 2: Act (MCP SSH + Auto-triggers)
- Claude Code hooks detect events (PR created, CI failed, deploy requested)
- MCP SSH Manager executes commands on VPS when gate allows
- Auto-trigger matrix:
  - CI fail → auto-diagnose + fix PR
  - Deploy merged → run deploy script via SSH
  - RAM alert → auto-scale (stop low-priority containers)
  - New plugin PR → auto-run test.sh after merge

### Stage 3: Reflect (Retro pipeline)
- Weekly automated retro: what deployed, what broke, what drifted
- Pulls from: git log, CI history, telemetry snapshots, incident sessions
- Outputs: `brainstorm/sessions/YYYY-MM-DD-retro-week-NN.md`

### Stage 4: Evolve (Learning loop)
- Retro findings → governance rule proposals (REVIEW gate)
- Script improvements → infra/scripts/ PRs
- HITL gate recalibration → if AUTO action failed, escalate to REVIEW
- Resource limit tuning → update Docker compose caps based on actual usage

## Options considered

### A. Manual pipeline (current state)
- Human reads dashboards, decides what to do
- ❌ Slow, doesn't scale with complexity

### B. n8n workflow automation
- Visual workflow builder, runs on VPS
- ❌ Another service consuming RAM (R07), separate from Claude Code

### C. Claude Code hooks + MCP SSH + GitHub Actions (recommended)
- Everything lives in this repo
- Claude Code hooks auto-trigger on events
- GitHub Actions handle CI/CD
- MCP SSH Manager bridges to VPS
- ✅ Zero additional services beyond what's already planned

## Risks

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Runaway SSH commands | Medium | HITL gates + command allowlist |
| Telemetry data explosion | Low | Retention policy, max 30 days |
| Retro noise (too many findings) | Medium | Top-3 per week, human prioritizes |
| Evolution loop creates bad rules | Low | All rule changes are REVIEW gate |

## Decision
> _Human fills this after reviewing._
