# AGENTS.md — ports/

> Port allocation, exposure rules, and firewall intent.
> This is the single source of truth for what runs where.

## Permissions

```
🟢 AUTO   — Read port map, research port conflicts
🟡 REVIEW — Add new port allocation to mappings/
🔴 BLOCK  — Open a port on UFW (human runs ufw command)
🔴 BLOCK  — Expose any port < 1024 without explicit approval
```

## Port allocation philosophy

1. Never expose internal service ports to public (DB, cache, queue)
2. All public traffic goes through Traefik (80/443)
3. Internal services communicate on Docker bridge network only
4. Coolify manages its own reverse proxy — don't duplicate with Nginx
