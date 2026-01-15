#!/usr/bin/env bash
# ai-migrate.sh - Migrate project from old AI structure to new Multi-AI Bootstrap
set -euo pipefail

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$(dirname "$SCRIPT_DIR")/lib/common.sh" ]]; then
  source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
elif [[ -f "$HOME/.ai-workspace/lib/common.sh" ]]; then
  source "$HOME/.ai-workspace/lib/common.sh"
else
  # Minimal fallback
  print_header() { echo -e "\n=== $1 ===\n"; }
  print_success() { echo "✓ $1"; }
  print_warning() { echo "⚠ $1"; }
  print_error() { echo "✗ $1"; }
  print_info() { echo "ℹ $1"; }
fi

# =============================================================================
# CONFIGURATION
# =============================================================================

# Old files to remove (root level)
OLD_ROOT_FILES=(
  "CLAUDE.md"           # Old Claude config (now .claude/claude.md)
  "AGENTS.md"           # Old Codex config (now CODEX.md)
  "Claude.md"           # Alternative old name
  "Gemini.md"           # Alternative old name
)

# Old .ai-context files (deprecated structure)
OLD_CONTEXT_FILES=(
  "current-task.md"
  "known-issues.md"
  "project-status.md"
  "roadmap.md"
  "session-state.md"
  "code-index.json"
  "code-index.md"
)

# Files to PRESERVE during migration (will be copied back after)
PRESERVE_FILES=(
  "decisions.md"
  "agents-reference.md"
)

# Backup directory
BACKUP_DIR=".ai-migrate-backup-$(date +%Y%m%d_%H%M%S)"

# =============================================================================
# FUNCTIONS
# =============================================================================

show_help() {
  cat << 'EOF'
ai migrate - Migrate project to new Multi-AI Bootstrap structure

USAGE
    ai migrate [options]

DESCRIPTION
    Removes old AI configuration files and structures, then initializes
    the new Multi-AI Bootstrap system.

    Old files removed:
    - CLAUDE.md, AGENTS.md, Claude.md, Gemini.md (root level)
    - .ai-context/ old structure (current-task.md, known-issues.md, etc.)

    New structure created:
    - .claude/claude.md
    - GEMINI.md (new format)
    - CODEX.md (new format)
    - .ai-context/ (new Multi-AI structure)

OPTIONS
    --dry-run       Show what would be removed without making changes
    --no-backup     Skip backup (not recommended)
    --force         Skip confirmation prompt
    -h, --help      Show this help

EXAMPLES
    ai migrate              # Interactive migration with backup
    ai migrate --dry-run    # Preview changes
    ai migrate --force      # Non-interactive migration

EOF
}

detect_old_files() {
  local found=()
  
  # Check root level old files
  for file in "${OLD_ROOT_FILES[@]}"; do
    if [[ -f "$file" ]]; then
      found+=("$file")
    fi
  done
  
  # Check old .ai-context structure
  if [[ -d ".ai-context" ]]; then
    for file in "${OLD_CONTEXT_FILES[@]}"; do
      if [[ -f ".ai-context/$file" ]]; then
        found+=(".ai-context/$file")
      fi
    done
  fi
  
  # Check for old GEMINI.md format (without new keywords)
  if [[ -f "GEMINI.md" ]] && ! grep -q "!analyze codebase" "GEMINI.md" 2>/dev/null; then
    found+=("GEMINI.md (old format)")
  fi
  
  # Check for old .claude/claude.md format
  if [[ -f ".claude/claude.md" ]] && ! grep -q "!checkpoint" ".claude/claude.md" 2>/dev/null; then
    found+=(".claude/claude.md (old format)")
  fi
  
  echo "${found[@]}"
}

show_detected() {
  print_header "Detected Old Files"
  
  local has_old=false
  
  # Root level files
  for file in "${OLD_ROOT_FILES[@]}"; do
    if [[ -f "$file" ]]; then
      echo "  📄 $file"
      has_old=true
    fi
  done
  
  # Old .ai-context files
  if [[ -d ".ai-context" ]]; then
    for file in "${OLD_CONTEXT_FILES[@]}"; do
      if [[ -f ".ai-context/$file" ]]; then
        echo "  📄 .ai-context/$file"
        has_old=true
      fi
    done
  fi
  
  # Old format files (will be regenerated)
  if [[ -f "GEMINI.md" ]] && ! grep -q "!analyze codebase" "GEMINI.md" 2>/dev/null; then
    echo "  📄 GEMINI.md (old format - will be regenerated)"
    has_old=true
  fi
  
  if [[ -f "CODEX.md" ]] && ! grep -q "!document solution" "CODEX.md" 2>/dev/null; then
    echo "  📄 CODEX.md (old format - will be regenerated)"
    has_old=true
  fi
  
  if [[ -f ".claude/claude.md" ]] && ! grep -q "!checkpoint" ".claude/claude.md" 2>/dev/null; then
    echo "  📄 .claude/claude.md (old format - will be regenerated)"
    has_old=true
  fi
  
  echo ""
  
  if [[ "$has_old" == "false" ]]; then
    print_success "No old files detected - project may already be migrated"
    return 1
  fi
  
  return 0
}

create_backup() {
  print_info "Creating backup in $BACKUP_DIR/"
  
  mkdir -p "$BACKUP_DIR"
  
  # Backup root files
  for file in "${OLD_ROOT_FILES[@]}"; do
    if [[ -f "$file" ]]; then
      cp "$file" "$BACKUP_DIR/"
      print_success "Backed up $file"
    fi
  done
  
  # Backup AI config files (will be regenerated)
  for file in GEMINI.md CODEX.md; do
    if [[ -f "$file" ]]; then
      cp "$file" "$BACKUP_DIR/"
      print_success "Backed up $file"
    fi
  done
  
  # Backup .claude/claude.md
  if [[ -f ".claude/claude.md" ]]; then
    mkdir -p "$BACKUP_DIR/.claude"
    cp ".claude/claude.md" "$BACKUP_DIR/.claude/"
    print_success "Backed up .claude/claude.md"
  fi
  
  # Backup entire .ai-context if exists
  if [[ -d ".ai-context" ]]; then
    cp -r ".ai-context" "$BACKUP_DIR/"
    print_success "Backed up .ai-context/"
  fi
  
  echo ""
}

remove_old_files() {
  print_header "Removing Old Files"
  
  # Remove root level old files
  for file in "${OLD_ROOT_FILES[@]}"; do
    if [[ -f "$file" ]]; then
      rm "$file"
      print_success "Removed $file"
    fi
  done
  
  # Remove old AI configs (will be regenerated with new format)
  for file in GEMINI.md CODEX.md; do
    if [[ -f "$file" ]]; then
      rm "$file"
      print_success "Removed $file (will regenerate)"
    fi
  done
  
  # Remove old .claude/claude.md
  if [[ -f ".claude/claude.md" ]]; then
    rm ".claude/claude.md"
    print_success "Removed .claude/claude.md (will regenerate)"
  fi
  
  # Handle .ai-context - preserve important files
  if [[ -d ".ai-context" ]]; then
    local temp_preserve="/tmp/ai-migrate-preserve-$$"
    mkdir -p "$temp_preserve"
    
    # Save files to preserve
    for file in "${PRESERVE_FILES[@]}"; do
      if [[ -f ".ai-context/$file" ]]; then
        cp ".ai-context/$file" "$temp_preserve/"
        print_info "Preserving $file"
      fi
    done
    
    # Remove entire .ai-context
    rm -rf ".ai-context"
    print_success "Removed .ai-context/ (will recreate)"
    
    # Store temp path for later restoration
    TEMP_PRESERVE_DIR="$temp_preserve"
  fi
  
  echo ""
}

restore_preserved_files() {
  if [[ -n "${TEMP_PRESERVE_DIR:-}" ]] && [[ -d "$TEMP_PRESERVE_DIR" ]]; then
    print_info "Restoring preserved files..."
    
    for file in "${PRESERVE_FILES[@]}"; do
      if [[ -f "$TEMP_PRESERVE_DIR/$file" ]]; then
        # Only restore if the preserved file has content
        if [[ -s "$TEMP_PRESERVE_DIR/$file" ]]; then
          cp "$TEMP_PRESERVE_DIR/$file" ".ai-context/"
          print_success "Restored $file (with original content)"
        fi
      fi
    done
    
    # Cleanup
    rm -rf "$TEMP_PRESERVE_DIR"
  fi
}

run_ai_start() {
  print_header "Initializing New Structure"
  
  # Find ai-workspace command
  local ai_workspace=""
  
  if command -v ai-workspace &>/dev/null; then
    ai_workspace="ai-workspace"
  elif [[ -x "$HOME/bin/ai-workspace" ]]; then
    ai_workspace="$HOME/bin/ai-workspace"
  elif [[ -x "$(dirname "$SCRIPT_DIR")/bin/ai-workspace.sh" ]]; then
    ai_workspace="$(dirname "$SCRIPT_DIR")/bin/ai-workspace.sh"
  fi
  
  if [[ -n "$ai_workspace" ]]; then
    print_info "Running ai-start..."
    echo ""
    "$ai_workspace" start
    
    # Restore preserved files AFTER ai-start creates the new structure
    restore_preserved_files
  else
    print_warning "ai-workspace not found. Run manually:"
    echo ""
    echo "  ai-start"
    echo ""
  fi
}

# =============================================================================
# MAIN
# =============================================================================

main() {
  local dry_run=false
  local no_backup=false
  local force=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        shift
        ;;
      --no-backup)
        no_backup=true
        shift
        ;;
      --force)
        force=true
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
    esac
  done
  
  print_header "AI Project Migration"
  echo "Migrating to Multi-AI Bootstrap structure..."
  echo ""
  
  # Detect old files
  if ! show_detected; then
    exit 0
  fi
  
  # Dry run - just show what would happen
  if [[ "$dry_run" == "true" ]]; then
    print_header "Dry Run - No Changes Made"
    echo "Would remove the files listed above and run ai-start."
    echo ""
    echo "Run without --dry-run to execute migration."
    exit 0
  fi
  
  # Confirmation
  if [[ "$force" != "true" ]]; then
    echo "This will:"
    echo "  1. Backup old files to $BACKUP_DIR/"
    echo "  2. Remove old AI configuration files"
    echo "  3. Run ai-start to create new structure"
    echo ""
    read -p "Continue? [y/N] " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Migration cancelled"
      exit 0
    fi
  fi
  
  # Create backup unless disabled
  if [[ "$no_backup" != "true" ]]; then
    create_backup
  else
    print_warning "Skipping backup (--no-backup)"
    echo ""
  fi
  
  # Remove old files
  remove_old_files
  
  # Run ai-start
  run_ai_start
  
  print_header "Migration Complete!"
  
  if [[ "$no_backup" != "true" ]]; then
    echo "Backup saved to: $BACKUP_DIR/"
  fi
  
  echo ""
  echo "New structure created:"
  echo "  .claude/claude.md    # Claude config (TDD workflow)"
  echo "  GEMINI.md            # Gemini config (Analysis)"
  echo "  CODEX.md             # Codex config (Support/Docs)"
  echo "  .ai-context/         # Multi-AI context files"
  echo ""
  print_info "You can safely delete $BACKUP_DIR/ after verifying the migration."
}

main "$@"
