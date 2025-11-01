-- iterm-layout.applescript - Create iTerm2 layout for AI workspace
-- Version: 1.0.3
--
-- This AppleScript creates a split layout in iTerm2:
-- Tab 1: AI Assistants
--   - Left pane (60%): Claude
--   - Right pane split horizontally:
--     - Top (50%): Gemini
--     - Bottom (50%): Codex
-- Tab 2: Control Console (ai-* commands)
--
-- Usage: osascript iterm-layout.applescript <project-directory>

on run argv
    set projectDir to item 1 of argv

    -- Extract project name from path
    set projectName to do shell script "basename " & quoted form of projectDir

    tell application "iTerm2"
        activate

        -- Use current window if available, otherwise create new
        if (count of windows) = 0 then
            create window with default profile
        end if

        tell current window
            tell current session of current tab
                -- Set tab title via session name
                set name to projectName & " - AIs"
                -- Set working directory and launch Claude
                write text "cd " & quoted form of projectDir
                write text "echo '🤖 Starting Claude...'"
                write text "claude"

                -- Split vertically to create right pane
                set rightPane to (split vertically with default profile)

                tell rightPane
                    -- Launch Gemini in top right
                    write text "cd " & quoted form of projectDir
                    write text "echo '🤖 Starting Gemini...'"
                    write text "gemini"

                    -- Split horizontally to create bottom right pane
                    set bottomPane to (split horizontally with default profile)

                    tell bottomPane
                        -- Launch Codex in bottom right
                        write text "cd " & quoted form of projectDir
                        write text "echo '🤖 Starting Codex...'"
                        write text "echo '💡 After Codex starts, type: /init'"
                        write text "codex"
                    end tell
                end tell
            end tell

            -- TAB 2: Control Console
            set controlTab to (create tab with default profile)
            tell current session of controlTab
                -- Set tab title via session name
                set name to projectName & " - Control"
                -- First change to project directory
                write text "cd " & quoted form of projectDir

                -- Get repo path to find the control script
                set repoPath to do shell script "jq -r '.repo_path' ~/.ai-workspace/config.json 2>/dev/null || echo ''"

                if repoPath is not "" then
                    -- Use the dedicated control console script
                    write text repoPath & "/bin/show-control-console.sh " & quoted form of projectDir
                else
                    -- Fallback: simple display
                    write text "clear"
                    write text "echo 'AI Workspace Control Console'"
                    write text "echo ''"
                    write text "echo 'Commands: ai-status | ai-stop | ai-help'"
                    write text "echo ''"
                    write text "ai-status"
                end if
            end tell

            -- Switch back to first tab (AI assistants)
            select first tab
        end tell
    end tell
end run
