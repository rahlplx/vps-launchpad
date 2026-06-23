# MCP SSH Manager — Claude Code ↔ Contabo VPS

Bridges Claude Code to the Contabo VPS (13.140.188.74) via [mcp-ssh-manager](https://github.com/bvisible/mcp-ssh-manager).

## What this enables

- Execute commands on VPS directly from Claude Code conversations
- File upload/download via SFTP
- Database operations (PostgreSQL dump/import)
- Health monitoring and log tailing
- Deployment automation

## 37 tools across 6 groups

| Group | Tools | HITL Gate |
|-------|-------|-----------|
| Core | list, execute, upload, download, sync | REVIEW |
| DevOps | deploy, sudo, tunnels, groups, aliases | BLOCK |
| Database | dump, import (PostgreSQL, KeyDB) | BLOCK |
| Monitoring | tail, health, resources | AUTO |
| Backup | snapshot, sync, restore | BLOCK |
| Security | host keys, profiles | BLOCK |

## Prerequisites

1. SSH key auth configured on VPS (no password auth)
2. Node.js 18+ on machine running Claude Code
3. Claude Code CLI or web environment with MCP support

## Setup

Run the install script or follow manual steps in `install.sh`.
