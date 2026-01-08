#!/bin/bash
# common.sh - Shared functions for AI Terminal Agent
# Version: 2.0.0
# This file is sourced by all ai-* commands

# Prevent multiple sourcing
[[ -n "${_AI_COMMON_LOADED:-}" ]] && return
_AI_COMMON_LOADED=1

# =============================================================================
# COLORS & FORMATTING
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# =============================================================================
# OUTPUT HELPERS
# =============================================================================

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1" >&2; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }
print_debug() { [[ -n "${AI_DEBUG:-}" ]] && echo -e "${DIM}[DEBUG]${NC} $1" >&2; }

print_header() {
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  $1${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_subheader() {
  echo ""
  echo -e "${BOLD}${CYAN}▸ $1${NC}"
  echo ""
}

# =============================================================================
# DIRECTORY CONSTANTS
# =============================================================================

AI_WORKSPACE_DIR="${AI_WORKSPACE_DIR:-$HOME/.ai-workspace}"
AI_AGENTS_LIB="$AI_WORKSPACE_DIR/agents"
AI_PROFILES_DIR="$AI_WORKSPACE_DIR/agent-profiles"
AI_SESSIONS_DIR="$AI_WORKSPACE_DIR/sessions"
AI_AGENT_INDEX="$AI_WORKSPACE_DIR/agent-index.json"

# Project-level directories
AI_PROJECT_AGENTS_DIR=".claude/agents"
AI_PROJECT_CONFIG=".ai-config"
AI_PROJECT_CONTEXT=".ai-context"

# Script location
AI_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AI_BIN_DIR="$AI_SCRIPT_DIR/bin"
AI_LIB_DIR="$AI_SCRIPT_DIR/lib"
AI_TEMPLATES_DIR="$AI_SCRIPT_DIR/templates"

# =============================================================================
# VALIDATION HELPERS
# =============================================================================

# Check if in a project directory with .ai-config
check_project_dir() {
  if [[ ! -f "$AI_PROJECT_CONFIG" ]]; then
    print_error "Not in a project directory (no .ai-config found)"
    print_info "Run 'ai start' first to initialize the project"
    return 1
  fi
}

# Check if workspace is initialized
check_workspace() {
  if [[ ! -d "$AI_WORKSPACE_DIR" ]]; then
    print_error "AI workspace not initialized"
    print_info "Run the installer first: ./install.sh"
    return 1
  fi
}

# Check required dependencies
check_dependencies() {
  local missing=()

  for cmd in "$@"; do
    if ! command -v "$cmd" &> /dev/null; then
      missing+=("$cmd")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    print_error "Missing dependencies: ${missing[*]}"
    return 1
  fi
}

# =============================================================================
# JSON HELPERS (with jq fallback)
# =============================================================================

# Check if jq is available
has_jq() {
  command -v jq &> /dev/null
}

# Get JSON value (with fallback for no jq)
json_get() {
  local file="$1"
  local path="$2"
  local default="${3:-}"

  if [[ ! -f "$file" ]]; then
    echo "$default"
    return
  fi

  if has_jq; then
    jq -r "$path // \"$default\"" "$file" 2>/dev/null || echo "$default"
  else
    # Basic grep fallback for simple paths like .key
    local key="${path#.}"
    grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$file" 2>/dev/null | \
      head -1 | cut -d'"' -f4 || echo "$default"
  fi
}

# Get JSON array as lines
json_array() {
  local file="$1"
  local path="$2"

  if [[ ! -f "$file" ]]; then
    return
  fi

  if has_jq; then
    jq -r "$path[]? // empty" "$file" 2>/dev/null
  else
    # Basic grep fallback
    local key="${path#.}"
    grep -o "\"$key\"[[:space:]]*:[[:space:]]*\[[^]]*\]" "$file" 2>/dev/null | \
      sed 's/.*\[//; s/\].*//; s/"//g; s/,/\n/g' | tr -d ' '
  fi
}

# Set JSON value (requires jq)
json_set() {
  local file="$1"
  local path="$2"
  local value="$3"

  if ! has_jq; then
    print_error "jq is required for this operation"
    return 1
  fi

  local tmp=$(mktemp)
  jq "$path = $value" "$file" > "$tmp" && mv "$tmp" "$file"
}

# =============================================================================
# CONFIG HELPERS
# =============================================================================

# Get active profile from .ai-config
get_active_profile() {
  json_get "$AI_PROJECT_CONFIG" ".agents.profile" "none"
}

# Get enabled agents from .ai-config
get_enabled_agents() {
  json_array "$AI_PROJECT_CONFIG" ".agents.enabled"
}

# Get project name
get_project_name() {
  json_get "$AI_PROJECT_CONFIG" ".project" "$(basename "$(pwd)")"
}

# Get project type
get_project_type() {
  json_get "$AI_PROJECT_CONFIG" ".type" "general"
}

# =============================================================================
# TOKEN CALCULATION
# =============================================================================

# Calculate tokens from agent files (1 token ≈ 4 chars)
calculate_tokens() {
  local dir="${1:-$AI_PROJECT_AGENTS_DIR}"
  local total=0

  if [[ -d "$dir" ]]; then
    for agent in "$dir"/*.md; do
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

# Get token status color
token_status_color() {
  local tokens=$1
  local limit=${2:-15000}

  if [[ $tokens -lt $((limit * 60 / 100)) ]]; then
    echo "${GREEN}"
  elif [[ $tokens -lt $((limit * 80 / 100)) ]]; then
    echo "${YELLOW}"
  else
    echo "${RED}"
  fi
}

# =============================================================================
# FILE HELPERS
# =============================================================================

# Create directory if not exists
ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

# Safe file copy (checks source exists)
safe_copy() {
  local src="$1"
  local dst="$2"

  if [[ -f "$src" ]]; then
    cp "$src" "$dst"
    return 0
  else
    print_warning "Source file not found: $src"
    return 1
  fi
}

# Get file age in seconds
file_age() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local now=$(date +%s)
    local mtime=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
    echo $((now - mtime))
  else
    echo 0
  fi
}

# =============================================================================
# SESSION HELPERS
# =============================================================================

# Get current session ID
get_session_id() {
  local session_file=".ai-workspace-active"
  if [[ -f "$session_file" ]]; then
    cat "$session_file"
  fi
}

# Check if workspace is active
is_workspace_active() {
  [[ -f ".ai-workspace-active" ]]
}

# =============================================================================
# TERMINAL HELPERS
# =============================================================================

# Check if running in iTerm2
is_iterm() {
  [[ "$TERM_PROGRAM" == "iTerm.app" ]]
}

# Set terminal title
set_title() {
  local title="$1"
  echo -ne "\033]0;${title}\007"
}

# =============================================================================
# VERSION INFO
# =============================================================================

AI_VERSION="2.0.0"

get_version() {
  echo "$AI_VERSION"
}
