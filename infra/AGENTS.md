# AGENTS.md — infra/

> Infrastructure scripts, Docker configs, system setup.
> Everything here is PROPOSED by agents, EXECUTED by humans.

## Permissions

```
🟢 AUTO   — Draft scripts, research best practices
🟡 REVIEW — Add/modify any script or docker config
🔴 BLOCK  — Execute any script on prod VPS
🔴 BLOCK  — Commit .env files or secrets
```

## Script conventions

All scripts must:
1. Start with `set -euo pipefail`
2. Be idempotent (safe to re-run)
3. Include a HITL comment at the top
4. Echo progress at each step
5. End with a clear "DONE" message and next steps

## Governance compliance

All Docker services must include (per R08):
```yaml
deploy:
  resources:
    limits:
      memory: {N}M
      cpus: '{n}'
```
