#!/bin/bash
# generate-project-codex.sh - Generate project-specific CODEX.md
# Version: 1.0.0

set -e

# Resolve script location dynamically
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SOURCE" )" && pwd )"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SOURCE" )" && pwd )"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TEMPLATE_FILE="$REPO_ROOT/templates/codex-project.md"
OUTPUT_FILE="${1:-Codex.md}"
AI_CONFIG=".ai-config"

# Check if template exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "Error: Template not found: $TEMPLATE_FILE"
  exit 1
fi

# Get project info
if command -v jq &> /dev/null && [[ -f "$AI_CONFIG" ]]; then
  PROJECT_NAME=$(jq -r '.project_name // "Unknown Project"' "$AI_CONFIG" 2>/dev/null || echo "Unknown Project")
else
  PROJECT_NAME=$(basename "$(pwd)")
fi

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Generate CODEX.md from template
cat "$TEMPLATE_FILE" | \
  sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" | \
  sed "s/{{TIMESTAMP}}/$TIMESTAMP/g" \
  > "$OUTPUT_FILE"

echo "✓ Generated $OUTPUT_FILE"
echo "  Project: $PROJECT_NAME"

