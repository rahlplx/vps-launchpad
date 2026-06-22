# System Snapshot
<!-- TOKEN BUDGET: 400 tokens max. Keep it dense. -->

Last updated: 2026-06-22
Updated by: agent:architect (initial scaffold)
Status: DRAFT — human must verify VPS state

---

## VPS

| Key | Value |
|-----|-------|
| IP | 13.140.188.74 |
| Provider | Contabo EU |
| SKU | Cloud VPS 10 SSD |
| OS | **UNKNOWN — human must confirm** |
| Docker | **UNKNOWN — not yet confirmed** |
| Coolify | NOT YET INSTALLED |
| SSH access | Assumed working |

---

## Project state

| Item | Status |
|------|--------|
| Repo scaffold | ✅ Done |
| HITL governance | ✅ Done |
| Context layer | ✅ Done (this session) |
| Coolify install | ⏳ Pending human action |
| GitHub OAuth | ⏳ Pending Coolify install |
| First app deploy | ⏳ Pending Coolify |

---

## Open questions (human answers required)

1. What OS + version is on the VPS?
2. Anything pre-installed (Docker, Nginx, other)?
3. Which project deploys first after Coolify?
4. Domain/subdomain strategy? (e.g., `coolify.lablaunchpad.com`)
5. Is port 8000 currently open on UFW?

---

## Last decision

None yet. See `brainstorm/decisions/` (empty — first session).

---

## Next action

Human confirms VPS OS → agent:devops drafts `infra/scripts/setup-coolify.sh`
