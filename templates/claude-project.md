# Project Context for Claude

> This file is auto-generated based on active agent profile.
> Managed by: AI Terminal Agent
> Profile: {{PROFILE_NAME}}
> Active Agents: {{AGENT_COUNT}}

## Project Overview

**Type**: {{PROJECT_TYPE}}
**Agent Profile**: {{PROFILE_NAME}}

## Active Agents

{{ACTIVE_AGENTS_LIST}}

## Agent System

This project uses **AI Terminal Agent** with dynamic agent management.

### Check Active Agents

```bash
# View active agents in this project
ai-agents active

# View token statistics
ai-agents stats

# List all available agents
ai-agents list
```

### Manage Agents

```bash
# Enable an additional agent
ai-agents enable <name>

# Disable an agent
ai-agents disable <name>

# Switch profile
ai-agents profile <name>
```

## Workflow with Agents

### 1. Understand the Context
- Use `Plan` to explore the codebase
- Use `Explore` to understand structure

### 2. Work with Active Agents
Agents in `.claude/agents/` are available for use.
Only active agents appear in the context.

### 3. Sequential Thinking
For complex tasks:
- Break down the problem
- Identify required agents
- If a needed agent is not active: `ai-agents enable <name>`
- Execute in sequence
- Validate results

## Best Practices

### ✅ ALWAYS
- Check active agents before starting (`ai-agents active`)
- Use Sequential Thinking for complex tasks
- Declare which agent you're using and why
- Validate results

### ❌ AVOID
- Assuming all agents are available
- Skipping result validation
- Using agents without explaining the reason

## Token Management

Current usage: Run `ai-agents stats`
- Recommended limit: 15,000 tokens
- Your profile is optimized for this project

If you need additional agents temporarily:
```bash
ai-agents enable <name>
# When finished
ai-agents disable <name>
```

## References

- All available agents: `ai-agents list`
- Complete documentation: `~/workspace/primavera/ai-terminal-agent/definitions.md`
- Agent system: `ai-agents help`