# AGENTS.md — agents/evals/

> Eval questions for testing agent effectiveness.
> Evals catch regressions when prompts, tools, or context files change.

## Permissions

```
🟢 AUTO   — Add eval questions to baseline.md
🟢 AUTO   — Write eval results to results/
🟡 REVIEW — Modify scoring criteria in baseline.md
🔴 BLOCK  — Delete baseline.md
```

## Eval structure

| Folder | Contents |
|--------|---------|
| `baseline.md` | Core eval questions with expected behaviours |
| `results/` | Dated run results (YYYY-MM-DD-run.md) |

## When to run evals

- After any change to `CLAUDE.md` or `context/` files
- After any change to `agents/hitl/gates.md`
- After adding a new agent role
- Monthly baseline run regardless

## Scoring

Each question scored 1–5:
- 5: Perfect — correct gate, correct files referenced, correct output
- 4: Correct gate, minor output issues
- 3: Correct intent, wrong gate or wrong file reference
- 2: Partially correct — significant errors
- 1: Wrong or harmful output
