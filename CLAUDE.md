# CLAUDE.md — vps-launchpad Session Bootstrap

> Read this first. Every session. No exceptions.
> Token budget for this file: ≤ 600 tokens.

---

## What this repo is

Agentic engineering workspace for self-hosted VPS infrastructure.
VPS: `13.140.188.74` (Contabo EU, Cloud VPS 10 SSD) | Owner: Rahul

---

## Session start — read in this order

1. `context/snapshot.md` — current VPS state, open questions, last decision
2. `context/stack.md` — locked tech choices (DO NOT propose alternatives without a spike)
3. `context/decisions-index.md` — what is already decided (DO NOT re-debate)
4. Folder-level `AGENTS.md` — your scope for THIS task
5. `governance/rules/core-rules.md` — hard constraints (non-negotiable)

---

## Your role this session

Check which folder/task you're working in → use the matching role from `AGENTS.md` root:

| Task area | Role | Tool allowlist |
|-----------|------|----------------|
| Architecture / docs | `agent:architect` | `agents/tools/architect.md` |
| Infra / scripts / docker | `agent:devops` | `agents/tools/devops.md` |
| Security / ports / firewall | `agent:security` | `agents/tools/security.md` |
| Evals / testing | `agent:eval` | `agents/tools/eval.md` |

---

## HITL gate quickref

```
🟢 AUTO   → execute (read, draft, brainstorm/sessions/)
🟡 REVIEW → open PR, do NOT merge yourself
🔴 BLOCK  → write proposal only, human executes
```

Full gate definitions: `agents/hitl/gates.md`

---

## Anti-hallucination rules (enforce every session)

1. **Never infer tech stack** — only `context/stack.md` is authoritative
2. **Never re-propose decided options** — check `context/decisions-index.md` first
3. **Never guess VPS state** — only `context/snapshot.md` is authoritative
4. **Never commit secrets** — R01 in `governance/rules/core-rules.md`
5. **Never push to main** — R03, always PR
6. **When uncertain about HITL** → default 🔴 BLOCK, open issue `hitl:needs-classification`

---

## Before acting on any infra task

Log intent in `brainstorm/sessions/YYYY-MM-DD-{topic}.md` (🟢 AUTO).
Use template: `agents/prompts/brainstorm.md`.

---

## Context budget (per session)

| Layer | Max tokens to load | When to load |
|-------|--------------------|--------------|
| Bootstrap (this file) | 600 | Always |
| context/snapshot.md | 400 | Always |
| context/stack.md | 300 | Always |
| context/decisions-index.md | 500 | Always |
| Folder AGENTS.md | 200 | Per task |
| governance/rules/ | 800 | When touching infra |
| Full file content | As needed | Lazy-load only |

Total reserved budget: ~2800 tokens. Remaining window: use for actual task.

---

## Handoff protocol

If completing work a sub-agent or next session must continue:
→ Use template `agents/prompts/handoff.md` to compress state.
→ Update `context/snapshot.md` with current status.
