#!/bin/bash
# ai-context.sh - Unified context management
# Version: 2.0.0
#
# Consolidates: ai-context-init.sh, ai-context-check.sh, ai-diff.sh, sync-contexts.sh

# Source common library if not already loaded
if [[ -z "${_AI_COMMON_LOADED:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
fi

# Templates directory
TEMPLATES_DIR="$AI_SCRIPT_DIR/templates/context"
CONTEXT_DIR=".ai-context"

# =============================================================================
# CONTEXT INIT
# =============================================================================

cmd_init() {
  local force=false
  local minimal=false
  local with_prompts=false
  local silent=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --force) force=true; shift ;;
      --minimal) minimal=true; shift ;;
      --with-prompts) with_prompts=true; shift ;;
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

  # Check if templates exist
  if [[ ! -d "$TEMPLATES_DIR" ]]; then
    print_error "Templates directory not found: $TEMPLATES_DIR"
    _print_info "Please ensure ai-terminal-agent is properly installed"
    return 1
  fi

  # Header
  if [[ "$silent" != "true" ]]; then
    print_header "Initializing AI Context Structure"
    echo ""

    # Check existing structure
    if [[ -d "$CONTEXT_DIR" ]] && [[ "$force" != "true" ]]; then
      _check_existing_structure || return 0
    fi
  else
    # Silent mode: skip if already complete
    if [[ -d "$CONTEXT_DIR" ]]; then
      local essential_count=0
      for file in project-status.md current-task.md decisions.md; do
        [[ -f "$CONTEXT_DIR/$file" ]] && ((essential_count++))
      done
      [[ $essential_count -ge 3 ]] && return 0
    fi
  fi

  # Create directory
  mkdir -p "$CONTEXT_DIR"
  _print_success "Created $CONTEXT_DIR/"

  # Define files to copy
  local files=(
    "project-status.md"
    "current-task.md"
    "decisions.md"
    "known-issues.md"
    "roadmap.md"
    "agents-reference.md"
  )

  [[ "$minimal" == "true" ]] && files=("project-status.md" "current-task.md")

  if [[ "$silent" != "true" ]]; then
    echo ""
    echo "Copying template files..."
    echo ""
  fi

  # Copy template files
  for file in "${files[@]}"; do
    if [[ -f "$TEMPLATES_DIR/$file" ]]; then
      if [[ -f "$CONTEXT_DIR/$file" ]] && [[ "$force" != "true" ]]; then
        _print_warning "$file already exists, skipping"
      else
        cp "$TEMPLATES_DIR/$file" "$CONTEXT_DIR/"
        _print_success "$file"
      fi
    else
      print_error "Template not found: $file"
    fi
  done

  # Create README
  _create_context_readme

  _print_success "README.md"

  # Generate initial prompts if requested
  if [[ "$with_prompts" == "true" ]]; then
    _create_initial_prompts
  fi

  # Show summary
  if [[ "$silent" != "true" ]]; then
    echo ""
    print_success "Context structure initialized!"
    echo ""
    echo "Structure created:"
    echo ""
    tree -L 2 "$CONTEXT_DIR" 2>/dev/null || find "$CONTEXT_DIR" -type f | sed 's|[^/]*/|  |g'

    echo ""
    echo "Next steps:"
    echo ""

    if [[ "$with_prompts" == "true" ]]; then
      echo "1. Start your AI workspace: ai start"
      echo "2. In Claude console, run the prompt from:"
      echo "   cat .ai-context/initial-prompts/claude-init.md"
    else
      echo "1. Fill in .ai-context/project-status.md with project details"
      echo "2. Update .ai-context/current-task.md with current work"
      echo "3. Tell your AIs to read these files before starting work"
      echo ""
      echo "Or run: ai context init --with-prompts"
      echo "to generate initialization prompts for each AI"
    fi
    echo ""
  fi
}

_check_existing_structure() {
  local missing_files=()

  for file in project-status.md current-task.md decisions.md known-issues.md roadmap.md agents-reference.md; do
    [[ ! -f "$CONTEXT_DIR/$file" ]] && missing_files+=("$file")
  done

  if [[ ${#missing_files[@]} -eq 0 ]]; then
    print_success "Structure .ai-context already exists and is complete!"
    echo ""
    print_info "Nothing to do. Use:"
    echo "  ai context check    - Check status"
    echo "  ai agents active    - See active agents"
    return 1
  fi

  if [[ ${#missing_files[@]} -gt 0 ]]; then
    print_warning "Structure .ai-context is incomplete"
    echo ""
    echo "Missing files:"
    for file in "${missing_files[@]}"; do
      echo "  - $file"
    done
    echo ""

    if [[ -t 0 ]]; then
      read -p "Add missing files? (y/n): " -n 1 -r
      echo ""
      [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
    fi
  fi

  return 0
}

_init_help() {
  cat << 'EOF'
ai context init - Initialize AI Context Structure

USAGE
    ai context init [options]

OPTIONS
    --force           Overwrite existing files
    --minimal         Create minimal structure only
    --with-prompts    Generate initial prompts for AIs
    --silent, -q      Silent mode (no output)
    -h, --help        Show this help

STRUCTURE CREATED
    .ai-context/
    ├── project-status.md     # Project overview and current state
    ├── current-task.md       # Active task tracking
    ├── decisions.md          # Technical decisions log
    ├── known-issues.md       # Bugs and limitations
    ├── roadmap.md            # Future plans and milestones
    └── agents-reference.md   # Quick reference of all agents

EXAMPLES
    ai context init                  # Initialize with templates
    ai context init --force          # Overwrite existing files
    ai context init --with-prompts   # Create initial prompts for AIs

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
    echo "  1. ai context init --with-prompts"
    echo "     Creates .ai-context structure with templates"
    echo ""
    echo "  2. ai start"
    echo "     Opens workspace and configures agents"
    return 0
  fi

  # SCENARIO 2: Incomplete structure
  if [[ ! -f "$CONTEXT_DIR/agents-reference.md" ]]; then
    print_warning "SCENARIO: Incomplete .ai-context structure"
    echo ""
    echo "MISSING:"
    echo "  - agents-reference.md (needed for Gemini agent activation)"
    echo ""
    echo "ACTION:"
    echo "  ai context init --force"
    return 0
  fi

  # SCENARIO 3: Ready but no active agents
  if [[ ! -d "$AI_PROJECT_AGENTS_DIR" ]] || [[ $(ls -A "$AI_PROJECT_AGENTS_DIR" 2>/dev/null | wc -l) -eq 0 ]]; then
    print_warning "SCENARIO: Context ready, but no active agents"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "  A - Use profile:"
    echo "     ai agents profile fullstack"
    echo ""
    echo "  B - Let Claude decide:"
    echo "     1. Fill: .ai-context/current-task.md"
    echo "     2. In Claude: 'Activate agents needed for this task'"
    echo ""
    echo "  C - Use Gemini (cheaper):"
    echo "     1. Fill: .ai-context/current-task.md"
    echo "     2. In Gemini: 'Read agents-reference.md and current-task.md,"
    echo "        analyze and run: ai-agents-activate <agents>'"
    return 0
  fi

  # SCENARIO 4: Everything working
  print_success "SCENARIO: System fully configured"
  echo ""

  local num_agents=$(_count_valid_agents)

  echo "STATUS:"
  echo "  - .ai-context structure: OK"
  echo "  - Active agents: $num_agents"

  # Check if context files are empty
  if [[ -f "$CONTEXT_DIR/project-status.md" ]]; then
    local lines=$(wc -l < "$CONTEXT_DIR/project-status.md" 2>/dev/null | tr -d ' ')
    if [[ $lines -lt 20 ]]; then
      echo ""
      print_warning "project-status.md seems empty or incomplete"
      echo "   In Claude: 'Analyze project and fill .ai-context/project-status.md'"
    fi
  fi

  echo ""
  echo "USEFUL COMMANDS:"
  echo "  ai agents active    - See active agents and token usage"
  echo "  ai context sync     - Sync context between AIs"
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
ai context - Manage shared AI context

USAGE
    ai context <command> [options]

COMMANDS
    init [options]       Initialize .ai-context/ structure
        --force          Overwrite existing files
        --minimal        Create minimal structure only
        --with-prompts   Generate initial prompts for AIs
        --silent         Silent mode

    check                Diagnose context state and suggest actions
    sync                 Sync context between AI configurations
    diff                 Compare AI context files

EXAMPLES
    ai context init                  # Initialize context structure
    ai context init --with-prompts   # Include initial prompts
    ai context check                 # Diagnose current state
    ai context sync                  # Regenerate AI configs

STRUCTURE
    .ai-context/
    ├── project-status.md     # Project overview
    ├── current-task.md       # Active task tracking
    ├── decisions.md          # Technical decisions (ADR)
    ├── known-issues.md       # Bugs and limitations
    ├── roadmap.md            # Future plans
    └── agents-reference.md   # Available agents reference

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
