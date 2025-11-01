#!/bin/bash
# ai-import.sh - Import AI Terminal Agent configuration
# Version: 1.0.0

IMPORT_FILE="$1"
TARGET_DIR="$HOME/workspace/primavera"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [[ -z "$IMPORT_FILE" ]]; then
  echo "Usage: ai-import <backup-file.tar.gz>"
  exit 1
fi

if [[ ! -f "$IMPORT_FILE" ]]; then
  echo -e "${RED}✗${NC} File not found: $IMPORT_FILE"
  exit 1
fi

echo "📥 Importing AI Terminal Agent..."
echo "File: $IMPORT_FILE"
echo ""

# Create target directory
mkdir -p "$TARGET_DIR"

# Extract
echo "Extracting files..."
tar -xzf "$IMPORT_FILE" -C "$TARGET_DIR"

# Find repository
REPO_PATH="$TARGET_DIR/ai-terminal-agent"

if [[ ! -d "$REPO_PATH" ]]; then
  echo -e "${RED}✗${NC} Repository not found in archive"
  exit 1
fi

echo -e "${GREEN}✓${NC} Files extracted"
echo ""

# Run installation
echo "Running installation..."
cd "$REPO_PATH"
./install.sh

echo ""
echo -e "${GREEN}🎉 Import complete!${NC}"
echo "Repository: $REPO_PATH"
