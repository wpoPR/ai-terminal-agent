# Usage Guide

## Basic Workflow

The typical workflow with AI Terminal Agent:

1. Navigate to your project
2. Run `ai-start` to launch workspace
3. Work with your AI assistants
4. Run `ai-stop` when done

## Commands Reference

### ai-start - Launch Workspace

Start an AI workspace in the current directory.

```bash
# Basic usage
cd ~/my-project
ai-start

# Options
ai-start --check      # Health check only
ai-start --dry-run    # Show what would happen
ai-start --debug      # Verbose output
```

**What it does:**
- Checks for existing workspace
- Creates/uses context files (claude.md, gemini.md, agents.md)
- Creates backup of context files
- Marks workspace as active
- (Future) Opens iTerm2 with split layout

**First time in a project:**
You'll be offered templates to choose from:
- `coding-project.md` - For software development
- `writing-project.md` - For content creation
- `research-project.md` - For research work
- `homelab-project.md` - For infrastructure projects

### ai-stop - Close Workspace

Close the active workspace and generate summary.

```bash
# Basic usage
ai-stop

# Options
ai-stop --no-summary     # Skip summary generation
```

**What it does:**
- Generates daily work summary (if not skipped)
- Removes active workspace marker
- Preserves context files

### ai-status - Check Active Workspaces

View currently active workspaces.

```bash
ai-status
```

Shows:
- Number of active workspaces
- Project paths
- Process IDs
- Start times

### ai-health-check - Verify Installation

Check that everything is configured correctly.

```bash
ai-health-check
```

Verifies:
- macOS and iTerm2
- Shift+Enter key binding
- AI CLIs (Claude, Gemini, Codex)
- Git global ignore configuration
- Directory structure
- Script symlinks

### ai-recent - List Recent Workspaces

Show recently used workspaces.

```bash
ai-recent
```

### ai-recover - Recover from Crashes

Find and clean up orphaned workspace files.

```bash
ai-recover
```

Useful when:
- iTerm2 crashed
- System rebooted unexpectedly
- Workspaces weren't closed properly

### ai-git-config - Manage Git Integration

Manage Git global ignore configuration.

```bash
# Show current status
ai-git-config

# Show ignore file contents
ai-git-config --show

# Verify configuration
ai-git-config --check

# Setup/reconfigure
ai-git-config --setup
```

### ai-diff - Compare Context Files

Compare differences between AI context files.

```bash
ai-diff
```

### ai-update - Update System

Update AI Terminal Agent from Git.

```bash
ai-update
```

Automatically:
- Checks for uncommitted changes
- Pulls latest changes
- Updates permissions
- Shows recent commits

### ai-export - Export Configuration

Export entire configuration for backup or transfer.

```bash
ai-export ~/backup.tar.gz
```

Includes:
- Repository
- Templates
- Git ignore configuration

### ai-import - Import Configuration

Import configuration on a new machine.

```bash
ai-import ~/backup.tar.gz
```

### ai-help - Show Help

Display help information.

```bash
# General help
ai-help

# Command-specific help
ai-help start
ai-help stop
```

## Working with Context Files

Context files store project information for AI assistants:
- `claude.md` - Context for Claude
- `gemini.md` - Context for Gemini
- `agents.md` - Shared context
- `codex.md` - Context for Codex (if used)

### Context File Structure

Based on your chosen template, context files include:
- Project description
- Tech stack / tools
- Current phase
- Key files
- Decisions made
- Next steps

### Editing Context Files

Edit directly in your text editor:
```bash
vim claude.md
code gemini.md
```

Changes are automatically backed up when you run `ai-start`.

## Project Configuration

Create `.ai-config` in your project root for custom settings:

```json
{
  "primary_ai": "claude",
  "auto_sync": true,
  "auto_backup": true,
  "template": "coding-project",
  "summary": {
    "mode": "auto",
    "generator": "gemini"
  }
}
```

See [Configuration](configuration.md) for all options.

## Tips & Best Practices

### 1. Keep Context Files Updated
Regularly update your context files with:
- New decisions
- Architecture changes
- Problems encountered
- Solutions found

### 2. Use Templates
Start new projects with appropriate templates:
- Saves time
- Ensures consistency
- Captures important information

### 3. Commit Strategically
By default, context files are NOT committed to Git.

To commit in a specific project:
```json
// .ai-config
{
  "git": {
    "commit_contexts": true
  }
}
```

### 4. Regular Summaries
Run `ai-stop` at end of day to get work summary.

### 5. Backup Important Work
Context files are backed up automatically, but for critical projects:
```bash
ai-export ~/backups/project-$(date +%Y%m%d).tar.gz
```

## Examples

### Example 1: Starting a New Coding Project

```bash
cd ~/projects/my-new-app
ai-start

# Choose "coding-project" template
# Fill in project details in claude.md

# Work with Claude, Gemini, Codex...

ai-stop
# Daily summary generated
```

### Example 2: Resuming Existing Project

```bash
cd ~/projects/my-app
ai-start

# Context files already exist
# Continue where you left off

ai-stop --no-summary  # Skip summary if not needed
```

### Example 3: Recovering from Crash

```bash
# iTerm crashed, workspaces left active
ai-recover

# Select orphaned workspaces to clean up
# Resume work normally
cd ~/projects/my-app
ai-start
```

### Example 4: Working on Multiple Projects

```bash
# Start first project
cd ~/projects/app1
ai-start

# In another terminal, start second project
cd ~/projects/app2
ai-start

# Check all active workspaces
ai-status

# Close one
cd ~/projects/app1
ai-stop
```

## Next Steps

- Learn about [Configuration Options](configuration.md)
- Understand [Architecture](architecture.md)
- See [Troubleshooting](troubleshooting.md) for common issues
