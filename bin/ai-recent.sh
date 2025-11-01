#!/bin/bash
# ai-recent.sh - List recently used workspaces
# Version: 1.0.0

WORKSPACE_DIR="$HOME/.ai-workspace"

echo "Recent Workspaces"
echo "═══════════════════"
echo ""

# Check sessions directory
if [[ -d "$WORKSPACE_DIR/sessions" ]]; then
  # Find recent session directories (last 10)
  find "$WORKSPACE_DIR/sessions" -type d -name "20*" 2>/dev/null | \
    sort -r | \
    head -10 | \
    while read -r session_dir; do
      date=$(basename "$session_dir")
      echo "📅 $date"

      # List workspaces in that session (if tracking exists)
      if [[ -f "$session_dir/workspaces.txt" ]]; then
        cat "$session_dir/workspaces.txt" | sed 's/^/   /'
      fi
      echo ""
    done
else
  echo "No recent sessions found"
fi

echo "To open a recent workspace:"
echo "  cd <workspace-path>"
echo "  ai-start"
