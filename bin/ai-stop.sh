#!/bin/bash
# ai-stop.sh - End AI session with summary and cleanup
#
# Usage:
#   ai-stop              # End session and generate summary
#   ai-stop --quiet      # End session without output
#
# What it does:
#   1. Generates session summary (duration, files, decisions)
#   2. Updates ai-handoff.md with final state
#   3. Clears session-specific state
#   4. Outputs summary for user

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
CONTEXT_DIR=".ai-context"
HANDOFF_FILE="${CONTEXT_DIR}/ai-handoff.md"
SESSION_FILE="${CONTEXT_DIR}/.session"
QUIET=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --quiet|-q)
      QUIET=true
      shift
      ;;
    --help|-h)
      echo "Usage: ai-stop [--quiet]"
      echo ""
      echo "Options:"
      echo "  --quiet, -q    End session without output"
      echo ""
      echo "What it does:"
      echo "  1. Generates session summary"
      echo "  2. Updates ai-handoff.md"
      echo "  3. Clears session state"
      exit 0
      ;;
  esac
done

# Check if in a workspace
if [[ ! -d "$CONTEXT_DIR" ]]; then
  echo -e "${YELLOW}⚠️  No .ai-context directory found${NC}"
  echo "   Are you in an AI workspace? Run 'ai-start' first."
  exit 1
fi

# Calculate session duration
calculate_duration() {
  if [[ -f "$SESSION_FILE" ]]; then
    local start_time
    start_time=$(cat "$SESSION_FILE" 2>/dev/null)
    local end_time
    end_time=$(date +%s)
    
    if [[ -n "$start_time" ]]; then
      local duration=$((end_time - start_time))
      local hours=$((duration / 3600))
      local minutes=$(((duration % 3600) / 60))
      
      if [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m"
      else
        echo "${minutes}m"
      fi
      return
    fi
  fi
  echo "unknown"
}

# Count modified files (git-based)
count_modified_files() {
  if command -v git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null; then
    git diff --name-only 2>/dev/null | wc -l | tr -d ' '
  else
    echo "N/A"
  fi
}

# Count completed todos
count_completed_todos() {
  local count=0
  if [[ -d "${CONTEXT_DIR}/todos" ]]; then
    count=$(grep -l "status: complete" "${CONTEXT_DIR}/todos/"*.md 2>/dev/null | wc -l | tr -d ' ')
  fi
  echo "$count"
}

# Count pending todos
count_pending_todos() {
  local count=0
  if [[ -d "${CONTEXT_DIR}/todos" ]]; then
    count=$(grep -l "status: pending\|status: ready" "${CONTEXT_DIR}/todos/"*.md 2>/dev/null | wc -l | tr -d ' ')
  fi
  echo "$count"
}

# Update ai-handoff.md with session end
update_handoff() {
  local duration="$1"
  local files_modified="$2"
  local todos_completed="$3"
  local timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M")
  
  if [[ -f "$HANDOFF_FILE" ]]; then
    # Add to history section
    local history_entry="| ${timestamp} | Session | Ended | Duration: ${duration}, Files: ${files_modified}, Todos: ${todos_completed} |"
    
    # Try to add to history table
    if grep -q "^| Time | AI | Action | Result |" "$HANDOFF_FILE"; then
      # Find the line after the header separator and add entry
      sed -i.bak "/^|------|-----|--------|--------|$/a\\
${history_entry}
" "$HANDOFF_FILE" 2>/dev/null || true
      rm -f "${HANDOFF_FILE}.bak"
    fi
    
    # Update session state
    sed -i.bak "s/- \*\*Phase:\*\* .*/- **Phase:** session ended/" "$HANDOFF_FILE" 2>/dev/null || true
    rm -f "${HANDOFF_FILE}.bak"
  fi
}

# Generate summary
generate_summary() {
  local duration
  duration=$(calculate_duration)
  
  local files_modified
  files_modified=$(count_modified_files)
  
  local todos_completed
  todos_completed=$(count_completed_todos)
  
  local todos_pending
  todos_pending=$(count_pending_todos)
  
  # Update handoff file
  update_handoff "$duration" "$files_modified" "$todos_completed"
  
  if ! $QUIET; then
    echo ""
    echo -e "${CYAN}╭──────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${NC}       ${GREEN}Session Summary${NC}              ${CYAN}│${NC}"
    echo -e "${CYAN}╰──────────────────────────────────────╯${NC}"
    echo ""
    echo -e "   ${BLUE}Duration:${NC}        ${duration}"
    echo -e "   ${BLUE}Files modified:${NC}  ${files_modified}"
    echo -e "   ${BLUE}Todos completed:${NC} ${todos_completed}"
    echo -e "   ${BLUE}Todos pending:${NC}   ${todos_pending}"
    echo ""
    
    if [[ "$todos_pending" -gt 0 ]]; then
      echo -e "   ${YELLOW}⚠️  You have pending todos${NC}"
      echo -e "   Run ${BLUE}ls ${CONTEXT_DIR}/todos/${NC} to see them"
      echo ""
    fi
    
    echo -e "   ${GREEN}✓${NC} Session state saved to ${BLUE}ai-handoff.md${NC}"
    echo ""
  fi
}

# Cleanup session
cleanup_session() {
  # Remove session file
  rm -f "$SESSION_FILE"
  
  # Clear any temporary files
  rm -f "${CONTEXT_DIR}/.tmp"* 2>/dev/null || true
}

# Main
main() {
  if ! $QUIET; then
    echo -e "${BLUE}🛑 Ending AI session...${NC}"
  fi
  
  # Generate summary
  generate_summary
  
  # Cleanup
  cleanup_session
  
  if ! $QUIET; then
    echo -e "${GREEN}Session ended.${NC} Run ${BLUE}ai-start${NC} to begin a new session."
    echo ""
  fi
}

main "$@"
