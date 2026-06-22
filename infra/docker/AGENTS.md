# AGENTS.md — infra/docker/

> Docker compose files for VPS services.

## Permissions

```
🟢 AUTO   — Read configs, research best practices
🟡 REVIEW — Add/modify compose files
🔴 BLOCK  — Deploy on VPS (docker compose up)
```

## Conventions

All services must include per R08:
```yaml
deploy:
  resources:
    limits:
      memory: {N}M
      cpus: '{n}'
```
