#!/bin/bash
# install.sh — Lightweight telemetry stack deployment
# HITL: 🔴 BLOCK — Human deploys via docker compose on VPS.
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== Telemetry Stack — Lightweight Install ==="
echo "VPS: 13.140.188.74 | Components: Netdata (256MB) + MLflow (128MB)"
echo "Total RAM budget: ~384MB"

COMPOSE_FILE="/opt/vps-launchpad/infra/docker/docker-compose.observability.yml"

# --- Step 1: Check compose file ---
echo "=== [1/3] Checking compose file ==="
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "❌ Missing: $COMPOSE_FILE"
  echo "   Clone the repo to /opt/vps-launchpad first."
  exit 1
fi
echo "✅ Compose file found"

# --- Step 2: Deploy stack ---
echo "=== [2/3] Deploying observability stack ==="
docker compose -f "$COMPOSE_FILE" up -d
echo "✅ Stack deployed"

# --- Step 3: Verify ---
echo "=== [3/3] Verification ==="
sleep 5

echo -n "Netdata (port 19999): "
curl -sf --max-time 5 http://localhost:19999/api/v1/info >/dev/null && echo "✅" || echo "❌ (may need a few more seconds)"

echo -n "MLflow (port 5000): "
curl -sf --max-time 5 http://localhost:5000/health >/dev/null && echo "✅" || echo "❌ (may need a few more seconds)"

echo ""
echo "=== DONE ==="
echo "Netdata: http://localhost:19999 (internal only)"
echo "MLflow:  http://localhost:5000  (internal only)"
echo "RAM used: ~384MB total (within R07 budget)"
