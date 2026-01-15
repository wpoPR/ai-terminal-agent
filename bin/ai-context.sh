#!/bin/bash
# ai-context.sh - Unified context management
# Version: 2.0.0
#
# Consolidates: ai-context-init.sh, ai-context-check.sh, ai-diff.sh, sync-contexts.sh

# Source common library if not already loaded
if [[ -z "${_AI_COMMON_LOADED:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # Try multiple locations for common.sh
  if [[ -f "$(dirname "$SCRIPT_DIR")/lib/common.sh" ]]; then
    source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
  elif [[ -f "$HOME/.ai-workspace/lib/common.sh" ]]; then
    source "$HOME/.ai-workspace/lib/common.sh"
  fi
fi

# Templates directory
TEMPLATES_DIR="$AI_WORKSPACE_DIR/templates/context"
CONTEXT_DIR=".ai-context"

# =============================================================================
# CONTEXT INIT (NEW STRUCTURE - Multi-AI Bootstrap)
# =============================================================================

cmd_init() {
  local force=false
  local silent=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --force) force=true; shift ;;
      --silent|-q) silent=true; shift ;;
      -h|--help) _init_help; return 0 ;;
      *) print_error "Unknown option: $1"; return 1 ;;
    esac
  done

  # Override print functions for silent mode
  if [[ "$silent" == "true" ]]; then
    _print_success() { :; }
    _print_info() { :; }
    _print_warning() { :; }
  else
    _print_success() { print_success "$1"; }
    _print_info() { print_info "$1"; }
    _print_warning() { print_warning "$1"; }
  fi

  # Header
  if [[ "$silent" != "true" ]]; then
    print_header "Initializing AI Context Structure"
    echo ""
  fi

  # Check if already initialized (with NEW structure)
  if [[ -d "$CONTEXT_DIR" ]] && [[ "$force" != "true" ]]; then
    if [[ -f "$CONTEXT_DIR/ai-handoff.md" ]] && [[ -d "$CONTEXT_DIR/todos" ]]; then
      if [[ "$silent" != "true" ]]; then
        print_success "Context structure already initialized (new format)"
        _print_info "Use --force to reinitialize"
      fi
      return 0
    fi
  fi

  # Create directory structure
  mkdir -p "$CONTEXT_DIR/todos"
  mkdir -p "$CONTEXT_DIR/backup"
  mkdir -p "docs/solutions"
  _print_success "Created directories"

  # Migrate old files to backup if they exist
  _migrate_old_files

  # Copy NEW context templates
  local new_templates=(
    "ai-handoff.md"
    "code-landmarks.md"
    "decisions.md"
    "agents-reference.md"
    "ai-workflows.md"
  )

  for file in "${new_templates[@]}"; do
    if [[ -f "$TEMPLATES_DIR/$file" ]]; then
      if [[ -f "$CONTEXT_DIR/$file" ]] && [[ "$force" != "true" ]]; then
        _print_warning "$file already exists, skipping"
      else
        cp "$TEMPLATES_DIR/$file" "$CONTEXT_DIR/"
        _print_success "$file"
      fi
    else
      # Create default if template missing
      _create_default_file "$file"
    fi
  done

  # Create session marker
  date +%s > "$CONTEXT_DIR/.session"

  # Show summary
  if [[ "$silent" != "true" ]]; then
    echo ""
    print_success "Context structure initialized!"
    echo ""
    echo "Structure created:"
    echo "  $CONTEXT_DIR/"
    echo "  ├── todos/           # File-based todo system"
    echo "  ├── backup/          # Migrated old files"
    echo "  ├── ai-handoff.md    # AI communication hub"
    echo "  ├── code-landmarks.md # Important code locations"
    echo "  ├── decisions.md     # Technical decisions"
    echo "  └── ai-workflows.md  # Multi-AI usage guide"
    echo ""
  fi
}

_migrate_old_files() {
  local backup_dir="$CONTEXT_DIR/backup"
  local migrated=false
  
  # Files to deprecate (old structure)
  local old_files=("current-task.md" "known-issues.md" "roadmap.md" "project-status.md")
  
  for file in "${old_files[@]}"; do
    if [[ -f "$CONTEXT_DIR/$file" ]]; then
      mv "$CONTEXT_DIR/$file" "$backup_dir/"
      migrated=true
    fi
  done
  
  if $migrated; then
    _print_warning "Migrated deprecated files to backup/"
    _print_info "- current-task.md → Use todos/ instead"
    _print_info "- known-issues.md → Use todos/ with [bug] tag"
    _print_info "- project-status.md → Use ai-handoff.md"
  fi
}

_create_default_file() {
  local file="$1"
  
  case "$file" in
    "ai-handoff.md")
      cat > "$CONTEXT_DIR/ai-handoff.md" << 'HANDOFF_EOF'
# AI Handoff

## Current State
- **Task:** (none)
- **Stack:** (run ai-stack-detect)
- **Last AI:** (none)
- **Updated:** (auto)

---

## Gemini Section
**Status:** idle

## Claude Section
**Status:** idle
**TDD Phase:** (none)

## Codex Section
**Status:** not-needed

---

## History
| Time | AI | Action | Result |
|------|-----|--------|--------|

## Session State
- **Phase:** not started
- **Completion:** 0%
HANDOFF_EOF
      _print_success "ai-handoff.md (default)"
      ;;
    "code-landmarks.md")
      cat > "$CONTEXT_DIR/code-landmarks.md" << 'LANDMARKS_EOF'
# Code Landmarks

*Updated by: Claude*
*Last updated: (not yet)*

## Entry Points
| Location | Purpose |
|----------|---------|
| (to be filled) | |

## Core Business Logic
| Location | Purpose |
|----------|---------|
| (to be filled) | |
LANDMARKS_EOF
      _print_success "code-landmarks.md (default)"
      ;;
    "decisions.md")
      cat > "$CONTEXT_DIR/decisions.md" << 'DECISIONS_EOF'
# Technical Decisions

## Template
```markdown
## YYYY-MM-DD: [Decision Title]
- **Decision:** [What]
- **Reason:** [Why]
- **Decided by:** [Claude/Gemini/Codex/User]
- **Status:** [Implemented/Pending]
```

---

## Decisions
(No decisions recorded yet)
DECISIONS_EOF
      _print_success "decisions.md (default)"
      ;;
    "ai-workflows.md")
      cat > "$CONTEXT_DIR/ai-workflows.md" << 'WORKFLOWS_EOF'
# Multi-AI Workflows Guide

> Quick reference for common development scenarios.

## Quick Legend
| AI | Role | When to Use |
|----|------|-------------|
| 🟡 Gemini | Analysis | Start tasks, analyze code |
| 🔵 Claude | Implementation | Write code, fix bugs |
| 🟢 Codex | Support | Docs, extra tests |

## Common Flows

### New Feature
1. Gemini: `!analyze task [description]`
2. Claude: Implement with TDD
3. Codex: `!update readme`

### Bug Fix
1. Gemini: `!analyze task Fix: [bug]`
2. Claude: TDD approach
3. Codex: `!document solution`

### Resume Work
Any AI: "Read .ai-context/ai-handoff.md and continue"

---
*Full guide at templates/context/ai-workflows.md*
WORKFLOWS_EOF
      _print_success "ai-workflows.md (default)"
      ;;
  esac
}

_init_help() {
  cat << 'EOF'
ai context init - Initialize AI Context Structure (Multi-AI Bootstrap)

USAGE
    ai context init [options]

OPTIONS
    --force           Recreate structure even if exists
    --silent, -q      Silent mode (no output)
    -h, --help        Show this help

NEW STRUCTURE CREATED
    .ai-context/
    ├── todos/              # File-based todo system (Gemini creates, Claude updates)
    ├── backup/             # Migrated old files
    ├── ai-handoff.md       # AI communication hub
    ├── code-landmarks.md   # Important code locations (Claude writes)
    ├── stack-config.md     # Auto-detected by ai-stack-detect
    └── decisions.md        # Technical decisions

    docs/solutions/         # Knowledge base (Codex writes)

MIGRATION
    Old files (current-task.md, known-issues.md, etc.) are automatically
    moved to .ai-context/backup/ when reinitializing.

EXAMPLES
    ai context init          # Initialize new structure
    ai context init --force  # Reinitialize and migrate old files

EOF
}

_create_context_readme() {
  cat > "$CONTEXT_DIR/README.md" << 'EOF'
# AI Context Directory

This directory contains shared context files for AI assistants (Claude, Gemini, Codex).

## Files

- **project-status.md** - Overview of project state, tech stack, and structure
- **current-task.md** - Active task tracking and implementation plan
- **decisions.md** - Technical decisions and architecture choices (ADR style)
- **known-issues.md** - Bugs, limitations, and technical debt
- **roadmap.md** - Future plans, milestones, and feature roadmap
- **agents-reference.md** - Quick reference of all available agents

## Usage by AIs

### Claude (Analysis & Architecture)
Read before: Analyzing code, planning features, making architectural decisions
Update after: Major refactoring, architectural changes, code reviews

### Gemini (Research & Agent Selection)
Read before: Researching libraries, writing documentation, comparing approaches
Special role: Analyzing tasks and activating optimal agents

### Codex (Implementation)
Read before: Starting implementation, writing code, creating components
Update after: Features completed, bugs fixed, code written

## Best Practices

1. Always read project-status.md first when starting work
2. Update current-task.md as you progress
3. Document decisions in decisions.md with rationale
4. Log bugs in known-issues.md as you discover them
5. Update roadmap.md when priorities change

---
*Managed by AI Terminal Agent*
EOF
}

_create_initial_prompts() {
  echo ""
  echo "Generating initial prompts for AIs..."
  echo ""

  mkdir -p "$CONTEXT_DIR/initial-prompts"

  # Claude prompt
  cat > "$CONTEXT_DIR/initial-prompts/claude-init.md" << 'EOF'
# Initial Prompt for Claude

Run this in the Claude console after `ai start`:

```
Please analyze this project and initialize the AI context files:

1. Read the project structure and key files
2. Fill in .ai-context/project-status.md with:
   - Project overview and description
   - Current state and completion estimate
   - Technical stack
   - Key files and structure

3. Create an initial entry in .ai-context/current-task.md
4. Document any technical decisions in .ai-context/decisions.md
5. List any obvious issues in .ai-context/known-issues.md
6. Create an initial roadmap in .ai-context/roadmap.md

Be thorough but concise.
```
EOF

  # Gemini prompt
  cat > "$CONTEXT_DIR/initial-prompts/gemini-init.md" << 'EOF'
# Initial Prompt for Gemini

Run this in the Gemini console after Claude has initialized:

```
Please read .ai-context/project-status.md to understand this project.

Then, help improve the documentation:

1. Review the project-status.md for any gaps
2. Research best practices for the tech stack mentioned
3. Add suggestions to .ai-context/roadmap.md
4. Note any questions in .ai-context/decisions.md

Keep your additions concise and actionable.
```
EOF

  print_success "initial-prompts/claude-init.md"
  print_success "initial-prompts/gemini-init.md"
}

# =============================================================================
# CONTEXT CHECK
# =============================================================================

cmd_check() {
  print_header "AI Context - Diagnostic"
  echo ""

  # SCENARIO 1: First time - nothing exists
  if [[ ! -d "$CONTEXT_DIR" ]]; then
    echo "SCENARIO: First time in this project"
    echo ""
    echo "ACTIONS NEEDED:"
    echo "  ai start    # Creates structure and detects stack"
    return 0
  fi

  # SCENARIO 2: Old structure detected (needs migration)
  if [[ -f "$CONTEXT_DIR/current-task.md" ]] && [[ ! -f "$CONTEXT_DIR/ai-handoff.md" ]]; then
    print_warning "SCENARIO: Old structure detected (pre-Multi-AI)"
    echo ""
    echo "Old files found:"
    [[ -f "$CONTEXT_DIR/current-task.md" ]] && echo "  - current-task.md"
    [[ -f "$CONTEXT_DIR/project-status.md" ]] && echo "  - project-status.md"
    [[ -f "$CONTEXT_DIR/known-issues.md" ]] && echo "  - known-issues.md"
    [[ -f "$CONTEXT_DIR/roadmap.md" ]] && echo "  - roadmap.md"
    echo ""
    echo "ACTION:"
    echo "  ai context init --force"
    echo "  (Old files will be moved to .ai-context/backup/)"
    return 0
  fi

  # SCENARIO 3: New structure but missing files
  if [[ ! -f "$CONTEXT_DIR/ai-handoff.md" ]] || [[ ! -d "$CONTEXT_DIR/todos" ]]; then
    print_warning "SCENARIO: Incomplete new structure"
    echo ""
    echo "MISSING:"
    [[ ! -f "$CONTEXT_DIR/ai-handoff.md" ]] && echo "  - ai-handoff.md"
    [[ ! -d "$CONTEXT_DIR/todos" ]] && echo "  - todos/ directory"
    [[ ! -f "$CONTEXT_DIR/stack-config.md" ]] && echo "  - stack-config.md (run ai-stack-detect)"
    echo ""
    echo "ACTION:"
    echo "  ai context init --force"
    return 0
  fi

  # SCENARIO 4: Ready but no stack detected
  if [[ ! -f "$CONTEXT_DIR/stack-config.md" ]]; then
    print_warning "SCENARIO: Stack not detected"
    echo ""
    echo "ACTION:"
    echo "  ai-stack-detect"
    return 0
  fi

  # SCENARIO 5: Everything working
  print_success "SCENARIO: System fully configured (Multi-AI)"
  echo ""

  local num_agents=$(_count_valid_agents)
  local num_todos=$(find "$CONTEXT_DIR/todos" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

  echo "STATUS:"
  echo "  - Structure: NEW (Multi-AI Bootstrap)"
  echo "  - Active agents: $num_agents"
  echo "  - Todos: $num_todos"
  [[ -f "$CONTEXT_DIR/stack-config.md" ]] && echo "  - Stack: detected"

  echo ""
  echo "USEFUL COMMANDS:"
  echo "  ai agents active    - See active agents and token usage"
  echo "  ai-stack-detect     - Re-detect project stack"
  echo "  ls $CONTEXT_DIR/todos/  - View todos"
}

_count_valid_agents() {
  local count=0
  local min_size=50

  shopt -s nullglob
  for agent_file in "$AI_PROJECT_AGENTS_DIR"/*.md; do
    [[ ! -f "$agent_file" ]] && continue
    local size=$(stat -f%z "$agent_file" 2>/dev/null || stat -c%s "$agent_file" 2>/dev/null)
    [[ $size -ge $min_size ]] && ((count++))
  done
  shopt -u nullglob

  echo $count
}

# =============================================================================
# CONTEXT SYNC
# =============================================================================

cmd_sync() {
  print_header "AI Context Sync"
  echo ""

  echo "Context sync helps maintain consistency between AI configuration files."
  echo ""

  # Check for context files
  local context_files=("claude.md" "gemini.md" "agents.md" "codex.md" "GEMINI.md" "AGENTS.md")
  local found_files=()

  for file in "${context_files[@]}"; do
    [[ -f "$file" ]] && found_files+=("$file")
  done

  if [[ ${#found_files[@]} -eq 0 ]]; then
    print_warning "No AI context files found in current directory"
    echo ""
    echo "Expected files: claude.md, GEMINI.md, AGENTS.md"
    echo ""
    echo "Run 'ai start' to generate these files"
    return 1
  fi

  echo "Found context files:"
  for file in "${found_files[@]}"; do
    local lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
    echo "  - $file ($lines lines)"
  done

  echo ""
  echo "Sync options:"
  echo "  1. Regenerate all AI config files"
  echo "  2. Copy .ai-context/ updates to all AIs (coming soon)"
  echo ""

  if [[ -t 0 ]]; then
    read -p "Select option (1-2): " choice

    case "$choice" in
      1)
        echo ""
        echo "Regenerating AI configuration files..."

        if [[ -x "$AI_BIN_DIR/generate-project.sh" ]]; then
          "$AI_BIN_DIR/generate-project.sh" claude .claude/claude.md 2>/dev/null && \
            print_success "Claude configuration regenerated"
          "$AI_BIN_DIR/generate-project.sh" gemini GEMINI.md 2>/dev/null && \
            print_success "GEMINI.md regenerated"
          "$AI_BIN_DIR/generate-project.sh" codex AGENTS.md 2>/dev/null && \
            print_success "AGENTS.md regenerated"
        else
          command -v generate-project-claude &>/dev/null && generate-project-claude .claude/claude.md
          command -v generate-project-gemini &>/dev/null && generate-project-gemini GEMINI.md
          command -v generate-project-codex &>/dev/null && generate-project-codex AGENTS.md
        fi
        ;;
      2)
        echo "This feature is coming soon"
        ;;
      *)
        echo "Invalid option"
        ;;
    esac
  fi
}

# =============================================================================
# CONTEXT DIFF
# =============================================================================

cmd_diff() {
  print_header "AI Context Diff"
  echo ""

  local context_files=("claude.md" "gemini.md" "agents.md" "codex.md" "GEMINI.md" "AGENTS.md")
  local found_files=()

  for file in "${context_files[@]}"; do
    [[ -f "$file" ]] && found_files+=("$file")
  done

  if [[ ${#found_files[@]} -eq 0 ]]; then
    echo "No context files found in current directory"
    return 1
  fi

  echo "Found context files:"
  for file in "${found_files[@]}"; do
    local lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
    echo "  - $file ($lines lines)"
  done

  echo ""
  echo "Options:"
  echo "  1. View differences between files"
  echo "  2. Merge files (coming soon)"
  echo ""

  if [[ -t 0 ]]; then
    read -p "Select option (1-2): " choice

    case "$choice" in
      1)
        if command -v diff &> /dev/null; then
          echo ""
          for ((i=0; i<${#found_files[@]}-1; i++)); do
            for ((j=i+1; j<${#found_files[@]}; j++)); do
              echo "Comparing ${found_files[$i]} vs ${found_files[$j]}:"
              echo "────────────────────────────────────"
              diff -u "${found_files[$i]}" "${found_files[$j]}" || true
              echo ""
            done
          done
        else
          print_error "diff command not available"
        fi
        ;;
      2)
        echo "Merge feature coming soon"
        ;;
      *)
        echo "Invalid option"
        ;;
    esac
  fi
}

# =============================================================================
# MAIN ROUTER
# =============================================================================

context_main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    init)  cmd_init "$@" ;;
    check) cmd_check "$@" ;;
    sync)  cmd_sync "$@" ;;
    diff)  cmd_diff "$@" ;;
    help|--help|-h)
      cat << 'EOF'
ai context - Manage shared AI context (Multi-AI Bootstrap)

USAGE
    ai context <command> [options]

COMMANDS
    init [options]       Initialize .ai-context/ structure
        --force          Reinitialize and migrate old files
        --silent         Silent mode

    check                Diagnose context state and suggest actions
    sync                 Sync/regenerate AI configurations
    diff                 Compare AI context files

EXAMPLES
    ai context init          # Initialize new structure
    ai context init --force  # Migrate old structure to new
    ai context check         # Diagnose current state
    ai context sync          # Regenerate AI configs

NEW STRUCTURE (Multi-AI Bootstrap)
    .ai-context/
    ├── todos/              # File-based todo system
    ├── backup/             # Migrated old files
    ├── ai-handoff.md       # AI communication hub
    ├── code-landmarks.md   # Important code locations
    ├── stack-config.md     # Auto-detected stack
    └── decisions.md        # Technical decisions

    docs/solutions/         # Knowledge base

EOF
      ;;
    *)
      print_error "Unknown context command: $command"
      echo "Run 'ai context help' for usage"
      exit 1
      ;;
  esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  context_main "$@"
fi
