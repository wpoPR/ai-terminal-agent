#!/bin/bash
# generate-daily-summary.sh - Generate daily work summary with Gemini
# Version: 1.0.0

PROJECT_DIR="${1:-$(pwd)}"
WORKSPACE_DIR="$HOME/.ai-workspace"
SUMMARY_DIR="$WORKSPACE_DIR/summaries/daily"
TODAY=$(date +%Y-%m-%d)

mkdir -p "$SUMMARY_DIR"

echo "📊 Daily Summary Generator"
echo "══════════════════════════"
echo "Project: $PROJECT_DIR"
echo "Date: $TODAY"
echo ""

# Collect information
echo "Collecting workspace data..."

# Check for context files
CONTEXTS=""
for file in claude.md gemini.md agents.md; do
  if [[ -f "$PROJECT_DIR/$file" ]]; then
    CONTEXTS="$CONTEXTS\n\n## $file\n$(tail -50 "$PROJECT_DIR/$file")"
  fi
done

# Get git commits (if in git repo)
GIT_COMMITS=""
if git -C "$PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  GIT_COMMITS=$(git -C "$PROJECT_DIR" log --since="today" --oneline 2>/dev/null || echo "")
fi

# Generate summary
SUMMARY_FILE="$SUMMARY_DIR/$TODAY.md"

cat > "$SUMMARY_FILE" << EOF
# Daily Work Summary - $TODAY

## Project: $(basename "$PROJECT_DIR")
Location: $PROJECT_DIR

## Work Done
$(if [[ -n "$CONTEXTS" ]]; then echo -e "$CONTEXTS"; else echo "No context captured"; fi)

## Git Commits
$(if [[ -n "$GIT_COMMITS" ]]; then echo "$GIT_COMMITS"; else echo "No commits today"; fi)

## Next Steps
(Extract from context files)

---
Generated: $(date)
EOF

echo "✓ Summary saved: $SUMMARY_FILE"
echo ""
echo "Preview:"
echo "────────────────────────────────────"
head -20 "$SUMMARY_FILE"
echo "────────────────────────────────────"
echo ""
echo "Full summary: $SUMMARY_FILE"
