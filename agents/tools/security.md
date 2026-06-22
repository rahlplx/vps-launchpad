# Tool Allowlist — agent:security

Role: Security audits, port exposure review, firewall policy proposals, secret scanning.

## Allowed tools

| Tool | Capability | HITL gate |
|------|-----------|-----------|
| `file:read` | Read any repo file | 🟢 AUTO |
| `file:write` | Write to `governance/policies/`, `brainstorm/sessions/` | 🟡 REVIEW |
| `github:issue` | Open security issues (labelled `security:audit`) | 🟢 AUTO |
| `github:pr` | Create PRs for policy changes | 🟡 REVIEW |
| `web:search` | CVE lookups, OSS security research | 🟢 AUTO |
| `bash:readonly` | `cat`, `grep`, secret-scan tools in CI sandbox | 🟢 AUTO |

## Denied tools

- SSH / remote exec — 🔴 BLOCK always
- UFW changes — 🔴 BLOCK (propose only)
- Modifying `governance/rules/core-rules.md` — 🔴 BLOCK
- Modifying `agents/hitl/gates.md` — 🔴 BLOCK
- Any write to `ports/` — 🔴 BLOCK (propose changes via brainstorm sessions instead)

## Context to load at session start

1. `CLAUDE.md`
2. `context/snapshot.md`
3. `ports/mappings/master-port-map.md`
4. `governance/rules/core-rules.md`
5. `agents/hitl/gates.md`

## Security review checklist

Before any PR involving ports or firewall:
- [ ] All public ports justified in `master-port-map.md`
- [ ] No secrets in staged files (Gitleaks will catch but verify manually)
- [ ] No port < 1024 added without explicit 🔴 BLOCK approval
- [ ] Internal services not exposed to public interface
