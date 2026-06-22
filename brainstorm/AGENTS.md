# AGENTS.md — brainstorm/

> Low friction zone. Agents can write freely here. No HITL required for creation.
> Nothing in this folder is ever deployed directly.

## Permissions

```
🟢 AUTO  — Create new session files (sessions/YYYY-MM-DD-{topic}.md)
🟢 AUTO  — Add spike research, competitive analysis, rough plans
🟡 REVIEW — Promote anything to decisions/ (requires human sign-off)
🔴 BLOCK — Delete existing decision files
```

## File conventions

- `sessions/` — raw thinking, unfiltered, timestamped
- `decisions/` — locked choices, never revisited without a new session
- `spikes/` — time-boxed technical explorations (max 2h per spike)

## Session template

When creating a session file, agents must use this header:

```markdown
# Session: {topic}
Date: YYYY-MM-DD
Agent: {agent-id}
Status: DRAFT | DECIDED | ARCHIVED

## Context
## Options considered
## Recommendation
## Risks
## Decision (human fills this)
```

## What belongs here

- VPS architecture options
- Plugin evaluation (OSS vs build)
- Port strategy discussions  
- Cost/resource tradeoff analysis
- Coolify vs alternative stack debates
