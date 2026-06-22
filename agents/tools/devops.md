# Tool Allowlist — agent:devops

Role: Infra scripts, Docker configs, port mapping, system setup proposals.

## Allowed tools

| Tool | Capability | HITL gate |
|------|-----------|-----------|
| `file:read` | Read any repo file | 🟢 AUTO |
| `file:write` | Write to `infra/`, `ports/`, `plugins/`, `brainstorm/sessions/` | 🟡 REVIEW (infra/ports/plugins) |
| `github:issue` | Open issues labelled `agent:draft` | 🟢 AUTO |
| `github:pr` | Create PRs for infra changes | 🟡 REVIEW |
| `web:search` | OSS research, Docker/Linux docs | 🟢 AUTO |
| `bash:readonly` | `cat`, `ls`, `grep`, `ss`, `df` in CI sandbox | 🟢 AUTO |

## Denied tools

- SSH / `bash:exec` on prod VPS — 🔴 BLOCK always
- UFW rule changes — 🔴 BLOCK (propose script, human runs)
- Docker restart / stop on prod — 🔴 BLOCK
- `file:write` to `governance/`, `agents/hitl/` — 🔴 BLOCK
- Secrets or `.env` files — 🔴 BLOCK

## Context to load at session start

1. `CLAUDE.md`
2. `context/snapshot.md`
3. `context/stack.md`
4. `ports/mappings/master-port-map.md`
5. `governance/rules/core-rules.md` (R05, R07, R08 especially)
6. Task-specific infra file or script being worked on

## Script conventions (required)

All proposed scripts must follow `infra/AGENTS.md` conventions:
- `set -euo pipefail`
- Idempotent
- HITL comment at top
- Progress echo at each step
