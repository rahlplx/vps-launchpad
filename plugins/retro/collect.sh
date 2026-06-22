#!/bin/bash
# collect.sh — Gather data for weekly retrospective
# HITL: 🟢 AUTO — Read-only data collection
# Idempotent: safe to re-run.

set -euo pipefail

LOOKBACK_DAYS=${1:-7}
SINCE=$(date -d "-${LOOKBACK_DAYS} days" +%Y-%m-%d 2>/dev/null || date -v-${LOOKBACK_DAYS}d +%Y-%m-%d)
TODAY=$(date +%Y-%m-%d)
WEEK_NUM=$(date +%V)
OUTPUT_DIR="brainstorm/sessions"
OUTPUT_FILE="${OUTPUT_DIR}/${TODAY}-retro-week-${WEEK_NUM}.md"

echo "=== Retro Data Collection ==="
echo "Period: $SINCE to $TODAY (Week $WEEK_NUM)"
echo "Output: $OUTPUT_FILE"

# --- Collect git log ---
echo "=== Collecting git log ==="
GIT_LOG=$(git log --oneline --since="$SINCE" --no-merges 2>/dev/null || echo "No commits in period")
MERGE_LOG=$(git log --oneline --since="$SINCE" --merges 2>/dev/null || echo "No merges in period")
COMMIT_COUNT=$(echo "$GIT_LOG" | grep -c . || echo "0")
MERGE_COUNT=$(echo "$MERGE_LOG" | grep -c . || echo "0")

# --- Collect PR data (if gh available) ---
echo "=== Collecting PR data ==="
if command -v gh &>/dev/null; then
  PRS_MERGED=$(gh pr list --state merged --search "merged:>=$SINCE" --json number,title,labels --limit 50 2>/dev/null || echo "[]")
  PRS_CLOSED=$(gh pr list --state closed --search "closed:>=$SINCE" --json number,title --limit 50 2>/dev/null || echo "[]")
else
  PRS_MERGED="(gh CLI not available)"
  PRS_CLOSED="(gh CLI not available)"
fi

# --- Collect telemetry snapshots ---
echo "=== Collecting telemetry snapshots ==="
SNAPSHOT_DIR="telemetry/snapshots"
if [ -d "$SNAPSHOT_DIR" ]; then
  SNAPSHOT_COUNT=$(find "$SNAPSHOT_DIR" -name "*.json" -newer <(date -d "$SINCE") 2>/dev/null | wc -l || echo "0")
else
  SNAPSHOT_COUNT="0"
fi

# --- Collect incident sessions ---
echo "=== Collecting incident sessions ==="
INCIDENTS=$(grep -rl "Status: INCIDENT\|incident\|outage" brainstorm/sessions/ 2>/dev/null | while read f; do
  mod_date=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null)
  since_epoch=$(date -d "$SINCE" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$SINCE" +%s 2>/dev/null)
  if [ "$mod_date" -ge "$since_epoch" ] 2>/dev/null; then echo "$f"; fi
done || echo "None")

# --- Generate retro session ---
echo "=== Generating retro session ==="
cat > "$OUTPUT_FILE" <<RETRO
# Session: Weekly Retro — Week $WEEK_NUM
Date: $TODAY
Agent: agent:architect
Status: DRAFT

---

## Period: $SINCE to $TODAY

## Summary
- Commits: $COMMIT_COUNT
- Merges: $MERGE_COUNT
- Telemetry snapshots: $SNAPSHOT_COUNT

## Commits
\`\`\`
$GIT_LOG
\`\`\`

## Merges
\`\`\`
$MERGE_LOG
\`\`\`

## PRs merged
$PRS_MERGED

## PRs closed (not merged)
$PRS_CLOSED

## Incidents
$INCIDENTS

## Resource trends
> Fill from telemetry snapshots. Compare start-of-week vs end-of-week RAM/CPU/disk.

## HITL gate review
> Were any AUTO actions that should have been REVIEW?
> Were any BLOCK actions that could safely be downgraded to REVIEW?

## Proposals
> Agent fills with max 3 actionable proposals based on data above.
> Each proposal becomes a separate PR if approved.

1.
2.
3.

## Decision
> _Human fills this after reviewing._
RETRO

echo ""
echo "=== DONE ==="
echo "Retro session created: $OUTPUT_FILE"
echo "Review and fill in the Decision section."
