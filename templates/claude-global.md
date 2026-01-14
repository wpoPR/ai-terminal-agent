# Claude Global Configuration

> Dynamic Agent System - AI Terminal Agent v1.1.0

## Overview

You are working with a **dynamic agent management system**. 
Available agents vary by project, based on the active profile.

## Agent System

### How It Works

1. **Global Library**: 45 specialized agents available
2. **Per-Project Agents**: Only agents from the active profile are loaded
3. **Management**: Via `ai-agents` commands

### Check Available Agents

**ALWAYS check available agents in the current project:**

```bash
ai-agents active    # Active agents in the project
ai-agents list      # All 45 available agents
ai-agents stats     # Statistics and tokens
```

### Available Profiles

- **frontend** - React/Next.js, UI/UX
- **backend** - APIs, backend architecture
- **fullstack** - Frontend + Backend + Database
- **mobile** - Mobile apps
- **devops** - Kubernetes, Terraform, deployment
- **data** - Data engineering, analytics
- **ai-ml** - AI/ML, MLOps
- **security** - Audit and security
- **docs** - Documentation
- **research** - Research and performance
- **minimal** - Basic code review

## MANDATORY FLOW

### 1. ALWAYS start with Sequential Thinking

For EVERY task, first use Sequential Thinking to:
- Break down the problem into steps
- Identify which agent(s) to use
- Verify if required agents are active
- Plan the execution sequence
- Document the strategy

**Example:**
```
🤔 [Sequential Thinking]
1. Problem: Create REST API with authentication
2. Required agents:
   - backend-architect (define design)
   - backend-security-coder (authentication)
   - api-documenter (document)
   - code-reviewer (validate)
3. Verification: ai-agents active
4. Status: backend-architect ✓, backend-security-coder ✓
          api-documenter ✗ (needs activation)
5. Sequence:
   a) backend-architect: API design
   b) backend-security-coder: implement auth
   c) Activate api-documenter
   d) api-documenter: document
   e) code-reviewer: review
```

### 2. Identify and use appropriate agent(s)

### 3. Validate results with Sequential Thinking

## Recommended Workflow

### 1. Understand the Project

```bash
# Check which profile is active
ai-agents active

# View statistics
ai-agents stats
```

### 2. Work with Active Agents

Agents in the project's `.claude/agents/` are available for use.
**Only these agents are in your context.**

### 3. Add Agents When Needed

If you need an agent that is not active:

```bash
# Activate temporarily
ai-agents enable test-automator

# Or switch profile
ai-agents profile security
```

### 4. Execute with Sequential Thinking

For complex tasks:

1. **Plan** (Sequential Thinking): Break down the problem
2. **Verify**: Which agents are available? (`ai-agents active`)
3. **Activate**: If needed, activate additional agents
4. **Execute**: Use agents in sequence
5. **Validate**: Review results (Sequential Thinking)

## Important Rules

### ✅ ALWAYS DO

1. **Check available agents** at the start
2. Use Sequential Thinking for coordination
3. Explicitly declare which agent you're using
4. Validate results from each agent
5. Monitor token usage (`ai-agents stats`)

### ❌ NEVER DO

1. Assume all agents are available
2. Use agents without explaining the reason
3. Ignore token limits
4. Skip result validation

## Token Optimization

The system manages tokens automatically:
- **Without management**: ~34k tokens (all agents)
- **With profiles**: ~8-12k tokens (optimized profile)
- **Recommended limit**: 15k tokens

If tokens are high:
```bash
ai-agents stats              # View current usage
ai-agents profile minimal    # Switch to lightweight profile
ai-agents disable <name>     # Disable specific agents
```

## Useful Commands

```bash
# Visualization
ai-agents list               # All agents
ai-agents active             # Active agents
ai-agents info <name>        # Details of an agent
ai-agents search <keyword>   # Search by keyword

# Management
ai-agents enable <name>      # Activate agent
ai-agents disable <name>     # Deactivate agent
ai-agents profile <name>     # Switch profile
ai-agents profile <p1>+<p2>  # Combine profiles

# Utilities
ai-agents stats              # Statistics
ai-agents suggest            # Suggestion based on project
ai-agents doctor             # Diagnostics
```

## Complete Agent Reference

To see all 45 available agents and when to use each one:

```bash
cat ~/workspace/primavera/ai-terminal-agent/definitions.md
```

Or see in the repository: `~/workspace/primavera/ai-terminal-agent/definitions.md`

## Response Template

When receiving a complex request:

```
🔍 [Initial Verification]
- Active agents in project: [list]
- Required agents: [list]
- Necessary actions: [activate agents if needed]

🤔 [Sequential Thinking]
- Problem analysis
- Agents to use: [only active or newly activated]
- Execution sequence

🔧 [Agent 1 - name]
- Why I use it: [reason]
- [execute task]
- Result: [summary]

🔧 [Agent 2 - name]
- Why I use it: [reason]
- [execute task]
- Result: [summary]

✅ [Final Validation]
- Review with Sequential Thinking
- Next steps
- Tokens used: [if relevant]
```

## Support

- Documentation: `ai-agents help`
- Complete guide: `~/workspace/primavera/ai-terminal-agent/docs/agent-management.md`
- Quick reference: `ai-agents list`

---

**Version**: AI Terminal Agent v1.1.0  
**System**: Dynamic Agent Management
