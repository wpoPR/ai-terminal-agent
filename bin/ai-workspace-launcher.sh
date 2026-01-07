#!/bin/bash
# ai-workspace-launcher.sh (ai-start) - Launch AI workspace
# Version: 1.0.0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

WORKSPACE_DIR="$HOME/.ai-workspace"
PROJECT_DIR="${1:-$(pwd)}"

# Change to project directory
cd "$PROJECT_DIR" || exit 1

echo "🚀 AI Terminal Agent - Workspace Launcher"
echo "════════════════════════════════════════"
echo "Project: $PROJECT_DIR"
echo ""

# Check if already active
if [[ -f ".ai-workspace-active" ]]; then
  PID=$(jq -r '.pid' ".ai-workspace-active" 2>/dev/null || echo "")

  if [[ -n "$PID" ]] && ps -p "$PID" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠${NC}  Workspace already active (PID: $PID)"
    echo "   Use: ai-status to check"
    exit 1
  else
    echo -e "${YELLOW}⚠${NC}  Removing stale workspace file"
    rm ".ai-workspace-active"
  fi
fi

# Check for existing AI configuration files
echo "📋 Checking AI configuration..."
[[ -d ".claude" ]] && echo -e "${GREEN}✓${NC} Found: .claude/"
[[ -f "GEMINI.md" ]] && echo -e "${GREEN}✓${NC} Found: GEMINI.md"
[[ -f "AGENTS.md" ]] && echo -e "${GREEN}✓${NC} Found: AGENTS.md"
[[ -d ".ai-context" ]] && echo -e "${GREEN}✓${NC} Found: .ai-context/"
echo ""

# Initialize .ai-context structure if it doesn't exist
if [[ ! -d ".ai-context" ]]; then
  echo "📂 Initializing AI context structure..."
  
  if command -v ai-context-init &> /dev/null; then
    ai-context-init --silent 2>/dev/null && {
      echo -e "${GREEN}✓${NC} .ai-context/ structure created"
    } || {
      echo -e "${YELLOW}⚠${NC}  Could not create .ai-context/ automatically"
      echo "   Run manually: ai-context-init"
    }
  else
    # Fallback: create minimal structure manually
    mkdir -p .ai-context
    
    # Get templates path
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    REPO_DIR="$(dirname "$SCRIPT_DIR")"
    TEMPLATES_DIR="$REPO_DIR/templates/context"
    
    if [[ -d "$TEMPLATES_DIR" ]]; then
      for template in project-status.md current-task.md decisions.md known-issues.md agents-reference.md; do
        if [[ -f "$TEMPLATES_DIR/$template" ]] && [[ ! -f ".ai-context/$template" ]]; then
          cp "$TEMPLATES_DIR/$template" ".ai-context/"
        fi
      done
      echo -e "${GREEN}✓${NC} .ai-context/ structure created"
    else
      echo -e "${YELLOW}⚠${NC}  Templates not found, creating minimal structure"
      echo "# Project Status" > .ai-context/project-status.md
      echo "# Current Task" > .ai-context/current-task.md
      echo "# Decisions" > .ai-context/decisions.md
    fi
  fi
  echo ""
fi

# Setup agents if needed
echo ""
if [[ ! -f ".ai-config" ]]; then
  # No config yet - run interactive setup
  echo "🤖 Agent Setup..."
  echo ""
  
  if [[ -x "$HOME/bin/ai-agents-setup-interactive" ]]; then
    "$HOME/bin/ai-agents-setup-interactive"
  elif [[ -x "$(dirname "$0")/ai-agents-setup-interactive.sh" ]]; then
    "$(dirname "$0")/ai-agents-setup-interactive.sh"
  else
    echo -e "${YELLOW}⚠${NC}  Interactive agent setup not available"
    echo -e "${BLUE}ℹ${NC}  Use 'ai-agents profile <name>' to configure later"
  fi
  echo ""
else
  # Config exists - check if agents are configured
  if command -v jq &> /dev/null; then
    HAS_AGENTS=$(jq 'has("agents")' .ai-config 2>/dev/null || echo "false")
    
    if [[ "$HAS_AGENTS" == "false" ]]; then
      # Old config without agents - offer to configure
      echo "🤖 Agent configuration not found"
      echo ""
      if [[ -t 0 ]]; then
        read -p "Configure agents now? (y/n): " -r -n 1
      else
        REPLY="n"  # Default to no in non-interactive mode
      fi
      echo ""
      
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ -x "$HOME/bin/ai-agents-setup-interactive" ]]; then
          "$HOME/bin/ai-agents-setup-interactive"
        fi
      else
        echo -e "${BLUE}ℹ${NC}  Use 'ai-agents profile <name>' to configure later"
      fi
      echo ""
    else
      # Agents configured - apply profile
      PROFILE=$(jq -r '.agents.profile // "none"' .ai-config 2>/dev/null || echo "none")
      
      if [[ "$PROFILE" != "none" ]] && [[ -n "$PROFILE" ]]; then
        echo "🤖 Loading agent profile: $PROFILE"
        
        if command -v ai-agents &> /dev/null; then
          # Re-apply profile to ensure agents are copied
          AGENTS_LIB="$WORKSPACE_DIR/agents"
          AGENTS_DIR=".claude/agents"
          
          mkdir -p "$AGENTS_DIR"
          
          # Get agents from config
          ENABLED_AGENTS=($(jq -r '.agents.enabled[]? // empty' .ai-config 2>/dev/null))
          
          if [[ ${#ENABLED_AGENTS[@]} -gt 0 ]]; then
            for agent in "${ENABLED_AGENTS[@]}"; do
              if [[ -f "$AGENTS_LIB/${agent}.md" ]] && [[ ! -f "$AGENTS_DIR/${agent}.md" ]]; then
                cp "$AGENTS_LIB/${agent}.md" "$AGENTS_DIR/" 2>/dev/null || true
              fi
            done
            echo -e "${GREEN}✓${NC} ${#ENABLED_AGENTS[@]} agent(s) loaded"
          fi
        fi
        echo ""
      fi
    fi
  fi
fi

# Generate AI configuration files
echo "📝 Generating AI configurations..."

# Claude
if command -v generate-project-claude &> /dev/null; then
  generate-project-claude .claude/claude.md 2>/dev/null && {
    echo -e "${GREEN}✓${NC} Claude configuration generated"
  } || {
    echo -e "${YELLOW}⚠${NC}  Could not generate Claude configuration"
  }
fi

# Gemini
if command -v generate-project-gemini &> /dev/null; then
  generate-project-gemini GEMINI.md 2>/dev/null && {
    echo -e "${GREEN}✓${NC} GEMINI.md generated (Gemini CLI)"
  } || {
    echo -e "${YELLOW}⚠${NC}  Could not generate GEMINI.md"
  }
fi

# Codex (AGENTS.md)
if command -v generate-project-codex &> /dev/null; then
  generate-project-codex AGENTS.md 2>/dev/null && {
    echo -e "${GREEN}✓${NC} AGENTS.md generated (Codex CLI)"
  } || {
    echo -e "${YELLOW}⚠${NC}  Could not generate AGENTS.md"
  }
fi

echo ""

# Create backup
echo "📦 Creating backup..."
BACKUP_DIR="$WORKSPACE_DIR/backups/$(basename "$PROJECT_DIR")"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup new config files
[[ -f ".claude/claude.md" ]] && cp ".claude/claude.md" "$BACKUP_DIR/claude.md.$TIMESTAMP.bak"
[[ -f "GEMINI.md" ]] && cp "GEMINI.md" "$BACKUP_DIR/GEMINI.md.$TIMESTAMP.bak"
[[ -f "AGENTS.md" ]] && cp "AGENTS.md" "$BACKUP_DIR/AGENTS.md.$TIMESTAMP.bak"

echo -e "${GREEN}✓${NC} Backup created"

# Create workspace-active marker
echo ""
echo "📝 Marking workspace as active..."

STARTED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
CURRENT_PID=$$

cat > ".ai-workspace-active" << EOF
{
  "pid": $CURRENT_PID,
  "project_path": "$PROJECT_DIR",
  "started_at": "$STARTED_AT",
  "iterm_session_id": ""
}
EOF

# Update global tracking
TRACKING_FILE="$WORKSPACE_DIR/tracking.json"
mkdir -p "$WORKSPACE_DIR"

if [[ ! -f "$TRACKING_FILE" ]]; then
  echo '{"active_workspaces":[]}' > "$TRACKING_FILE"
fi

# Add to tracking (using jq if available, otherwise simple append)
if command -v jq &> /dev/null; then
  TEMP_FILE=$(mktemp)
  jq --arg path "$PROJECT_DIR" \
     --arg pid "$CURRENT_PID" \
     --arg started "$STARTED_AT" \
     '.active_workspaces += [{
       "path": $path,
       "pid": ($pid | tonumber),
       "started_at": $started,
       "last_heartbeat": $started
     }]' "$TRACKING_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$TRACKING_FILE"
fi

# Create session entry
TODAY=$(date +%Y-%m-%d)
SESSION_DIR="$WORKSPACE_DIR/sessions/$TODAY"
mkdir -p "$SESSION_DIR"
echo "$PROJECT_DIR" >> "$SESSION_DIR/workspaces.txt"

echo -e "${GREEN}✓${NC} Workspace marked as active"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Workspace is ready!"
echo ""

# Get repository path for AppleScript
REPO_PATH=$(jq -r '.repo_path' "$WORKSPACE_DIR/config.json" 2>/dev/null || echo "")

# Check if we're already in iTerm2
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  echo "🖥️  Detected iTerm2 - Creating layout in current window..."
  echo ""

  # Use AppleScript to split current window
  if [[ -f "$REPO_PATH/bin/iterm-layout.applescript" ]]; then
    osascript "$REPO_PATH/bin/iterm-layout.applescript" "$PROJECT_DIR" 2>/dev/null || {
      echo -e "${YELLOW}⚠${NC}  AppleScript failed, manual setup required"
      echo ""
      echo "Manual steps:"
      echo "  1. Split vertically (⌘+D)"
      echo "  2. In right pane, split horizontally (⌘+Shift+D)"
      echo "  3. Run in each pane:"
      echo "     - Left (60%): claude"
      echo "     - Top right: gemini"
      echo "     - Bottom right: codex"
    }
  else
    echo -e "${YELLOW}⚠${NC}  AppleScript not found"
    echo ""
    echo "Manual steps:"
    echo "  1. Split vertically (⌘+D)"
    echo "  2. In right pane, split horizontally (⌘+Shift+D)"
    echo "  3. Run in each pane:"
    echo "     - Left (60%): claude"
    echo "     - Top right: gemini"
    echo "     - Bottom right: codex"
  fi
else
  # Not in iTerm2, try to open new window
  echo "🚀 Opening iTerm2 with layout..."
  echo ""

  if [[ -f "$REPO_PATH/bin/iterm-layout.applescript" ]] && [[ -d "/Applications/iTerm.app" ]]; then
    osascript "$REPO_PATH/bin/iterm-layout.applescript" "$PROJECT_DIR" 2>/dev/null && {
      echo -e "${GREEN}✓${NC} iTerm2 window opened"
    } || {
      echo -e "${YELLOW}⚠${NC}  Failed to open iTerm2 automatically"
      echo ""
      echo "Please open iTerm2 manually and run:"
      echo "  cd $PROJECT_DIR"
      echo "  claude    # In left pane"
      echo "  gemini    # In top right"
      echo "  codex     # In bottom right"
    }
  else
    echo -e "${YELLOW}⚠${NC}  Automatic iTerm2 launch not available"
    echo ""
    echo "Please open iTerm2 manually and run:"
    echo "  cd $PROJECT_DIR"
    echo "  claude    # In left pane"
    echo "  gemini    # In top right"
    echo "  codex     # In bottom right"
  fi
fi

echo ""
echo "When done working:"
echo "  ai-stop  # Generate summary and close"
echo ""
