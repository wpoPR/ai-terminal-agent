#!/bin/bash
# ai-stop.sh - Stop AI workspace with optional summary
# Version: 1.0.0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

NO_SUMMARY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --no-summary)
      NO_SUMMARY=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

echo "🛑 Stopping AI Workspace"
echo "══════════════════════════"
echo ""

# Find active workspace file in current directory
if [[ ! -f ".ai-workspace-active" ]]; then
  echo -e "${YELLOW}⚠${NC}  No active workspace in current directory"

  # Search for active workspaces
  echo ""
  echo "Searching for active workspaces..."

  find "$HOME/workspace" "$HOME/projects" -name ".ai-workspace-active" -type f 2>/dev/null | while read -r active_file; do
    local dir=$(dirname "$active_file")
    echo "  Found: $dir"
  done

  exit 1
fi

PROJECT_DIR=$(pwd)
PID=$(jq -r '.pid' ".ai-workspace-active" 2>/dev/null || echo "")
STARTED_AT=$(jq -r '.started_at' ".ai-workspace-active" 2>/dev/null || echo "")

echo "Project: $PROJECT_DIR"
echo "PID: $PID"
echo "Started: $STARTED_AT"
echo ""

# Generate summary if requested
if [[ "$NO_SUMMARY" == "false" ]]; then
  echo "📊 Generating daily summary..."

  # Check if summary script exists
  if command -v generate-daily-summary.sh &> /dev/null; then
    generate-daily-summary.sh "$PROJECT_DIR"
  else
    echo -e "${YELLOW}⚠${NC}  Summary generation not yet implemented"
    echo "   (generate-daily-summary.sh not found)"
  fi

  echo ""
fi

# Remove active marker
echo "🧹 Cleaning up..."
rm ".ai-workspace-active"

# Remove from global tracking
WORKSPACE_DIR="$HOME/.ai-workspace"
TRACKING_FILE="$WORKSPACE_DIR/tracking.json"

if [[ -f "$TRACKING_FILE" ]] && command -v jq &> /dev/null; then
  TEMP_FILE=$(mktemp)
  jq --arg path "$PROJECT_DIR" \
     '.active_workspaces = [.active_workspaces[] | select(.path != $path)]' \
     "$TRACKING_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$TRACKING_FILE"
fi

echo -e "${GREEN}✓${NC} Workspace closed"

echo ""
echo "✅ Done!"
echo ""
echo "Context files preserved:"
for file in claude.md gemini.md agents.md codex.md; do
  if [[ -f "$file" ]]; then
    echo "  - $file"
  fi
done

echo ""
echo "To start again:"
echo "  ai-start"
