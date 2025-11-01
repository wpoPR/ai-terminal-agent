#!/bin/bash
# ai-diff.sh - Compare and merge context files
# Version: 1.0.0

echo "AI Context Diff Tool"
echo "══════════════════════"
echo ""

# Check if context files exist
CONTEXT_FILES=("claude.md" "gemini.md" "agents.md" "codex.md")
FOUND_FILES=()

for file in "${CONTEXT_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    FOUND_FILES+=("$file")
  fi
done

if [[ ${#FOUND_FILES[@]} -eq 0 ]]; then
  echo "No context files found in current directory"
  exit 1
fi

echo "Found context files:"
for file in "${FOUND_FILES[@]}"; do
  local lines=$(wc -l < "$file" | tr -d ' ')
  echo "  - $file ($lines lines)"
done

echo ""
echo "Options:"
echo "  1. View differences between files"
echo "  2. Merge files (coming soon)"
echo ""

read -p "Select option (1-2): " choice

case "$choice" in
  1)
    if command -v diff &> /dev/null; then
      echo ""
      for ((i=0; i<${#FOUND_FILES[@]}-1; i++)); do
        for ((j=i+1; j<${#FOUND_FILES[@]}; j++)); do
          echo "Comparing ${FOUND_FILES[$i]} vs ${FOUND_FILES[$j]}:"
          echo "────────────────────────────────────"
          diff -u "${FOUND_FILES[$i]}" "${FOUND_FILES[$j]}" || true
          echo ""
        done
      done
    else
      echo "diff command not available"
    fi
    ;;
  2)
    echo "Merge feature coming soon"
    ;;
  *)
    echo "Invalid option"
    ;;
esac
