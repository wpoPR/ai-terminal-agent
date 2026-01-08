#!/bin/bash
# ai-config.sh - Unified configuration management
# Version: 2.0.0
#
# Consolidates: ai-health-check.sh, ai-git-config.sh, ai-export.sh, ai-import.sh, ai-update.sh

# Source common library if not already loaded
if [[ -z "${_AI_COMMON_LOADED:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
fi

# Configuration file paths
GITIGNORE_GLOBAL="$HOME/.gitignore_global"
CONFIG_FILE="$AI_WORKSPACE_DIR/config.json"

# =============================================================================
# HEALTH CHECK (DOCTOR)
# =============================================================================

cmd_doctor() {
  local checks_passed=0
  local checks_failed=0
  local checks_warning=0

  _check_pass() {
    print_success "$1"
    ((checks_passed++))
  }

  _check_fail() {
    print_error "$1"
    ((checks_failed++))
  }

  _check_warn() {
    print_warning "$1"
    ((checks_warning++))
  }

  print_header "AI Workspace Health Check"
  echo ""

  # 1. System checks
  echo "System:"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    _check_pass "macOS detected ($(sw_vers -productVersion 2>/dev/null || echo 'unknown'))"
  else
    _check_warn "Not running on macOS (some features may not work)"
  fi

  if [[ -d "/Applications/iTerm.app" ]]; then
    _check_pass "iTerm2 installed"
  else
    _check_warn "iTerm2 not found at /Applications/iTerm.app"
  fi

  echo ""

  # 2. AI CLIs
  echo "AI CLIs:"

  if command -v claude &> /dev/null; then
    _check_pass "Claude CLI installed"
  else
    _check_fail "Claude CLI not installed (npm install -g @anthropic-ai/claude-code)"
  fi

  if command -v gemini &> /dev/null; then
    _check_pass "Gemini CLI installed"
  else
    _check_warn "Gemini CLI not installed"
  fi

  if command -v codex &> /dev/null || command -v openai &> /dev/null; then
    _check_pass "Codex/OpenAI CLI installed"
  else
    _check_warn "Codex CLI not installed"
  fi

  echo ""

  # 3. Git configuration
  echo "Git Configuration:"

  if git config --global core.excludesfile &> /dev/null; then
    local excludefile=$(git config --global core.excludesfile)
    _check_pass "Git global ignore configured"

    if [[ -f "$excludefile" ]]; then
      _check_pass "~/.gitignore_global exists"
    else
      _check_warn "Git global ignore file not found: $excludefile"
    fi
  else
    _check_fail "Git global ignore not configured (run: ai config git --setup)"
  fi

  echo ""

  # 4. Directory structure
  echo "Directory Structure:"

  if [[ -d "$AI_WORKSPACE_DIR" ]]; then
    _check_pass "~/.ai-workspace/ exists"

    for dir in sessions backups agents agent-profiles; do
      if [[ -d "$AI_WORKSPACE_DIR/$dir" ]]; then
        _check_pass "~/.ai-workspace/$dir/ exists"
      else
        _check_warn "~/.ai-workspace/$dir/ missing"
      fi
    done
  else
    _check_fail "~/.ai-workspace/ not found"
  fi

  echo ""

  # 5. Scripts and symlinks
  echo "Scripts:"

  if [[ -d "$HOME/bin" ]]; then
    _check_pass "~/bin/ directory exists"

    local scripts=("ai" "ai-agents" "ai-workspace" "ai-context" "ai-config")
    for script in "${scripts[@]}"; do
      if [[ -L "$HOME/bin/$script" ]] || [[ -f "$HOME/bin/$script" ]]; then
        _check_pass "$script available"
      else
        _check_warn "$script not found"
      fi
    done
  else
    _check_fail "~/bin/ not found"
  fi

  if [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    _check_pass "~/bin in PATH"
  else
    _check_warn "~/bin not in PATH (add to ~/.zshrc)"
  fi

  echo ""

  # 6. Repository
  echo "Repository:"

  if [[ -f "$CONFIG_FILE" ]]; then
    local repo_path=$(json_get "$CONFIG_FILE" ".repo_path" "")

    if [[ -d "$repo_path" ]]; then
      _check_pass "Repository found at: $repo_path"

      if [[ -d "$repo_path/.git" ]]; then
        _check_pass "Repository is a git repository"
      else
        _check_warn "Repository is not a git repository"
      fi
    else
      _check_fail "Repository not found at: $repo_path"
    fi
  else
    _check_warn "config.json not found"
  fi

  echo ""

  # Summary
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Summary:"
  echo -e "  ${GREEN}✓${NC} Passed: $checks_passed"
  [[ $checks_warning -gt 0 ]] && echo -e "  ${YELLOW}⚠${NC}  Warnings: $checks_warning"
  [[ $checks_failed -gt 0 ]] && echo -e "  ${RED}✗${NC} Failed: $checks_failed"
  echo ""

  if [[ $checks_failed -eq 0 && $checks_warning -eq 0 ]]; then
    echo -e "${GREEN}Status: All systems operational${NC}"
    return 0
  elif [[ $checks_failed -eq 0 ]]; then
    echo -e "${YELLOW}Status: System operational with warnings${NC}"
    return 0
  else
    echo -e "${RED}Status: Issues detected${NC}"
    echo ""
    echo "Required actions:"
    echo "  - Fix failed checks above"
    echo "  - Re-run: ai config doctor"
    return 1
  fi
}

# =============================================================================
# GIT CONFIGURATION
# =============================================================================

cmd_git() {
  local command="${1:-status}"

  case "$command" in
    --show|show)
      if [[ -f "$GITIGNORE_GLOBAL" ]]; then
        cat "$GITIGNORE_GLOBAL"
      else
        echo "File not found: $GITIGNORE_GLOBAL"
      fi
      ;;

    --setup|setup)
      echo "Setting up Git global ignore..."

      local repo_path=$(json_get "$CONFIG_FILE" ".repo_path" "")

      if [[ -n "$repo_path" ]] && [[ -f "$repo_path/config/gitignore_global.template" ]]; then
        cp "$repo_path/config/gitignore_global.template" "$GITIGNORE_GLOBAL"
        print_success "Created ~/.gitignore_global"
      else
        # Create default gitignore
        cat > "$GITIGNORE_GLOBAL" << 'EOF'
# AI Terminal Agent - Global Git Ignore

# AI workspace files
.ai-workspace-active
.ai-config
.ai-sessions/
.ai-backups/

# Claude Code
.claude/

# Gemini
.gemini/

# Codex
.codex/

# AI context (optional - uncomment to ignore)
# .ai-context/

# OS files
.DS_Store
.Spotlight-V100
.Trashes
Thumbs.db
EOF
        print_success "Created default ~/.gitignore_global"
      fi

      git config --global core.excludesfile "$GITIGNORE_GLOBAL"
      print_success "Git configured"
      echo ""
      echo "Global ignore is now active for all repositories"
      ;;

    --check|check)
      local excludefile=$(git config --global core.excludesfile 2>/dev/null || echo "")

      if [[ -n "$excludefile" ]] && [[ -f "$excludefile" ]]; then
        print_success "Git global ignore configured and working"
        return 0
      else
        print_error "Git global ignore not properly configured"
        echo "  Run: ai config git --setup"
        return 1
      fi
      ;;

    status|*)
      print_header "Git Global Ignore Status"
      echo ""

      local excludefile=$(git config --global core.excludesfile 2>/dev/null || echo "")

      if [[ -n "$excludefile" ]]; then
        print_success "Git global ignore configured"
        echo "  File: $excludefile"

        if [[ -f "$excludefile" ]]; then
          print_success "File exists"
          echo ""
          echo "Ignored patterns:"
          grep -v "^#" "$excludefile" | grep -v "^$" | sed 's/^/  - /'
        else
          print_error "File not found"
        fi
      else
        print_error "Git global ignore not configured"
        echo ""
        echo "Run: ai config git --setup"
      fi
      ;;
  esac
}

# =============================================================================
# EXPORT
# =============================================================================

cmd_export() {
  local output_file="${1:-$HOME/ai-terminal-agent-backup.tar.gz}"

  print_header "Exporting AI Terminal Agent"
  echo ""

  local repo_path=$(json_get "$CONFIG_FILE" ".repo_path" "")

  if [[ ! -d "$repo_path" ]]; then
    print_error "Repository not found: $repo_path"
    return 1
  fi

  echo "Creating backup..."
  echo "  Repository: $repo_path"
  echo "  Config: ~/.gitignore_global"
  echo ""

  # Create tarball
  tar -czf "$output_file" \
    -C "$(dirname "$repo_path")" "$(basename "$repo_path")" \
    -C "$HOME" ".gitignore_global" \
    2>/dev/null

  if [[ $? -eq 0 ]]; then
    print_success "Export complete!"
    echo "File: $output_file"
    echo ""
    echo "To import on another machine:"
    echo "  ai config import $output_file"
  else
    print_error "Export failed"
    return 1
  fi
}

# =============================================================================
# IMPORT
# =============================================================================

cmd_import() {
  local import_file="$1"
  local target_dir="$HOME/workspace/primavera"

  if [[ -z "$import_file" ]]; then
    echo "Usage: ai config import <backup-file.tar.gz>"
    return 1
  fi

  if [[ ! -f "$import_file" ]]; then
    print_error "File not found: $import_file"
    return 1
  fi

  print_header "Importing AI Terminal Agent"
  echo ""
  echo "File: $import_file"
  echo ""

  # Create target directory
  mkdir -p "$target_dir"

  # Extract
  echo "Extracting files..."
  tar -xzf "$import_file" -C "$target_dir"

  # Find repository
  local repo_path="$target_dir/ai-terminal-agent"

  if [[ ! -d "$repo_path" ]]; then
    print_error "Repository not found in archive"
    return 1
  fi

  print_success "Files extracted"
  echo ""

  # Run installation
  echo "Running installation..."
  cd "$repo_path"
  ./install.sh

  echo ""
  print_success "Import complete!"
  echo "Repository: $repo_path"
}

# =============================================================================
# UPDATE
# =============================================================================

cmd_update() {
  print_header "Updating AI Terminal Agent"
  echo ""

  local repo_path=$(json_get "$CONFIG_FILE" ".repo_path" "")

  if [[ ! -d "$repo_path" ]]; then
    print_error "Repository not found: $repo_path"
    return 1
  fi

  echo "Repository: $repo_path"
  cd "$repo_path" || return 1

  if [[ ! -d ".git" ]]; then
    print_warning "Not a git repository"
    echo "Cannot update automatically"
    return 1
  fi

  # Check for uncommitted changes
  if [[ -n $(git status -s) ]]; then
    print_warning "You have uncommitted changes:"
    git status -s
    echo ""

    if [[ -t 0 ]]; then
      read -p "Stash changes and update? (y/n) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash
        print_success "Changes stashed"
      else
        echo "Update cancelled"
        return 0
      fi
    fi
  fi

  # Pull updates
  echo "Pulling updates..."
  if git pull; then
    echo ""
    print_success "Update complete!"
    echo ""
    echo "Recent changes:"
    git log --oneline -5
    echo ""

    # Re-apply permissions
    chmod +x bin/*.sh 2>/dev/null || true
    chmod +x bin/ai 2>/dev/null || true

    print_success "All scripts updated and ready to use"
  else
    print_error "Update failed"
    return 1
  fi
}

# =============================================================================
# MAIN ROUTER
# =============================================================================

config_main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    doctor|health|check) cmd_doctor "$@" ;;
    git)                 cmd_git "$@" ;;
    export)              cmd_export "$@" ;;
    import)              cmd_import "$@" ;;
    update)              cmd_update "$@" ;;
    help|--help|-h)
      cat << 'EOF'
ai config - Configuration management

USAGE
    ai config <command> [options]

COMMANDS
    doctor               Run health check diagnostics
    git [option]         Manage git global ignore
        --setup          Configure git to ignore AI files
        --show           Show current gitignore contents
        --check          Check if configured correctly
    export [file]        Export configuration to tarball
    import <file>        Import configuration from tarball
    update               Update AI Terminal Agent from git

EXAMPLES
    ai config doctor              # Check installation health
    ai config git --setup         # Setup git ignore
    ai config export              # Create backup
    ai config import backup.tar.gz
    ai config update              # Update from git

EOF
      ;;
    *)
      print_error "Unknown config command: $command"
      echo "Run 'ai config help' for usage"
      exit 1
      ;;
  esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  config_main "$@"
fi
