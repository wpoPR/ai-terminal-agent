#!/bin/bash
# generate-project.sh - Unified project configuration generator
# Version: 2.0.0
#
# Consolidates: generate-project-claude.sh, generate-project-gemini.sh, generate-project-codex.sh

set -e

# Resolve script location
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
TEMPLATES_DIR="$REPO_ROOT/templates"
AI_CONFIG=".ai-config"

# =============================================================================
# HELPERS
# =============================================================================

get_project_info() {
  if command -v jq &> /dev/null && [[ -f "$AI_CONFIG" ]]; then
    PROJECT_NAME=$(jq -r '.project_name // "Unknown Project"' "$AI_CONFIG" 2>/dev/null || echo "Unknown Project")
    PROFILE=$(jq -r '.agents.profile // "none"' "$AI_CONFIG" 2>/dev/null || echo "none")
  else
    PROJECT_NAME=$(basename "$(pwd)")
    PROFILE="none"
  fi
}

get_active_agents() {
  AGENT_COUNT=0
  ACTIVE_AGENTS=""

  if [[ -d ".claude/agents" ]]; then
    for agent_file in .claude/agents/*.md; do
      if [[ -f "$agent_file" ]]; then
        agent_name=$(basename "$agent_file" .md)
        ACTIVE_AGENTS="${ACTIVE_AGENTS}- ${agent_name}\n"
        AGENT_COUNT=$((AGENT_COUNT + 1))
      fi
    done
  fi
}

detect_project_type() {
  PROJECT_TYPE="General"

  if [[ -f "package.json" ]]; then
    if grep -q "react\|next" package.json 2>/dev/null; then
      PROJECT_TYPE="Frontend (React/Next.js)"
    elif grep -q "express\|fastify" package.json 2>/dev/null; then
      PROJECT_TYPE="Backend (Node.js)"
    fi
  elif [[ -f "requirements.txt" ]]; then
    if grep -q "fastapi\|flask\|django" requirements.txt 2>/dev/null; then
      PROJECT_TYPE="Backend (Python)"
    elif grep -q "pandas\|numpy" requirements.txt 2>/dev/null; then
      PROJECT_TYPE="Data Science"
    fi
  elif [[ -d "ios" ]] || [[ -d "android" ]]; then
    PROJECT_TYPE="Mobile App"
  fi
}

# =============================================================================
# GENERATE CLAUDE CONFIGURATION
# =============================================================================

generate_claude() {
  local output_file="${1:-.claude/claude.md}"
  local template_file="$TEMPLATES_DIR/claude-project.md"

  mkdir -p .claude

  get_project_info
  get_active_agents
  detect_project_type

  if [[ -f "$template_file" ]]; then
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    cat "$template_file" | \
      sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" | \
      sed "s/{{PROFILE_NAME}}/$PROFILE/g" | \
      sed "s/{{TIMESTAMP}}/$timestamp/g" \
      > "$output_file"
  else
    # Fallback: generate minimal config if template not found
    cat > "$output_file" << EOF
# Claude Configuration - ${PROJECT_NAME}

## Role: Implementation with TDD

You are Claude, responsible for implementing features using Test-Driven Development.

### File Responsibilities

**MUST Read:**
- \`.ai-context/stack-config.md\` - Commands for test/lint
- \`.ai-context/ai-handoff.md\` - Current state
- \`.ai-context/todos/\` - Task from Gemini

**MUST Write:**
- \`.ai-context/todos/\` - UPDATE (Gemini creates)
- \`.ai-context/ai-handoff.md\` - Your status
- Source code and tests

### TDD Loop
1. RED - Write failing test
2. GREEN - Implement to pass
3. VALIDATE - Lint + typecheck

### Keywords
| Keyword | Action |
|---------|--------|
| \`!ai-help\` | Show commands |
| \`!checkpoint\` | Save state |
| \`!todo complete\` | Mark done |

---
Generated: $(date +"%Y-%m-%d %H:%M:%S")
Profile: ${PROFILE}
EOF
  fi

  echo "Generated $output_file"
  echo "  Profile: $PROFILE"
  echo "  Agents: $AGENT_COUNT"
}

# =============================================================================
# GENERATE GEMINI CONFIGURATION
# =============================================================================

generate_gemini() {
  local output_file="${1:-GEMINI.md}"
  local template_file="$TEMPLATES_DIR/gemini-project.md"

  get_project_info

  if [[ -f "$template_file" ]]; then
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    cat "$template_file" | \
      sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" | \
      sed "s/{{TIMESTAMP}}/$timestamp/g" \
      > "$output_file"
  else
    # Generate minimal config if template not found
    cat > "$output_file" << EOF
# Gemini Configuration - ${PROJECT_NAME}

## Role

You are the research and orchestration assistant for this project.

### Primary Responsibilities

1. **Research** - Look up libraries, best practices, documentation
2. **Agent Selection** - Analyze tasks and activate optimal agents for Claude
3. **Documentation** - Help with README, comments, technical docs

### Agent Activation Workflow

1. Read \`.ai-context/agents-reference.md\` to know all available agents
2. Read \`.ai-context/current-task.md\` to understand the task
3. Analyze which domains are involved
4. Execute: \`ai agents activate <agent1> <agent2> ...\`

### Commands

\`\`\`bash
ai agents list           # See all available agents
ai agents profile list   # See available profiles
\`\`\`

---
Generated: $(date +"%Y-%m-%d %H:%M:%S")
EOF
  fi

  echo "Generated $output_file"
  echo "  Project: $PROJECT_NAME"
}

# =============================================================================
# GENERATE CODEX CONFIGURATION
# =============================================================================

generate_codex() {
  local output_file="${1:-CODEX.md}"
  local template_file="$TEMPLATES_DIR/codex-project.md"

  get_project_info

  if [[ -f "$template_file" ]]; then
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    cat "$template_file" | \
      sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" | \
      sed "s/{{TIMESTAMP}}/$timestamp/g" \
      > "$output_file"
  else
    # Generate minimal config if template not found
    cat > "$output_file" << EOF
# Codex Configuration - ${PROJECT_NAME}

## Role

You are the implementation assistant for this project.

### Primary Responsibilities

1. **Code Generation** - Write code quickly and efficiently
2. **Tests** - Create unit tests and integration tests
3. **Refactoring** - Safe code improvements
4. **Components** - Create UI components, utilities

### Guidelines

- Read \`.ai-context/project-status.md\` before starting
- Follow existing code patterns
- Write clean, documented code
- Create tests for new functionality

### Shared Context

Check these files for context:
- \`.ai-context/project-status.md\` - Project overview
- \`.ai-context/current-task.md\` - Active task
- \`.ai-context/decisions.md\` - Technical decisions

---
Generated: $(date +"%Y-%m-%d %H:%M:%S")
EOF
  fi

  echo "Generated $output_file"
  echo "  Project: $PROJECT_NAME"
}

# =============================================================================
# MAIN
# =============================================================================

show_help() {
  cat << 'EOF'
generate-project - Generate AI configuration files

USAGE
    generate-project <type> [output-file]

TYPES
    claude [file]    Generate Claude configuration (default: .claude/claude.md)
    gemini [file]    Generate Gemini configuration (default: GEMINI.md)
    codex [file]     Generate Codex configuration (default: CODEX.md)
    all              Generate all configuration files

EXAMPLES
    generate-project claude
    generate-project gemini GEMINI.md
    generate-project codex CODEX.md
    generate-project all

EOF
}

main() {
  local type="${1:-help}"
  shift || true

  case "$type" in
    claude)
      generate_claude "$@"
      ;;
    gemini)
      generate_gemini "$@"
      ;;
    codex)
      generate_codex "$@"
      ;;
    all)
      generate_claude
      generate_gemini
      generate_codex
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      echo "Unknown type: $type"
      echo "Run 'generate-project help' for usage"
      exit 1
      ;;
  esac
}

main "$@"
