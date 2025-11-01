#!/bin/bash
# ai-health-check.sh - Verify AI Terminal Agent installation and configuration
# Version: 1.0.0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

check_pass() {
  echo -e "${GREEN}✓${NC} $1"
  ((CHECKS_PASSED++))
}

check_fail() {
  echo -e "${RED}✗${NC} $1"
  ((CHECKS_FAILED++))
}

check_warn() {
  echo -e "${YELLOW}⚠${NC}  $1"
  ((CHECKS_WARNING++))
}

echo ""
echo "🔍 AI Workspace Health Check"
echo "═══════════════════════════════════"
echo ""

# 1. System checks
echo "System:"

# macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
  check_pass "macOS detected ($(sw_vers -productVersion))"
else
  check_fail "Not running on macOS"
fi

# iTerm2
if [[ -d "/Applications/iTerm.app" ]]; then
  local iterm_version=$(/Applications/iTerm.app/Contents/MacOS/iTerm2 --version 2>/dev/null | head -n1 || echo "unknown")
  check_pass "iTerm2 installed"
else
  check_warn "iTerm2 not found at /Applications/iTerm.app"
fi

echo ""

# 2. iTerm2 key binding check
echo "iTerm2 Configuration:"

# Check for Shift+Enter binding (hex code 0xd-0x20000)
if defaults read com.googlecode.iterm2 2>/dev/null | grep -q "0xd-0x20000"; then
  check_pass "Shift+Enter key binding configured"
else
  check_warn "Shift+Enter key binding may not be configured"
  echo "   Run: /terminal-setup"
fi

echo ""

# 3. AI CLIs
echo "AI CLIs:"

# Claude
if command -v claude &> /dev/null; then
  local claude_version=$(claude --version 2>/dev/null | head -n1 || echo "unknown")
  check_pass "Claude CLI installed"

  # Check if authenticated
  if claude auth status &> /dev/null || [[ -f "$HOME/.config/claude/config.json" ]]; then
    check_pass "Claude authenticated"
  else
    check_warn "Claude may not be authenticated (run: claude auth login)"
  fi
else
  check_fail "Claude CLI not installed (npm install -g @anthropic-ai/claude-code)"
fi

# Gemini
if command -v gemini &> /dev/null; then
  check_pass "Gemini CLI installed"
else
  check_warn "Gemini CLI not installed (npm install -g @google/generative-ai)"
fi

# Codex/OpenAI
if command -v codex &> /dev/null || command -v openai &> /dev/null; then
  check_pass "Codex/OpenAI CLI installed"
else
  check_warn "Codex CLI not installed (npm install -g @openai/codex)"
fi

echo ""

# 4. Git configuration
echo "Git Configuration:"

# Global ignore
if git config --global core.excludesfile &> /dev/null; then
  local excludefile=$(git config --global core.excludesfile)
  check_pass "Git global ignore configured"

  if [[ -f "$excludefile" ]]; then
    check_pass "~/.gitignore_global exists"
  else
    check_warn "Git global ignore file not found: $excludefile"
  fi
else
  check_fail "Git global ignore not configured (run: ai-git-config --setup)"
fi

echo ""

# 5. Directory structure
echo "Directory Structure:"

if [[ -d "$HOME/.ai-workspace" ]]; then
  check_pass "~/.ai-workspace/ exists"

  # Check subdirectories
  for dir in sessions backups summaries/daily summaries/weekly; do
    if [[ -d "$HOME/.ai-workspace/$dir" ]]; then
      check_pass "~/.ai-workspace/$dir/ exists"
    else
      check_warn "~/.ai-workspace/$dir/ missing"
    fi
  done
else
  check_fail "~/.ai-workspace/ not found"
fi

if [[ -d "$HOME/templates/ai-contexts" ]]; then
  local template_count=$(ls -1 "$HOME/templates/ai-contexts"/*.md 2>/dev/null | wc -l | tr -d ' ')
  check_pass "Templates installed ($template_count templates)"
else
  check_warn "Templates directory not found"
fi

echo ""

# 6. Scripts and symlinks
echo "Scripts:"

if [[ -d "$HOME/bin" ]]; then
  check_pass "~/bin/ directory exists"

  # Check key scripts
  local scripts=("ai-start" "ai-stop" "ai-status" "ai-help")
  for script in "${scripts[@]}"; do
    if [[ -L "$HOME/bin/$script" ]]; then
      local target=$(readlink "$HOME/bin/$script")
      if [[ -f "$target" ]]; then
        check_pass "$script symlink valid"
      else
        check_fail "$script symlink broken (target: $target)"
      fi
    elif [[ -f "$HOME/bin/$script" ]]; then
      check_pass "$script exists"
    else
      check_fail "$script not found"
    fi
  done
else
  check_fail "~/bin/ not found"
fi

# Check if ~/bin is in PATH
if [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
  check_pass "~/bin in PATH"
else
  check_warn "~/bin not in PATH (add to ~/.zshrc)"
fi

echo ""

# 7. Repository
echo "Repository:"

if [[ -f "$HOME/.ai-workspace/config.json" ]]; then
  local repo_path=$(jq -r '.repo_path' "$HOME/.ai-workspace/config.json" 2>/dev/null || echo "")

  if [[ -d "$repo_path" ]]; then
    check_pass "Repository found at: $repo_path"

    # Check if it's a git repo
    if [[ -d "$repo_path/.git" ]]; then
      check_pass "Repository is a git repository"
    else
      check_warn "Repository is not a git repository"
    fi
  else
    check_fail "Repository not found at: $repo_path"
  fi
else
  check_warn "config.json not found"
fi

echo ""

# 8. Summary
echo "═══════════════════════════════════"
echo "Summary:"
echo -e "  ${GREEN}✓${NC} Passed: $CHECKS_PASSED"
if [[ $CHECKS_WARNING -gt 0 ]]; then
  echo -e "  ${YELLOW}⚠${NC}  Warnings: $CHECKS_WARNING"
fi
if [[ $CHECKS_FAILED -gt 0 ]]; then
  echo -e "  ${RED}✗${NC} Failed: $CHECKS_FAILED"
fi
echo ""

if [[ $CHECKS_FAILED -eq 0 && $CHECKS_WARNING -eq 0 ]]; then
  echo -e "${GREEN}Status: ✅ All systems operational${NC}"
  echo ""
  echo "TIPS:"
  echo "  - Use 'ai-start' to launch a workspace"
  echo "  - Run 'ai-help' for full documentation"
  exit 0
elif [[ $CHECKS_FAILED -eq 0 ]]; then
  echo -e "${YELLOW}Status: ⚠️  System operational with warnings${NC}"
  echo ""
  echo "RECOMMENDATIONS:"
  [[ $CHECKS_WARNING -gt 0 ]] && echo "  - Review warnings above"
  echo "  - Run 'ai-help' for more information"
  exit 0
else
  echo -e "${RED}Status: ❌ Issues detected${NC}"
  echo ""
  echo "REQUIRED ACTIONS:"
  echo "  - Fix failed checks above"
  echo "  - Re-run: ai-health-check"
  echo "  - Or re-install: cd <repo> && ./install.sh"
  exit 1
fi
