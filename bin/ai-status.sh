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

# Show agent information if in a project with .ai-config
if [[ -f ".ai-config" ]]; then
  echo ""
  echo "Agent Management"
  echo "════════════════"
  echo ""
  
  # Get profile
  if command -v jq &> /dev/null; then
    PROFILE=$(jq -r '.agents.profile // "none"' .ai-config 2>/dev/null || echo "none")
  else
    PROFILE="none"
  fi
  
  echo "Profile: $PROFILE"
  
  # Count active agents
  if [[ -d ".claude/agents" ]]; then
    AGENT_COUNT=$(find ".claude/agents" -name "*.md" -type f | wc -l | tr -d ' ')
    echo "Active Agents: $AGENT_COUNT"
    
    # Calculate tokens
    TOTAL_TOKENS=0
    for agent in .claude/agents/*.md; do
      if [[ -f "$agent" ]]; then
        SIZE=$(wc -c < "$agent" | tr -d ' ')
        TOKENS=$((SIZE / 4))
        TOTAL_TOKENS=$((TOTAL_TOKENS + TOKENS))
      fi
    done
    
    LIMIT=15000
    PERCENT=$((TOTAL_TOKENS * 100 / LIMIT))
    
    printf "Tokens: ~%'d / %'d (%d%%)\n" "$TOTAL_TOKENS" "$LIMIT" "$PERCENT" 2>/dev/null || \
      echo "Tokens: ~$TOTAL_TOKENS / $LIMIT ($PERCENT%)"
    
    if [[ $TOTAL_TOKENS -gt $LIMIT ]]; then
      echo "⚠  Warning: Token usage exceeds recommended limit"
    fi
    
    echo ""
    echo "Commands:"
    echo "  ai-agents stats     - Detailed agent statistics"
    echo "  ai-agents active    - List active agents"
    echo "  ai-agents profile   - Manage agent profiles"
  else
    echo "No agents active"
    echo ""
    echo "Commands:"
    echo "  ai-agents profile list    - Available profiles"
    echo "  ai-agents suggest         - Get profile suggestion"
  fi
fi

echo ""
echo "Commands:"
echo "  ai-recent   - Show recent workspaces"
echo "  ai-recover  - Recover from crashes"
