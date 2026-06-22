# PR Checklist

> Every PR to vps-launchpad must satisfy this checklist before merge.

## Mandatory (blocks merge if missing)

- [ ] Has exactly one `hitl:*` label
- [ ] No secrets, tokens, or credentials in any file
- [ ] New directories include `AGENTS.md`
- [ ] Port changes include update to `ports/mappings/master-port-map.md`
- [ ] New Docker services declare `mem_limit` and `cpus`
- [ ] Linked to a brainstorm session (paste path) if touching infra

## For agent-authored PRs

- [ ] PR description states: agent role + tool used + HITL gate rationale
- [ ] Intent was logged in `brainstorm/sessions/` before PR creation
- [ ] No direct SSH commands — scripts only, human executes

## For 🔴 BLOCK PRs (documentation of human intent)

- [ ] PR describes what human will execute manually
- [ ] Expected outcome documented
- [ ] Rollback plan documented
