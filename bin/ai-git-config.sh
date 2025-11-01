#!/bin/bash
# ai-git-config.sh - Manage git global ignore configuration
# Version: 1.0.0

COMMAND="${1:-}"
GITIGNORE_GLOBAL="$HOME/.gitignore_global"

show_status() {
  echo "Git Global Ignore Status"
  echo "════════════════════════"
  echo ""

  # Check if configured
  local excludefile=$(git config --global core.excludesfile 2>/dev/null || echo "")

  if [[ -n "$excludefile" ]]; then
    echo "✓ Git global ignore configured"
    echo "  File: $excludefile"

    if [[ -f "$excludefile" ]]; then
      echo "✓ File exists"
      echo ""
      echo "Ignored patterns:"
      grep -v "^#" "$excludefile" | grep -v "^$" | sed 's/^/  - /'
    else
      echo "✗ File not found"
    fi
  else
    echo "✗ Git global ignore not configured"
    echo ""
    echo "Run: ai-git-config --setup"
  fi
}

show_file() {
  if [[ -f "$GITIGNORE_GLOBAL" ]]; then
    cat "$GITIGNORE_GLOBAL"
  else
    echo "File not found: $GITIGNORE_GLOBAL"
  fi
}

setup() {
  echo "Setting up Git global ignore..."

  # Get repository path
  local repo_path=$(jq -r '.repo_path' "$HOME/.ai-workspace/config.json" 2>/dev/null || echo "")

  if [[ -n "$repo_path" ]] && [[ -f "$repo_path/config/gitignore_global.template" ]]; then
    cp "$repo_path/config/gitignore_global.template" "$GITIGNORE_GLOBAL"
    echo "✓ Created ~/.gitignore_global"
  else
    echo "✗ Template not found"
    exit 1
  fi

  # Configure git
  git config --global core.excludesfile "$GITIGNORE_GLOBAL"
  echo "✓ Git configured"
  echo ""
  echo "Global ignore is now active for all repositories"
}

check() {
  local excludefile=$(git config --global core.excludesfile 2>/dev/null || echo "")

  if [[ -n "$excludefile" ]] && [[ -f "$excludefile" ]]; then
    echo "✓ Git global ignore configured and working"
    return 0
  else
    echo "✗ Git global ignore not properly configured"
    echo "  Run: ai-git-config --setup"
    return 1
  fi
}

case "$COMMAND" in
  --show)
    show_file
    ;;
  --setup)
    setup
    ;;
  --check)
    check
    ;;
  *)
    show_status
    ;;
esac
