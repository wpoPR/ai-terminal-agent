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

  mkdir -p .claude

  get_project_info
  get_active_agents
  detect_project_type

  cat > "$output_file" << EOF
# Project Context for Claude

> This file is auto-generated based on active agent profile.
> Managed by: AI Terminal Agent v2.0.0
> Profile: ${PROFILE}
> Active Agents: ${AGENT_COUNT}

## Project Overview

**Name**: ${PROJECT_NAME}
**Type**: ${PROJECT_TYPE}
**Agent Profile**: ${PROFILE}

## Active Agents

${ACTIVE_AGENTS}

## Agent System

This project uses **AI Terminal Agent** with dynamic agent management.

### Check Active Agents

\`\`\`bash
# See active agents in this project
ai agents active

# See token statistics
ai agents stats

# List all available agents
ai agents list
\`\`\`

### Manage Agents

\`\`\`bash
# Enable an additional agent
ai agents enable <name>

# Disable an agent
ai agents disable <name>

# Switch profile
ai agents profile <name>
\`\`\`

## Workflow with Agents

### 1. Understand Context
- Use \`Plan\` to explore the codebase
- Use \`Explore\` to understand structure
- Check available agents: \`ai agents active\`

### 2. Work with Active Agents
Agents in \`.claude/agents/\` are available for use.
**Only these agents are in your context.**

For this project (profile: **${PROFILE}**):
${ACTIVE_AGENTS}

### 3. Sequential Thinking
For complex tasks:
1. Break down the problem
2. Identify necessary agents
3. If a needed agent is not active: \`ai agents enable <name>\`
4. Execute in sequence
5. Validate results

## Best Practices

### Always
- Check active agents before starting (\`ai agents active\`)
- Use Sequential Thinking for complex tasks
- Declare which agent you're using and why
- Validate results
- Monitor tokens (\`ai agents stats\`)

### Avoid
- Assuming all agents are available
- Using agents without explaining why
- Ignoring token limits (15k recommended)
- Skipping result validation

## Token Management

Current usage: Run \`ai agents stats\`

- **Recommended limit**: 15,000 tokens
- **Your profile (${PROFILE})**: ~${AGENT_COUNT} active agents

If tokens are high:
\`\`\`bash
ai agents stats              # See detailed usage
ai agents profile minimal    # Switch to lighter profile
ai agents disable <name>     # Disable specific agents
\`\`\`

## Useful Commands

\`\`\`bash
# Visualization
ai agents active             # Active agents
ai agents info <name>        # Agent details
ai agents search <keyword>   # Search agents

# Management
ai agents profile list       # See available profiles
ai agents suggest            # Get profile suggestion
ai config doctor             # System diagnostics

# Workflow integration
ai status                    # Status + active agents
\`\`\`

---

**Generated**: $(date)
**System**: AI Terminal Agent v2.0.0
**Profile**: ${PROFILE}
EOF

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
  local output_file="${1:-AGENTS.md}"
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
    codex [file]     Generate Codex configuration (default: AGENTS.md)
    all              Generate all configuration files

EXAMPLES
    generate-project claude
    generate-project gemini GEMINI.md
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
