# Stack Lock — vps-launchpad
<!-- TOKEN BUDGET: 300 tokens max. Source of truth. DO NOT INFER. -->

Last updated: 2026-06-22
Locked by: Rahul (repo owner)

> These choices are LOCKED. Agents do NOT propose alternatives unless a spike
> exists in `brainstorm/spikes/` AND a human has promoted it to `brainstorm/decisions/`.

---

## Infrastructure

| Layer | Choice | Locked reason |
|-------|--------|---------------|
| PaaS | Coolify | OSS, Docker-native, GitHub OAuth built-in |
| Reverse proxy | Traefik (via Coolify) | Bundled, auto-SSL |
| OS | Ubuntu 22.04 or 24.04 | **TBC — human confirms** |
| VPS | Contabo EU 13.140.188.74 | Already provisioned |

## Application stack

| Layer | Choice | Notes |
|-------|--------|-------|
| Frontend | SvelteKit | Internal port 3000 |
| Backend | FastAPI | Internal port 8080 |
| Primary DB | PostgreSQL | Internal port 5432 (PgBouncer on 6432) |
| Cache / queue | KeyDB | Redis-compatible, internal port 6379 |
| Vector DB | Qdrant | Internal ports 6333 / 6334 |
| LLM observability | Langfuse | Internal port 4000 |

## Constraints

- RAM ceiling: 20GB used (4GB headroom on 24GB) — R07
- All containers: declare `mem_limit` + `cpus` — R08
- No paid SaaS without brainstorm session documenting OSS alternatives — R06
- Oracle Free Tier constraints honoured (zero-cost ceiling)
