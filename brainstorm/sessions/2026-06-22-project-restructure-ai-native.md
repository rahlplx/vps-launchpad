# Session: AI-Native Project Restructure
Date: 2026-06-22
Agent: agent:architect
Status: COMPLETE

---

## Context

Initial scaffold existed (brainstorm/, agents/hitl/, governance/, infra/, plugins/, ports/).
Problem: no AI-native context layer → agents hallucinate state, re-debate locked decisions,
lose context between sessions, and sub-agents bleed scope.

Triggered by: user request to add "vibe coding and agentic engineering docs for ai agents
so that no hallucination, context issues, memory issues, agent/sub-agents issues."

---

## Options considered

### A. Add CLAUDE.md only (minimal)
- Pros: Low friction, quick
- Cons: Doesn't solve sub-agent isolation, memory, or token efficiency

### B. Full AI-native layer (chosen)
- Add `CLAUDE.md` as session bootstrap
- Add `context/` folder with compressed always-loaded state
- Add `agents/tools/` with per-role tool allowlists
- Add `agents/memory/` with session-init and context budget protocols
- Add `agents/prompts/` with reusable templates
- Add `agents/evals/` with baseline eval questions
- Add `brainstorm/decisions/` and `brainstorm/spikes/` subfolders
- Add `governance/policies/` with token efficiency policy
- Add `docs/` with architecture and runbook subfolders
- Pros: Comprehensive, solves all identified failure modes
- Cons: More files to maintain, initial setup cost

---

## Recommendation

**Option B** — the failure modes (hallucination, session amnesia, sub-agent scope bleed,
context overflow) require a systematic solution. One-off fixes won't hold.

HITL gate: 🟡 REVIEW (adding files to multiple folders)

---

## Problems solved by this restructure

| Problem | Solution |
|---------|----------|
| Hallucination of VPS state | `context/snapshot.md` — single source of truth |
| Re-debating locked decisions | `context/decisions-index.md` + DO NOT re-debate guard |
| Session amnesia | `agents/memory/session-init.md` — ordered read protocol |
| Context overflow | `governance/policies/token-efficiency.md` — budgets |
| Sub-agent scope bleed | `agents/tools/{role}.md` — per-role allowlists |
| Hallucination of stack choices | `context/stack.md` — locked, authoritative |
| Ad-hoc PR descriptions | `agents/prompts/pr-description.md` — template |
| No handoff between sessions | `agents/prompts/handoff.md` — template |
| No regression testing for agents | `agents/evals/baseline.md` — 8 baseline evals |
| Brainstorm without decisions | `brainstorm/decisions/` — promotion path |
| Technical uncertainty handled poorly | `brainstorm/spikes/` — time-boxed exploration |

---

## Risks

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Context files become stale | Medium | Freshness rule in context/AGENTS.md |
| Token budgets ignored | Low | Policy + PR checklist enforcement |
| Too many files to maintain | Low | Most are templates or stable reference |

---

## Decision

> _Human: this restructure was applied in one session. Reviewing AGENTS.md updates
>  and new context/ files. Merge PR if satisfied._
