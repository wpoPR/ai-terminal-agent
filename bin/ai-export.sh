#!/bin/bash
# ai-export.sh - Export AI Terminal Agent configuration
# Version: 1.0.0

OUTPUT_FILE="${1:-$HOME/ai-terminal-agent-backup.tar.gz}"
WORKSPACE_DIR="$HOME/.ai-workspace"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "📦 Exporting AI Terminal Agent..."
echo ""

# Get repository path
REPO_PATH=$(jq -r '.repo_path' "$WORKSPACE_DIR/config.json" 2>/dev/null || echo "")

if [[ ! -d "$REPO_PATH" ]]; then
  echo -e "${RED}✗${NC} Repository not found: $REPO_PATH"
  exit 1
fi

echo "Creating backup..."
echo "  Repository: $REPO_PATH"
echo "  Templates: ~/templates/ai-contexts/"
echo "  Config: ~/.gitignore_global"
echo ""

# Create tarball
tar -czf "$OUTPUT_FILE" \
  -C "$(dirname "$REPO_PATH")" "$(basename "$REPO_PATH")" \
  -C "$HOME" "templates/ai-contexts" \
  -C "$HOME" ".gitignore_global" \
  2>/dev/null

if [[ $? -eq 0 ]]; then
  echo -e "${GREEN}✅ Export complete!${NC}"
  echo "File: $OUTPUT_FILE"
  echo ""
  echo "📁 Included:"
  echo "   - Repository: $REPO_PATH"
  echo "   - Templates: ~/templates/ai-contexts/"
  echo "   - Git ignore: ~/.gitignore_global"
  echo ""
  echo "🚀 To import on another machine:"
  echo "   ai-import $OUTPUT_FILE"
else
  echo -e "${RED}✗${NC} Export failed"
  exit 1
fi
