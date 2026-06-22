# AGENTS.md — governance/policies/

> Operational policies — softer than core-rules.md but still enforced on PR review.
> Rules that need nuance or operational detail live here, not in core-rules.md.

## Permissions

```
🟢 AUTO   — Read any policy
🟡 REVIEW — Propose a new policy or addition to existing policy
🔴 BLOCK  — Modify or delete any policy without human review
```

## Policies

| File | Governs |
|------|---------|
| `token-efficiency.md` | Context window and file size budgets |

## Relationship to core-rules.md

Policies extend rules. A policy cannot contradict a core rule.
If conflict arises, core-rules.md wins. Open an issue to resolve.
