# Session: VPS Setup Strategy — Coolify + GitHub OAuth + Resource Efficiency
Date: 2026-06-22
Agent: agent:architect
Status: DRAFT

---

## Context

Contabo EU VPS (13.140.188.74) — Cloud VPS 10 SSD. Instance: vmi3373425.
Goals: Deploy Coolify, connect GitHub via OAuth, maximize resource efficiency, establish monitoring.
OS: TBD (need human confirmation — assumed Ubuntu 22.04/24.04).

---

## Options considered

### A. Coolify (self-hosted PaaS)
- OSS, Docker-native, GitHub OAuth built-in
- Auto SSL, reverse proxy (Traefik), resource limits per app
- ✅ Best fit for current stack (SvelteKit + FastAPI)
- Risk: Coolify process itself consumes ~300–500MB RAM

### B. Dokku
- Lighter (~50MB overhead), Heroku-like
- Less GUI, more CLI — higher ops friction
- ❌ Weaker multi-app isolation

### C. Bare Docker Compose + Nginx
- Maximum control, zero overhead
- High maintenance burden, no GUI
- ❌ Defeats the self-hosted PaaS goal

### D. k3s (lightweight Kubernetes)
- Future-proof, production-grade
- Heavy learning curve, overkill for 1-dev team
- ❌ Not now — revisit at scale

---

## Recommendation

**Option A — Coolify**, with the following efficiency hardening:
1. Swap file (2GB) to buffer RAM spikes
2. Docker daemon config: set default resource limits
3. UFW firewall — close all except 22, 80, 443, 8000 (Coolify)
4. Coolify behind Traefik with rate limiting
5. Netdata or Glances for lightweight monitoring (no Prometheus overhead yet)

---

## Risks

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Coolify update breaks config | Medium | Pin Coolify version, backup before updates |
| RAM exhaustion under load | Medium | Swap + per-container limits |
| Port conflict with existing services | Low | Audit with `ss -tlnp` before install |
| GitHub OAuth token leak | Low | Store only in Coolify env, never in repo |

---

## Open questions for human

1. What OS + version is on the VPS right now?
2. Anything already installed (Docker, Nginx, etc.)?
3. Which project deploys first after Coolify is up?
4. Domain/subdomain strategy? (e.g., coolify.lablaunchpad.com)

---

## Decision
> _Human fills this after reviewing._
