# Context Budget Policy

> Token efficiency is a first-class concern. Context overflow causes truncation,
> hallucination, and loss of early-session instructions. Manage the budget actively.

---

## Budget allocation (per session, approximate)

| Layer | Budget | Notes |
|-------|--------|-------|
| Session bootstrap (CLAUDE.md + context/) | 2000 | Always consumed |
| Role + scope (tools/ + folder AGENTS.md) | 400 | Always consumed |
| Governance (rules + port map) | 800 | Load when touching infra |
| Task content (files being worked on) | 4000 | Main workspace |
| Response generation | 2000 | Agent output |
| **Safety buffer** | 1000 | Never fill completely |
| **Total safe budget** | ~10000 | Typical model context window usage |

---

## File size limits (enforced by policy)

| File | Max tokens | Enforcement |
|------|-----------|-------------|
| `CLAUDE.md` | 600 | Manual review on PR |
| `context/snapshot.md` | 400 | Manual review on PR |
| `context/stack.md` | 300 | Manual review on PR |
| `context/decisions-index.md` | 500 | Manual review on PR |
| Any `AGENTS.md` file | 400 | Manual review on PR |
| Brainstorm session | 1500 | Guideline, not enforced |
| Infra scripts | Unlimited | Code, not context |

---

## Anti-bloat rules

1. **AGENTS.md files are context, not documentation** — stay under 400 tokens
2. **decisions-index.md is an index** — one-liners only, link to full doc
3. **snapshot.md is a snapshot** — current state only, archive old state
4. **Do not paste code into context files** — link to the file instead
5. **Do not repeat information** across context files — DRY principle applies

---

## Sub-agent token isolation

When spawning a sub-agent, pass ONLY:
- The sub-agent's tool spec (`agents/tools/{role}.md`)
- The specific task input
- Minimal context from snapshot (paste relevant section, not full file)

Do NOT pass the full session context to sub-agents — they have their own budget.
