#!/bin/bash
# ai-status.sh - Show status of active workspaces
# Version: 1.0.0

WORKSPACE_DIR="$HOME/.ai-workspace"
TRACKING_FILE="$WORKSPACE_DIR/tracking.json"

echo "AI Workspace Status"
echo "═══════════════════"
echo ""

# Check if tracking file exists
if [[ ! -f "$TRACKING_FILE" ]]; then
  echo "No active workspaces"
  exit 0
fi

# Read tracking file (simplified - will need jq in full version)
if command -v jq &> /dev/null; then
  # With jq
  active_count=$(jq '.active_workspaces | length' "$TRACKING_FILE" 2>/dev/null || echo "0")

  if [[ "$active_count" -eq 0 ]]; then
    echo "No active workspaces"
  else
    echo "Active Workspaces: $active_count"
    echo ""

    jq -r '.active_workspaces[] | "📁 \(.path)\n   PID: \(.pid)\n   Started: \(.started_at)\n"' "$TRACKING_FILE" 2>/dev/null
  fi
else
  # Without jq - basic check
  if grep -q "active_workspaces" "$TRACKING_FILE" 2>/dev/null; then
    echo "Tracking file exists (install jq for details)"
    cat "$TRACKING_FILE"
  else
    echo "No active workspaces"
  fi
fi

echo ""
echo "Commands:"
echo "  ai-recent   - Show recent workspaces"
echo "  ai-recover  - Recover from crashes"
