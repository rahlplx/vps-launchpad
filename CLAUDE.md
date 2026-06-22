# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

An agentic engineering workspace for self-hosted infrastructure on a Contabo VPS (13.140.188.74, EU). Not a deployable application — it's a living system of scripts, configs, runbooks, and governance rules managed through Human-in-the-Loop (HITL) gates.

**Stack lock:** SvelteKit + FastAPI + PostgreSQL + KeyDB + Qdrant + Coolify

## HITL gate system (critical)

Every action in this repo is governed by HITL gates. Agents must respect these:

- **AUTO** — agent executes freely (reading files, writing to `brainstorm/sessions/`)
- **REVIEW** — agent creates a PR with `hitl:review` label; human merges
- **BLOCK** — agent proposes only; human executes (SSH, UFW, deploys, secrets, DB migrations)

When uncertain about gate level, default to BLOCK. See `agents/hitl/gates.md` for the full matrix.

Every PR must carry exactly one `hitl:` label (`hitl:auto`, `hitl:review`, `hitl:block`, `hitl:needs-classification`). CI enforces this via `.github/workflows/hitl-governance.yml`.

## CI checks on every PR

Two workflows run on PRs (`.github/workflows/`):

**hitl-governance.yml** (original):
1. **HITL label required** — exactly one `hitl:*` label must be present
2. **Gitleaks secrets scan** — blocks any committed credentials
3. **AGENTS.md check** — every new directory must contain an `AGENTS.md`

**full-pipeline.yml** (extended):
4. **ShellCheck** — lints all `.sh` scripts
5. **Docker compose validation** — verifies R08 resource limits on all compose files
6. **Port map consistency** — warns if compose/firewall changes lack port map update (R05)
7. **Pipeline telemetry** — collects CI metrics as JSON snapshots

## Governance rules (governance/rules/core-rules.md)

Key rules that affect development:
- **R07**: RAM hard ceiling — no change may push VPS beyond 20GB used (24GB total, 4GB headroom)
- **R08**: Every Docker service must declare `mem_limit` and `cpus` in compose config
- **R06**: Before adding any paid SaaS, a brainstorm session documenting OSS alternatives must exist
- **R05**: Port changes require updating `ports/mappings/master-port-map.md` in the same PR

## Directory contracts

Each directory has its own `AGENTS.md` that overrides or extends root-level permissions. Always read the local `AGENTS.md` before modifying files in a directory.

| Directory | Purpose | Gate default |
|-----------|---------|-------------|
| `brainstorm/sessions/` | Raw thinking, spikes, research | AUTO (create), REVIEW (promote to decisions/) |
| `infra/scripts/` | System scripts, Docker configs | REVIEW (draft), BLOCK (execute on VPS) |
| `plugins/{name}/` | Coolify plugins, integrations | REVIEW (config), BLOCK (deploy) |
| `ports/mappings/` | Port allocation truth table | REVIEW (internal), BLOCK (public/UFW) |
| `governance/` | Rules, policies, checklists | REVIEW (via PR), BLOCK (modify agents/hitl/gates.md) |
| `plugins/mcp-ssh/` | MCP SSH Manager for VPS access | REVIEW (config), BLOCK (install, SSH credentials) |
| `plugins/telemetry/` | Netdata + MLflow observability | REVIEW (config), BLOCK (deploy on VPS) |
| `plugins/retro/` | Weekly retro + evolution pipeline | AUTO (generate retro), REVIEW (propose rule changes) |
| `infra/docker/` | Docker compose files for VPS | REVIEW (modify), BLOCK (deploy) |

## Conventions

**Scripts** (`infra/scripts/`, `plugins/*/install.sh`):
- Must start with `set -euo pipefail`
- Must be idempotent (safe to re-run)
- Must include a HITL gate comment at the top (e.g., `# HITL: 🔴 BLOCK`)
- Must echo progress at each step and end with a DONE message

**Brainstorm sessions** (`brainstorm/sessions/`):
- Filename: `YYYY-MM-DD-{topic}.md`
- Required header fields: topic, date, agent ID, status (DRAFT/DECIDED/ARCHIVED)
- Must include: Context, Options considered, Recommendation, Risks, Decision (human fills)

**Docker compose files**:
- Must include resource limits per R08: `deploy.resources.limits.memory` and `deploy.resources.limits.cpus` (or `mem_limit` and `cpus` shorthand)

**Plugin folders** must contain: `AGENTS.md`, `README.md`, `config.example.yml`, `install.sh`, `test.sh`

## Agent workflow

1. Log intent in `brainstorm/sessions/` before executing
2. Reference a governance rule from `governance/rules/` if touching infra
3. Create a REVIEW PR — never push directly to `main`
4. Tag the relevant HITL gate symbol in the PR description

## Autonomous pipeline

The repo implements a self-evolving feedback loop:

```
Observe (Netdata + MLflow + CI metrics)
  → Act (MCP SSH + Claude Code hooks)
    → Reflect (weekly retro → brainstorm/sessions/)
      → Evolve (governance proposals → REVIEW PR)
```

- **MCP SSH Manager** (`plugins/mcp-ssh/`): 37 tools bridging Claude Code to VPS via SSH
- **Telemetry** (`plugins/telemetry/`): Netdata (256MB) + MLflow (128MB, SQLite) = ~384MB total
- **Retro pipeline** (`plugins/retro/`): Weekly automated retro via GitHub Actions cron, max 3 proposals per cycle
- **Evolution**: Retro findings become governance rule PRs (always REVIEW gate)

## Port map

The single source of truth for port allocation is `ports/mappings/master-port-map.md`. Public ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 8000 (Coolify, temporary). All internal services (PostgreSQL 5432, PgBouncer 6432, KeyDB 6379, Qdrant 6333/6334, FastAPI 8080, SvelteKit 3000, MLflow 5000) stay on Docker bridge network only.
