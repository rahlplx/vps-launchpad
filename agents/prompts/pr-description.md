# Template: PR Description

<!-- Use this for ALL agent-authored PRs. Fill every section. -->

```markdown
## Agent PR — {brief title}

**Agent role**: {agent:architect | agent:devops | agent:security | agent:eval}
**HITL gate**: {🟢 hitl:auto | 🟡 hitl:review | 🔴 hitl:block}
**Brainstorm session**: {path to session file, or N/A}

---

## What this PR does

<!-- 2-3 sentences max. What changed and why. -->

---

## HITL gate rationale

<!-- Why this specific gate level? -->
<!-- If 🟡 REVIEW: what specifically needs human eyes? -->
<!-- If 🔴 BLOCK: what must the human execute manually? -->

---

## Checklist

- [ ] Exactly one `hitl:*` label applied
- [ ] No secrets or credentials in any file
- [ ] New directories include `AGENTS.md`
- [ ] Port changes → `ports/mappings/master-port-map.md` updated in same PR
- [ ] New Docker services declare `mem_limit` and `cpus`
- [ ] Brainstorm session linked (if touching infra)
- [ ] Agent role + tools used documented above
- [ ] Intent logged in `brainstorm/sessions/` before this PR

---

## If 🔴 BLOCK — human execution steps

<!-- Document exactly what the human needs to do manually. -->
<!-- Include expected output and rollback plan. -->

**Steps:**
1. 
2. 

**Expected outcome:**

**Rollback plan:**

---

## Governance rules touched

<!-- List any core-rules.md rules this PR relates to -->
<!-- e.g., R05 (port map update), R08 (Docker resource caps) -->
```
