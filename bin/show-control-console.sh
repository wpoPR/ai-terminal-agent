#!/bin/bash
# show-control-console.sh - Display control console UI
# Version: 1.0.0

PROJECT_DIR="${1:-$(pwd)}"

clear
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  AI Workspace Control Console"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📍 Project: $PROJECT_DIR"
echo ""
echo "🎮 Available Commands:"
echo "  ai-status              - Show active workspaces"
echo "  ai-stop                - Close workspace with summary"
echo "  ai-stop --no-summary   - Close without summary"
echo "  ai-recent              - List recent workspaces"
echo "  ai-recover             - Recover from crashes"
echo "  ai-diff                - Compare context files"
echo "  ai-help                - Show all commands"
echo ""
echo "📊 Current Status:"
ai-status
echo ""
echo "💡 Tip: Use ⌘+1 to switch to AI tab, ⌘+2 for this console"
echo ""
