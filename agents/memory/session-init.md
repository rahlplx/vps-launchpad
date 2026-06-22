# Session Initialization Protocol

> Load files in this exact order at the start of every agent session.
> Stop loading if context budget is exceeded — lazy-load remaining files only when needed.

---

## Phase 1 — Always load (bootstrap, ~2000 tokens)

```
1. CLAUDE.md                          (~600 tokens)
2. context/snapshot.md                (~400 tokens)
3. context/stack.md                   (~300 tokens)
4. context/decisions-index.md         (~500 tokens)
```

After Phase 1: you know the current state, locked stack, and decided options.
You can answer most questions without loading more.

---

## Phase 2 — Load for your role (~200–800 tokens)

```
5. agents/tools/{your-role}.md        (~200 tokens)
6. Folder AGENTS.md for task scope    (~200 tokens)
```

---

## Phase 3 — Load when touching infra/governance (~800 tokens)

```
7. governance/rules/core-rules.md     (~500 tokens)
8. ports/mappings/master-port-map.md  (~300 tokens)
```

---

## Phase 4 — Lazy load (only when directly needed)

```
9.  brainstorm/sessions/{relevant session}   — only if continuing specific work
10. infra/scripts/{specific script}          — only if modifying that script
11. plugins/{specific plugin}/               — only if working on that plugin
12. agents/evals/baseline.md                 — only for eval agent
```

---

## Context overflow protocol

If you approach context limit mid-task:
1. Summarise completed work into `brainstorm/sessions/` (AUTO)
2. Create handoff using `agents/prompts/handoff.md`
3. Update `context/snapshot.md` with current status
4. The NEXT session picks up from `context/snapshot.md`

---

## Anti-amnesia checklist

Before ending any session with incomplete work:
- [ ] Intent logged in `brainstorm/sessions/`
- [ ] `context/snapshot.md` updated with new status
- [ ] Any decisions promoted to `brainstorm/decisions/` (via REVIEW PR)
- [ ] Handoff note written if sub-agent continues
