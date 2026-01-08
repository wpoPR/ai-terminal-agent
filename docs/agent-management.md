# Agent Management Guide

Complete guide to the dynamic agent management system in AI Terminal Agent.

## Overview

The agent system lets you activate only the specialized agents you need for each project, dramatically reducing token usage:

| Configuration | Agents | Tokens |
|---------------|--------|--------|
| Without management | 47 agents | ~34k tokens |
| With management | 3-5 agents | ~8-12k tokens |
| **Savings** | | **60-70%** |

---

## Concepts

### Global Agent Library

All available agents live in `~/.ai-workspace/agents/`:
- 47 specialized agents
- Synced with the repository
- Updated via `ai agents update`

### Active Agents

Agents copied to `.claude/agents/` in your project:
- Only agents needed for the project
- Claude Code reads them automatically
- Managed via `ai agents` commands

### Profiles

Pre-defined combinations of agents:
- 11 profiles available
- Based on project types
- Customizable via commands

### Token Tracking

Automatic usage monitoring:
- Approximate calculation (1 token ≈ 4 characters)
- Recommended limit: 15,000 tokens
- Warnings when exceeding 80%

---

## Available Profiles

| Profile | Agents | Tokens | Best For |
|---------|--------|--------|----------|
| `minimal` | 2 | ~5k | Code review only, simple projects |
| `frontend` | 4 | ~10k | React, Next.js, Vue, Angular, design systems |
| `backend` | 4 | ~11k | APIs REST/GraphQL, microservices, Node.js, Python |
| `fullstack` | 4 | ~11k | Full web apps, MVPs, startups |
| `mobile` | 3 | ~10k | iOS/Android, React Native, Flutter |
| `devops` | 5 | ~14k | Infrastructure, CI/CD, deployment, monitoring |
| `data` | 4 | ~12k | Data pipelines, analytics, query optimization |
| `ai-ml` | 4 | ~12k | LLMs, RAG, ML models, AI deployment |
| `security` | 4 | ~13k | Security audits, pen testing, compliance |
| `docs` | 4 | ~10k | Technical docs, APIs, tutorials, diagrams |
| `research` | 3 | ~10k | Research, investigation, performance analysis |

### Profile Details

#### minimal (2 agents, ~5k tokens)
```
- code-reviewer
- architect-review
```

#### frontend (4 agents, ~10k tokens)
```
- frontend-developer
- frontend-security-coder
- ui-ux-designer
- code-reviewer
```

#### backend (4 agents, ~11k tokens)
```
- backend-architect
- backend-security-coder
- api-documenter
- code-reviewer
```

#### fullstack (4 agents, ~11k tokens)
```
- frontend-developer
- backend-architect
- database-architect
- code-reviewer
```

#### mobile (3 agents, ~10k tokens)
```
- mobile-developer
- backend-architect
- mobile-security-coder
```

#### devops (5 agents, ~14k tokens)
```
- kubernetes-architect
- terraform-specialist
- deployment-engineer
- observability-engineer
- devops-troubleshooter
```

#### data (4 agents, ~12k tokens)
```
- data-engineer
- database-architect
- database-optimizer
- data-scientist
```

#### ai-ml (4 agents, ~12k tokens)
```
- ai-engineer
- ml-production-engineer
- mlops-engineer
- prompt-engineer
```

#### security (4 agents, ~13k tokens)
```
- security-auditor
- frontend-security-coder
- backend-security-coder
- code-reviewer
```

#### docs (4 agents, ~11k tokens)
```
- docs-architect
- api-documenter
- tutorial-engineer
- mermaid-diagram-expert
```

#### research (3 agents, ~9k tokens)
```
- gemini-research-assistant
- search-specialist
- performance-engineer
```

---

## Commands

### View Agents

```bash
# List all available agents
ai agents list

# List agents by category
ai agents list --category web

# Show active agents in project
ai agents active

# Show agent details
ai agents info frontend-developer

# Search agents by keyword
ai agents search react
```

### Profile Management

```bash
# List available profiles
ai agents profile list

# Show current profile
ai agents profile

# Activate a profile
ai agents profile fullstack

# Combine multiple profiles
ai agents profile frontend+security

# Reset to minimal
ai agents reset
```

### Individual Agent Management

```bash
# Enable a specific agent
ai agents enable test-automator

# Disable an agent
ai agents disable frontend-security-coder
```

### Statistics & Diagnostics

```bash
# Show detailed token statistics
ai agents stats

# Get profile suggestion for project
ai agents suggest

# Run full diagnostics
ai agents doctor

# Update agent library
ai agents update
```

---

## Workflows

### New Project

```bash
cd ~/my-new-project
ai start

# Interactive menu appears
# Choose profile based on project type
# Agents are configured automatically
```

### Existing Project

```bash
cd ~/existing-project
ai start

# If .ai-config exists, loads saved profile
# Otherwise, interactive menu appears
```

### Changing Profiles

```bash
# You're working on frontend, now need DevOps
ai agents profile devops

# Restart Claude Code to load new agents
```

### Adding Agent Temporarily

```bash
# Need tests only now
ai agents enable test-automator

# Restart Claude Code

# When done
ai agents disable test-automator
```

### Combining Profiles

```bash
# Full stack project with security focus
ai agents profile fullstack+security

# Result: union of agents from both profiles (no duplicates)
```

---

## Smart Suggestion

The `ai agents suggest` command analyzes your project and suggests the best profile:

```bash
ai agents suggest

# Output:
# Analyzing project...
#
# Detected: React/Next.js → frontend profile
# Detected: Node.js backend → backend profile
#
# Recommendation: fullstack profile
#
# To activate: ai agents profile fullstack
```

### Auto-Detection

The system detects:
- **Frontend**: `package.json` with react, next, vue, angular
- **Backend**: `package.json` with express, fastify, koa
- **Python Backend**: `requirements.txt` with fastapi, flask, django
- **Mobile**: `ios/Podfile`, `android/build.gradle`
- **DevOps**: `Dockerfile`, `k8s/`, `*.tf`
- **Data**: `requirements.txt` with pandas, numpy
- **AI/ML**: `requirements.txt` with tensorflow, pytorch

---

## Integration with Status

The `ai status` command shows agent information automatically:

```bash
ai status

# Output includes:
#
# Agent Management
# ────────────────
# Profile: fullstack
# Active Agents: 4
# Tokens: ~10,600 / 15,000 (70%)
#
# Commands:
#   ai agents stats     - Detailed statistics
#   ai agents active    - List active agents
```

---

## Best Practices

### 1. Use Appropriate Profiles

- **Don't use devops** for simple frontend projects
- **Don't use fullstack** if you only need backend
- **Use minimal** for quick code review

### 2. Monitor Tokens

```bash
# Always check after activating agents
ai agents stats

# If > 80%, consider switching profiles
```

### 3. Combine Profiles When Needed

```bash
# Instead of adding individual agents
ai agents profile frontend+security

# More organized and easier to manage
```

### 4. Use Automatic Suggestion

```bash
# In new projects, always run
ai agents suggest

# May reveal non-obvious needs
```

### 5. Update Regularly

```bash
# After each repository update
ai agents update

# Keeps agents synced
```

---

## Troubleshooting

### Agents not appearing in Claude Code

**Problem**: Activated agents but Claude doesn't recognize them

**Solution**:
```bash
# Check if agents are in .claude/agents/
ls -la .claude/agents/

# If missing, reactivate profile
ai agents profile <name>

# Restart Claude Code/Cursor
```

### Token usage too high

**Problem**: Even with profile, tokens are high

**Solution**:
```bash
# See details
ai agents stats

# Switch to lighter profile
ai agents profile minimal

# Or disable specific agents
ai agents disable <name>
```

### Agent library not found

**Problem**: `ai agents list` returns error

**Solution**:
```bash
# Update library
ai agents update

# Or re-run installation
cd ~/workspace/ai-terminal-agent
./install.sh
```

### Profile not saving to .ai-config

**Problem**: Every time `ai start` runs, asks for profile

**Solution**:
```bash
# Check if jq is installed
brew install jq

# Check .ai-config
cat .ai-config

# Re-apply profile
ai agents profile <name>
```

---

## Advanced Configuration

### Custom Token Limit

In `.ai-config`:

```json
{
  "agents": {
    "profile": "fullstack",
    "enabled": [],
    "token_limit": 12000
  }
}
```

### Disable Auto-update

```json
{
  "agents": {
    "auto_update": false
  }
}
```

### Pre-configure Profile

When creating a project, add `.ai-config` with profile:

```json
{
  "agents": {
    "profile": "frontend"
  }
}
```

When running `ai start`, loads automatically.

---

## Custom Agents

### Creating Your Own Agent

1. Create a markdown file in `~/.ai-workspace/agents/`:

```bash
cat > ~/.ai-workspace/agents/my-custom-agent.md << 'EOF'
# My Custom Agent

## Role
Description of what this agent does.

## Expertise
- Skill 1
- Skill 2

## Guidelines
- Guideline 1
- Guideline 2
EOF
```

2. Update the agent index:

```bash
ai agents update
```

3. Enable in your project:

```bash
ai agents enable my-custom-agent
```

### Custom Profile

1. Create a profile in `~/.ai-workspace/agent-profiles/`:

```bash
cat > ~/.ai-workspace/agent-profiles/my-profile.json << 'EOF'
{
  "name": "my-profile",
  "description": "My custom profile",
  "agents": [
    "code-reviewer",
    "my-custom-agent"
  ]
}
EOF
```

2. Activate:

```bash
ai agents profile my-profile
```

---

## FAQ

**Q: Can I have different agents in each project?**
A: Yes! Each project has its own `.claude/agents/` and `.ai-config`.

**Q: Do I need to restart Claude every time I change agents?**
A: Yes, Claude reads agents only at startup.

**Q: Can I customize profiles?**
A: Yes, edit the JSON files in `~/.ai-workspace/agent-profiles/`.

**Q: Do agents affect Claude performance?**
A: Yes, more agents = more tokens = slightly impacted performance.

**Q: Can I add my own agents?**
A: Yes, add `.md` files in `~/.ai-workspace/agents/` and run `ai agents update`.

**Q: What happens if I delete `.claude/agents/`?**
A: Agents are deactivated. Run `ai agents profile <name>` to reactivate.

**Q: How do I know which agents are available?**
A: Run `ai agents list` or `ai agents search <keyword>`.

---

## Additional Resources

- [Quick Reference](quick-reference.md) - Quick commands
- [Installation Guide](installation.md) - Detailed installation
- [Usage Guide](usage.md) - How to use the system
- [Troubleshooting](troubleshooting.md) - Common issues
