#!/bin/bash
# generate-agent-index.sh - Generate agent metadata index
# This script analyzes all agents and creates agent-index.json

set -e

AGENTS_DIR="${1:-$HOME/.ai-workspace/agents}"
OUTPUT_FILE="${2:-$HOME/.ai-workspace/agent-index.json}"

# Check if agents directory exists
if [[ ! -d "$AGENTS_DIR" ]]; then
  echo "Error: Agents directory not found: $AGENTS_DIR"
  exit 1
fi

echo "Generating agent index from: $AGENTS_DIR"
echo "Output: $OUTPUT_FILE"

# Start JSON
echo "{" > "$OUTPUT_FILE"

first=true
for agent_file in "$AGENTS_DIR"/*.md; do
  if [[ ! -f "$agent_file" ]]; then
    continue
  fi
  
  filename=$(basename "$agent_file" .md)
  
  # Extract metadata from agent file
  name=$(grep -m1 "^name:" "$agent_file" | sed 's/name: *//' || echo "$filename")
  description=$(grep -m1 "^description:" "$agent_file" | sed 's/description: *//' | head -c 100 || echo "")
  
  # Calculate file size and estimate tokens (1 token ≈ 4 chars)
  size_bytes=$(wc -c < "$agent_file" | tr -d ' ')
  size_tokens=$(( size_bytes / 4 ))
  
  # Determine category based on filename patterns
  category="general"
  tags="[]"
  
  case "$filename" in
    *frontend*)
      category="web"
      tags='["frontend", "react", "ui"]'
      ;;
    *backend*)
      category="backend"
      tags='["backend", "api", "server"]'
      ;;
    *mobile*)
      category="mobile"
      tags='["mobile", "app"]'
      ;;
    *database*)
      category="data"
      tags='["database", "sql", "data"]'
      ;;
    *data*)
      category="data"
      tags='["data", "analytics"]'
      ;;
    *security*)
      category="security"
      tags='["security", "audit"]'
      ;;
    *devops*|*kubernetes*|*terraform*|*deployment*)
      category="devops"
      tags='["devops", "infrastructure"]'
      ;;
    *ai-*|*ml-*|*mlops*)
      category="ai-ml"
      tags='["ai", "ml", "machine-learning"]'
      ;;
    *docs*|*api-documenter*|*tutorial*)
      category="docs"
      tags='["documentation", "writing"]'
      ;;
    *research*|*search*)
      category="research"
      tags='["research", "investigation"]'
      ;;
    *reviewer*|*architect-review*)
      category="quality"
      tags='["review", "quality"]'
      ;;
  esac
  
  # Add comma separator (except for first entry)
  if [[ "$first" == "false" ]]; then
    echo "," >> "$OUTPUT_FILE"
  fi
  first=false
  
  # Write JSON entry (without trailing comma, we add it above)
  cat >> "$OUTPUT_FILE" << EOF
  "$filename": {
    "name": "$name",
    "category": "$category",
    "tags": $tags,
    "size_tokens": $size_tokens,
    "size_bytes": $size_bytes,
    "description": "$description"
  }
EOF
done

# Close JSON
echo "" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

# Count agents
agent_count=$(find "$AGENTS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
echo ""
echo "✓ Generated index for $agent_count agents"
echo "✓ Saved to: $OUTPUT_FILE"

