# Retro Pipeline — Learn and Evolve

Automated retrospective system that closes the feedback loop: observe → act → reflect → evolve.

## How it works

### Collect (weekly, via GitHub Actions)
The `retro-collect.sh` script gathers:
- Git log (commits, PRs merged, PRs rejected)
- CI metrics (pass/fail rates, avg duration, flaky tests)
- Telemetry snapshots (resource trends, alerts fired)
- Incident sessions (any brainstorm/sessions/ tagged as incidents)

### Analyze (agent-generated)
Claude Code analyzes collected data and produces a retro session:
- What deployed successfully
- What broke and why
- Resource drift (are we approaching R07 ceiling?)
- HITL gate effectiveness (any AUTO actions that should be REVIEW?)

### Propose (REVIEW gate)
Findings become actionable proposals:
- Governance rule amendments → PR with `hitl:review`
- Script improvements → PR to `infra/scripts/`
- Resource limit tuning → PR to Docker compose files
- HITL gate recalibration → proposal in brainstorm/sessions/

### Evolve (human approves)
Human reviews proposals, merges what makes sense. The system gets smarter each cycle.

## Retro session output

Generated at: `brainstorm/sessions/YYYY-MM-DD-retro-week-NN.md`

```markdown
# Session: Weekly Retro — Week NN
Date: YYYY-MM-DD
Agent: agent:architect
Status: DRAFT

## Period: YYYY-MM-DD to YYYY-MM-DD

## Deployments
## Incidents
## Resource trends
## HITL gate review
## Proposals
## Decision (human fills this)
```
