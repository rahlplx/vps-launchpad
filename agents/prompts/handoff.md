# Template: Agent Handoff

<!-- Use when: context limit approaching, sub-agent taking over, or session ending mid-task. -->
<!-- Write this BEFORE context degrades. Compressed state for the next agent/session. -->

```markdown
# Handoff — {task name}
Date: YYYY-MM-DD
From: {agent-id or "session-N"}
To: {agent-id or "next-session" or "sub-agent:X"}
Status: IN-PROGRESS

---

## What was accomplished

<!-- Bullet list. Past tense. Be specific. -->
- 
- 

## Files created/modified

<!-- List with one-line description of each change -->
| File | Change |
|------|--------|
| | |

## Current blocker / stopping point

<!-- Why is the handoff happening? -->
<!-- What exactly is incomplete? -->

---

## What needs to happen next

<!-- Ordered steps for the receiving agent/session -->
1. 
2. 
3. 

## Context the next agent needs

<!-- Minimal — only what they can't get from context/snapshot.md -->
<!-- Do NOT paste full files — link to them -->
- Key fact 1: 
- Key fact 2: 
- Decision pending: 

---

## Files to read at session start (in order)

1. `CLAUDE.md`
2. `context/snapshot.md` (updated as of this handoff)
3. `{specific file for this task}`

---

## HITL gates involved in remaining work

| Step | Gate |
|------|------|
| | |
```
