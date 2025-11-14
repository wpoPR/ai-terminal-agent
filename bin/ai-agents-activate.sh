#!/bin/bash
# ai-agents-activate.sh - Activate specific agents (to be called by Gemini)
# Gemini does the intelligent analysis, this script just copies files
# Version: 2.0.0

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }

WORKSPACE_DIR="$HOME/.ai-workspace"
AGENTS_LIB="$WORKSPACE_DIR/agents"
AGENTS_DIR=".claude/agents"

show_help() {
  cat << 'EOF'
ai-agents-activate - Activate specific agents (simple file copier)

USAGE:
  ai-agents-activate <agent1> <agent2> ... <agentN>
  ai-agents-activate --profile <profile>
  ai-agents-activate --list <file>

OPTIONS:
  <agents>          Space-separated list of agent names
  --profile <name>  Activate all agents from a profile
  --list <file>     Read agent list from file (one per line)
  --dry-run         Show what would be done without doing it
  -h, --help        Show this help

DESCRIPTION:
  Simple script that ONLY copies agent files. Does NO analysis.
  Designed to be called by Gemini after intelligent analysis.

  GEMINI does the thinking (reads workspace-manager.md, analyzes task)
  THIS SCRIPT does the mechanical work (copies files)

WORKFLOW:
  1. Gemini reads workspace-manager.md (knows all 45 agents)
  2. Gemini reads .ai-context/current-task.md (understands task)
  3. Gemini decides which agents needed (intelligent analysis)
  4. Gemini calls this script with agent list (mechanical copy)
  5. Script copies agents to .claude/agents/
  6. Claude auto-detects (no restart!)

EXAMPLES:
  # Activate specific agents
  ai-agents-activate frontend-developer backend-architect database-architect

  # Activate profile (reads from config)
  ai-agents-activate --profile fullstack

  # Read from file
  echo "frontend-developer" > agents.txt
  echo "backend-architect" >> agents.txt
  ai-agents-activate --list agents.txt

GEMINI PROMPT:
  "After analyzing the task and consulting workspace-manager.md,
   I've determined we need: frontend-developer, backend-architect,
   database-architect. Please run:
   
   ai-agents-activate frontend-developer backend-architect database-architect"

EOF
}

# Parse arguments
DRY_RUN=false
AGENTS=()
PROFILE=""
LIST_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    --list)
      LIST_FILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      # Everything else is treated as agent name
      AGENTS+=("$1")
      shift
      ;;
  esac
done

# Determine agent list
if [[ -n "$PROFILE" ]]; then
  # Load from profile
  PROFILE_FILE="$WORKSPACE_DIR/agent-profiles/${PROFILE%%+*}.json"
  if [[ ! -f "$PROFILE_FILE" ]]; then
    print_error "Profile not found: $PROFILE"
    exit 1
  fi
  
  AGENTS=($(jq -r '.agents[]' "$PROFILE_FILE" 2>/dev/null))
  
  # Handle combined profiles
  if [[ "$PROFILE" == *"+"* ]]; then
    SECONDARY_PROFILE="${PROFILE#*+}"
    SECONDARY_FILE="$WORKSPACE_DIR/agent-profiles/${SECONDARY_PROFILE}.json"
    if [[ -f "$SECONDARY_FILE" ]]; then
      SECONDARY_AGENTS=($(jq -r '.agents[]' "$SECONDARY_FILE" 2>/dev/null))
      AGENTS+=("${SECONDARY_AGENTS[@]}")
    fi
  fi
  
  # Remove duplicates
  AGENTS=($(printf '%s\n' "${AGENTS[@]}" | sort -u))
  
elif [[ -n "$LIST_FILE" ]]; then
  # Load from file
  if [[ ! -f "$LIST_FILE" ]]; then
    print_error "List file not found: $LIST_FILE"
    exit 1
  fi
  
  mapfile -t AGENTS < "$LIST_FILE"
  
elif [[ ${#AGENTS[@]} -eq 0 ]]; then
  print_error "No agents specified"
  echo "Use --help for usage information"
  exit 1
fi

echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  AI Agents - Activation${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}Agents to activate (${#AGENTS[@]}):${NC}"
for agent in "${AGENTS[@]}"; do
  echo "  • $agent"
done
echo ""

# Estimate tokens
TOTAL_TOKENS=0
for agent in "${AGENTS[@]}"; do
  agent_file="$AGENTS_LIB/${agent}.md"
  if [[ -f "$agent_file" ]]; then
    SIZE=$(wc -c < "$agent_file" | tr -d ' ')
    TOKENS=$((SIZE / 4))
    TOTAL_TOKENS=$((TOTAL_TOKENS + TOKENS))
  fi
done

echo -e "${CYAN}Estimated token usage:${NC} ~${TOTAL_TOKENS} / 15000 ($(( TOTAL_TOKENS * 100 / 15000 ))%)"
echo ""

if [[ $TOTAL_TOKENS -gt 15000 ]]; then
  print_warning "Token usage exceeds recommended limit!"
  print_info "Consider using a more focused profile"
  echo ""
fi

# Dry run mode
if [[ "$DRY_RUN" == "true" ]]; then
  print_info "Dry run mode - no changes made"
  echo ""
  exit 0
fi

# Activate agents
echo "Activating agents..."
echo ""

mkdir -p "$AGENTS_DIR"

# Clear existing agents
rm -f "$AGENTS_DIR"/*.md

# Copy new agents
SUCCESS=0
for agent in "${AGENTS[@]}"; do
  agent_file="$AGENTS_LIB/${agent}.md"
  if [[ -f "$agent_file" ]]; then
    cp "$agent_file" "$AGENTS_DIR/"
    print_success "$agent"
    SUCCESS=$((SUCCESS + 1))
  else
    print_warning "$agent (not found)"
  fi
done

echo ""
print_success "Activated $SUCCESS agent(s)"
print_info "Claude will auto-detect the new agents (no restart needed!)"
echo ""

# Update .ai-config if exists
if [[ -f ".ai-config" ]] && command -v jq &> /dev/null; then
  temp=$(mktemp)
  agents_json=$(printf '%s\n' "${AGENTS[@]}" | jq -R . | jq -s .)
  
  # Set profile if provided, otherwise use "custom"
  PROFILE_NAME="${PROFILE:-custom}"
  
  jq --arg prof "$PROFILE_NAME" --argjson agents "$agents_json" \
    '.agents.profile = $prof | .agents.enabled = $agents' \
    .ai-config > "$temp" 2>/dev/null
  
  if [[ -s "$temp" ]]; then
    mv "$temp" .ai-config
    print_success "Updated .ai-config"
  else
    rm "$temp"
  fi
fi

echo ""
print_success "Done! Claude will auto-detect the new agents (no restart needed!)"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  • Continue working - agents are ready!"
echo "  • Check status: ${GREEN}ai-agents active${NC}"
echo "  • View tokens: ${GREEN}ai-agents stats${NC}"
echo ""

