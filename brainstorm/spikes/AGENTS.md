# AGENTS.md — brainstorm/spikes/

> Time-boxed technical explorations. Max 2 hours per spike.
> Spikes produce a recommendation, not an implementation.

## Permissions

```
🟢 AUTO   — Create a new spike file
🟢 AUTO   — Update status of own spike (IN-PROGRESS → COMPLETE)
🟡 REVIEW — Promote spike recommendation to a decision
🔴 BLOCK  — Delete a completed spike
```

## File naming

`YYYY-MM-DD-{topic}.md` — e.g., `2026-06-22-ollama-local-llm.md`

## When to create a spike

- Considering an alternative to a locked stack choice (required before proposing change)
- Evaluating a new OSS tool not yet in the stack
- Investigating a technical approach that's uncertain
- R06: before any paid SaaS addition

## Time-box enforcement

Spikes have a 2-hour limit. If the answer isn't clear in 2 hours:
- Mark status `ABANDONED` with a summary of what was learned
- Open a new spike with a narrower question
- Do NOT continue indefinitely

Use template: `agents/prompts/spike.md`
