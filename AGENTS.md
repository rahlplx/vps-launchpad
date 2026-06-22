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

| Role | ID | Scope | Tool allowlist |
|------|----|-------|----------------|
| Architect | `agent:architect` | brainstorm/, docs/, context/, governance/ | `agents/tools/architect.md` |
| DevOps Agent | `agent:devops` | infra/, ports/, plugins/ | `agents/tools/devops.md` |
| Security Agent | `agent:security` | governance/policies/, ports/ | `agents/tools/security.md` |
| Eval Agent | `agent:eval` | agents/evals/ | `agents/tools/eval.md` |
| HITL Coordinator | `agent:hitl` | Cross-cutting — manages approval gates | Read-only across all |

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

Agent context resets between sessions. Follow `agents/memory/session-init.md` for load order.

Always read first (in order):
1. `CLAUDE.md` — session bootstrap and anti-hallucination rules
2. `context/snapshot.md` — current VPS and project state
3. `context/stack.md` — locked technology choices
4. `context/decisions-index.md` — what is already decided
5. `agents/tools/{your-role}.md` — your tool allowlist
6. The folder-level `AGENTS.md` for local scope

See `governance/policies/token-efficiency.md` for context budget policy.

---

## Escalation

If an agent is uncertain about HITL gate classification:
→ Default to 🔴 BLOCK
→ File an issue with label `hitl:needs-classification`
→ Do not proceed
