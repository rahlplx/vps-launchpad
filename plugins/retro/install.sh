#!/bin/bash
# install.sh — Retro pipeline setup
# HITL: 🟡 REVIEW — Sets up GitHub Actions workflow
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== Retro Pipeline — Setup ==="

# --- Step 1: Verify workflow exists ---
echo "=== [1/2] Checking GitHub Actions workflow ==="
WORKFLOW=".github/workflows/retro-pipeline.yml"
if [ -f "$WORKFLOW" ]; then
  echo "✅ Retro workflow exists: $WORKFLOW"
else
  echo "❌ Missing: $WORKFLOW"
  echo "   Run from repo root to create it."
  exit 1
fi

# --- Step 2: Verify retro template ---
echo "=== [2/2] Checking retro template ==="
TEMPLATE="governance/templates/retro-template.md"
if [ -f "$TEMPLATE" ]; then
  echo "✅ Retro template exists: $TEMPLATE"
else
  echo "❌ Missing: $TEMPLATE"
  exit 1
fi

echo ""
echo "=== DONE ==="
echo "Retro pipeline runs weekly via GitHub Actions."
echo "Manual trigger: gh workflow run retro-pipeline.yml"
