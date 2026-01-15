#!/bin/bash
# AI Terminal Agent - Installation Script
# Version: 2.0.0

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get repository directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$HOME/bin"
TEMPLATES_DIR="$HOME/templates/ai-contexts"
WORKSPACE_DIR="$HOME/.ai-workspace"

# Print colored output
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }

echo ""
echo "🚀 AI Terminal Agent - Installation"
echo "═══════════════════════════════════"
echo "Repository: $REPO_DIR"
echo ""

# 1. Check dependencies
check_dependencies() {
  echo "📋 Checking dependencies..."

  # Check macOS
  if [[ "$(uname -s)" != "Darwin" ]]; then
    print_error "This tool requires macOS"
    exit 1
  fi
  print_success "macOS detected"

  # Check iTerm2
  if [[ ! -d "/Applications/iTerm.app" ]]; then
    print_warning "iTerm2 not found at /Applications/iTerm.app"
    print_info "Download from: https://iterm2.com/"
  else
    print_success "iTerm2 installed"
  fi

  # Check Git
  if ! command -v git &> /dev/null; then
    print_error "Git is required but not installed"
    print_info "Install via: xcode-select --install"
    exit 1
  fi
  print_success "Git installed"

  # Check jq
  if ! command -v jq &> /dev/null; then
    print_warning "jq not found (recommended for JSON parsing)"
    print_info "Install via: brew install jq"
  else
    print_success "jq installed"
  fi

  echo ""
}

# 2. Configure iTerm2 key binding (Shift+Enter)
setup_iterm_keybinding() {
  echo "🔧 Configuring iTerm2 key bindings..."

  if command -v /terminal-setup &> /dev/null; then
    /terminal-setup > /dev/null 2>&1 || true
    print_success "Shift+Enter configured"
  else
    print_warning "/terminal-setup not found"
    print_info "Configure manually: iTerm2 → Preferences → Keys"
    print_info "Add: Shift+Enter → Send Text: \\n"
  fi

  echo ""
}

# 3. Check AI CLIs
check_ai_clis() {
  echo "🤖 Checking AI CLIs..."

  # Check Claude
  if command -v claude &> /dev/null; then
    print_success "Claude CLI installed"
  else
    print_warning "Claude CLI not found"
    print_info "Install: npm install -g @anthropic-ai/claude-code"
  fi

  # Check Gemini
  if command -v gemini &> /dev/null; then
    print_success "Gemini CLI installed"
  else
    print_warning "Gemini CLI not found"
    print_info "Install: npm install -g @google/generative-ai"
  fi

  # Check Codex (or OpenAI CLI)
  if command -v codex &> /dev/null || command -v openai &> /dev/null; then
    print_success "Codex/OpenAI CLI installed"
  else
    print_warning "Codex CLI not found"
    print_info "Install: npm install -g @openai/codex"
  fi

  echo ""
}

# 4. Create directory structure
create_directories() {
  echo "📁 Creating directories..."

  mkdir -p "$BIN_DIR"
  mkdir -p "$TEMPLATES_DIR"
  mkdir -p "$WORKSPACE_DIR"/{sessions,backups,summaries/daily,summaries/weekly}
  mkdir -p "$WORKSPACE_DIR/config"
  mkdir -p "$WORKSPACE_DIR/templates/context"
  mkdir -p "$WORKSPACE_DIR/lib"

  print_success "Directories created"
  echo ""
}

# Install shared library
install_lib() {
  echo "📚 Installing shared library..."
  
  if [[ -f "$REPO_DIR/lib/common.sh" ]]; then
    cp "$REPO_DIR/lib/common.sh" "$WORKSPACE_DIR/lib/"
    chmod +x "$WORKSPACE_DIR/lib/common.sh"
    print_success "lib/common.sh installed"
  else
    print_warning "lib/common.sh not found in repo"
  fi
  
  echo ""
}

# 5. Pre-install check
pre_install_check() {
  local errors=0
  
  # Check if bin directory exists
  if [[ ! -d "$BIN_DIR" ]]; then
    echo "📁 Creating $BIN_DIR..."
    if ! mkdir -p "$BIN_DIR" 2>/dev/null; then
      print_error "Failed to create $BIN_DIR"
      print_info "Try: mkdir -p $BIN_DIR"
      ((errors++))
    fi
  fi
  
  # Check write permission
  if [[ ! -w "$BIN_DIR" ]]; then
    print_warning "No write permission in $BIN_DIR"
    print_info "Installation will continue, but you may need sudo"
  fi
  
  # Check for conflicts (commands already existing)
  local conflicts=()
  for cmd in ai-start ai-stop ai-quick ai-context-check; do
    if command -v "$cmd" &>/dev/null; then
      local existing_path=$(which "$cmd")
      if [[ "$existing_path" != "$BIN_DIR/$cmd" ]]; then
        conflicts+=("$cmd ($existing_path)")
      fi
    fi
  done
  
  if [[ ${#conflicts[@]} -gt 0 ]]; then
    print_warning "Commands already exist in different location:"
    for conflict in "${conflicts[@]}"; do
      echo "  • $conflict"
    done
    echo ""
    read -p "Overwrite? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Installation cancelled by user"
      exit 0
    fi
  fi
  
  if [[ $errors -gt 0 ]]; then
    print_error "Pre-install check failed: $errors error(s)"
    exit 1
  fi
}

# 6. Create symlinks in ~/bin/
create_symlinks() {
  echo "🔗 Creating symlinks in ~/bin/..."

  # Main unified CLI entry point
  rm -f "$BIN_DIR/ai"
  ln -sf "$REPO_DIR/bin/ai" "$BIN_DIR/ai"
  chmod +x "$REPO_DIR/bin/ai"
  print_success "ai (unified CLI)"

  # Consolidated modules
  local scripts=(
    "ai-workspace.sh:ai-workspace"
    "ai-context.sh:ai-context"
    "ai-config.sh:ai-config"
    "ai-help-unified.sh:ai-help"
    "ai-agents.sh:ai-agents"
    "generate-project.sh:generate-project"
    "ai-agents-setup-interactive.sh:ai-agents-setup-interactive"
    "ai-agents-activate.sh:ai-agents-activate"
    "generate-agent-index.sh:generate-agent-index"
    "generate-daily-summary.sh:generate-daily-summary"
    "ai-stack-detect.sh:ai-stack-detect"
    "ai-stop.sh:ai-stop"
  )

  for script_pair in "${scripts[@]}"; do
    local source="${script_pair%%:*}"
    local target="${script_pair##*:}"
    rm -f "$BIN_DIR/$target"
    ln -sf "$REPO_DIR/bin/$source" "$BIN_DIR/$target"
  done
  print_success "All modules linked"

  # Make all scripts executable
  chmod +x "$REPO_DIR"/bin/*.sh 2>/dev/null || true
  chmod +x "$REPO_DIR"/bin/ai 2>/dev/null || true
  chmod +x "$REPO_DIR"/lib/*.sh 2>/dev/null || true

  print_success "All symlinks created"
  echo ""
}

# 6. Install templates (copy, not symlink, to allow customization)
install_templates() {
  echo "📝 Installing templates..."

  # Copy templates only if they don't exist
  for template in "$REPO_DIR"/templates/*.md; do
    local basename="$(basename "$template")"
    if [[ ! -f "$TEMPLATES_DIR/$basename" ]]; then
      cp "$template" "$TEMPLATES_DIR/"
    fi
  done

  print_success "Templates installed"
  echo ""
}

# Install stack detection rules
install_stack_rules() {
  echo "📋 Installing stack detection rules..."
  
  local config_dir="$WORKSPACE_DIR/config"
  mkdir -p "$config_dir"
  
  if [[ -f "$REPO_DIR/config/stack-rules.json" ]]; then
    cp "$REPO_DIR/config/stack-rules.json" "$config_dir/"
    print_success "Stack rules installed"
  else
    print_warning "stack-rules.json not found"
  fi
  
  echo ""
}

# Install context templates
install_context_templates() {
  echo "📝 Installing context templates..."
  
  local context_templates_dir="$WORKSPACE_DIR/templates/context"
  mkdir -p "$context_templates_dir"
  
  # Copy NEW context templates only (not deprecated ones)
  local new_templates=(
    "ai-handoff.md"
    "code-landmarks.md"
    "todo-template.md"
    "stack-config.md"
    "decisions.md"
    "agents-reference.md"
    "ai-workflows.md"
  )
  
  for template in "${new_templates[@]}"; do
    if [[ -f "$REPO_DIR/templates/context/$template" ]]; then
      cp "$REPO_DIR/templates/context/$template" "$context_templates_dir/"
    fi
  done
  
  # Copy solution template
  if [[ -f "$REPO_DIR/templates/solution-template.md" ]]; then
    cp "$REPO_DIR/templates/solution-template.md" "$WORKSPACE_DIR/templates/"
  fi
  
  # NOTE: These files are DEPRECATED and not copied:
  # - current-task.md (replaced by todos/)
  # - known-issues.md (replaced by todos/ with [bug] tag)
  # - roadmap.md (replaced by todos/ with p3)
  # - project-status.md (replaced by ai-handoff.md)
  
  print_success "Context templates installed"
  echo ""
}

# 7. Install shell completion
install_completion() {
  echo "⌨️  Installing shell completion..."

  if [[ -f "$REPO_DIR/config/ai-completion.zsh" ]]; then
    cp "$REPO_DIR/config/ai-completion.zsh" "$WORKSPACE_DIR/ai-completion.zsh"
    print_success "Shell completion installed"
  else
    print_warning "Completion file not found"
  fi

  echo ""
}

# 8. Setup Agent Management System
setup_agents() {
  echo "🤖 Setting up Agent Management System..."
  
  local agents_dir="$WORKSPACE_DIR/agents"
  local profiles_dir="$WORKSPACE_DIR/agent-profiles"
  
  # Create directories
  mkdir -p "$agents_dir"
  mkdir -p "$profiles_dir"
  
  # Copy agents from agents-list/ to global library
  if [[ -d "$REPO_DIR/agents-list" ]]; then
    cp -r "$REPO_DIR/agents-list/"*.md "$agents_dir/" 2>/dev/null || true
    local agent_count=$(find "$agents_dir" -name "*.md" -type f | wc -l | tr -d ' ')
    print_success "Copied $agent_count agents to library"
  else
    print_warning "agents-list/ not found, skipping agent copy"
  fi
  
  # Copy agent profiles
  if [[ -d "$REPO_DIR/config/agent-profiles" ]]; then
    cp -r "$REPO_DIR/config/agent-profiles/"*.json "$profiles_dir/" 2>/dev/null || true
    local profile_count=$(find "$profiles_dir" -name "*.json" -type f | wc -l | tr -d ' ')
    print_success "Installed $profile_count agent profiles"
  else
    print_warning "config/agent-profiles/ not found, skipping profiles"
  fi
  
  # Generate agent index
  if [[ -x "$REPO_DIR/bin/generate-agent-index.sh" ]] && [[ -d "$agents_dir" ]]; then
    "$REPO_DIR/bin/generate-agent-index.sh" "$agents_dir" "$WORKSPACE_DIR/agent-index.json" > /dev/null 2>&1 || true
    if [[ -f "$WORKSPACE_DIR/agent-index.json" ]]; then
      print_success "Generated agent index"
    fi
  fi
  
  # Setup global CLAUDE.md
  local claude_dir="$HOME/.claude"
  mkdir -p "$claude_dir"
  
  if [[ -f "$REPO_DIR/templates/claude-global.md" ]]; then
    cp "$REPO_DIR/templates/claude-global.md" "$claude_dir/CLAUDE.md"
    print_success "Configured global CLAUDE.md"
  fi
  
  echo ""
}

# 8. Configure Git Global Ignore
setup_git_ignore() {
  echo "📦 Configuring Git global ignore..."

  local gitignore_global="$HOME/.gitignore_global"

  if [[ ! -f "$gitignore_global" ]]; then
    cp "$REPO_DIR/config/gitignore_global.template" "$gitignore_global"
    print_success "~/.gitignore_global created"
  else
    print_info "~/.gitignore_global already exists (not overwriting)"
  fi

  # Configure git to use it
  git config --global core.excludesfile "$gitignore_global"
  print_success "Git global ignore configured"

  echo ""
}

# 8. Update .zshrc (if necessary)
update_zshrc() {
  echo "🐚 Updating .zshrc..."

  local zshrc="$HOME/.zshrc"

  # Check if already configured
  if grep -q "AI Terminal Agent" "$zshrc" 2>/dev/null; then
    print_info ".zshrc already configured"
  else
    # Add configuration
    echo "" >> "$zshrc"
    cat "$REPO_DIR/config/zshrc.snippet" >> "$zshrc"
    print_success ".zshrc updated"
    print_info "Restart shell or run: source ~/.zshrc"
  fi

  echo ""
}

# 9. Save repository location
save_repo_location() {
  echo "💾 Saving repository location..."

  local config_file="$WORKSPACE_DIR/config.json"
  echo "{\"repo_path\": \"$REPO_DIR\", \"version\": \"2.0.0\", \"installed_at\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" > "$config_file"

  print_success "Repository location saved"
  echo ""
}

# 10. Run health check
run_health_check() {
  echo "🏥 Running health check..."
  echo ""

  # Run health check via unified CLI
  if [[ -x "$REPO_DIR/bin/ai-config.sh" ]]; then
    "$REPO_DIR/bin/ai-config.sh" doctor || true
  else
    print_info "Health check will be available after installation"
  fi
}

# 11. Show quick start guide
show_quickstart() {
  echo ""
  echo "✅ Installation Complete!"
  echo "═══════════════════════════════════"
  echo ""
  echo "📚 Quick Start:"
  echo "   cd ~/your-project"
  echo "   ai start                    # Start workspace"
  echo "   ai status                   # Check status"
  echo "   ai stop                     # Close workspace"
  echo ""
  echo "📖 Commands:"
  echo "   ai workspace ...            # Workspace management"
  echo "   ai agents ...               # Agent management"
  echo "   ai context ...              # Context management"
  echo "   ai config ...               # Configuration"
  echo "   ai help [topic]             # Help"
  echo ""
  echo "📖 Full documentation:"
  echo "   ai help"
  echo ""
  echo "🔧 Repository:"
  echo "   $REPO_DIR"
  echo ""
  echo "🔄 To update:"
  echo "   ai config update"
  echo ""

  # Check if PATH includes ~/bin
  if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    print_warning "~/bin is not in your PATH"
    print_info "Restart your shell or run: source ~/.zshrc"
  fi

  echo ""
}

# Main installation flow
main() {
  check_dependencies
  pre_install_check
  setup_iterm_keybinding
  check_ai_clis
  create_directories
  install_lib
  create_symlinks
  install_templates
  install_stack_rules
  install_context_templates
  install_completion
  setup_agents
  setup_git_ignore
  update_zshrc
  save_repo_location
  run_health_check
  show_quickstart
}

# Run installation
main "$@"
