#!/bin/bash
# ai-help-unified.sh - Unified help system
# Version: 2.0.0
#
# Consolidates: ai-help.sh, ai-tips.sh, ai-quick.sh

# Source common library if not already loaded
if [[ -z "${_AI_COMMON_LOADED:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
fi

# =============================================================================
# MAIN HELP
# =============================================================================

show_main_help() {
  cat << 'EOF'
AI Terminal Agent - Help
========================

QUICK START
    cd ~/your-project
    ai start              # Opens iTerm2 with 3 AI splits
    ai status             # Check workspace status
    ai stop               # Close with daily summary

COMMANDS
    ai start [path]       Launch AI workspace with iTerm2 splits
    ai stop               Close workspace and generate summary
    ai status             Show active workspaces

    ai workspace ...      Workspace management (start, stop, status, recent, recover)
    ai agents ...         Agent management (list, enable, disable, profile, stats)
    ai context ...        Context management (init, check, sync, diff)
    ai config ...         Configuration (doctor, git, export, import, update)
    ai help [topic]       Show help for a topic

HOW TO USE THE 3 AIs
    Claude:   Analysis, planning, architecture, debugging
    Gemini:   Research, comparisons, documentation, agent activation
    Codex:    Fast implementation, tests, components

    Shared context: .ai-context/
    - Claude analyzes and creates .ai-context/project-status.md
    - Other AIs read context before working

HELP TOPICS
    ai help start         Detailed help for ai start
    ai help agents        Agent management help
    ai help context       About shared context
    ai help workflow      Recommended workflow
    ai help division      Work division between AIs
    ai help tips          Quick tips and examples
    ai help quick         FAQ and quick answers

EXAMPLES
    # New project:
    cd ~/my-new-project
    ai start

    # Existing project - full analysis:
    cd ~/existing-project
    ai start
    # In Claude: "Analyze this project and create .ai-context/project-status.md"

    # Close workspace:
    ai stop               # Generates automatic summary

EOF
}

# =============================================================================
# TOPIC HELP
# =============================================================================

show_topic_help() {
  local topic="$1"

  case "$topic" in
    start|workspace)
      cat << 'EOF'
ai start - Launch AI Workspace
==============================

USAGE
    ai start [path]
    ai workspace start [path]

DESCRIPTION
    Launches iTerm2 with automatic layout:

    Tab 1 "AIs":
      ├─ Claude (left, 60%)
      ├─ Gemini (top right)
      └─ Codex (bottom right)

    Creates automatically:
    - .ai-context/ (if doesn't exist)
    - .ai-workspace-active (tracking)
    - Backup of contexts

EXAMPLES
    ai start                    # Workspace in current directory
    ai start ~/my-project       # Workspace in specific path

NEXT STEPS
    1. In Claude: "Analyze this project and fill .ai-context/"
    2. Work normally with the 3 AIs
    3. Close with: ai stop

EOF
      ;;

    agents)
      cat << 'EOF'
ai agents - Agent Management
============================

USAGE
    ai agents <command> [options]

COMMANDS
    list [category]      List all available agents
    active               Show active agents in project
    enable <name>        Enable an agent
    disable <name>       Disable an agent
    profile <name>       Activate a profile (or 'list' for profiles)
    stats                Show token usage
    suggest              Suggest profile for current project
    doctor               Run diagnostics
    search <query>       Search agents
    info <name>          Show agent details

AVAILABLE PROFILES
    minimal     - 2 agents  (~5k tokens)  - Code review only
    frontend    - 4 agents  (~10k tokens) - React/Next.js
    backend     - 4 agents  (~11k tokens) - API/backend
    fullstack   - 4 agents  (~11k tokens) - Full web
    mobile      - 3 agents  (~10k tokens) - iOS/Android
    devops      - 5 agents  (~14k tokens) - Infrastructure
    data        - 4 agents  (~12k tokens) - Data engineering
    ai-ml       - 4 agents  (~12k tokens) - Machine learning
    security    - 4 agents  (~13k tokens) - Security audit
    docs        - 4 agents  (~10k tokens) - Documentation

EXAMPLES
    ai agents list              # List all agents
    ai agents profile fullstack # Activate fullstack profile
    ai agents enable security-auditor
    ai agents stats             # Check token usage

EOF
      ;;

    context)
      cat << 'EOF'
ai context - Shared Context
===========================

USAGE
    ai context <command> [options]

COMMANDS
    init [--force] [--with-prompts]    Initialize .ai-context/
    check                               Diagnose context state
    sync                                Sync AI configurations
    diff                                Compare context files

STRUCTURE
    .ai-context/
    ├── project-status.md     # Project overview and current state
    ├── current-task.md       # Active task tracking
    ├── decisions.md          # Technical decisions (ADR style)
    ├── known-issues.md       # Bugs and limitations
    ├── roadmap.md            # Future plans
    └── agents-reference.md   # Available agents reference

HOW AIs USE CONTEXT
    Claude (Analysis & Architecture):
      - Reads before: analyzing code, planning features
      - Updates after: major refactoring, architectural changes

    Gemini (Research & Agent Selection):
      - Reads: agents-reference.md for agent activation
      - Updates after: research completed, agents activated

    Codex (Implementation):
      - Reads before: starting implementation
      - Updates after: features completed, bugs fixed

EXAMPLES
    ai context init                  # Initialize structure
    ai context init --with-prompts   # Include AI prompts
    ai context check                 # Diagnose state

EOF
      ;;

    workflow)
      cat << 'EOF'
Recommended Workflow
====================

1. START
   cd ~/your-project
   ai start

2. INITIALIZE (First time)
   In Claude: "Analyze this project and fill .ai-context/"

3. WORK
   - Use Claude for analysis and architecture
   - Use Gemini for research and agent activation
   - Use Codex for fast implementation

4. SHARE CONTEXT
   Each AI should read .ai-context/ before starting
   Each AI should update .ai-context/ after major changes

5. CLOSE
   ai stop    # Generates daily summary

WORKFLOW FOR EXISTING PROJECT

   ai start
   # In Claude:
   "Analyze this project and create:
    - .ai-context/project-status.md
    - .ai-context/current-task.md
    - .ai-context/known-issues.md"

   # In Gemini:
   "Read .ai-context/ and suggest improvements"

   # In Codex:
   "Read .ai-context/current-task.md and implement"

EOF
      ;;

    division)
      cat << 'EOF'
Work Division Between AIs
=========================

CLAUDE - Analysis & Architecture
  Best for:
    - Code analysis and review
    - Architecture decisions
    - Complex refactoring
    - Debugging difficult issues
    - Planning implementation

GEMINI - Research & Orchestration
  Best for:
    - Library research
    - Documentation
    - Comparing approaches
    - Agent activation
    - Quick questions

CODEX - Implementation
  Best for:
    - Fast code generation
    - Unit tests
    - Simple components
    - Repetitive code
    - Quick fixes

WHEN TO USE EACH

  Task                    | Claude | Gemini | Codex
  ------------------------|--------|--------|-------
  Code review             |   X    |        |
  Architecture decisions  |   X    |        |
  Research libraries      |        |   X    |
  Write documentation     |        |   X    |
  Fast code generation    |        |        |   X
  Unit tests              |        |        |   X
  Complex debugging       |   X    |        |
  Compare approaches      |        |   X    |

EOF
      ;;

    tips|dicas)
      show_tips
      ;;

    quick)
      show_quick
      ;;

    *)
      echo "Unknown topic: $topic"
      echo ""
      echo "Available topics:"
      echo "  start, agents, context, workflow, division, tips, quick"
      ;;
  esac
}

# =============================================================================
# TIPS
# =============================================================================

show_tips() {
  cat << 'EOF'
Quick Tips
==========

STARTING A SESSION
    ai start                    # Start workspace
    ai agents profile fullstack # Set agent profile
    ai context init             # Initialize context

CHECK STATUS
    ai status                   # Workspace status
    ai agents active            # Active agents
    ai agents stats             # Token usage

AGENT MANAGEMENT
    ai agents list              # All available agents
    ai agents enable <name>     # Add agent
    ai agents disable <name>    # Remove agent
    ai agents profile list      # Available profiles

CONTEXT MANAGEMENT
    ai context init             # Create .ai-context/
    ai context check            # Diagnose state
    ai context sync             # Regenerate AI configs

DIAGNOSTICS
    ai config doctor            # Health check
    ai config git --check       # Git ignore status

CLOSING SESSION
    ai stop                     # With summary
    ai stop --no-summary        # Quick close

BEST PRACTICES
    1. Always check active agents before starting: ai agents active
    2. Keep tokens under 15k: ai agents stats
    3. Use context files for AI coordination
    4. Let Claude do complex analysis
    5. Use Gemini for research (it's cheaper)
    6. Use Codex for fast code generation

EOF
}

# =============================================================================
# QUICK FAQ
# =============================================================================

show_quick() {
  cat << 'EOF'
FAQ - Quick Answers
===================

Q: How do I start?
A: cd ~/project && ai start

Q: How do I add an agent?
A: ai agents enable <name>
   Example: ai agents enable security-auditor

Q: How do I change profiles?
A: ai agents profile <name>
   Example: ai agents profile fullstack

Q: How do I check token usage?
A: ai agents stats

Q: How do I initialize context?
A: ai context init --with-prompts

Q: How do I close the workspace?
A: ai stop

Q: How do I run diagnostics?
A: ai config doctor

Q: How do I update AI Terminal Agent?
A: ai config update

Q: Where are the agents?
A: ai agents list          # All available
   ai agents active        # Currently active

Q: Where is the context?
A: .ai-context/            # Shared context directory
   .claude/agents/         # Active agent files

Q: Which AI should I use?
A: Claude  - Complex analysis, architecture
   Gemini  - Research, documentation
   Codex   - Fast code, tests

EOF
}

# =============================================================================
# MAIN ROUTER
# =============================================================================

help_main() {
  local topic="${1:-}"

  if [[ -z "$topic" ]]; then
    show_main_help
  else
    show_topic_help "$topic"
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  help_main "$@"
fi
