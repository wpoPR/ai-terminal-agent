# Claude Configuration Guide

Complete guide on CLAUDE.md configuration in AI Terminal Agent v1.1.0

## Overview

With the dynamic agent management system, Claude configuration was restructured to support:
- Dynamic agents per project
- Specialized profiles
- Global configuration + per-project configuration

## File Structure

### 1. Global CLAUDE.md (`~/.claude/CLAUDE.md`)

**Location**: `~/.claude/CLAUDE.md`  
**Purpose**: Global instructions about the agent system  
**Created**: Automatically during `install.sh`

This file instructs Claude about:
- Dynamic agent management system
- How to check available agents
- How to enable/disable agents
- Recommended workflow
- Useful commands

**When used**: For all projects, as base context

### 2. Per-Project CLAUDE.md (Optional)

**Location**: `<project>/CLAUDE.md`  
**Purpose**: Project-specific context  
**Created**: Via `generate-project-claude`

This file contains:
- Active profile in the project
- List of active agents
- Project-specific instructions
- Detected project type

**When used**: As additional project-specific context

### 3. definitions.md (Reference)

**Location**: `~/workspace/primavera/ai-terminal-agent/definitions.md`  
**Purpose**: Complete reference of all 45 agents  
**Created**: Part of the repository

This file contains:
- Complete mapping: Task → Agent
- Complete flow examples
- When to use each agent
- Agent prioritization

**When used**: As reference when needing information about specific agents

## Comparison: Before vs After

### Before (v1.0.0)

```
config/CLAUDE.md (single file)
├── Complete list of 45 agents
├── Static mapping
└── Always loaded (~34k tokens)
```

### After (v1.1.0)

```
~/.claude/CLAUDE.md (global)
├── Instructions about agent system
├── How to check/enable agents
└── Dynamic workflow

<project>/CLAUDE.md (optional, generated)
├── Active profile
├── Project-specific agents
└── Project context

definitions.md (reference)
├── Complete agent mapping
└── Detailed examples
```

## How It Works

### 1. Installation

During `./install.sh`:
```bash
# Creates ~/.claude/CLAUDE.md global
cp templates/claude-global.md ~/.claude/CLAUDE.md
```

### 2. First Use in Project

```bash
cd ~/my-project
ai-start

# Interactive menu appears
# Choose profile: frontend, backend, fullstack, etc
# Agents are copied to .claude/agents/
```

### 3. Generate Project CLAUDE.md (Optional)

```bash
# In project directory
generate-project-claude

# Generates CLAUDE.md with:
# - Active profile
# - Loaded agents
# - Specific instructions
```

### 4. Claude Reads Context

When Claude starts in a project:
1. Reads `~/.claude/CLAUDE.md` (global)
2. Reads `.claude/agents/*.md` (active agents)
3. Reads project `CLAUDE.md` (if exists)

## Commands

### Manage Global CLAUDE.md

```bash
# View global CLAUDE.md
cat ~/.claude/CLAUDE.md

# Edit global CLAUDE.md
nano ~/.claude/CLAUDE.md

# Restore from template
cp ~/workspace/primavera/ai-terminal-agent/templates/claude-global.md ~/.claude/CLAUDE.md
```

### Manage Per-Project CLAUDE.md

```bash
# Generate CLAUDE.md for current project
cd ~/my-project
generate-project-claude

# Generate with custom name
generate-project-claude PROJECT-CLAUDE.md

# Regenerate when changing profile
ai-agents profile backend
generate-project-claude
```

### View Complete Reference

```bash
# View all agents and when to use
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Search by keyword
grep -i "frontend" ~/workspace/primavera/ai-terminal-agent/definitions.md
```

## Workflows

### Workflow 1: New Project

```bash
# 1. Start project
cd ~/new-project
ai-start

# 2. Choose profile in interactive menu
# (e.g.: fullstack)

# 3. (Optional) Generate project CLAUDE.md
generate-project-claude

# 4. Work normally
# Claude knows the system and active agents
```

### Workflow 2: Change Profile

```bash
# 1. Change profile
ai-agents profile devops

# 2. Regenerate project CLAUDE.md
generate-project-claude

# 3. Restart Claude Code
# New agents are loaded
```

### Workflow 3: Add Temporary Agent

```bash
# 1. Check active agents
ai-agents active

# 2. Add agent
ai-agents enable test-automator

# 3. (Optional) Regenerate CLAUDE.md
generate-project-claude

# 4. Restart Claude Code
```

## Templates

### Global Template (`templates/claude-global.md`)

Global instructions about:
- Dynamic agent system
- How to check available agents
- ai-agents commands
- Recommended workflow
- Token optimization

### Per-Project Template (`templates/claude-project.md`)

Template with placeholders:
- `{{PROFILE_NAME}}`
- `{{AGENT_COUNT}}`
- `{{ACTIVE_AGENTS_LIST}}`
- `{{PROJECT_TYPE}}`

The `generate-project-claude` script replaces these placeholders.

## Customization

### Customize Global CLAUDE.md

```bash
# Edit template
nano ~/workspace/primavera/ai-terminal-agent/templates/claude-global.md

# Re-install
cd ~/workspace/primavera/ai-terminal-agent
./install.sh
```

### Customize Project Template

```bash
# Edit template
nano ~/workspace/primavera/ai-terminal-agent/templates/claude-project.md

# Use custom template
generate-project-claude
```

### Add Specific Instructions

In the project, edit the generated CLAUDE.md:
```bash
# Generate base
generate-project-claude

# Add your instructions
nano CLAUDE.md
```

## Migrating Existing Projects

If you have projects with old CLAUDE.md:

```bash
cd ~/existing-project

# 1. Backup old (if exists)
mv CLAUDE.md CLAUDE-old.md

# 2. Configure agents
ai-start  # Or: ai-agents profile <name>

# 3. Generate new
generate-project-claude

# 4. Compare and merge customizations
diff CLAUDE-old.md CLAUDE.md
```

## Best Practices

### ✅ Recommended

1. **Keep global simple**: General instructions in `~/.claude/CLAUDE.md`
2. **Use profiles**: Let the system manage agents
3. **Generate per project**: Use `generate-project-claude` for specific context
4. **Regenerate when changing profile**: Keep synchronized
5. **Consult definitions.md**: For agent reference

### ❌ Avoid

1. **Don't modify agents in .claude/agents/**: Use `ai-agents` commands
2. **Don't duplicate definitions.md**: Use as reference
3. **Don't hardcode agent list**: Keep dynamic
4. **Don't ignore tokens**: Monitor with `ai-agents stats`

## Troubleshooting

### Global CLAUDE.md doesn't exist

```bash
# Re-install
cd ~/workspace/primavera/ai-terminal-agent
./install.sh
```

### Project CLAUDE.md outdated

```bash
# Regenerate
generate-project-claude
```

### Claude doesn't recognize agents

```bash
# Check active agents
ai-agents active

# Check .claude/agents/
ls -la .claude/agents/

# Restart Claude Code
```

### Agent reference not found

```bash
# View complete mapping
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Or search
ai-agents search <keyword>
```

## Complete Structure

```
CLAUDE.md System v1.1.0
│
├── Global (~/.claude/CLAUDE.md)
│   ├── Instructions about agent system
│   ├── ai-agents commands
│   └── Recommended workflow
│
├── Per Project (<project>/CLAUDE.md)
│   ├── Active profile
│   ├── Loaded agents
│   └── Specific context
│
├── Active Agents (<project>/.claude/agents/)
│   ├── frontend-developer.md
│   ├── backend-architect.md
│   └── ... (per profile)
│
└── Reference (definitions.md)
    ├── Complete mapping
    └── Usage examples
```

## References

- [Agent Management Guide](agent-management.md)
- [Migration Notes](../config/CLAUDE-migration-note.md)
- [Definitions](../definitions.md)
- [Quick Reference](quick-reference.md)

---

**Version**: v1.1.0  
**System**: Agent Management System
