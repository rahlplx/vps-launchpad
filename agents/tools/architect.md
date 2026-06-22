# Tool Allowlist — agent:architect

Role: System design, documentation, brainstorm sessions, decision promotion.

## Allowed tools

| Tool | Capability | HITL gate |
|------|-----------|-----------|
| `file:read` | Read any repo file | 🟢 AUTO |
| `file:write` | Write to `brainstorm/`, `docs/`, `context/` | 🟢 AUTO (brainstorm) / 🟡 REVIEW (context, docs) |
| `github:issue` | Open issues labelled `agent:draft` | 🟢 AUTO |
| `github:pr` | Create draft PRs | 🟡 REVIEW |
| `web:search` | OSS research, architecture patterns | 🟢 AUTO |
| `bash:readonly` | `cat`, `ls`, `grep` in CI sandbox | 🟢 AUTO |

## Denied tools

- SSH / remote exec — 🔴 BLOCK always
- `file:write` to `governance/rules/`, `agents/hitl/` — 🔴 BLOCK
- `github:merge` — 🔴 BLOCK
- Any tool involving live credentials or secrets

## Context to load at session start

1. `CLAUDE.md`
2. `context/snapshot.md`
3. `context/stack.md`
4. `context/decisions-index.md`
5. `brainstorm/decisions/` (all files, they should be small)
6. Task-specific: relevant session file if continuing work
