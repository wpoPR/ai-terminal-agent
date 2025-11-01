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

# Check for context files
CONTEXT_EXISTS=false
for file in claude.md gemini.md agents.md codex.md; do
  if [[ -f "$file" ]]; then
    CONTEXT_EXISTS=true
    echo -e "${GREEN}✓${NC} Found: $file"
  fi
done

echo ""

# If no context files, offer to create from template
if [[ "$CONTEXT_EXISTS" == "false" ]]; then
  echo "No context files found."
  echo ""
  echo "Available templates:"
  ls -1 "$HOME/templates/ai-contexts"/*.md 2>/dev/null | xargs -n1 basename | sed 's/^/  - /'
  echo ""
  read -p "Create from template? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Select template:"
    select template in "$HOME/templates/ai-contexts"/*.md; do
      if [[ -n "$template" ]]; then
        cp "$template" "claude.md"
        cp "$template" "gemini.md"
        cp "$template" "agents.md"
        echo -e "${GREEN}✓${NC} Context files created"
        break
      fi
    done
  fi
fi

# Create backup
echo ""
echo "📦 Creating backup..."
mkdir -p "$WORKSPACE_DIR/backups/$(basename "$PROJECT_DIR")"
for file in claude.md gemini.md agents.md codex.md; do
  if [[ -f "$file" ]]; then
    cp "$file" "$WORKSPACE_DIR/backups/$(basename "$PROJECT_DIR")/${file}.$(date +%Y%m%d_%H%M%S).bak"
  fi
done
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
