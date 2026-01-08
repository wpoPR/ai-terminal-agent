# Usage Guide

How to use AI Terminal Agent for multi-AI development workflows.

## Basic Workflow

```
1. Navigate to project    →  cd ~/my-project
2. Launch workspace       →  ai start
3. Work with AIs          →  Claude, Gemini, Codex in iTerm2 splits
4. Close workspace        →  ai stop
```

---

## Command Reference

### Quick Commands

| Command | Description |
|---------|-------------|
| `ai start [path]` | Launch AI workspace |
| `ai stop` | Close workspace with summary |
| `ai status` | Show active workspaces |

### All Commands

```bash
# Workspace Management
ai workspace start [path]     # Launch workspace
ai workspace stop             # Close workspace
ai workspace status           # Show active workspaces
ai workspace recent           # List recent workspaces
ai workspace recover          # Recover from crashes
ai workspace console          # Show control console

# Agent Management
ai agents list                # List all agents
ai agents active              # Show active agents
ai agents enable <name>       # Enable agent
ai agents disable <name>      # Disable agent
ai agents profile <name>      # Activate profile
ai agents profile list        # List profiles
ai agents stats               # Token usage
ai agents suggest             # Suggest profile
ai agents doctor              # Diagnostics

# Context Management
ai context init               # Initialize .ai-context/
ai context init --with-prompts
ai context check              # Diagnose context
ai context sync               # Sync AI configs
ai context diff               # Compare files

# Configuration
ai config doctor              # Health check
ai config git --setup         # Setup git ignore
ai config git --check         # Check git config
ai config export [file]       # Export config
ai config import <file>       # Import config
ai config update              # Update from git

# Help
ai help                       # Main help
ai help agents                # Agent help
ai help context               # Context help
ai help workflow              # Workflow guide
ai help division              # AI division guide
ai help tips                  # Quick tips
```

---

## Workspace Management

### Starting a Workspace

```bash
cd ~/my-project
ai start
```

**What happens:**
1. Checks for existing workspace
2. Opens iTerm2 with split layout:
   - Left (60%): Claude
   - Top right: Gemini
   - Bottom right: Codex
3. Creates `.ai-context/` if needed
4. Loads agent profile
5. Creates context backup

**First time in a project:**
- Interactive agent profile selection appears
- Choose based on project type (frontend, backend, fullstack, etc.)
- Profile is saved to `.ai-config`

### Closing a Workspace

```bash
ai stop
```

**What happens:**
1. Generates daily work summary (via Gemini)
2. Saves summary to `~/.ai-workspace/summaries/daily/`
3. Removes active workspace marker
4. Preserves context files

**Skip summary:**
```bash
ai stop --no-summary
```

### Check Status

```bash
ai status
```

**Shows:**
- Active workspaces
- Project paths
- Active agents
- Token usage
- Start times

### Recover from Crashes

```bash
ai workspace recover
```

**Useful when:**
- iTerm2 crashed
- System rebooted
- Workspaces left orphaned

---

## Working with Multiple AIs

### Layout

```
┌──────────────────────────┬─────────────────┐
│                          │     GEMINI      │
│                          │   (Research)    │
│         CLAUDE           ├─────────────────┤
│    (Analysis/Arch)       │     CODEX       │
│                          │ (Implementation)│
└──────────────────────────┴─────────────────┘
```

### When to Use Each AI

| Task | Claude | Gemini | Codex |
|------|:------:|:------:|:-----:|
| Code analysis | X | | |
| Architecture decisions | X | | |
| Complex debugging | X | | |
| Feature planning | X | | |
| Library research | | X | |
| Documentation | | X | |
| Compare approaches | | X | |
| Fast code generation | | | X |
| Unit tests | | | X |
| Simple components | | | X |

### Best Practice Workflow

1. **Claude** analyzes and creates plan
2. **Gemini** researches libraries/approaches
3. **Codex** implements the code
4. **Claude** reviews the result

---

## Context System

### Structure

```
.ai-context/
├── project-status.md     # Project overview
├── current-task.md       # Active task
├── decisions.md          # Technical decisions
├── known-issues.md       # Bugs and limitations
├── roadmap.md            # Future plans
└── agents-reference.md   # Available agents
```

### Initialize Context

```bash
# Basic initialization
ai context init

# With AI prompts for getting started
ai context init --with-prompts
```

### How AIs Share Context

**Claude creates context:**
```
In Claude: "Analyze this project and fill .ai-context/project-status.md"
```

**Other AIs read context:**
```
In Gemini: "Read .ai-context/project-status.md and suggest improvements"
In Codex: "Read .ai-context/current-task.md and implement"
```

**Update after changes:**
```
In Claude: "Update .ai-context/project-status.md with today's progress"
```

---

## Project Configuration

Create `.ai-config` in your project root:

```json
{
  "agents": {
    "profile": "fullstack",
    "enabled": ["test-automator"],
    "token_limit": 15000
  },
  "summary": {
    "mode": "auto",
    "generator": "gemini"
  },
  "backup": {
    "enabled": true,
    "retention_days": 3
  }
}
```

### Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `agents.profile` | `minimal` | Active agent profile |
| `agents.enabled` | `[]` | Additional agents |
| `agents.token_limit` | `15000` | Max tokens warning |
| `summary.mode` | `auto` | `auto`, `manual`, `disabled` |
| `summary.generator` | `gemini` | `gemini` or `basic` |
| `backup.enabled` | `true` | Auto-backup contexts |
| `backup.retention_days` | `3` | Days to keep backups |

---

## Common Workflows

### New Project

```bash
cd ~/my-new-project
ai start

# Select profile (e.g., fullstack)
# iTerm2 opens with 3 AIs

# In Claude:
"Create initial project structure and fill .ai-context/"

# In Gemini:
"Research best practices for [stack]"

# In Codex:
"Implement boilerplate"

ai stop
```

### Existing Project (First Time)

```bash
cd ~/existing-project
ai start

# In Claude:
"Analyze this project and create:
- .ai-context/project-status.md
- .ai-context/current-task.md
- .ai-context/known-issues.md"

# Work normally...

ai stop
```

### Add Feature

```bash
ai start

# In Claude:
"Read .ai-context/project-status.md
Create plan for feature X in .ai-context/feature-x-plan.md"

# In Gemini:
"Research best libraries for [aspect]"

# In Codex:
"Implement feature X according to plan"

# In Claude:
"Review code and update documentation"

ai stop
```

### Fix Bug

```bash
ai start

# In Claude:
"Analyze bug: [description]
Find root cause
Propose fix"

# In Claude (after approval):
"Implement fix"

# In Codex:
"Create regression test"

ai stop
```

### Code Review

```bash
ai start

# In Claude:
"Review code in [file/directory]
Focus on: security, performance, best practices
Create report in .ai-context/review-report.md"

ai stop
```

---

## Tips & Best Practices

### Do

1. **Initialize context first**
   ```bash
   ai context init --with-prompts
   ```

2. **Use appropriate profile**
   ```bash
   ai agents suggest    # Get recommendation
   ai agents profile <name>
   ```

3. **Keep context updated**
   - Update `.ai-context/` after significant changes
   - Each AI should read before starting

4. **Monitor token usage**
   ```bash
   ai agents stats
   ```

5. **Close workspaces properly**
   ```bash
   ai stop    # Generates summary
   ```

### Don't

1. **Don't ask the same question to all 3 AIs**
   - Waste of time and resources

2. **Don't mix specialties**
   - Let Claude analyze, Gemini research, Codex implement

3. **Don't ignore token limits**
   - Keep under 15k for best performance

4. **Don't create huge context files**
   - AIs may not process everything
   - Keep files focused and concise

---

## Examples

### Example: Starting a React Project

```bash
cd ~/projects/my-react-app
ai start

# Choose "frontend" profile

# In Claude:
"Analyze package.json and suggest improvements to project structure"

# In Gemini:
"Research the best state management for this React app:
- Redux vs Zustand vs Jotai
- Pros and cons for our use case"

# In Codex:
"Create a Header component with navigation"

ai stop
```

### Example: API Development

```bash
cd ~/projects/my-api
ai start

# Choose "backend" profile

# In Claude:
"Design REST API structure for user management
Include: authentication, CRUD, permissions"

# In Gemini:
"Compare JWT vs session-based auth for Node.js
Consider: scalability, security, simplicity"

# In Codex:
"Implement POST /api/auth/login endpoint"

ai stop
```

### Example: Multiple Projects

```bash
# Terminal 1
cd ~/projects/frontend
ai start

# Terminal 2
cd ~/projects/backend
ai start

# Check all active
ai status

# Close one
cd ~/projects/frontend
ai stop
```

---

## Next Steps

- [Agent Management](agent-management.md) - Learn about the agent system
- [Quick Reference](quick-reference.md) - Cheatsheet
- [Troubleshooting](troubleshooting.md) - Common issues
