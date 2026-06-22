#!/bin/bash
# test.sh — Telemetry stack smoke test
# HITL: 🟡 REVIEW — Read-only health checks
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== Telemetry Stack — Smoke Test ==="
PASS=0
FAIL=0

echo -n "[1] Netdata responding (port 19999)... "
if curl -sf --max-time 5 http://localhost:19999/api/v1/info >/dev/null 2>&1; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[2] MLflow responding (port 5000)... "
if curl -sf --max-time 5 http://localhost:5000/health >/dev/null 2>&1; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[3] Netdata RAM data available... "
if curl -sf --max-time 5 "http://localhost:19999/api/v1/data?chart=system.ram&points=1" >/dev/null 2>&1; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[4] MLflow experiment API available... "
if curl -sf --max-time 5 "http://localhost:5000/api/2.0/mlflow/experiments/search?max_results=1" >/dev/null 2>&1; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && echo "🟢 All checks passed" || echo "🟡 Some checks failed — review above"
