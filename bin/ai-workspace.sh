#!/bin/bash
# ai-workspace.sh - Unified workspace management
# Version: 2.0.0
#
# Consolidates: ai-workspace-launcher.sh, ai-stop.sh, ai-status.sh,
#               ai-recover.sh, ai-recent.sh, show-control-console.sh

# Source common library if not already loaded
if [[ -z "${_AI_COMMON_LOADED:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$(dirname "$SCRIPT_DIR")/lib/common.sh"
fi

# =============================================================================
# WORKSPACE START
# =============================================================================

cmd_start() {
  local project_dir="${1:-$(pwd)}"

  # Change to project directory
  cd "$project_dir" || {
    print_error "Cannot access directory: $project_dir"
    exit 1
  }

  print_header "AI Terminal Agent - Workspace Start"
  echo ""
  print_info "Project: $project_dir"
  echo ""

  # Check if already active
  if [[ -f ".ai-workspace-active" ]]; then
    local pid=$(json_get ".ai-workspace-active" ".pid" "")

    if [[ -n "$pid" ]] && ps -p "$pid" > /dev/null 2>&1; then
      print_warning "Workspace already active (PID: $pid)"
      print_info "Use: ai status to check"
      exit 1
    else
      print_warning "Removing stale workspace file"
      rm ".ai-workspace-active"
    fi
  fi

  # Check for existing AI configuration files
  echo "Checking AI configuration..."
  [[ -d ".claude" ]] && print_success "Found: .claude/"
  [[ -f "GEMINI.md" ]] && print_success "Found: GEMINI.md"
  [[ -f "AGENTS.md" ]] && print_success "Found: AGENTS.md"
  [[ -d ".ai-context" ]] && print_success "Found: .ai-context/"
  echo ""

  # Initialize .ai-context structure if it doesn't exist
  if [[ ! -d ".ai-context" ]]; then
    echo "Initializing AI context structure..."

    if [[ -f "$AI_BIN_DIR/ai-context.sh" ]]; then
      source "$AI_BIN_DIR/ai-context.sh"
      cmd_init --silent 2>/dev/null && {
        print_success ".ai-context/ structure created"
      } || {
        print_warning "Could not create .ai-context/ automatically"
        print_info "Run manually: ai context init"
      }
    else
      # Fallback: create minimal structure
      mkdir -p .ai-context
      echo "# Project Status" > .ai-context/project-status.md
      echo "# Current Task" > .ai-context/current-task.md
      echo "# Decisions" > .ai-context/decisions.md
      print_success ".ai-context/ minimal structure created"
    fi
    echo ""
  fi

  # Setup agents if needed
  if [[ ! -f "$AI_PROJECT_CONFIG" ]]; then
    echo "Agent Setup..."
    echo ""

    if [[ -x "$AI_BIN_DIR/ai-agents-setup-interactive.sh" ]]; then
      "$AI_BIN_DIR/ai-agents-setup-interactive.sh"
    else
      print_warning "Interactive agent setup not available"
      print_info "Use 'ai agents profile <name>' to configure later"
    fi
    echo ""
  else
    # Config exists - load agents if configured
    if has_jq; then
      local has_agents=$(jq 'has("agents")' "$AI_PROJECT_CONFIG" 2>/dev/null || echo "false")

      if [[ "$has_agents" == "true" ]]; then
        local profile=$(get_active_profile)

        if [[ "$profile" != "none" ]] && [[ -n "$profile" ]]; then
          echo "Loading agent profile: $profile"

          mkdir -p "$AI_PROJECT_AGENTS_DIR"

          # Get agents from config and copy them
          local agents
          agents=$(get_enabled_agents)

          if [[ -n "$agents" ]]; then
            local count=0
            while IFS= read -r agent; do
              if [[ -f "$AI_AGENTS_LIB/${agent}.md" ]] && [[ ! -f "$AI_PROJECT_AGENTS_DIR/${agent}.md" ]]; then
                cp "$AI_AGENTS_LIB/${agent}.md" "$AI_PROJECT_AGENTS_DIR/"
                ((count++))
              fi
            done <<< "$agents"

            [[ $count -gt 0 ]] && print_success "$count agent(s) loaded"
          fi
          echo ""
        fi
      fi
    fi
  fi

  # Generate AI configuration files
  echo "Generating AI configurations..."

  if [[ -x "$AI_BIN_DIR/generate-project.sh" ]]; then
    "$AI_BIN_DIR/generate-project.sh" claude .claude/claude.md 2>/dev/null && \
      print_success "Claude configuration generated"
    "$AI_BIN_DIR/generate-project.sh" gemini GEMINI.md 2>/dev/null && \
      print_success "GEMINI.md generated"
    "$AI_BIN_DIR/generate-project.sh" codex AGENTS.md 2>/dev/null && \
      print_success "AGENTS.md generated"
  else
    # Try legacy scripts
    command -v generate-project-claude &>/dev/null && generate-project-claude .claude/claude.md 2>/dev/null
    command -v generate-project-gemini &>/dev/null && generate-project-gemini GEMINI.md 2>/dev/null
    command -v generate-project-codex &>/dev/null && generate-project-codex AGENTS.md 2>/dev/null
  fi
  echo ""

  # Create backup
  echo "Creating backup..."
  local backup_dir="$AI_WORKSPACE_DIR/backups/$(basename "$project_dir")"
  mkdir -p "$backup_dir"
  local timestamp=$(date +%Y%m%d_%H%M%S)

  [[ -f ".claude/claude.md" ]] && cp ".claude/claude.md" "$backup_dir/claude.md.$timestamp.bak"
  [[ -f "GEMINI.md" ]] && cp "GEMINI.md" "$backup_dir/GEMINI.md.$timestamp.bak"
  [[ -f "AGENTS.md" ]] && cp "AGENTS.md" "$backup_dir/AGENTS.md.$timestamp.bak"

  print_success "Backup created"
  echo ""

  # Create workspace-active marker
  echo "Marking workspace as active..."

  local started_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local current_pid=$$

  cat > ".ai-workspace-active" << EOF
{
  "pid": $current_pid,
  "project_path": "$project_dir",
  "started_at": "$started_at",
  "iterm_session_id": ""
}
EOF

  # Update global tracking
  local tracking_file="$AI_WORKSPACE_DIR/tracking.json"
  ensure_dir "$AI_WORKSPACE_DIR"

  if [[ ! -f "$tracking_file" ]]; then
    echo '{"active_workspaces":[]}' > "$tracking_file"
  fi

  if has_jq; then
    local temp_file=$(mktemp)
    jq --arg path "$project_dir" \
       --arg pid "$current_pid" \
       --arg started "$started_at" \
       '.active_workspaces += [{
         "path": $path,
         "pid": ($pid | tonumber),
         "started_at": $started,
         "last_heartbeat": $started
       }]' "$tracking_file" > "$temp_file"
    mv "$temp_file" "$tracking_file"
  fi

  # Create session entry
  local today=$(date +%Y-%m-%d)
  local session_dir="$AI_SESSIONS_DIR/$today"
  mkdir -p "$session_dir"
  echo "$project_dir" >> "$session_dir/workspaces.txt"

  print_success "Workspace marked as active"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  print_success "Workspace is ready!"
  echo ""

  # Launch iTerm2 layout
  _launch_iterm_layout "$project_dir"

  echo ""
  echo "When done working:"
  echo "  ai stop    # Generate summary and close"
  echo ""
}

_launch_iterm_layout() {
  local project_dir="$1"
  local applescript="$AI_BIN_DIR/iterm-layout.applescript"

  if is_iterm; then
    echo "Detected iTerm2 - Creating layout in current window..."
    echo ""

    if [[ -f "$applescript" ]]; then
      osascript "$applescript" "$project_dir" 2>/dev/null || {
        print_warning "AppleScript failed, manual setup required"
        _show_manual_iterm_steps
      }
    else
      print_warning "AppleScript not found"
      _show_manual_iterm_steps
    fi
  else
    echo "Opening iTerm2 with layout..."
    echo ""

    if [[ -f "$applescript" ]] && [[ -d "/Applications/iTerm.app" ]]; then
      osascript "$applescript" "$project_dir" 2>/dev/null && {
        print_success "iTerm2 window opened"
      } || {
        print_warning "Failed to open iTerm2 automatically"
        _show_manual_iterm_steps
      }
    else
      print_warning "Automatic iTerm2 launch not available"
      _show_manual_iterm_steps
    fi
  fi
}

_show_manual_iterm_steps() {
  echo ""
  echo "Manual steps:"
  echo "  1. Split vertically (Cmd+D)"
  echo "  2. In right pane, split horizontally (Cmd+Shift+D)"
  echo "  3. Run in each pane:"
  echo "     - Left (60%): claude"
  echo "     - Top right: gemini"
  echo "     - Bottom right: codex"
}

# =============================================================================
# WORKSPACE STOP
# =============================================================================

cmd_stop() {
  local no_summary=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --no-summary) no_summary=true; shift ;;
      *) shift ;;
    esac
  done

  print_header "Stopping AI Workspace"
  echo ""

  # Check for active workspace
  if [[ ! -f ".ai-workspace-active" ]]; then
    print_warning "No active workspace in current directory"
    echo ""
    echo "Searching for active workspaces..."

    find "$HOME/workspace" "$HOME/projects" -name ".ai-workspace-active" -type f 2>/dev/null | while read -r active_file; do
      echo "  Found: $(dirname "$active_file")"
    done

    exit 1
  fi

  local project_dir=$(pwd)
  local pid=$(json_get ".ai-workspace-active" ".pid" "")
  local started_at=$(json_get ".ai-workspace-active" ".started_at" "")

  echo "Project: $project_dir"
  echo "PID: $pid"
  echo "Started: $started_at"
  echo ""

  # Generate summary if requested
  if [[ "$no_summary" == "false" ]]; then
    echo "Generating daily summary..."

    if command -v generate-daily-summary.sh &> /dev/null; then
      generate-daily-summary.sh "$project_dir"
    else
      print_warning "Summary generation not yet implemented"
    fi
    echo ""
  fi

  # Remove active marker
  echo "Cleaning up..."
  rm ".ai-workspace-active"

  # Remove from global tracking
  local tracking_file="$AI_WORKSPACE_DIR/tracking.json"

  if [[ -f "$tracking_file" ]] && has_jq; then
    local temp_file=$(mktemp)
    jq --arg path "$project_dir" \
       '.active_workspaces = [.active_workspaces[] | select(.path != $path)]' \
       "$tracking_file" > "$temp_file"
    mv "$temp_file" "$tracking_file"
  fi

  print_success "Workspace closed"
  echo ""

  echo "Context files preserved:"
  for file in claude.md gemini.md agents.md codex.md; do
    [[ -f "$file" ]] && echo "  - $file"
  done

  echo ""
  echo "To start again:"
  echo "  ai start"
}

# =============================================================================
# WORKSPACE STATUS
# =============================================================================

cmd_status() {
  print_header "AI Workspace Status"
  echo ""

  local tracking_file="$AI_WORKSPACE_DIR/tracking.json"

  # Check if tracking file exists
  if [[ ! -f "$tracking_file" ]]; then
    echo "No active workspaces"
  else
    if has_jq; then
      local active_count=$(jq '.active_workspaces | length' "$tracking_file" 2>/dev/null || echo "0")

      if [[ "$active_count" -eq 0 ]]; then
        echo "No active workspaces"
      else
        echo "Active Workspaces: $active_count"
        echo ""
        jq -r '.active_workspaces[] | "  \(.path)\n   PID: \(.pid) | Started: \(.started_at)\n"' "$tracking_file" 2>/dev/null
      fi
    else
      echo "Tracking file exists (install jq for details)"
    fi
  fi

  # Show agent information if in a project
  if [[ -f "$AI_PROJECT_CONFIG" ]]; then
    print_subheader "Agent Management"

    local profile=$(get_active_profile)
    echo "Profile: $profile"

    if [[ -d "$AI_PROJECT_AGENTS_DIR" ]]; then
      local agent_count=$(find "$AI_PROJECT_AGENTS_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
      echo "Active Agents: $agent_count"

      local total_tokens=$(calculate_tokens)
      local limit=15000
      local percent=$((total_tokens * 100 / limit))
      local color=$(token_status_color $total_tokens $limit)

      printf "Tokens: ${color}~%'d${NC} / %'d (%d%%)\n" "$total_tokens" "$limit" "$percent" 2>/dev/null || \
        echo "Tokens: ~$total_tokens / $limit ($percent%)"

      [[ $total_tokens -gt $limit ]] && print_warning "Token usage exceeds recommended limit"

      echo ""
      echo "Commands:"
      echo "  ai agents stats     - Detailed agent statistics"
      echo "  ai agents active    - List active agents"
    else
      echo "No agents active"
      echo ""
      echo "Commands:"
      echo "  ai agents profile list    - Available profiles"
      echo "  ai agents suggest         - Get profile suggestion"
    fi
  fi

  echo ""
  echo "Workspace Commands:"
  echo "  ai workspace recent   - Show recent workspaces"
  echo "  ai workspace recover  - Recover from crashes"
}

# =============================================================================
# WORKSPACE RECENT
# =============================================================================

cmd_recent() {
  print_header "Recent Workspaces"
  echo ""

  if [[ -d "$AI_SESSIONS_DIR" ]]; then
    find "$AI_SESSIONS_DIR" -type d -name "20*" 2>/dev/null | \
      sort -r | \
      head -10 | \
      while read -r session_dir; do
        local date=$(basename "$session_dir")
        echo "  $date"

        if [[ -f "$session_dir/workspaces.txt" ]]; then
          cat "$session_dir/workspaces.txt" | sed 's/^/     /'
        fi
        echo ""
      done
  else
    echo "No recent sessions found"
  fi

  echo "To open a recent workspace:"
  echo "  cd <workspace-path>"
  echo "  ai start"
}

# =============================================================================
# WORKSPACE RECOVER
# =============================================================================

cmd_recover() {
  print_header "AI Workspace Recovery"
  echo ""

  echo "Searching for orphaned workspace files..."
  echo ""

  local found_orphans=0

  for dir in "$HOME/workspace" "$HOME/projects" "$HOME/Documents"; do
    if [[ -d "$dir" ]]; then
      while IFS= read -r active_file; do
        [[ -z "$active_file" ]] && continue

        local project_dir=$(dirname "$active_file")
        local pid=$(json_get "$active_file" ".pid" "")

        if [[ -n "$pid" ]] && ! ps -p "$pid" > /dev/null 2>&1; then
          echo "Found orphaned workspace:"
          echo "  Path: $project_dir"
          echo "  PID: $pid (dead)"
          echo ""

          if [[ -t 0 ]]; then
            read -p "Remove this orphaned file? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
              rm "$active_file"
              print_success "Removed"
            fi
          fi
          echo ""

          ((found_orphans++))
        fi
      done < <(find "$dir" -name ".ai-workspace-active" -type f 2>/dev/null)
    fi
  done

  if [[ $found_orphans -eq 0 ]]; then
    print_success "No orphaned workspaces found"
  fi

  echo ""
  echo "Recovery complete"
  echo ""
  echo "You can now:"
  echo "  - Run 'ai status' to check active workspaces"
  echo "  - Run 'ai start' in your project directory"
}

# =============================================================================
# WORKSPACE CONSOLE
# =============================================================================

cmd_console() {
  local project_dir="${1:-$(pwd)}"

  clear
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "  AI Workspace Control Console"
  echo "═══════════════════════════════════════════════════════════"
  echo ""
  echo "  Project: $project_dir"
  echo ""
  echo "  Available Commands:"
  echo "  ai status              - Show active workspaces"
  echo "  ai stop                - Close workspace with summary"
  echo "  ai stop --no-summary   - Close without summary"
  echo "  ai workspace recent    - List recent workspaces"
  echo "  ai workspace recover   - Recover from crashes"
  echo "  ai context diff        - Compare context files"
  echo "  ai help                - Show all commands"
  echo ""
  echo "  Current Status:"
  cmd_status
  echo ""
  echo "  Tip: Use Cmd+1 to switch to AI tab, Cmd+2 for this console"
  echo ""
}

# =============================================================================
# MAIN ROUTER
# =============================================================================

workspace_main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    start)   cmd_start "$@" ;;
    stop)    cmd_stop "$@" ;;
    status)  cmd_status "$@" ;;
    recent)  cmd_recent "$@" ;;
    recover) cmd_recover "$@" ;;
    console) cmd_console "$@" ;;
    help|--help|-h)
      cat << 'EOF'
ai workspace - Manage AI workspaces

USAGE
    ai workspace <command> [options]

COMMANDS
    start [path]         Launch AI workspace with iTerm2 splits
    stop [--no-summary]  Close workspace and generate summary
    status               Show active workspaces and token usage
    recent               List recent workspaces
    recover              Recover from crashes (remove orphaned files)
    console              Show control console UI

EXAMPLES
    ai workspace start                  # Start in current directory
    ai workspace start ~/projects/app   # Start in specific directory
    ai workspace stop                   # Stop with summary
    ai workspace stop --no-summary      # Stop without summary
    ai workspace recover                # Clean up orphaned workspaces

SHORTCUTS
    ai start    # Same as: ai workspace start
    ai stop     # Same as: ai workspace stop
    ai status   # Same as: ai workspace status

EOF
      ;;
    *)
      print_error "Unknown workspace command: $command"
      echo "Run 'ai workspace help' for usage"
      exit 1
      ;;
  esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  workspace_main "$@"
fi
