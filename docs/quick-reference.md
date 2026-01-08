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
| `ai start` | Start workspace in current project |
| `ai stop` | Close workspace and generate summary |
| `ai status` | Show active workspaces |
| `ai help` | Full documentation |
| `ai help tips` | Quick tips and examples |

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

### Claude (Analysis & Architecture)
```
✅ Complex code analysis
✅ Feature planning
✅ Refactoring
✅ Difficult debugging
✅ Code review

❌ Web research
❌ Simple repetitive code
```

**Example:**
```
Analyze this project and create .ai-context/project-status.md
with: objective, progress, next steps
```

### Gemini (Research & Docs)
```
✅ Research libraries
✅ Compare technologies
✅ Write documentation
✅ Generate examples
✅ Query APIs

❌ Implement code
❌ Complex debugging
```

**Example:**
```
Research the best JWT libraries for Node.js
Compare jsonwebtoken vs jose vs paseto
```

### Codex (Implementation)
```
✅ Repetitive code
✅ Unit tests
✅ Simple components
✅ Snippets
✅ Code completion

❌ Architectural decisions
❌ Deep analysis
```

**Example:**
```
Create unit tests for src/auth/jwt.js
```

---

## Shared Context System

### Recommended Structure

```
your-project/
├── .ai-context/              # Shared AI "memory"
│   ├── project-status.md     # Project overview
│   ├── current-task.md       # Active task
│   ├── decisions.md          # Technical decisions
│   ├── known-issues.md       # Bugs and limitations
│   └── roadmap.md            # Future plans
├── docs/                     # Public documentation
└── [your code]
```

### How to Share Knowledge

**1. Claude analyzes and creates context:**
```
Analyze the project and create .ai-context/project-status.md
```

**2. Other AIs read the context:**
```
# In Gemini or Codex:
Read .ai-context/project-status.md

[your specific task]
```

**3. Keep it updated:**
```
# In Claude (after changes):
Update .ai-context/project-status.md with what we did today
```

---

## Common Workflows

### 1. New Project
```
1. ai start
2. Claude: "Create initial project structure for [type]"
3. Claude: "Create .ai-context/project-status.md"
4. Gemini: "Research best practices for [stack]"
5. Codex: "Implement basic boilerplate"
```

### 2. Existing Project (First Time)
```
1. ai start
2. Claude: "Analyze this project and create .ai-context/project-status.md"
3. Claude: "List next steps in .ai-context/roadmap.md"
4. [Work normally]
5. ai stop (generates summary)
```

### 3. Add Feature
```
1. ai start
2. Claude: "Read .ai-context/project-status.md
           Create plan for feature X in .ai-context/feature-x-plan.md"
3. Gemini: "Research best libs for [aspect of feature]"
4. Codex: "Implement feature X according to plan"
5. Claude: "Review code and update documentation"
6. ai stop
```

### 4. Fix Bug
```
1. ai start
2. Claude: "Analyze the bug: [description]
           Reproduce the problem
           Identify the cause"
3. Claude: "Implement fix"
4. Codex: "Create test to prevent regression"
5. ai stop
```

### 5. Refactoring
```
1. ai start
2. Claude: "Analyze [module/file]
           Identify code smells
           Create refactoring plan"
3. Claude: "Execute refactoring step by step"
4. Claude: "Verify tests still pass"
5. ai stop
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

### Initial Project Analysis
```
Analyze this project and give me:

1. **Objective:** What does the project do?
2. **Stack:** Technologies used
3. **Structure:** Folder/file organization
4. **Status:** What's done? What's missing?
5. **Next Steps:** Priority 1, 2, 3

Create .ai-context/project-status.md with this information.
```

### Feature Planning
```
I want to add: [describe the feature]

Based on .ai-context/project-status.md:

1. Create implementation plan
2. List files to be created/modified
3. Identify necessary dependencies
4. Estimate complexity (simple/medium/complex)

Save in .ai-context/feature-[name]-plan.md
```

### Solution Research
```
I need: [describe the problem/need]

Research and compare:
- Option A vs B vs C
- Pros and cons
- Recommendation with justification

Focus on: [important criteria: performance, size, community, etc]
```

### Bug Debugging
```
Bug: [describe the symptom]

Steps to reproduce:
1. [step 1]
2. [step 2]
3. [error appears]

Please:
1. Locate related code
2. Identify root cause
3. Propose fix
4. Implement if approved
```

---

## Troubleshooting

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

---

## Useful Links

- **Full Docs:** `ai help`
- **Workflows:** `docs/workflows/analyzing-existing-project.md`
- **Templates:** `~/templates/ai-contexts/`
