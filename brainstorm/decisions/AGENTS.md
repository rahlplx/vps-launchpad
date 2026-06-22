# AGENTS.md — brainstorm/decisions/

> Promoted, locked decisions. Human-approved only.
> These are the source of truth for choices already made.

## Permissions

```
🟢 AUTO   — Read any decision file
🟡 REVIEW — Add a new decision file (promoted from sessions/)
🔴 BLOCK  — Modify or delete an existing decision file
🔴 BLOCK  — Demote a decision back to sessions/ without new brainstorm
```

## File naming

`DEC-{NNN}-{slug}.md` — e.g., `DEC-001-coolify-paas.md`

## Promotion process

1. Human fills "Decision" section in `brainstorm/sessions/{session}.md`
2. Agent:architect creates PR promoting to `decisions/DEC-NNN-{slug}.md`
3. PR labelled `hitl:review`
4. Human merges PR
5. Agent updates `context/decisions-index.md` in same or follow-up PR

## Decision file template

```markdown
# DEC-{NNN}: {Title}
Date decided: YYYY-MM-DD
Decided by: {human name}
Status: LOCKED

## Decision
{one paragraph}

## Context
{why this was decided}

## Source session
{brainstorm/sessions/YYYY-MM-DD-{topic}.md}

## What this locks out
{options that are now off the table}
```
