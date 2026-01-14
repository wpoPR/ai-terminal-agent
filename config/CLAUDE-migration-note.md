# CLAUDE.md Migration Notes

## Changes in v1.1.0

With the implementation of the **Dynamic Agent Management System**, the CLAUDE.md structure was reorganized.

### Before (v1.0.0)

- **Global CLAUDE.md** with complete list of 45 agents
- Static file with complete mapping
- All agents always loaded (~34k tokens)

### After (v1.1.0)

- **Global CLAUDE.md** (`~/.claude/CLAUDE.md`) - Instructions about agent system
- **Project template** (`templates/claude-project.md`) - Adapts to profile
- **definitions.md** - Complete agent reference (preserved)
- **Dynamic agents** - Only active profile loaded (~8-12k tokens)

### Files

1. **`~/.claude/CLAUDE.md`** (new)
   - Global instructions
   - Agent management system
   - Recommended workflow
   - How to check/activate agents

2. **`templates/claude-project.md`** (new)
   - Project template
   - Adapts to active profile
   - Project-specific instructions

3. **`definitions.md`** (already existed)
   - Complete reference of all 45 agents
   - Detailed mapping of when to use each agent
   - Complete flow examples

4. **`config/CLAUDE-reference.md`** (old CLAUDE.md renamed)
   - Backup of original file
   - Historical reference

### How to Use Now

#### Initial Setup
```bash
# The new global CLAUDE.md is already at ~/.claude/CLAUDE.md
# Automatically created during implementation
```

#### Per Project
```bash
cd ~/my-project
ai-start

# Interactive menu appears
# Choose profile (frontend, backend, fullstack, etc)
# Agents are configured automatically

# Check active agents
ai-agents active

# View statistics
ai-agents stats
```

#### Add Agents Temporarily
```bash
# Need an agent that's not in the profile?
ai-agents enable test-automator

# Restart Claude Code to load
```

### Benefits

1. **Performance**: 60-70% less tokens
2. **Flexibility**: Profiles per project type
3. **Control**: Enable/disable agents dynamically
4. **Organization**: Each project with its agents
5. **Maintenance**: Easier to manage

### Reference Commands

```bash
# See all available agents
ai-agents list

# See complete mapping (like old CLAUDE.md)
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Complete agent system documentation
cat ~/workspace/primavera/ai-terminal-agent/docs/agent-management.md
```

### Migrating Existing Projects

If you already have projects with the old system:

```bash
cd ~/existing-project
ai-start

# If no .ai-config, interactive menu appears
# Choose appropriate profile

# Or configure manually
ai-agents profile fullstack
```

### Questions?

- Agent system: `ai-agents help`
- Full documentation: `docs/agent-management.md`
- Agent reference: `definitions.md`
- Diagnostics: `ai-agents doctor`

---

**Migration Date**: 2025-01-13  
**Version**: v1.1.0  
**System**: Agent Management System
