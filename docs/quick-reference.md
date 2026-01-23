# Quick Reference: AI Terminal Agent

## Quick Start

```bash
cd ~/your-project
ai start
```

iTerm2 will open with:
- **Tab 1 "AIs":** Claude (left) | Gemini (top-right) | Codex (bottom-right)
- **Tab 2 "Control":** Command console

---

## Essential Commands

| Command | Description |
|---------|-------------|
| `ai start` | Start workspace (creates .ai-context/, detects stack) |
| `ai stop` | Close workspace and generate summary |
| `ai status` | Show active workspaces |
| `ai migrate` | Migrate old projects to new structure |
| `ai help` | Full documentation |

### Workspace Management

```bash
ai workspace start [path]    # Start workspace
ai workspace stop            # Close with summary
ai workspace status          # Show active workspaces
ai workspace recent          # List recent workspaces
ai workspace recover         # Recover from crashes
```

### Agent Management

```bash
ai agents list               # List all available agents
ai agents active             # Show active agents
ai agents profile list       # List profiles
ai agents profile <name>     # Activate profile
ai agents enable <name>      # Enable agent
ai agents disable <name>     # Disable agent
ai agents stats              # Token statistics
ai agents suggest            # Get profile suggestion
```

### Context Management

```bash
ai context init              # Initialize .ai-context/
ai context init --with-prompts  # Include AI prompts
ai context check             # Diagnose context state
ai context sync              # Sync AI configurations
```

### Configuration

```bash
ai config doctor             # Health check
ai config git --setup        # Configure git ignore
ai config update             # Update from git
ai config export             # Export configuration
ai config import <file>      # Import configuration
```

---

## When to Use Each AI

### Gemini (Analysis & Planning)
```
✅ Task analysis & complexity estimation
✅ Agent selection for Claude
✅ Code indexing & duplicate detection
✅ PR size verification
✅ Research & comparison

❌ Write source code
❌ Update code-landmarks.md
```

**Example:**
```
!analyze task Add user authentication with JWT
```

### Claude (Implementation)
```
✅ TDD workflow (test first)
✅ Feature implementation
✅ Refactoring
✅ Difficult debugging
✅ Update code-landmarks.md

❌ Task planning (Gemini's job)
❌ Solution documentation
```

**Example:**
```
Read .ai-context/ and implement auth
!checkpoint after login feature
```

### Codex (Documentation & Tests)
```
✅ Solution documentation
✅ Add tests to existing code
✅ Update README
✅ API documentation

❌ Primary implementation
❌ Architectural decisions
```

**Example:**
```
!document solution for auth implementation
!add tests for src/auth/
```

---

## Shared Context System

### Structure (v2.1+)

```
your-project/
├── .ai-context/              # Shared AI "memory"
│   ├── ai-handoff.md         # AI communication hub
│   ├── ai-workflows.md       # Common scenario guide
│   ├── code-landmarks.md     # Important code locations
│   ├── decisions.md          # Technical decisions
│   ├── stack-config.md       # Auto-detected stack info
│   ├── todos/                # File-based tasks
│   │   └── 001-task.md       # Individual todo files
│   └── backup/               # Migration backups
├── .geminiignore             # Prevents Gemini context overflow
├── docs/solutions/           # Documented solutions
└── [your code]
```

### AI Roles & Keywords

| AI | Role | Keywords |
|----|------|----------|
| **Gemini** | Analysis | `!analyze task`, `!select agents`, `!todo create` |
| **Claude** | Implementation | `!checkpoint`, `!handoff`, `!todo update` |
| **Codex** | Documentation | `!document solution`, `!add tests` |

### How to Share Knowledge

**1. Gemini analyzes and creates todos:**
```
!analyze task Add user authentication
```

**2. Claude implements and updates:**
```
Read .ai-context/ and implement the auth task
```

**3. Codex documents:**
```
!document solution for auth implementation
```

---

## Common Workflows

### 1. New Feature
```
1. ai start
2. Gemini: "!analyze task Add user authentication"
   → Creates todo, recommends agents
3. Claude: "Read .ai-context/ and implement"
   → Uses TDD, updates landmarks
4. Codex: "!document solution for auth"
5. ai stop
```

### 2. Bug Fix
```
1. ai start
2. Gemini: "!analyze task Fix login timeout bug"
3. Claude: "Debug and fix the issue"
   → !checkpoint after fix
4. Codex: "!add tests for regression prevention"
5. ai stop
```

### 3. Refactoring
```
1. ai start
2. Gemini: "!analyze codebase"
   → Generates code-index.json, finds duplicates
3. Claude: "Refactor based on analysis"
4. ai stop
```

### 4. First Time in Existing Project
```
1. ai start (auto-detects stack)
2. Gemini: "!analyze codebase"
3. Claude: "Update .ai-context/code-landmarks.md"
4. [Work normally]
5. ai stop
```

### 5. Migrate Old Project
```
1. ai stop (if active)
2. ai migrate (creates backup, converts structure)
3. ai start (use new structure)
```

---

## Practical Tips

### Do

1. **Use only 1 AI for initial analysis**
   - Avoids duplicated work
   - Claude is best for deep analysis

2. **Keep .ai-context/ updated**
   - It's the shared "memory"
   - Update after important changes

3. **Be specific in prompts**
   ```
   ✅ "Create tests for src/auth/jwt.js"
   ❌ "Make tests"
   ```

4. **Use Tab 2 (Control) to check status**
   ```bash
   ai status      # See active workspaces
   ai workspace recent  # See history
   ```

5. **Close with ai stop**
   - Generates automatic daily summary
   - Keeps history organized

### Don't

1. **Don't ask the same question to all 3 AIs**
   - Waste of time/resources

2. **Don't leave context outdated**
   - AIs will work with wrong info

3. **Don't mix specialties**
   - Use each AI for what it does best

4. **Don't create giant contexts**
   - AIs may not read everything
   - Prefer focused, concise files

---

## Prompt Templates

### For Gemini - Task Analysis
```
!analyze task [describe what you want to do]

Example:
!analyze task Add user authentication with JWT and refresh tokens
```

### For Gemini - Agent Selection
```
!select agents

(Run after !analyze task to get agent recommendations)
```

### For Claude - Start Implementation
```
Read .ai-context/ and implement the [task name] todo.
Use TDD workflow.
```

### For Claude - Checkpoint
```
!checkpoint

(Saves current progress to ai-handoff.md)
```

### For Claude - Handoff
```
!handoff

(Generates ready-to-copy prompt for next AI)
```

### For Codex - Document Solution
```
!document solution for [what was implemented]

Example:
!document solution for JWT authentication with refresh tokens
```

### For Codex - Add Tests
```
!add tests for [file or module]

Example:
!add tests for src/auth/
```

---

## Troubleshooting

### Gemini context overflow (400+ files read at once)
```bash
# Check if .geminiignore exists:
ls -la .geminiignore

# If not, copy the template:
cp ~/.ai-workspace/templates/geminiignore.template .geminiignore

# Or run ai start again (creates it automatically)
```

### iTerm2 doesn't open splits automatically
```bash
# Manual test:
osascript ~/workspace/primavera/ai-terminal-agent/bin/iterm-layout.applescript "$(pwd)"

# If it fails, configure manually:
# Tab 1: Cmd+D (vertical split), then Cmd+Shift+D (horizontal split)
```

### ai commands not found
```bash
# Add to PATH:
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Context not being shared
```bash
# Check if .ai-context/ exists:
ls -la .ai-context/

# If not:
ai context init
```

### Old project structure
```bash
# Migrate to new structure:
ai migrate

# Preview changes first:
ai migrate --dry-run
```

---

## Useful Links

- **Full Docs:** `ai help`
- **Workflows:** `docs/workflows/analyzing-existing-project.md`
- **Templates:** `~/templates/ai-contexts/`
