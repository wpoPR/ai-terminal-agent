#!/bin/bash
# ai-recover.sh - Recover workspaces after crashes
# Version: 1.0.0

WORKSPACE_DIR="$HOME/.ai-workspace"
TRACKING_FILE="$WORKSPACE_DIR/tracking.json"

echo "AI Workspace Recovery"
echo "═══════════════════════"
echo ""

# Find orphaned .ai-workspace-active files
echo "Searching for orphaned workspace files..."
echo ""

FOUND_ORPHANS=0

# Search in common project directories
for dir in "$HOME/workspace" "$HOME/projects" "$HOME/Documents"; do
  if [[ -d "$dir" ]]; then
    find "$dir" -name ".ai-workspace-active" -type f 2>/dev/null | while read -r active_file; do
      local project_dir=$(dirname "$active_file")
      local pid=$(jq -r '.pid' "$active_file" 2>/dev/null || echo "")

      if [[ -n "$pid" ]]; then
        # Check if process is still running
        if ! ps -p "$pid" > /dev/null 2>&1; then
          echo "Found orphaned workspace:"
          echo "  Path: $project_dir"
          echo "  PID: $pid (dead)"
          echo ""

          read -p "Remove this orphaned file? (y/n) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$active_file"
            echo "✓ Removed"
          fi
          echo ""

          FOUND_ORPHANS=$((FOUND_ORPHANS + 1))
        fi
      fi
    done
  fi
done

if [[ $FOUND_ORPHANS -eq 0 ]]; then
  echo "✓ No orphaned workspaces found"
fi

echo ""
echo "Recovery complete"
echo ""
echo "You can now:"
echo "  - Run 'ai-status' to check active workspaces"
echo "  - Run 'ai-start' in your project directory"
