# HITL Gates — Master Definition

> Human-in-the-Loop gate system for vps-launchpad.
> This file is 🔴 BLOCK — only human can modify after initial setup.

---

## Gate levels

### 🟢 AUTO
Agent executes without human approval.
- Reading any file in repo
- Writing to `brainstorm/sessions/`
- Opening a GitHub Issue (labelled `agent:draft`)
- Running read-only commands in sandboxed CI

### 🟡 REVIEW
Agent creates a PR. Human must approve and merge before action takes effect.
- Adding any file to `plugins/`, `ports/`, `infra/`, `governance/`
- Modifying existing configs
- Adding new agent tool definitions
- Dependency additions (`package.json`, `requirements.txt`, `Dockerfile`)

### 🔴 BLOCK
Agent proposes only. Human executes manually.
- SSH into prod VPS
- UFW rule changes
- Coolify UI actions (deploys, env vars, restarts)
- Database migrations
- GitHub OAuth App creation/modification
- Secrets and credentials — anywhere
- Modifying this file (`hitl/gates.md`)

---

## Approval workflow

```
Agent intent
    ↓
Log in brainstorm/sessions/ (AUTO)
    ↓
Create PR with gate label (🟡 REVIEW or 🔴 BLOCK)
    ↓
Human reviews PR
    ↓
  [🟡 REVIEW] → Human merges PR → Agent confirms
  [🔴 BLOCK]  → Human executes manually → Human closes issue
```

---

## PR labels (enforced by governance/rules/)

| Label | Meaning |
|-------|---------|
| `hitl:auto` | No approval needed — informational |
| `hitl:review` | Needs human review before merge |
| `hitl:block` | Human must execute — do not merge as action |
| `hitl:needs-classification` | Agent uncertain — human classifies |

---

## Escalation contacts

- Primary: Rahul (repo owner)
- Fallback: Open issue with `priority:urgent` label
