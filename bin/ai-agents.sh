#!/bin/bash
# ai-agents.sh - Agent Management System
# Version: 1.0.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Directories
WORKSPACE_DIR="$HOME/.ai-workspace"
AGENTS_LIB="$WORKSPACE_DIR/agents"
PROFILES_DIR="$WORKSPACE_DIR/agent-profiles"
AGENT_INDEX="$WORKSPACE_DIR/agent-index.json"
PROJECT_AGENTS_DIR=".claude/agents"
AI_CONFIG=".ai-config"

# Helper functions
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }

# Check if in project directory
check_project_dir() {
  if [[ ! -f "$AI_CONFIG" ]]; then
    print_error "Not in a project directory (no .ai-config found)"
    print_info "Run 'ai-start' first to initialize the project"
    exit 1
  fi
}

# Get active profile from .ai-config
get_active_profile() {
  if [[ ! -f "$AI_CONFIG" ]]; then
    echo "none"
    return
  fi
  
  if command -v jq &> /dev/null; then
    jq -r '.agents.profile // "none"' "$AI_CONFIG" 2>/dev/null || echo "none"
  else
    grep -o '"profile"[[:space:]]*:[[:space:]]*"[^"]*"' "$AI_CONFIG" | cut -d'"' -f4 || echo "none"
  fi
}

# Get enabled agents from .ai-config
get_enabled_agents() {
  if [[ ! -f "$AI_CONFIG" ]]; then
    return
  fi
  
  if command -v jq &> /dev/null; then
    jq -r '.agents.enabled[]? // empty' "$AI_CONFIG" 2>/dev/null
  else
    # Fallback without jq (basic parsing)
    grep -o '"enabled"[[:space:]]*:[[:space:]]*\[[^]]*\]' "$AI_CONFIG" | \
      sed 's/.*\[//; s/\].*//; s/"//g; s/,/\n/g' | tr -d ' '
  fi
}

# Calculate tokens from agent files
calculate_tokens() {
  local total=0
  
  if [[ -d "$PROJECT_AGENTS_DIR" ]]; then
    for agent in "$PROJECT_AGENTS_DIR"/*.md; do
      if [[ -f "$agent" ]]; then
        local size=$(wc -c < "$agent" | tr -d ' ')
        local tokens=$((size / 4))
        total=$((total + tokens))
      fi
    done
  fi
  
  echo "$total"
}

# Format number with thousand separators
format_number() {
  printf "%'d" "$1" 2>/dev/null || echo "$1"
}

#
# COMMAND: list
#
cmd_list() {
  local category="$1"
  
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Available Agents${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  if [[ ! -d "$AGENTS_LIB" ]]; then
    print_error "Agent library not found: $AGENTS_LIB"
    print_info "Run 'ai-update' to initialize the library"
    exit 1
  fi
  
  local count=0
  for agent_file in "$AGENTS_LIB"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
      continue
    fi
    
    local filename=$(basename "$agent_file" .md)
    
    # Filter by category if provided
    if [[ -n "$category" ]]; then
      if ! echo "$filename" | grep -q "$category"; then
        continue
      fi
    fi
    
    local name=$(grep -m1 "^name:" "$agent_file" | sed 's/name: *//' || echo "$filename")
    local desc=$(grep -m1 "^description:" "$agent_file" | sed 's/description: *//' | head -c 60 || echo "")
    
    echo -e "${CYAN}$name${NC}"
    echo "  ID: $filename"
    if [[ -n "$desc" ]]; then
      echo "  $desc..."
    fi
    echo ""
    
    count=$((count + 1))
  done
  
  if [[ $count -eq 0 ]]; then
    print_warning "No agents found"
  else
    echo -e "${BOLD}Total: $count agents${NC}"
  fi
}

#
# COMMAND: active
#
cmd_active() {
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Active Agents${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  local profile=$(get_active_profile)
  echo -e "Profile: ${CYAN}$profile${NC}"
  echo ""
  
  if [[ ! -d "$PROJECT_AGENTS_DIR" ]]; then
    print_warning "No agents directory found (.claude/agents/)"
    return
  fi
  
  local count=0
  local total_tokens=0
  
  for agent_file in "$PROJECT_AGENTS_DIR"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
      continue
    fi
    
    local filename=$(basename "$agent_file" .md)
    local size=$(wc -c < "$agent_file" | tr -d ' ')
    local tokens=$((size / 4))
    total_tokens=$((total_tokens + tokens))
    
    echo -e "${GREEN}✓${NC} $filename  ${CYAN}(~$(format_number $tokens) tokens)${NC}"
    count=$((count + 1))
  done
  
  echo ""
  
  if [[ $count -eq 0 ]]; then
    print_warning "No active agents"
  else
    local limit=15000
    local percent=$((total_tokens * 100 / limit))
    echo -e "${BOLD}Total: $count agents${NC}"
    echo -e "${BOLD}Tokens: ~$(format_number $total_tokens) / $(format_number $limit) (${percent}%)${NC}"
    
    if [[ $total_tokens -gt $limit ]]; then
      print_warning "Token usage exceeds recommended limit!"
    elif [[ $total_tokens -gt $((limit * 80 / 100)) ]]; then
      print_warning "Token usage is high (>80%)"
    else
      print_success "Token usage is within recommended limit"
    fi
  fi
}

#
# COMMAND: enable
#
cmd_enable() {
  local agent_name="$1"
  
  if [[ -z "$agent_name" ]]; then
    print_error "Agent name required"
    echo "Usage: ai-agents enable <agent-name>"
    exit 1
  fi
  
  check_project_dir
  
  local source_file="$AGENTS_LIB/${agent_name}.md"
  
  if [[ ! -f "$source_file" ]]; then
    print_error "Agent not found: $agent_name"
    print_info "Use 'ai-agents list' to see available agents"
    exit 1
  fi
  
  mkdir -p "$PROJECT_AGENTS_DIR"
  
  local dest_file="$PROJECT_AGENTS_DIR/${agent_name}.md"
  
  if [[ -f "$dest_file" ]]; then
    print_warning "Agent already enabled: $agent_name"
    return
  fi
  
  cp "$source_file" "$dest_file"
  print_success "Agent enabled: $agent_name"
  
  # Update .ai-config
  if command -v jq &> /dev/null && [[ -f "$AI_CONFIG" ]]; then
    local temp=$(mktemp)
    jq --arg agent "$agent_name" '.agents.enabled += [$agent] | .agents.enabled |= unique' "$AI_CONFIG" > "$temp" 2>/dev/null || true
    if [[ -s "$temp" ]]; then
      mv "$temp" "$AI_CONFIG"
    else
      rm "$temp"
    fi
  fi
  
  print_warning "Restart Claude Code to load the agent"
}

#
# COMMAND: disable
#
cmd_disable() {
  local agent_name="$1"
  
  if [[ -z "$agent_name" ]]; then
    print_error "Agent name required"
    echo "Usage: ai-agents disable <agent-name>"
    exit 1
  fi
  
  check_project_dir
  
  local agent_file="$PROJECT_AGENTS_DIR/${agent_name}.md"
  
  if [[ ! -f "$agent_file" ]]; then
    print_warning "Agent not active: $agent_name"
    return
  fi
  
  rm "$agent_file"
  print_success "Agent disabled: $agent_name"
  
  # Update .ai-config
  if command -v jq &> /dev/null && [[ -f "$AI_CONFIG" ]]; then
    local temp=$(mktemp)
    jq --arg agent "$agent_name" '.agents.enabled -= [$agent]' "$AI_CONFIG" > "$temp" 2>/dev/null || true
    if [[ -s "$temp" ]]; then
      mv "$temp" "$AI_CONFIG"
    else
      rm "$temp"
    fi
  fi
  
  print_warning "Restart Claude Code for changes to take effect"
}

#
# COMMAND: profile
#
cmd_profile() {
  local subcommand="$1"
  local profile_name="$2"
  
  # If no subcommand, show current profile
  if [[ -z "$subcommand" ]]; then
    check_project_dir
    local current=$(get_active_profile)
    echo "Current profile: $current"
    return
  fi
  
  # Handle 'list' subcommand
  if [[ "$subcommand" == "list" ]]; then
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${BLUE}  Available Profiles${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [[ ! -d "$PROFILES_DIR" ]]; then
      print_error "Profiles directory not found: $PROFILES_DIR"
      exit 1
    fi
    
    for profile_file in "$PROFILES_DIR"/*.json; do
      if [[ ! -f "$profile_file" ]]; then
        continue
      fi
      
      local name=$(basename "$profile_file" .json)
      
      if command -v jq &> /dev/null; then
        local display=$(jq -r '.display_name // .name' "$profile_file" 2>/dev/null)
        local desc=$(jq -r '.description // ""' "$profile_file" 2>/dev/null)
        local agent_count=$(jq -r '.agents | length' "$profile_file" 2>/dev/null)
        local tokens=$(jq -r '.estimated_tokens // 0' "$profile_file" 2>/dev/null)
        
        echo -e "${CYAN}$name${NC} - $display"
        echo "  $desc"
        echo "  Agents: $agent_count  |  Tokens: ~$(format_number $tokens)"
      else
        echo -e "${CYAN}$name${NC}"
      fi
      
      echo ""
    done
    
    return
  fi
  
  # Activate profile(s)
  profile_name="$subcommand"
  check_project_dir
  
  # Handle combined profiles (e.g., frontend+security)
  if [[ "$profile_name" == *"+"* ]]; then
    IFS='+' read -ra PROFILES <<< "$profile_name"
    
    local all_agents=()
    for prof in "${PROFILES[@]}"; do
      local prof_file="$PROFILES_DIR/${prof}.json"
      if [[ ! -f "$prof_file" ]]; then
        print_error "Profile not found: $prof"
        exit 1
      fi
      
      if command -v jq &> /dev/null; then
        while IFS= read -r agent; do
          all_agents+=("$agent")
        done < <(jq -r '.agents[]' "$prof_file" 2>/dev/null)
      fi
    done
    
    # Remove duplicates
    local unique_agents=($(printf "%s\n" "${all_agents[@]}" | sort -u))
    
    echo "Activating combined profile: $profile_name"
    echo "Agents: ${#unique_agents[@]}"
    echo ""
    
    # Clear current agents
    rm -rf "$PROJECT_AGENTS_DIR"
    mkdir -p "$PROJECT_AGENTS_DIR"
    
    # Copy agents
    for agent in "${unique_agents[@]}"; do
      local source="$AGENTS_LIB/${agent}.md"
      if [[ -f "$source" ]]; then
        cp "$source" "$PROJECT_AGENTS_DIR/"
        echo -e "${GREEN}✓${NC} $agent"
      else
        print_warning "Agent not found: $agent"
      fi
    done
    
    # Update .ai-config
    if command -v jq &> /dev/null && [[ -f "$AI_CONFIG" ]]; then
      local temp=$(mktemp)
      local agents_json=$(printf '%s\n' "${unique_agents[@]}" | jq -R . | jq -s .)
      jq --arg prof "$profile_name" --argjson agents "$agents_json" \
        '.agents.profile = $prof | .agents.enabled = $agents' \
        "$AI_CONFIG" > "$temp" 2>/dev/null || true
      if [[ -s "$temp" ]]; then
        mv "$temp" "$AI_CONFIG"
      else
        rm "$temp"
      fi
    fi
    
    echo ""
    print_success "Profile activated: $profile_name"
    print_warning "Restart Claude Code to load agents"
    return
  fi
  
  # Single profile activation
  local profile_file="$PROFILES_DIR/${profile_name}.json"
  
  if [[ ! -f "$profile_file" ]]; then
    print_error "Profile not found: $profile_name"
    print_info "Use 'ai-agents profile list' to see available profiles"
    exit 1
  fi
  
  if ! command -v jq &> /dev/null; then
    print_error "jq is required for profile management"
    print_info "Install: brew install jq"
    exit 1
  fi
  
  local agents=($(jq -r '.agents[]' "$profile_file" 2>/dev/null))
  
  echo "Activating profile: $profile_name"
  echo "Agents: ${#agents[@]}"
  echo ""
  
  # Clear current agents
  rm -rf "$PROJECT_AGENTS_DIR"
  mkdir -p "$PROJECT_AGENTS_DIR"
  
  # Copy agents from library
  for agent in "${agents[@]}"; do
    local source="$AGENTS_LIB/${agent}.md"
    if [[ -f "$source" ]]; then
      cp "$source" "$PROJECT_AGENTS_DIR/"
      echo -e "${GREEN}✓${NC} $agent"
    else
      print_warning "Agent not found: $agent"
    fi
  done
  
  # Update .ai-config
  if [[ -f "$AI_CONFIG" ]]; then
    local temp=$(mktemp)
    local agents_json=$(printf '%s\n' "${agents[@]}" | jq -R . | jq -s .)
    jq --arg prof "$profile_name" --argjson agents "$agents_json" \
      '.agents.profile = $prof | .agents.enabled = $agents' \
      "$AI_CONFIG" > "$temp" 2>/dev/null || true
    if [[ -s "$temp" ]]; then
      mv "$temp" "$AI_CONFIG"
    else
      rm "$temp"
    fi
  fi
  
  echo ""
  print_success "Profile activated: $profile_name"
  print_warning "Restart Claude Code to load agents"
}

#
# COMMAND: stats
#
cmd_stats() {
  check_project_dir
  
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  📊 Agent Statistics${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  local profile=$(get_active_profile)
  echo "Perfil Ativo: $profile"
  
  if [[ ! -d "$PROJECT_AGENTS_DIR" ]]; then
    print_warning "No agents directory found"
    return
  fi
  
  local count=0
  local total_tokens=0
  local limit=15000
  
  echo ""
  printf "%-30s %10s %8s\n" "Agent" "Tokens" "Status"
  printf "%-30s %10s %8s\n" "$(printf '─%.0s' {1..30})" "$(printf '─%.0s' {1..10})" "$(printf '─%.0s' {1..8})"
  
  for agent_file in "$PROJECT_AGENTS_DIR"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
      continue
    fi
    
    local filename=$(basename "$agent_file" .md)
    local size=$(wc -c < "$agent_file" | tr -d ' ')
    local tokens=$((size / 4))
    total_tokens=$((total_tokens + tokens))
    
    printf "%-30s %10s    ✓\n" "$filename" "$(format_number $tokens)"
    count=$((count + 1))
  done
  
  echo ""
  printf "%-30s %10s\n" "$(printf '─%.0s' {1..30})" "$(printf '─%.0s' {1..10})"
  echo ""
  
  echo "Total de Agentes: $count"
  
  local percent=$((total_tokens * 100 / limit))
  echo "Tokens Estimados: $(format_number $total_tokens) / $(format_number $limit) ($percent%)"
  
  echo ""
  
  if [[ $total_tokens -gt $limit ]]; then
    print_warning "⚠  Token usage exceeds recommended limit!"
    print_info "Consider using a lighter profile or disabling some agents"
  elif [[ $total_tokens -gt $((limit * 80 / 100)) ]]; then
    print_warning "Token usage is high (>80%)"
  else
    print_success "💡 Dica: Você está dentro do limite recomendado!"
  fi
}

#
# COMMAND: suggest
#
cmd_suggest() {
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Agent Profile Suggestion${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  check_project_dir
  
  echo "Analyzing project..."
  echo ""
  
  local suggestions=()
  local confidence=0
  
  # Check for frontend frameworks
  if [[ -f "package.json" ]]; then
    if grep -q "react\|next" package.json 2>/dev/null; then
      suggestions+=("frontend")
      confidence=$((confidence + 20))
      echo -e "${GREEN}✓${NC} Detected: React/Next.js → ${CYAN}frontend${NC} profile"
    fi
    
    if grep -q "express\|fastify\|koa" package.json 2>/dev/null; then
      suggestions+=("backend")
      confidence=$((confidence + 20))
      echo -e "${GREEN}✓${NC} Detected: Node.js backend → ${CYAN}backend${NC} profile"
    fi
  fi
  
  # Check for Python backend
  if [[ -f "requirements.txt" ]]; then
    if grep -q "fastapi\|flask\|django" requirements.txt 2>/dev/null; then
      suggestions+=("backend")
      confidence=$((confidence + 20))
      echo -e "${GREEN}✓${NC} Detected: Python backend → ${CYAN}backend${NC} profile"
    fi
    
    if grep -q "pandas\|numpy\|scikit" requirements.txt 2>/dev/null; then
      suggestions+=("data")
      confidence=$((confidence + 15))
      echo -e "${GREEN}✓${NC} Detected: Data science libs → ${CYAN}data${NC} profile"
    fi
    
    if grep -q "tensorflow\|pytorch\|transformers" requirements.txt 2>/dev/null; then
      suggestions+=("ai-ml")
      confidence=$((confidence + 20))
      echo -e "${GREEN}✓${NC} Detected: ML libraries → ${CYAN}ai-ml${NC} profile"
    fi
  fi
  
  # Check for mobile
  if [[ -f "ios/Podfile" ]] || [[ -f "android/build.gradle" ]]; then
    suggestions+=("mobile")
    confidence=$((confidence + 25))
    echo -e "${GREEN}✓${NC} Detected: Mobile project → ${CYAN}mobile${NC} profile"
  fi
  
  # Check for DevOps
  if [[ -f "Dockerfile" ]] || [[ -d "k8s" ]] || [[ -d "kubernetes" ]]; then
    suggestions+=("devops")
    confidence=$((confidence + 15))
    echo -e "${GREEN}✓${NC} Detected: Containers/K8s → ${CYAN}devops${NC} profile"
  fi
  
  if ls *.tf &> /dev/null || [[ -d "terraform" ]]; then
    suggestions+=("devops")
    confidence=$((confidence + 15))
    echo -e "${GREEN}✓${NC} Detected: Terraform → ${CYAN}devops${NC} profile"
  fi
  
  echo ""
  
  # Remove duplicates
  local unique_suggestions=($(printf "%s\n" "${suggestions[@]}" | sort -u))
  
  if [[ ${#unique_suggestions[@]} -eq 0 ]]; then
    print_info "Could not detect project type"
    echo "Suggested default: ${CYAN}minimal${NC}"
    echo ""
    echo "Available profiles: frontend, backend, fullstack, mobile, devops, data, ai-ml"
    return
  fi
  
  if [[ ${#unique_suggestions[@]} -eq 1 ]]; then
    echo -e "${BOLD}Recommendation:${NC} ${CYAN}${unique_suggestions[0]}${NC} profile"
  elif [[ ${#unique_suggestions[@]} -eq 2 ]]; then
    # Combine two profiles
    local combined="${unique_suggestions[0]}+${unique_suggestions[1]}"
    echo -e "${BOLD}Recommendation:${NC} ${CYAN}$combined${NC} (combined profile)"
  else
    # Check if frontend+backend detected
    if printf '%s\n' "${unique_suggestions[@]}" | grep -q "frontend" && \
       printf '%s\n' "${unique_suggestions[@]}" | grep -q "backend"; then
      echo -e "${BOLD}Recommendation:${NC} ${CYAN}fullstack${NC} profile"
    else
      echo -e "${BOLD}Recommendations:${NC}"
      for sug in "${unique_suggestions[@]}"; do
        echo "  - ${CYAN}$sug${NC}"
      done
    fi
  fi
  
  echo ""
  echo "Confidence: $confidence%"
  echo ""
  echo "To activate: ${BOLD}ai-agents profile <name>${NC}"
}

#
# COMMAND: doctor
#
cmd_doctor() {
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  🏥 Agent System Diagnostics${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  local errors=0
  
  # Check global library
  if [[ -d "$AGENTS_LIB" ]]; then
    local agent_count=$(find "$AGENTS_LIB" -name "*.md" -type f | wc -l | tr -d ' ')
    print_success "Biblioteca global existe (~/.ai-workspace/agents/)"
    print_success "$agent_count agentes disponíveis"
  else
    print_error "Biblioteca global não encontrada"
    errors=$((errors + 1))
  fi
  
  # Check profiles
  if [[ -d "$PROFILES_DIR" ]]; then
    local profile_count=$(find "$PROFILES_DIR" -name "*.json" -type f | wc -l | tr -d ' ')
    print_success "$profile_count perfis configurados"
  else
    print_error "Diretório de perfis não encontrado"
    errors=$((errors + 1))
  fi
  
  # Check agent index
  if [[ -f "$AGENT_INDEX" ]]; then
    print_success "agent-index.json válido"
  else
    print_warning "agent-index.json não encontrado"
  fi
  
  # Check project-specific
  if [[ -f "$AI_CONFIG" ]]; then
    print_success ".ai-config válido"
    
    if [[ -d "$PROJECT_AGENTS_DIR" ]]; then
      local active_count=$(find "$PROJECT_AGENTS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
      print_success ".claude/agents/ existe"
      print_success "$active_count agentes ativos"
      
      # Check tokens
      local tokens=$(calculate_tokens)
      local limit=15000
      local percent=$((tokens * 100 / limit))
      
      if [[ $tokens -gt $limit ]]; then
        print_error "Tokens: $(format_number $tokens) / $(format_number $limit) (OVER LIMIT)"
        errors=$((errors + 1))
      elif [[ $tokens -gt $((limit * 80 / 100)) ]]; then
        print_warning "Tokens: $(format_number $tokens) / $(format_number $limit) (HIGH)"
      else
        print_success "Tokens: $(format_number $tokens) / $(format_number $limit) (OK)"
      fi
    else
      print_warning ".claude/agents/ não existe (nenhum agente ativo)"
    fi
  else
    print_info "Não em um projeto AI (sem .ai-config)"
  fi
  
  # Check jq
  if command -v jq &> /dev/null; then
    print_success "jq instalado"
  else
    print_warning "jq não instalado (funcionalidade limitada)"
    print_info "Install: brew install jq"
  fi
  
  echo ""
  
  if [[ $errors -eq 0 ]]; then
    print_success "${BOLD}Tudo funcionando corretamente!${NC}"
  else
    print_error "${BOLD}$errors problema(s) encontrado(s)${NC}"
    print_info "Run 'ai-update' para corrigir problemas de instalação"
  fi
}

#
# COMMAND: info
#
cmd_info() {
  local agent_name="$1"
  
  if [[ -z "$agent_name" ]]; then
    print_error "Agent name required"
    echo "Usage: ai-agents info <agent-name>"
    exit 1
  fi
  
  local agent_file="$AGENTS_LIB/${agent_name}.md"
  
  if [[ ! -f "$agent_file" ]]; then
    print_error "Agent not found: $agent_name"
    exit 1
  fi
  
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Agent Information${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  local name=$(grep -m1 "^name:" "$agent_file" | sed 's/name: *//' || echo "$agent_name")
  local desc=$(grep -m1 "^description:" "$agent_file" | sed 's/description: *//' | head -c 200 || echo "")
  local size=$(wc -c < "$agent_file" | tr -d ' ')
  local tokens=$((size / 4))
  
  echo "Name: ${CYAN}$name${NC}"
  echo "ID: $agent_name"
  echo "Size: $(format_number $size) bytes"
  echo "Tokens: ~$(format_number $tokens)"
  echo ""
  
  if [[ -n "$desc" ]]; then
    echo "Description:"
    echo "$desc"
    echo ""
  fi
  
  # Check if active
  if [[ -f "$PROJECT_AGENTS_DIR/${agent_name}.md" ]]; then
    print_success "Status: ACTIVE"
  else
    print_info "Status: Available (not active)"
  fi
}

#
# COMMAND: search
#
cmd_search() {
  local keyword="$1"
  
  if [[ -z "$keyword" ]]; then
    print_error "Search keyword required"
    echo "Usage: ai-agents search <keyword>"
    exit 1
  fi
  
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Search Results: \"$keyword\"${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  local count=0
  
  for agent_file in "$AGENTS_LIB"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
      continue
    fi
    
    local filename=$(basename "$agent_file" .md)
    
    # Search in filename, name, and description
    if grep -qi "$keyword" "$agent_file" 2>/dev/null; then
      local name=$(grep -m1 "^name:" "$agent_file" | sed 's/name: *//' || echo "$filename")
      local desc=$(grep -m1 "^description:" "$agent_file" | sed 's/description: *//' | head -c 60 || echo "")
      
      echo -e "${CYAN}$name${NC}"
      echo "  ID: $filename"
      if [[ -n "$desc" ]]; then
        echo "  $desc..."
      fi
      echo ""
      
      count=$((count + 1))
    fi
  done
  
  if [[ $count -eq 0 ]]; then
    print_warning "No agents found matching: $keyword"
  else
    echo -e "${BOLD}Found: $count agent(s)${NC}"
  fi
}

#
# COMMAND: reset
#
cmd_reset() {
  check_project_dir
  
  echo "Resetting to minimal profile..."
  
  cmd_profile "minimal"
}

#
# COMMAND: update
#
cmd_update() {
  echo "Updating agent library..."
  echo ""
  
  local repo_dir=$(jq -r '.repo_path // ""' "$WORKSPACE_DIR/config.json" 2>/dev/null || echo "")
  
  if [[ -z "$repo_dir" ]] || [[ ! -d "$repo_dir" ]]; then
    print_error "Repository path not found in config"
    print_info "Re-run install.sh to fix"
    exit 1
  fi
  
  # Copy agents
  if [[ -d "$repo_dir/agents-list" ]]; then
    cp -r "$repo_dir/agents-list/"*.md "$AGENTS_LIB/" 2>/dev/null || true
    print_success "Updated agents from repository"
  fi
  
  # Copy profiles
  if [[ -d "$repo_dir/config/agent-profiles" ]]; then
    cp -r "$repo_dir/config/agent-profiles/"*.json "$PROFILES_DIR/" 2>/dev/null || true
    print_success "Updated profiles"
  fi
  
  # Regenerate index
  if [[ -x "$repo_dir/bin/generate-agent-index.sh" ]]; then
    "$repo_dir/bin/generate-agent-index.sh" "$AGENTS_LIB" "$AGENT_INDEX" > /dev/null 2>&1 || true
    print_success "Regenerated agent index"
  fi
  
  echo ""
  print_success "Agent library updated!"
  print_info "To update active agents, run: ai-agents profile <name>"
}

#
# COMMAND: explain
#
cmd_explain() {
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  Sistema de Gerenciamento de Agentes${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  
  echo -e "${BOLD}${CYAN}O que são Agentes?${NC}"
  echo "Agentes são especialistas em áreas específicas (frontend, backend, security, etc)"
  echo "que Claude pode usar para resolver problemas complexos."
  echo ""
  
  echo -e "${BOLD}${CYAN}Como Funciona:${NC}"
  echo ""
  echo -e "${GREEN}1. Biblioteca Global${NC}"
  echo "   • 45 agentes disponíveis em: ${CYAN}$AGENTS_LIB${NC}"
  echo "   • Sempre disponíveis para ativação"
  echo ""
  
  echo -e "${GREEN}2. Agentes por Projeto${NC}"
  echo "   • Apenas agentes do perfil ativo são copiados"
  echo "   • Ficam em: ${CYAN}.claude/agents/${NC}"
  echo "   • Claude Code lê automaticamente"
  echo ""
  
  echo -e "${GREEN}3. Perfis${NC}"
  echo "   • 11 perfis pré-definidos"
  echo "   • Cada perfil tem 2-5 agentes otimizados"
  echo "   • Exemplos: frontend, backend, fullstack, mobile, devops"
  echo ""
  
  echo -e "${BOLD}${CYAN}Benefícios:${NC}"
  echo ""
  echo -e "  ${GREEN}✓${NC} ${BOLD}Performance:${NC} 60-70% menos tokens (34k → 8-12k)"
  echo -e "  ${GREEN}✓${NC} ${BOLD}Organização:${NC} Apenas agentes relevantes por projeto"
  echo -e "  ${GREEN}✓${NC} ${BOLD}Flexibilidade:${NC} Troca de perfil quando necessário"
  echo -e "  ${GREEN}✓${NC} ${BOLD}Controle:${NC} Ativa/desativa agentes individualmente"
  echo ""
  
  echo -e "${BOLD}${CYAN}Arquivos de Contexto:${NC}"
  echo ""
  echo -e "${YELLOW}1. Configuração Global${NC}"
  echo "   ${CYAN}~/.claude/CLAUDE.md${NC}"
  echo "   • Instruções globais sobre sistema de agentes"
  echo "   • Claude lê em todos os projetos"
  echo ""
  
  echo -e "${YELLOW}2. Agentes Ativos (por projeto)${NC}"
  echo "   ${CYAN}.claude/agents/*.md${NC}"
  echo "   • Apenas agentes do perfil ativo"
  echo "   • Claude lê automaticamente"
  echo ""
  
  echo -e "${YELLOW}3. Contexto Compartilhado${NC}"
  echo "   ${CYAN}.ai-context/project-status.md${NC}"
  echo "   • Compartilhado entre Claude, Gemini, Codex"
  echo "   • Use para comunicação entre AIs"
  echo ""
  
  echo -e "${YELLOW}4. Referência Completa${NC}"
  echo "   ${CYAN}~/workspace/primavera/ai-terminal-agent/definitions.md${NC}"
  echo "   • Mapeamento completo de todos os 45 agentes"
  echo "   • Quando usar cada agente"
  echo ""
  
  echo -e "${BOLD}${CYAN}Workflow Básico:${NC}"
  echo ""
  echo "  1. ${GREEN}ai-start${NC}              - Menu interativo, escolhe perfil"
  echo "  2. ${GREEN}ai-agents active${NC}      - Ver agentes ativos"
  echo "  3. ${GREEN}ai-agents enable <nome>${NC} - Ativar agente adicional"
  echo "  4. ${GREEN}ai-agents stats${NC}       - Monitorar uso de tokens"
  echo "  5. ${GREEN}ai-agents profile <nome>${NC} - Trocar perfil"
  echo ""
  
  echo -e "${BOLD}${CYAN}Mais Informações:${NC}"
  echo ""
  echo "  ${CYAN}ai-tips sharing${NC}     - Como AIs compartilham contexto"
  echo "  ${CYAN}ai-agents help${NC}      - Todos os comandos"
  echo "  ${CYAN}ai-agents list${NC}      - Ver todos os 45 agentes"
  echo "  ${CYAN}ai-agents suggest${NC}   - Sugestão baseada no projeto"
  echo ""
}

#
# MAIN
#
main() {
  local command="${1:-help}"
  shift || true
  
  case "$command" in
    list)
      cmd_list "$@"
      ;;
    active)
      cmd_active
      ;;
    enable)
      cmd_enable "$@"
      ;;
    disable)
      cmd_disable "$@"
      ;;
    profile)
      cmd_profile "$@"
      ;;
    stats)
      cmd_stats
      ;;
    suggest)
      cmd_suggest
      ;;
    doctor)
      cmd_doctor
      ;;
    info)
      cmd_info "$@"
      ;;
    search)
      cmd_search "$@"
      ;;
    reset)
      cmd_reset
      ;;
    update)
      cmd_update
      ;;
    explain)
      cmd_explain
      ;;
    help|--help|-h)
      cat << 'EOF'
ai-agents - Agent Management System

USAGE:
  ai-agents <command> [options]

COMMANDS:
  list [--category <cat>]   List all available agents
  active                    Show active agents in current project
  enable <name>             Enable an agent
  disable <name>            Disable an agent
  search <keyword>          Search agents by keyword
  
  profile [list]            Show current profile or list all profiles
  profile <name>            Activate a profile
  profile <p1>+<p2>         Combine multiple profiles
  reset                     Reset to minimal profile
  
  stats                     Show detailed token statistics
  suggest                   Suggest profile based on project
  doctor                    Run diagnostics
  info <name>               Show agent information
  update                    Update agent library
  explain                   Explain the agent management system
  
  help                      Show this help

EXAMPLES:
  ai-agents list
  ai-agents enable test-automator
  ai-agents profile fullstack
  ai-agents profile frontend+security
  ai-agents stats
  ai-agents suggest

For more information: ai-help agents
EOF
      ;;
    *)
      print_error "Unknown command: $command"
      echo "Use 'ai-agents help' for usage"
      exit 1
      ;;
  esac
}

main "$@"

