# vps-launchpad

> Agentic engineering workspace for self-hosted infrastructure on Contabo VPS (13.140.188.74, EU).
> Platform-agnostic. AI-agnostic. Human-in-the-loop by default.

## What this repo is

A living system — not a static config dump. Every folder has its own `AGENTS.md` defining what agents can do there, what requires human approval, and what is fully automated. Governance rules enforce this boundary.

## Structure

```
vps-launchpad/
├── brainstorm/       # Raw thinking, decisions, spikes — no polish required
├── plugins/          # Coolify plugins, integrations, extension configs
├── ports/            # Port map, exposure rules, firewall intent
├── agents/           # Agent definitions, tools, HITL gates, evals
├── governance/       # Rules, policies, approval checklists
├── infra/            # Scripts, Docker configs, nginx, system setup
└── docs/             # Architecture decisions, runbooks, diagrams
```

## Core principles

1. **HITL by default** — agents propose, humans approve anything touching prod
2. **Agent-agnostic** — no vendor lock (Claude, GPT, Gemini, local — all valid)
3. **Platform-agnostic** — Coolify today, Dokku/k3s tomorrow — abstracted
4. **OSS-first** — self-hosted > SaaS, always audit before adding a dep
5. **Zero-cost ceiling** — Oracle Free Tier constraints honoured everywhere

## Quick nav

| Goal | Go to |
|------|-------|
| Brainstorm a new idea | `brainstorm/sessions/` |
| Add a plugin/integration | `plugins/` + its `AGENTS.md` |
| Map a new port | `ports/mappings/` |
| Define an agent tool | `agents/tools/` |
| Governance / approval | `governance/rules/` |
| Infra scripts | `infra/scripts/` |

## HITL gate legend (used across all AGENTS.md files)

| Symbol | Meaning |
|--------|---------|
| 🟢 AUTO | Agent executes without approval |
| 🟡 REVIEW | Agent drafts, human reviews before merge |
| 🔴 BLOCK | Agent cannot touch — human only |
