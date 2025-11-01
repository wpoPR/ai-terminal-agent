#!/bin/bash
# ai-help.sh - Display help for AI Terminal Agent
# Version: 1.0.0

COMMAND="${1:-}"

show_main_help() {
  cat << 'EOF'
AI Terminal Agent - Help

USAGE:
  ai-start [path]           Start AI workspace
  ai-stop                   Close workspace with summary
  ai-status                 Show active workspaces
  ai-recent                 List recent workspaces
  ai-recover                Recover from crashes
  ai-health-check           Verify installation
  ai-git-config             Manage git global ignore
  ai-diff                   Compare context files
  ai-export [file]          Export configuration
  ai-import [file]          Import configuration
  ai-update                 Update from git
  ai-help [command]         Show help

WORKSPACE MANAGEMENT:
  ai-start                  Launch workspace in current directory
  ai-start --check          Health check only (don't launch)
  ai-start --dry-run        Show what would happen
  ai-start --debug          Verbose output
  ai-stop                   Close with daily summary
  ai-stop --no-summary      Close without summary

EXAMPLES:
  cd ~/my-project && ai-start
  ai-status
  ai-stop

DOCUMENTATION:
  Full docs: https://github.com/seu-usuario/ai-terminal-agent

For detailed help on a command:
  ai-help [command]
EOF
}

show_command_help() {
  case "$1" in
    start)
      cat << 'EOF'
ai-start - Launch AI Workspace

USAGE:
  ai-start [OPTIONS] [PATH]

OPTIONS:
  --check       Health check only
  --dry-run     Show what would happen
  --debug       Verbose output
  --recent N    Open recent workspace

DESCRIPTION:
  Launches iTerm2 with Claude, Gemini, and Codex in split layout.
  Syncs context files automatically.

EXAMPLES:
  ai-start
  ai-start ~/my-project
  ai-start --check
  ai-start --recent 1
EOF
      ;;
    stop)
      cat << 'EOF'
ai-stop - Close Workspace

USAGE:
  ai-stop [OPTIONS]

OPTIONS:
  --no-summary     Don't generate daily summary
  --summary-only   Generate summary but don't close

DESCRIPTION:
  Closes active workspace and generates daily summary.
  Uses Gemini to aggregate work from all projects.

EXAMPLES:
  ai-stop
  ai-stop --no-summary
EOF
      ;;
    *)
      echo "No detailed help available for: $1"
      echo "Run 'ai-help' for list of commands"
      ;;
  esac
}

if [[ -z "$COMMAND" ]]; then
  show_main_help
else
  show_command_help "$COMMAND"
fi
