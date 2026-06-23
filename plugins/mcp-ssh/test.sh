#!/bin/bash
# test.sh — Smoke test for MCP SSH Manager
# HITL: 🟡 REVIEW — Safe read-only checks
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== MCP SSH Manager — Smoke Test ==="
PASS=0
FAIL=0

# Test 1: npm package installed
echo -n "[1] @iflow-mcp/mcp-ssh-manager installed... "
if npm list -g @iflow-mcp/mcp-ssh-manager &>/dev/null; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

# Test 2: SSH key exists
echo -n "[2] SSH key exists (~/.ssh/contabo_vps)... "
if [ -f "$HOME/.ssh/contabo_vps" ]; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

# Test 3: SSH connection
echo -n "[3] SSH connection to 13.140.188.74... "
if ssh -i "$HOME/.ssh/contabo_vps" -o ConnectTimeout=5 -o BatchMode=yes root@13.140.188.74 "exit 0" 2>/dev/null; then
  echo "✅"; ((PASS++))
else
  echo "❌ (may need key copy)"; ((FAIL++))
fi

# Test 4: Claude Code MCP registration
echo -n "[4] MCP server registered in Claude Code... "
if command -v claude &>/dev/null && claude mcp list 2>/dev/null | grep -q "contabo-vps"; then
  echo "✅"; ((PASS++))
else
  echo "❌ (claude CLI not available or server not registered)"; ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && echo "🟢 All checks passed" || echo "🟡 Some checks failed — review above"
