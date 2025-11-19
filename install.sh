#!/bin/bash
# AI Terminal Agent - Installation Script
# Version: 1.0.0

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

  print_success "Directories created"
  echo ""
}

# 5. Pre-install check
pre_install_check() {
  local errors=0
  
  # Verificar se diretório bin existe
  if [[ ! -d "$BIN_DIR" ]]; then
    echo "📁 Creating $BIN_DIR..."
    if ! mkdir -p "$BIN_DIR" 2>/dev/null; then
      print_error "Failed to create $BIN_DIR"
      print_info "Try: mkdir -p $BIN_DIR"
      ((errors++))
    fi
  fi
  
  # Verificar permissão de escrita
  if [[ ! -w "$BIN_DIR" ]]; then
    print_warning "No write permission in $BIN_DIR"
    print_info "Installation will continue, but you may need sudo"
  fi
  
  # Verificar se há conflitos (comandos já existentes)
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

  # List of scripts to symlink
  local scripts=(
    "ai-workspace-launcher.sh:ai-start"
    "ai-stop.sh:ai-stop"
    "ai-status.sh:ai-status"
    "ai-recent.sh:ai-recent"
    "ai-recover.sh:ai-recover"
    "ai-diff.sh:ai-diff"
    "ai-update.sh:ai-update"
    "ai-help.sh:ai-help"
    "ai-health-check.sh:ai-health-check"
    "ai-git-config.sh:ai-git-config"
    "ai-export.sh:ai-export"
    "ai-import.sh:ai-import"
    "ai-tips.sh:ai-tips"
    "ai-agents.sh:ai-agents"
    "ai-agents-setup-interactive.sh:ai-agents-setup-interactive"
    "ai-agents-activate.sh:ai-agents-activate"
    "ai-context-init.sh:ai-context-init"
    "ai-context-check.sh:ai-context-check"
    "ai-quick.sh:ai-quick"
    "generate-project-claude.sh:generate-project-claude"
    "generate-project-gemini.sh:generate-project-gemini"
    "generate-project-codex.sh:generate-project-codex"
    "generate-daily-summary.sh:generate-daily-summary"
  )

  for script_pair in "${scripts[@]}"; do
    local source="${script_pair%%:*}"
    local target="${script_pair##*:}"

    # Remove existing symlink or file
    rm -f "$BIN_DIR/$target"

    # Create symlink
    ln -sf "$REPO_DIR/bin/$source" "$BIN_DIR/$target"
  done

  # Make all scripts executable
  chmod +x "$REPO_DIR"/bin/*.sh 2>/dev/null || true

  print_success "Symlinks created"
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

# 7. Setup Agent Management System
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
  echo "{\"repo_path\": \"$REPO_DIR\", \"version\": \"1.0.0\", \"installed_at\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" > "$config_file"

  print_success "Repository location saved"
  echo ""
}

# 10. Run health check
run_health_check() {
  echo "🏥 Running health check..."
  echo ""

  # Only run if ai-health-check exists
  if [[ -x "$REPO_DIR/bin/ai-health-check.sh" ]]; then
    "$BIN_DIR/ai-health-check" || true
  else
    print_warning "ai-health-check.sh not found yet (will be available after creating all scripts)"
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
  echo "   ai-start"
  echo ""
  echo "📖 Full documentation:"
  echo "   ai-help"
  echo ""
  echo "🔧 Repository location:"
  echo "   $REPO_DIR"
  echo ""
  echo "💡 To edit scripts:"
  echo "   cd $REPO_DIR"
  echo "   # Edit files in bin/"
  echo "   # Changes take effect immediately (symlinks)"
  echo ""
  echo "🔄 To update:"
  echo "   ai-update"
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
  create_symlinks
  install_templates
  setup_agents
  setup_git_ignore
  update_zshrc
  save_repo_location
  run_health_check
  show_quickstart
}

# Run installation
main "$@"
