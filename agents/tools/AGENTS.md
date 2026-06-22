# AGENTS.md — agents/tools/

> Tool allowlists per agent role. Agents MUST NOT use tools outside their allowlist.
> This is the primary sub-agent isolation boundary.

## Permissions

```
🟢 AUTO   — Read any tool spec
🟡 REVIEW — Add a new tool to an existing allowlist
🟡 REVIEW — Create a new agent tool spec
🔴 BLOCK  — Grant 🔴 BLOCK override to any tool
🔴 BLOCK  — Modify this AGENTS.md without human sign-off
```

## Sub-agent isolation rules

1. Each sub-agent receives ONLY its own tool spec file, not others'
2. Tool specs are the contract — if a tool isn't listed, the agent must escalate
3. Tool names are capability labels, not provider APIs (agent-agnostic)
4. When spawning a sub-agent: pass the relevant `tools/{agent-id}.md` as context
