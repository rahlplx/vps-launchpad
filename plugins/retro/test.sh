#!/bin/bash
# test.sh — Retro pipeline smoke test
# HITL: 🟡 REVIEW — Read-only checks
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== Retro Pipeline — Smoke Test ==="
PASS=0
FAIL=0

echo -n "[1] Retro workflow exists... "
if [ -f ".github/workflows/retro-pipeline.yml" ]; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[2] Retro template exists... "
if [ -f "governance/templates/retro-template.md" ]; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[3] Collect script exists... "
if [ -f "plugins/retro/collect.sh" ]; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo -n "[4] brainstorm/sessions/ writable... "
if [ -d "brainstorm/sessions" ] && [ -w "brainstorm/sessions" ]; then
  echo "✅"; ((PASS++))
else
  echo "❌"; ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && echo "🟢 All checks passed" || echo "🟡 Some checks failed — review above"
