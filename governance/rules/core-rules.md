# Governance Rules — vps-launchpad

> Enforced constraints for all agents and contributors.
> Violations block PR merge via GitHub Actions (see .github/workflows/).

---

## R01 — No secrets in repo

**Rule**: Zero tolerance for credentials, tokens, API keys, passwords in any committed file.
**Enforcement**: `git-secrets` scan on every push + PR.
**Remediation**: Rotate immediately, rewrite git history, post incident in `brainstorm/sessions/`.

## R02 — HITL gate must be declared on every PR

**Rule**: Every PR must have exactly one `hitl:*` label.
**Enforcement**: GitHub Actions label-check workflow.
**Remediation**: PR blocked until labelled.

## R03 — No direct push to main

**Rule**: All changes via PR. Branch protection on `main`.
**Enforcement**: GitHub branch protection rules.
**Remediation**: Force-push blocked by GitHub.

## R04 — Agent files must have AGENTS.md

**Rule**: Every new folder created by an agent must include an `AGENTS.md`.
**Enforcement**: PR review checklist.
**Remediation**: PR fails review without it.

## R05 — Port changes require port map update

**Rule**: Opening or closing any port requires updating `ports/mappings/master-port-map.md` in the same PR.
**Enforcement**: Manual PR review.
**Remediation**: PR rejected without port map update.

## R06 — OSS-first

**Rule**: Before adding any paid SaaS dependency, a brainstorm session must exist in `brainstorm/sessions/` documenting OSS alternatives evaluated.
**Enforcement**: PR review checklist.
**Remediation**: PR blocked until session file linked.

## R07 — Oracle Free Tier hard ceiling

**Rule**: No infra change may push RAM beyond 20GB used (leaving 4GB headroom on 24GB).
**Enforcement**: Monitoring alert + manual review.
**Remediation**: Scale down or optimize before adding new service.

## R08 — Docker resource caps required

**Rule**: Every new Docker service must declare `mem_limit` and `cpus` in its compose config.
**Enforcement**: PR review checklist.
**Remediation**: PR blocked without resource declarations.
