# AGENTS.md — agents/memory/

> Context management protocols. Agents reference these to avoid context overflow,
> session amnesia, and hallucination from stale or missing context.

## Permissions

```
🟢 AUTO   — Read any file here
🟡 REVIEW — Modify context-budget.md or session-init.md
🔴 BLOCK  — Delete any file here
```

## Core memory principle

Agent context resets every session. Memory in this repo is FILE-BASED, not model-memory.
Files are the only reliable persistent state. If it's not in a file, it's lost.

## Files

| File | Purpose |
|------|---------|
| `session-init.md` | Ordered protocol for what to read at session start |
| `context-budget.md` | Token budget policy and overflow prevention |
