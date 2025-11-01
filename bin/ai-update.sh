#!/bin/bash
# ai-update.sh - Update AI Terminal Agent from git
# Version: 1.0.0

WORKSPACE_DIR="$HOME/.ai-workspace"
CONFIG_FILE="$WORKSPACE_DIR/config.json"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔄 Updating AI Terminal Agent..."
echo ""

# Get repository path
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo -e "${RED}✗${NC} Configuration not found: $CONFIG_FILE"
  echo "   Run install.sh first"
  exit 1
fi

REPO_PATH=$(jq -r '.repo_path' "$CONFIG_FILE" 2>/dev/null || echo "")

if [[ ! -d "$REPO_PATH" ]]; then
  echo -e "${RED}✗${NC} Repository not found: $REPO_PATH"
  exit 1
fi

echo "Repository: $REPO_PATH"
cd "$REPO_PATH" || exit 1

# Check if it's a git repository
if [[ ! -d ".git" ]]; then
  echo -e "${YELLOW}⚠${NC}  Not a git repository"
  echo "   Cannot update automatically"
  exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
  echo -e "${YELLOW}⚠${NC}  You have uncommitted changes:"
  git status -s
  echo ""
  read -p "Stash changes and update? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git stash
    echo -e "${GREEN}✓${NC} Changes stashed"
  else
    echo "Update cancelled"
    exit 0
  fi
fi

# Pull updates
echo "Pulling updates..."
if git pull; then
  echo ""
  echo -e "${GREEN}✅ Update complete!${NC}"
  echo ""
  echo "📝 Recent changes:"
  git log --oneline -5
  echo ""

  # Re-apply permissions
  chmod +x bin/*.sh 2>/dev/null || true

  echo -e "${GREEN}✓${NC} All scripts updated and ready to use"
else
  echo -e "${RED}✗${NC} Update failed"
  exit 1
fi
