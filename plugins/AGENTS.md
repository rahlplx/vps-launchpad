# AGENTS.md — plugins/

> Integrations, Coolify plugins, and extension configs.
> Each plugin has its own subfolder with its own AGENTS.md.

## Permissions

```
🟢 AUTO   — Research and draft plugin configs
🟡 REVIEW — Add new plugin folder + config files
🟡 REVIEW — Modify existing plugin config
🔴 BLOCK  — Deploy plugin to prod (human triggers via Coolify UI or CLI)
🔴 BLOCK  — Store credentials or tokens in any plugin file
```

## Plugin folder structure (per plugin)

```
plugins/{name}/
├── AGENTS.md          # Local agent contract
├── README.md          # What this plugin does, why it exists
├── config.example.yml # Template — never the real values
├── install.sh         # Idempotent install script (agent-drafted, human-runs)
└── test.sh            # Smoke test after install
```

## Active plugins

| Plugin | Status | Purpose |
|--------|--------|---------|
| coolify | DRAFT | Core PaaS — Coolify install + config |
| github-oauth | DRAFT | GitHub OAuth for Coolify |
| monitoring | DRAFT | Lightweight resource monitoring |
| firewall | DRAFT | UFW rules management |

## Adding a new plugin

1. Agent creates folder + files (REVIEW gate)
2. Human reviews config.example.yml
3. Human fills real values in Coolify env or `.env` (never committed)
4. Human runs `install.sh`
5. Agent runs `test.sh` and logs result in brainstorm/sessions/
