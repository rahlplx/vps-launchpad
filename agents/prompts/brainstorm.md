# Template: Brainstorm Session

<!-- Copy this template to brainstorm/sessions/YYYY-MM-DD-{topic}.md -->
<!-- Fill all sections. "N/A" is valid. Never leave a section blank. -->

```markdown
# Session: {topic}
Date: YYYY-MM-DD
Agent: {agent-id}
Status: DRAFT

---

## Context

<!-- What problem are we solving? What triggered this session? -->
<!-- Reference relevant decisions from context/decisions-index.md -->
<!-- DO NOT repeat information already in context/snapshot.md — link to it -->

Related decisions: <!-- e.g., AD-001, GD-002 -->
Triggered by: <!-- issue #N, human request, or previous session -->

---

## Options considered

<!-- Minimum 2 options. Use this structure for each: -->

### A. {Option name}
- What it is: 
- Pros: 
- Cons: 
- Cost/resource impact: 
- Compatibility with stack.md: ✅/❌/⚠️

### B. {Option name}
- What it is:
- Pros:
- Cons:
- Cost/resource impact:
- Compatibility with stack.md: ✅/❌/⚠️

---

## Recommendation

**Option {X}** because:
- Reason 1
- Reason 2

HITL gate for this recommendation: 🟢/🟡/🔴

---

## Risks

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| | | |

---

## Open questions (human fills)

1. 
2. 

---

## Decision

> _Human fills this section after reviewing._
> Once filled, promote to `brainstorm/decisions/` via REVIEW PR.
> Update `context/decisions-index.md` with the decision ID.
```
