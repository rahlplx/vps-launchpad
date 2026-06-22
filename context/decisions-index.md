# Decisions Index
<!-- TOKEN BUDGET: 500 tokens max. One-liner per decision. Full detail in brainstorm/decisions/. -->

Last updated: 2026-06-22

> DO NOT re-debate items marked ✅ LOCKED.
> To revisit: open a new brainstorm session → promote to decisions/ → update this index.

---

## Architecture decisions

| ID | Decision | Status | Source |
|----|----------|--------|--------|
| AD-001 | Use Coolify as self-hosted PaaS (not Dokku, k3s, or bare compose) | ✅ LOCKED | `brainstorm/sessions/2026-06-22-vps-setup-strategy.md` |
| AD-002 | SvelteKit + FastAPI + PostgreSQL + KeyDB + Qdrant as app stack | ✅ LOCKED | `AGENTS.md` root |
| AD-003 | Traefik as reverse proxy (bundled with Coolify) | ✅ LOCKED | AD-001 implies |
| AD-004 | Langfuse for LLM observability | ✅ LOCKED | Port map |

## Governance decisions

| ID | Decision | Status | Source |
|----|----------|--------|--------|
| GD-001 | HITL-by-default: agents propose, humans approve prod actions | ✅ LOCKED | `agents/hitl/gates.md` |
| GD-002 | All PRs require exactly one `hitl:*` label | ✅ LOCKED | `governance/rules/core-rules.md` R02 |
| GD-003 | No direct push to main | ✅ LOCKED | R03 |
| GD-004 | New folders must include AGENTS.md | ✅ LOCKED | R04 |

## Infrastructure decisions

| ID | Decision | Status | Source |
|----|----------|--------|--------|
| ID-001 | 2GB swap file to buffer RAM spikes | 🟡 PROPOSED | `brainstorm/sessions/2026-06-22-vps-setup-strategy.md` |
| ID-002 | UFW: only 22, 80, 443, 8000 open publicly | 🟡 PROPOSED | Port map |
| ID-003 | Coolify UI (port 8000) → lock behind IP whitelist post-setup | 🟡 PROPOSED | Port map |

---

## Pending decisions (human input required)

- **PD-001**: VPS OS version → blocks Coolify install
- **PD-002**: Domain/subdomain strategy → blocks Traefik config
- **PD-003**: First app to deploy after Coolify → blocks app pipeline
