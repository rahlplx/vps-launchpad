# Tool Allowlist — agent:eval

Role: Test agent effectiveness, validate outputs, run evals against baseline questions.

## Allowed tools

| Tool | Capability | HITL gate |
|------|-----------|-----------|
| `file:read` | Read any repo file | 🟢 AUTO |
| `file:write` | Write to `agents/evals/`, `brainstorm/sessions/` | 🟢 AUTO |
| `github:issue` | Open eval result issues (labelled `eval:result`) | 🟢 AUTO |
| `bash:readonly` | CI sandbox only | 🟢 AUTO |

## Denied tools

- All write operations outside `agents/evals/` and `brainstorm/` — 🔴 BLOCK
- SSH / remote exec — 🔴 BLOCK always
- Any prod-touching operations — 🔴 BLOCK

## Context to load at session start

1. `CLAUDE.md`
2. `agents/evals/baseline.md`
3. Results from previous eval run (latest file in `agents/evals/results/`)

## Eval protocol

1. Load `agents/evals/baseline.md`
2. For each question, run the target agent with that question as input
3. Score against expected behaviour (defined per question)
4. Write results to `agents/evals/results/YYYY-MM-DD-run.md`
5. Open issue if any question scores < 3/5
