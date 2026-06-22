# AGENTS.md — context/

> Compressed, always-loaded system state. Every agent reads this folder at session start.
> Files here must stay under their token budgets — enforced by policy in governance/policies/token-efficiency.md.

## Permissions

```
🟢 AUTO   — Read any file here
🟡 REVIEW — Update snapshot.md or decisions-index.md (human verifies state is accurate)
🔴 BLOCK  — Delete any file here
🔴 BLOCK  — Exceed token budgets defined per file
```

## Files

| File | Max tokens | Updated by | Purpose |
|------|-----------|------------|---------|
| `snapshot.md` | 400 | Human (after decisions) | Current VPS/project state |
| `stack.md` | 300 | Human only | Locked tech choices |
| `decisions-index.md` | 500 | Agent:architect (REVIEW PR) | Compressed decision log |

## Freshness rule

If `snapshot.md` is more than 7 days old and a prod action is being proposed,
the agent MUST flag staleness and request a human update before proceeding.
