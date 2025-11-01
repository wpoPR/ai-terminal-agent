#!/bin/bash
# ai-set-title.sh - Set iTerm2 window and tab title
# Version: 1.0.0

TITLE="${1:-$(basename "$(pwd)")}"

# Set iTerm2 tab title using escape sequences
echo -ne "\033]0;${TITLE}\007"

# Also set tab title via AppleScript (more reliable)
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    osascript -e "tell application \"iTerm2\"
        tell current session of current window
            set name to \"${TITLE}\"
        end tell
    end tell" 2>/dev/null
fi

echo "✓ Title set to: $TITLE"
