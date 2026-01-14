#!/bin/bash
# ai-agents-setup-interactive.sh - Interactive agent setup during ai-start
# Version: 1.0.0

# Colors
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

WORKSPACE_DIR="$HOME/.ai-workspace"
PROFILES_DIR="$WORKSPACE_DIR/agent-profiles"
AI_CONFIG=".ai-config"

# Show menu
show_agent_menu() {
  echo -e "${BOLD}${BLUE}┌─────────────────────────────────────────────┐${NC}"
  echo -e "${BOLD}${BLUE}│  🤖 Agent Configuration                     │${NC}"
  echo -e "${BOLD}${BLUE}└─────────────────────────────────────────────┘${NC}"
  echo ""
  echo "Pre-defined Profiles:"
  echo ""
  echo -e "  ${CYAN}1.${NC} frontend      (4 agents) - React, Next.js, Vue"
  echo -e "  ${CYAN}2.${NC} backend       (4 agents) - APIs, Node.js, databases"
  echo -e "  ${CYAN}3.${NC} fullstack     (4 agents) - Full Frontend + Backend"
  echo -e "  ${CYAN}4.${NC} mobile        (3 agents) - React Native, Flutter"
  echo -e "  ${CYAN}5.${NC} devops        (5 agents) - Kubernetes, Terraform, CI/CD"
  echo -e "  ${CYAN}6.${NC} data          (4 agents) - Data engineering, ETL, analytics"
  echo -e "  ${CYAN}7.${NC} ai-ml         (4 agents) - Machine Learning, AI"
  echo -e "  ${CYAN}8.${NC} security      (4 agents) - Security audit, vulnerabilities"
  echo -e "  ${CYAN}9.${NC} docs          (4 agents) - Technical documentation"
  echo -e " ${CYAN}10.${NC} research      (3 agents) - Performance, research"
  echo -e " ${CYAN}11.${NC} minimal       (2 agents) - Code review only"
  echo ""
  echo -e "${YELLOW}Special options:${NC}"
  echo -e "  ${CYAN}s.${NC} Suggest profile based on project"
  echo -e "  ${CYAN}c.${NC} Combine profiles (e.g.: frontend+security)"
  echo -e "  ${CYAN}n.${NC} Skip (configure later)"
  echo ""
}

# Get user choice (deprecated - now inline in main)
get_user_choice() {
  local user_choice
  read -p "Choose [1-11/s/c/n]: " -r user_choice
  echo "$user_choice"
}

# Apply profile
apply_profile() {
  local profile_name="$1"
  local profile_file="$PROFILES_DIR/${profile_name}.json"
  
  if [[ ! -f "$profile_file" ]]; then
    echo -e "${YELLOW}⚠${NC}  Profile not found: $profile_name"
    return 1
  fi
  
  if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  jq required for profile management"
    return 1
  fi
  
  local agents=($(jq -r '.agents[]' "$profile_file" 2>/dev/null))
  
  echo "Activating profile: ${CYAN}$profile_name${NC}"
  echo "Agents: ${#agents[@]}"
  echo ""
  
  # Create agents directory
  mkdir -p ".claude/agents"
  
  # Copy agents from library
  local agents_lib="$WORKSPACE_DIR/agents"
  local success=0
  
  for agent in "${agents[@]}"; do
    local source="$agents_lib/${agent}.md"
    if [[ -f "$source" ]]; then
      cp "$source" ".claude/agents/"
      echo -e "${GREEN}✓${NC} $agent"
      success=$((success + 1))
    else
      echo -e "${YELLOW}⚠${NC}  $agent (not found)"
    fi
  done
  
  echo ""
  
  if [[ $success -gt 0 ]]; then
    # Update or create .ai-config
    if [[ -f "$AI_CONFIG" ]]; then
      # Update existing config
      local temp=$(mktemp)
      local agents_json=$(printf '%s\n' "${agents[@]}" | jq -R . | jq -s .)
      jq --arg prof "$profile_name" --argjson agents "$agents_json" \
        '.agents.profile = $prof | .agents.enabled = $agents' \
        "$AI_CONFIG" > "$temp" 2>/dev/null
      
      if [[ -s "$temp" ]]; then
        mv "$temp" "$AI_CONFIG"
      else
        rm "$temp"
        # Fallback: create agents section manually
        create_agent_config "$profile_name" "${agents[@]}"
      fi
    else
      # Create new config with agents section
      create_agent_config "$profile_name" "${agents[@]}"
    fi
    
    echo -e "${GREEN}✓${NC} Profile configured: $profile_name"
    return 0
  else
    echo -e "${YELLOW}⚠${NC}  No agents were configured"
    return 1
  fi
}

# Create agent config section
create_agent_config() {
  local profile="$1"
  shift
  local agents=("$@")
  
  if [[ ! -f "$AI_CONFIG" ]]; then
    # Create basic config
    cat > "$AI_CONFIG" << 'EOF'
{
  "layout": "default",
  "primary_ai": "claude",
  "auto_sync": true,
  "auto_backup": true,
  "template": "coding-project",
  "agents": {
    "profile": "",
    "enabled": [],
    "auto_update": true,
    "token_limit": 15000
  }
}
EOF
  fi
  
  # Update with jq if available
  if command -v jq &> /dev/null; then
    local temp=$(mktemp)
    local agents_json=$(printf '%s\n' "${agents[@]}" | jq -R . | jq -s .)
    jq --arg prof "$profile" --argjson agents "$agents_json" \
      '.agents.profile = $prof | .agents.enabled = $agents' \
      "$AI_CONFIG" > "$temp" 2>/dev/null
    
    if [[ -s "$temp" ]]; then
      mv "$temp" "$AI_CONFIG"
    else
      rm "$temp"
    fi
  fi
}

# Main interactive setup
main() {
  # Check if agents library exists
  if [[ ! -d "$WORKSPACE_DIR/agents" ]]; then
    echo -e "${YELLOW}⚠${NC}  Agent library not found"
    echo -e "${BLUE}ℹ${NC}  Run 'ai-update' to initialize agents"
    return 1
  fi
  
  show_agent_menu
  
  # Read with fallback for non-interactive mode
  local choice
  if [[ -t 0 ]]; then
    read -p "Choose [1-11/s/c/n]: " -r choice
  else
    choice="11"  # Default to minimal in non-interactive mode
  fi
  
  case "$choice" in
    1)
      apply_profile "frontend"
      ;;
    2)
      apply_profile "backend"
      ;;
    3)
      apply_profile "fullstack"
      ;;
    4)
      apply_profile "mobile"
      ;;
    5)
      apply_profile "devops"
      ;;
    6)
      apply_profile "data"
      ;;
    7)
      apply_profile "ai-ml"
      ;;
    8)
      apply_profile "security"
      ;;
    9)
      apply_profile "docs"
      ;;
    10)
      apply_profile "research"
      ;;
    11)
      apply_profile "minimal"
      ;;
    s|S)
      echo "Analyzing project..."
      echo ""
      if command -v ai-agents &> /dev/null; then
        ai-agents suggest
        echo ""
        read -p "Apply the suggestion? (y/n): " -r apply
        if [[ $apply =~ ^[Yy]$ ]]; then
          # Get suggested profile (simplified - would need parsing)
          read -p "Enter profile name: " -r profile_name
          apply_profile "$profile_name"
        fi
      else
        echo -e "${YELLOW}⚠${NC}  ai-agents command not available"
        apply_profile "minimal"
      fi
      ;;
    c|C)
      echo "Combine profiles:"
      echo ""
      read -p "Enter profiles separated by '+' (e.g.: frontend+security): " -r combined
      echo ""
      if command -v ai-agents &> /dev/null; then
        ai-agents profile "$combined"
      else
        echo -e "${YELLOW}⚠${NC}  ai-agents command not available"
        echo -e "${BLUE}ℹ${NC}  Applying minimal profile"
        apply_profile "minimal"
      fi
      ;;
    n|N)
      echo -e "${BLUE}ℹ${NC}  Skipping agent configuration"
      echo ""
      return 0
      ;;
    *)
      echo -e "${YELLOW}⚠${NC}  Invalid option, using minimal profile"
      apply_profile "minimal"
      ;;
  esac
}

main "$@"
