# AGENTS.md — agents/prompts/

> Reusable prompt templates for common agent operations.
> Templates prevent hallucination by standardising recurring actions.
> Agents MUST use these templates rather than ad-hoc prompts.

## Permissions

```
🟢 AUTO   — Use any template
🟢 AUTO   — Read any template
🟡 REVIEW — Add or modify a template
🔴 BLOCK  — Delete a template
```

## Templates

| File | Use when |
|------|----------|
| `brainstorm.md` | Starting a new brainstorm session |
| `pr-description.md` | Creating a PR |
| `handoff.md` | Handing off to sub-agent or next session |
| `spike.md` | Starting a time-boxed technical exploration |
