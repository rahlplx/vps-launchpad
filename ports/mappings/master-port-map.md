# Port Map — vps-launchpad (13.140.188.74)

> Last updated: 2026-06-22
> Agent: agent:devops | Status: DRAFT — human review required

---

## Public (UFW open, Traefik routes)

| Port | Protocol | Service | Status | Notes |
|------|----------|---------|--------|-------|
| 22 | TCP | SSH | 🟢 OPEN | Restrict to known IPs when possible |
| 80 | TCP | HTTP → redirect | 🟢 OPEN | Traefik redirects to 443 |
| 443 | TCP | HTTPS (Traefik) | 🟢 OPEN | All apps behind this |
| 8000 | TCP | Coolify UI | 🟡 TEMP | Lock behind VPN/IP whitelist after setup |

---

## Internal (Docker bridge only — NOT exposed to public)

| Port | Service | Container | Notes |
|------|---------|-----------|-------|
| 5432 | PostgreSQL | postgres | PgBouncer on 6432 |
| 6432 | PgBouncer | pgbouncer | App connects here |
| 6379 | KeyDB | keydb | Redis-compatible |
| 6333 | Qdrant HTTP | qdrant | Vector DB |
| 6334 | Qdrant gRPC | qdrant | |
| 8080 | FastAPI | api | Behind Traefik |
| 3000 | SvelteKit | frontend | Behind Traefik |
| 4000 | Langfuse | langfuse | Observability |

---

| 5000 | MLflow | mlflow | LLM/agent observability (SQLite) |
| 8500 | Reserved | — | Was Evidently, now available |

---

## Reserved (future use)

| Port | Intended Service | Notes |
|------|-----------------|-------|
| 9000 | Monitoring (Netdata/Glances) | Internal only |
| 11434 | Ollama | Internal only — if local LLM added |

---

## Rules

1. Adding to internal table → 🟡 REVIEW PR
2. Adding to public table → 🔴 BLOCK → human approves + runs UFW command
3. Any port below 1024 → 🔴 BLOCK always
