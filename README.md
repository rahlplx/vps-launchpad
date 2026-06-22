# vps-launchpad

> Agentic engineering workspace for self-hosted infrastructure on Contabo VPS (13.140.188.74, EU).
> Platform-agnostic. AI-agnostic. Human-in-the-loop by default.

## What this repo is

A living system — not a static config dump. Every folder has its own `AGENTS.md` defining what agents can do there, what requires human approval, and what is fully automated. Governance rules enforce this boundary.

## Structure

```
vps-launchpad/
├── CLAUDE.md              # Session bootstrap — AI agents read this first
├── context/               # Compressed always-loaded state (snapshot, stack, decisions)
├── agents/
│   ├── hitl/              # HITL gate master definitions
│   ├── tools/             # Per-role tool allowlists (sub-agent isolation)
│   ├── memory/            # Session-init protocol + context budget policy
│   ├── prompts/           # Reusable templates (brainstorm, PR, handoff, spike)
│   └── evals/             # Baseline eval questions for agent regression testing
├── brainstorm/
│   ├── sessions/          # Raw thinking, timestamped
│   ├── decisions/         # Promoted locked decisions (human-approved)
│   └── spikes/            # Time-boxed technical explorations (max 2h)
├── governance/
│   ├── rules/             # Hard governance rules (R01–R08)
│   ├── policies/          # Operational policies (token efficiency, etc.)
│   └── checklists/        # PR and deploy checklists
├── docs/
│   ├── architecture/      # ADRs and system diagrams
│   └── runbooks/          # Human-executed operational procedures
├── infra/                 # Scripts, Docker configs, system setup (proposed, not executed)
├── plugins/               # Coolify plugins, integrations
└── ports/                 # Port map, exposure rules, firewall intent
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
| **Start a session (AI agent)** | `CLAUDE.md` → `context/snapshot.md` |
| Check current VPS state | `context/snapshot.md` |
| Check locked tech choices | `context/stack.md` |
| Check what's already decided | `context/decisions-index.md` |
| Brainstorm a new idea | `brainstorm/sessions/` (use `agents/prompts/brainstorm.md`) |
| Run a technical spike | `brainstorm/spikes/` (use `agents/prompts/spike.md`) |
| Promote a decision | `brainstorm/decisions/` via REVIEW PR |
| Add a plugin/integration | `plugins/` + its `AGENTS.md` |
| Map a new port | `ports/mappings/` |
| Infra scripts | `infra/scripts/` |
| Governance / approval | `governance/rules/` |
| Write a runbook | `docs/runbooks/` |
| Run agent evals | `agents/evals/baseline.md` |

## HITL gate legend (used across all AGENTS.md files)

| Symbol | Meaning |
|--------|---------|
| 🟢 AUTO | Agent executes without approval |
| 🟡 REVIEW | Agent drafts, human reviews before merge |
| 🔴 BLOCK | Agent cannot touch — human only |
