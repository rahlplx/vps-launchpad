# AGENTS.md — agents/

> Agent definitions, tool contracts, HITL gates, and evals.
> This is the agentic engineering core of the repo.

## Permissions

```
🟢 AUTO   — Add tools to agents/tools/ (drafts only)
🟢 AUTO   — Add eval questions to agents/evals/
🟡 REVIEW — Modify HITL gate definitions
🟡 REVIEW — Add a new agent role
🔴 BLOCK  — Grant any agent 🔴 BLOCK override
🔴 BLOCK  — Modify agents/hitl/gates.md without human sign-off
```

## Subfolders

| Folder | Purpose |
|--------|---------|
| `hitl/` | HITL gate definitions and approval workflows |
| `tools/` | Tool specs — what each agent can call |
| `memory/` | Persistent context patterns (not secrets) |
| `evals/` | Eval questions for testing agent effectiveness |

## Agent design principles

1. **Stateless by default** — agents read context fresh each session from `brainstorm/decisions/` and `governance/rules/`
2. **Tool-bounded** — each agent has an explicit tool allowlist in `tools/{agent-id}.md`
3. **Escalate, don't guess** — uncertain HITL classification → always 🔴 BLOCK
4. **Audit trail** — every agent action creates a file (brainstorm session, PR, or issue)
5. **Platform-agnostic** — tools defined by capability, not by provider API
