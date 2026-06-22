# AGENTS.md — Root

> This file defines the agentic contract for the entire `vps-launchpad` repo.
> Every subdirectory inherits these rules unless it overrides them in its own `AGENTS.md`.

---

## Identity

- **Repo**: vps-launchpad
- **Owner**: Rahul (Lab Launchpad)
- **VPS**: 13.140.188.74 (Contabo EU, Cloud VPS 10 SSD)
- **Stack lock**: SvelteKit + FastAPI + PostgreSQL + KeyDB + Qdrant + Coolify

---

## Agent roles

| Role | ID | Scope |
|------|----|-------|
| Architect | `agent:architect` | brainstorm/, docs/, governance/ |
| DevOps Agent | `agent:devops` | infra/, ports/, plugins/ |
| Security Agent | `agent:security` | governance/policies/, ports/exposed/ |
| Eval Agent | `agent:eval` | agents/evals/ |
| HITL Coordinator | `agent:hitl` | Cross-cutting — manages approval gates |

---

## HITL gates (global defaults)

```
🟢 AUTO   — Read operations, drafting files, adding to brainstorm/
🟡 REVIEW — Any new file in infra/, plugins/, ports/exposed/
🟡 REVIEW — Pull requests, dependency additions, config changes
🔴 BLOCK  — Direct SSH commands to prod VPS
🔴 BLOCK  — Firewall rule changes
🔴 BLOCK  — Database migrations on live data
🔴 BLOCK  — Secrets, env files, credentials — never in repo
```

---

## Governance hooks

Every agent action MUST:
1. Log intent in `brainstorm/sessions/YYYY-MM-DD-{topic}.md` before executing
2. Reference a governance rule from `governance/rules/` if touching infra
3. Create a REVIEW PR — never push directly to `main`
4. Tag the relevant HITL gate symbol in the PR description

---

## Tool contract

Agents may use:
- File read/write within repo (non-secret)
- GitHub API (PRs, issues, labels) via OAuth token in env
- Web search for OSS research
- Bash in sandboxed CI environment only

Agents may NOT use:
- Live SSH into VPS (propose scripts → human runs)
- External API calls with user credentials
- Write to `governance/` without a REVIEW-tagged PR

---

## Memory

Agent context resets between sessions. Always read:
1. `brainstorm/decisions/` for locked choices
2. `governance/rules/` for current constraints
3. The folder-level `AGENTS.md` for local scope

---

## Escalation

If an agent is uncertain about HITL gate classification:
→ Default to 🔴 BLOCK
→ File an issue with label `hitl:needs-classification`
→ Do not proceed
