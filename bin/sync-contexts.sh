#!/bin/bash
# sync-contexts.sh - Sync context files between AIs
# Version: 1.0.0

# This script syncs context between different AI context files
# For now, it's a stub that shows what would be synced

CONTEXT_FILES=("claude.md" "gemini.md" "agents.md" "codex.md")

echo "Context Sync"
echo "════════════"
echo ""

FOUND=false
for file in "${CONTEXT_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    echo "✓ $file ($(wc -l < "$file" | tr -d ' ') lines)"
    FOUND=true
  fi
done

if [[ "$FOUND" == "false" ]]; then
  echo "No context files found"
  exit 1
fi

echo ""
echo "Context files are independent."
echo "Manual sync: copy content between files as needed."
echo ""
echo "Automatic sync feature coming in future version."
