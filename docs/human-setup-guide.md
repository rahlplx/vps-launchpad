# VPS Launchpad — Human Setup Guide

> This guide is for YOU (the human). Follow it step by step on your local machine and VPS.
> Never share credentials with AI agents, paste them in chat, or commit them to git.

---

## Phase 1: Contabo API Access

### What you're doing
Connecting to the Contabo REST API so you can manage your VPS programmatically — start/stop, snapshots, monitoring.

### Step 1.1 — Get your API credentials

1. Log in to **Contabo Customer Control Panel**: https://my.contabo.com
2. Click **"API"** in the left sidebar (blue section)
3. You'll see:
   - **Client ID** — copy it
   - **Client Secret** — copy it
4. Click **"Send Link"** to set your **API password** (different from your login password)
5. Check your email and set the API password

> **What these are:**
> - Client ID + Secret = OAuth2 app credentials (identifies your app)
> - API User = your Contabo login email
> - API Password = separate password just for API access

### Step 1.2 — Test the API works

Open a terminal and run:

```bash
# Get an access token
TOKEN=$(curl -s -X POST "https://auth.contabo.com/auth/realms/contabo/protocol/openid-connect/token" \
  -d "grant_type=password" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "username=YOUR_EMAIL" \
  -d "password=YOUR_API_PASSWORD" | jq -r '.access_token')

# List your VPS instances
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.contabo.com/v1/compute/instances" | jq '.data[] | {id, name, status, ipConfig}'
```

> **What you're learning:** OAuth2 client credentials flow. You exchange credentials for a short-lived token, then use that token for API calls. The token expires — you never store it permanently.

### Step 1.3 — Store credentials safely

On your **local machine** (not VPS, not in git):

```bash
# Create a local-only env file
cat > ~/.contabo-api.env << 'EOF'
CONTABO_CLIENT_ID=your_client_id_here
CONTABO_CLIENT_SECRET=your_client_secret_here
CONTABO_API_USER=your_email@example.com
CONTABO_API_PASSWORD=your_api_password_here
EOF

chmod 600 ~/.contabo-api.env
```

> **Why ~/.contabo-api.env?** It lives in your home directory, never inside the repo, and `chmod 600` means only your user can read it. The `.gitignore` already blocks `.env*` files.

---

## Phase 2: SSH Key Setup

### What you're doing
Creating a dedicated SSH key for Claude Code to connect to your VPS. Separate keys = separate revocation if compromised.

### Step 2.1 — Generate a dedicated key

```bash
# Generate ed25519 key (strongest, shortest)
ssh-keygen -t ed25519 -f ~/.ssh/contabo_vps -N "" -C "claude-code@vps-launchpad"
```

> **What you're learning:**
> - `-t ed25519` = modern elliptic curve algorithm (faster + more secure than RSA)
> - `-f ~/.ssh/contabo_vps` = custom filename so it doesn't overwrite your default key
> - `-N ""` = no passphrase (needed for automated access; the key file itself is the secret)
> - `-C "..."` = comment tag so you know what this key is for

### Step 2.2 — Copy public key to VPS

```bash
ssh-copy-id -i ~/.ssh/contabo_vps.pub root@13.140.188.74
```

Or manually:

```bash
# Show the public key
cat ~/.ssh/contabo_vps.pub

# SSH into VPS with your current method
ssh root@13.140.188.74

# Append to authorized_keys
echo "PASTE_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
```

> **What you're learning:** SSH key auth works in pairs. The **private key** (~/.ssh/contabo_vps) stays on your machine — never share it. The **public key** (.pub) goes on the server. When you connect, the server challenges your private key to prove you hold the matching pair.

### Step 2.3 — Test the connection

```bash
ssh -i ~/.ssh/contabo_vps root@13.140.188.74 "hostname && uptime"
```

Expected output: your VPS hostname and uptime.

### Step 2.4 — Harden SSH (recommended)

On the VPS, edit `/etc/ssh/sshd_config`:

```bash
# Disable password auth (key-only)
PasswordAuthentication no
PermitRootLogin prohibit-password

# Restart SSH
sudo systemctl restart sshd
```

> **What you're learning:** Disabling password auth means brute-force attacks on port 22 become useless. Only someone with your private key file can log in. This is standard hardening for any public-facing server.

---

## Phase 3: MCP SSH Manager for Claude Code

### What you're doing
Installing the bridge that lets Claude Code run commands on your VPS through the MCP protocol.

### Step 3.1 — Install the MCP server

On your **local machine**:

```bash
npm install -g @iflow-mcp/mcp-ssh-manager
```

> **What you're learning:** MCP (Model Context Protocol) is Anthropic's standard for AI tools to interact with external systems. An MCP server exposes "tools" (functions) that Claude Code can call. This one exposes SSH commands as tools.

### Step 3.2 — Register with Claude Code

```bash
claude mcp add contabo-vps -- npx @iflow-mcp/mcp-ssh-manager \
  --host 13.140.188.74 \
  --port 22 \
  --username root \
  --privateKey ~/.ssh/contabo_vps
```

> **What you're learning:** `claude mcp add` registers a named MCP server. When Claude Code starts, it launches this server process and gets access to its tools. The SSH key path is passed as a flag — the key itself stays on disk, not in any config file.

### Step 3.3 — Verify in Claude Code

Start a new Claude Code session and say:

```
List my SSH servers
```

You should see `contabo-vps` with 37 available tools.

### Step 3.4 — Tool groups and HITL mapping

| Group | Tools | Risk | Your HITL gate |
|-------|-------|------|----------------|
| **Core** | list, execute, upload, download, sync | Medium | Start with REVIEW |
| **Monitoring** | tail, health, resources | Low | Can be AUTO |
| **DevOps** | deploy, sudo, tunnels | High | Keep as BLOCK |
| **Database** | dump, import | High | Keep as BLOCK |
| **Backup** | snapshot, sync, restore | Medium | REVIEW |
| **Security** | host keys, profiles | High | BLOCK |

> **What you're learning:** Not all SSH tools are equal. "List files" is low risk; "sudo rm" is catastrophic. Map tool groups to HITL gates based on risk. You can always relax gates later — tightening after an incident is harder.

---

## Phase 4: Claude Code Environment Config

### What you're doing
Configuring Claude Code so it knows about your credentials without them ever touching git.

### Option A: Claude Code CLI (local)

```bash
# Set environment variables for Claude Code sessions
export CONTABO_CLIENT_ID=$(grep CLIENT_ID ~/.contabo-api.env | cut -d= -f2)
export CONTABO_CLIENT_SECRET=$(grep CLIENT_SECRET ~/.contabo-api.env | cut -d= -f2)
export CONTABO_API_USER=$(grep API_USER ~/.contabo-api.env | cut -d= -f2)
export CONTABO_API_PASSWORD=$(grep API_PASSWORD ~/.contabo-api.env | cut -d= -f2)
```

Or add to your shell profile (`~/.bashrc` or `~/.zshrc`):

```bash
# Load Contabo API credentials for Claude Code
[ -f ~/.contabo-api.env ] && export $(grep -v '^#' ~/.contabo-api.env | xargs)
```

### Option B: Claude Code Web Environment

When creating a web session at claude.ai/code:
1. Go to environment settings
2. Add environment variables:
   - `CONTABO_CLIENT_ID`
   - `CONTABO_CLIENT_SECRET`
   - `CONTABO_API_USER`
   - `CONTABO_API_PASSWORD`
3. These are encrypted and never visible in logs

> **What you're learning:** Environment variables are the standard way to pass secrets to applications. They exist only in memory during the session — not written to disk, not committed to git, not visible in process listings (on modern OSes).

---

## Phase 5: First VPS Management Session

### What you're doing
Using Claude Code + MCP SSH to manage your VPS for the first time.

### Test sequence (safe, read-only)

Start a Claude Code session and try these:

```
1. "Check my VPS disk usage"
   → Should run: df -h

2. "Show running Docker containers"
   → Should run: docker ps

3. "Check RAM usage"
   → Should run: free -h

4. "Show open ports"
   → Should run: ss -tlnp

5. "Check UFW firewall status"
   → Should run: sudo ufw status verbose
```

### First real action (after test)

```
"Deploy the observability stack from infra/docker/docker-compose.observability.yml"
```

This runs:
```bash
cd /opt/vps-launchpad
git pull origin main
docker compose -f infra/docker/docker-compose.observability.yml up -d
```

> **What you're learning:** Always start with read-only commands to verify the connection works. Then graduate to state-changing commands. This is the same principle behind HITL gates — observe before acting.

---

## Phase 6: Telemetry Verification

### After deploying the observability stack:

```bash
# On VPS — check services are running
docker ps | grep -E 'netdata|mlflow'

# Check Netdata
curl -s http://localhost:19999/api/v1/info | jq '.version'

# Check MLflow
curl -s http://localhost:5000/health

# Check RAM usage of observability stack
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}" | grep -E 'netdata|mlflow'
```

Expected: Netdata under 256MB, MLflow under 128MB.

> **What you're learning:** Always verify resource usage after deploying. Your R07 rule (20GB ceiling) means every megabyte counts. The `docker stats` command shows real-time container resource usage — bookmark it.

---

## Security Checklist

Before you start managing the VPS with Claude Code, verify:

- [ ] SSH key auth works (Phase 2.3)
- [ ] Password auth disabled on VPS (Phase 2.4)
- [ ] Contabo API credentials stored in `~/.contabo-api.env` with 600 permissions
- [ ] No credentials in any git-tracked file
- [ ] UFW firewall is active with only ports 22, 80, 443, 8000 open
- [ ] MCP SSH Manager registered with Claude Code (Phase 3.2)
- [ ] First read-only test completed (Phase 5)

---

## Glossary

| Term | What it means |
|------|--------------|
| **OAuth2** | Authentication protocol. You exchange credentials for a short-lived token. |
| **Bearer token** | The token you get from OAuth2. Include it in API request headers. |
| **ed25519** | Modern SSH key algorithm. Faster and more secure than RSA. |
| **MCP** | Model Context Protocol. Anthropic's standard for AI tool integration. |
| **HITL** | Human-in-the-Loop. A gate that requires human approval before action. |
| **R07** | Governance rule: RAM must stay under 20GB (4GB headroom on 24GB VPS). |
| **R08** | Governance rule: Every Docker service must declare memory and CPU limits. |
| **UFW** | Uncomplicated Firewall. Ubuntu's frontend for iptables. |
| **Idempotent** | Safe to run multiple times — same result every time. |
| **SQLite** | File-based database. No server process needed. Used by MLflow for traces. |
