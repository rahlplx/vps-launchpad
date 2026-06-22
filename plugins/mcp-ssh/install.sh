#!/bin/bash
# install.sh — MCP SSH Manager setup for Claude Code
# HITL: 🔴 BLOCK — Human runs this on their local machine (not on VPS).
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== MCP SSH Manager — Setup for Claude Code ==="
echo ""

# --- Step 1: Check prerequisites ---
echo "=== [1/5] Checking prerequisites ==="

if ! command -v node &>/dev/null; then
  echo "❌ Node.js not found. Install Node.js 18+ first."
  echo "   https://nodejs.org/"
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo "❌ Node.js $NODE_VERSION found, need 18+."
  exit 1
fi
echo "✅ Node.js $(node -v)"

if ! command -v claude &>/dev/null; then
  echo "⚠️  Claude Code CLI not found in PATH."
  echo "   Install: npm install -g @anthropic-ai/claude-code"
  echo "   Or use the web version at claude.ai/code"
fi

# --- Step 2: Install MCP SSH Manager ---
echo ""
echo "=== [2/5] Installing MCP SSH Manager ==="
npm install -g @iflow-mcp/mcp-ssh-manager
echo "✅ MCP SSH Manager installed"

# --- Step 3: Generate SSH key (if not exists) ---
echo ""
echo "=== [3/5] SSH key setup ==="
SSH_KEY="$HOME/.ssh/contabo_vps"
if [ -f "$SSH_KEY" ]; then
  echo "✅ SSH key already exists: $SSH_KEY"
else
  echo "Generating SSH key for Contabo VPS..."
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "claude-code@vps-launchpad"
  echo "✅ SSH key generated: $SSH_KEY"
  echo ""
  echo "⚠️  MANUAL STEP REQUIRED:"
  echo "   Copy the public key to your VPS:"
  echo "   ssh-copy-id -i ${SSH_KEY}.pub root@13.140.188.74"
  echo ""
  echo "   Or manually append to /root/.ssh/authorized_keys on the VPS"
fi

# --- Step 4: Register MCP server with Claude Code ---
echo ""
echo "=== [4/5] Registering MCP server with Claude Code ==="
if command -v claude &>/dev/null; then
  claude mcp add contabo-vps -- npx @iflow-mcp/mcp-ssh-manager \
    --host 13.140.188.74 \
    --port 22 \
    --username root \
    --privateKey "$SSH_KEY"
  echo "✅ MCP server 'contabo-vps' registered with Claude Code"
else
  echo "⚠️  Claude Code CLI not available. Add manually:"
  echo ""
  echo '   claude mcp add contabo-vps -- npx @iflow-mcp/mcp-ssh-manager \'
  echo '     --host 13.140.188.74 \'
  echo '     --port 22 \'
  echo '     --username root \'
  echo "     --privateKey $SSH_KEY"
fi

# --- Step 5: Verify connection ---
echo ""
echo "=== [5/5] Connection test ==="
echo "Testing SSH connection to 13.140.188.74..."
if ssh -i "$SSH_KEY" -o ConnectTimeout=5 -o BatchMode=yes root@13.140.188.74 "echo 'SSH connection successful'" 2>/dev/null; then
  echo "✅ SSH connection verified"
else
  echo "⚠️  SSH connection failed. Ensure:"
  echo "   1. VPS is running"
  echo "   2. Public key is in /root/.ssh/authorized_keys on VPS"
  echo "   3. Port 22 is open (UFW)"
  echo "   4. Correct IP: 13.140.188.74"
fi

echo ""
echo "=== DONE ==="
echo "Next steps:"
echo "  1. If SSH key was just created, copy it to the VPS (see step 3 above)"
echo "  2. Start a Claude Code session and verify MCP tools are available"
echo "  3. Test with: 'list my SSH servers' in Claude Code"
echo "  4. Review HITL gates in plugins/mcp-ssh/README.md for allowed operations"
