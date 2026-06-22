# Policy: Token Efficiency

> AI agents operate within finite context windows. This policy prevents context overflow,
> hallucination from truncated context, and wasted tokens on non-essential information.

---

## P-TOK-01: Context file size limits

| File | Hard limit | Rationale |
|------|-----------|-----------|
| `CLAUDE.md` | 600 tokens | Session bootstrap — always loaded |
| `context/snapshot.md` | 400 tokens | Always loaded |
| `context/stack.md` | 300 tokens | Always loaded |
| `context/decisions-index.md` | 500 tokens | Always loaded |
| Any `AGENTS.md` | 400 tokens | Loaded per-task |
| Governance rules (single rule) | 200 tokens | Loaded when relevant |

**Enforcement**: PR reviewer checks file size before merge.
**Measurement**: Approximate as 1 token ≈ 4 characters.

---

## P-TOK-02: Always-loaded context must not duplicate

Content in the 4 always-loaded context files (`CLAUDE.md`, `context/`) must be:
- Non-overlapping (no repeated facts)
- Linked, not embedded (reference file paths, don't paste content)
- Summaries only (index or pointer to full detail)

---

## P-TOK-03: Sub-agent context isolation

When invoking a sub-agent:
- Pass ONLY the sub-agent's tool spec + minimal task context
- Do NOT forward the parent agent's full context window
- Extract and compress relevant state into a handoff using `agents/prompts/handoff.md`

---

## P-TOK-04: Lazy loading

Agents MUST follow the load order in `agents/memory/session-init.md`.
Phase 4 files (lazy-load) must NOT be pre-loaded — only when directly needed.
Loading unnecessary files wastes tokens and can cause context overflow.

---

## P-TOK-05: Brainstorm session size

Brainstorm sessions have a recommended cap of 1500 tokens.
If a session exceeds this:
- Split into multiple sessions (link them)
- Archive completed sections to reduce active length
- Extract decisions to `brainstorm/decisions/`

---

## P-TOK-06: Context freshness over completeness

A stale snapshot is better than an overloaded context.
When context budget is tight:
1. Keep always-loaded files (Phase 1)
2. Drop governance files if not touching infra
3. Never drop `context/snapshot.md` — it prevents the worst hallucinations

---

## Rationale

Every token spent on redundant or stale context is a token not available for the task.
Context overflow causes silent truncation of early instructions, leading to:
- Agents ignoring HITL gates
- Agents re-debating locked decisions
- Agents hallucinating VPS state
This policy exists to prevent exactly those failure modes.
