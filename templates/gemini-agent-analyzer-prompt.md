# Gemini Prompt - Agent Analysis and Activation

Use this prompt in the Gemini console to analyze the task and activate ideal agents.

**IMPORTANT:** Gemini does the intelligent analysis, the script only copies files!

---

## 📋 Complete Prompt (Recommended)

```
Please act as an ai-terminal-agent agent optimization specialist.

Task:
1. Read .ai-context/agents-reference.md to know ALL 45 available agents
2. Read .ai-context/current-task.md to understand the current task
3. Intelligently analyze which technical domains are involved:
   - Frontend? (React, Vue, UI, components)
   - Backend? (API, database, server)
   - Mobile? (iOS, Android, React Native)
   - DevOps? (Docker, K8s, CI/CD)
   - Data? (ETL, analytics, pipelines)
   - Security? (Auth, encryption)
   - AI/ML? (models, training, LLMs)

4. Determine the specific agents needed (not just profile)

5. Execute the command with the agent list:

   ai-agents-activate <agent1> <agent2> <agent3> ...

Example:
   ai-agents-activate frontend-developer backend-architect database-architect security-auditor

The script will:
- Copy ONLY the specified agents to .claude/agents/
- Remove old agents
- Claude will auto-detect (no restart needed!)

After executing, provide a summary:
- Activated agents (complete list)
- Token estimate (~Xk/15k)
- Justification for each agent chosen
- Equivalent profile (if any)

Be specific and intelligent in your analysis!
```

---

## 🎯 Alternative Prompt (With Detailed Explanation)

If you want Gemini to explain before activating:

```
Please analyze the current task and suggest agent configuration:

1. **Reading:**
   - Open and read .ai-context/current-task.md
   - Identify keywords and technical domains

2. **Analysis:**
   - Frontend? (React, Vue, UI, components)
   - Backend? (API, database, server)
   - Mobile? (iOS, Android, React Native)
   - DevOps? (Docker, K8s, CI/CD)
   - Data? (ETL, analytics, pipelines)
   - Security? (Auth, encryption, vulnerabilities)
   - AI/ML? (models, training, LLMs)

3. **Recommendation:**
   Provide:
   - Recommended profile
   - Specific agents
   - Token estimate (~Xk/15k)
   - Justification

4. **Activation:**
   After confirmation, execute:
   ai-agents-activate <agent-list>

Be concise and technical!
```

---

## 🚀 Real Usage Example

### Scenario: Add Analytics Dashboard

**Task in .ai-context/current-task.md:**
```markdown
# Current Task

Add analytics dashboard to React app with:
- Interactive charts (Chart.js)
- REST API for fetching metrics
- Optimized PostgreSQL queries
- Redis caching
```

**Gemini Executes:**
```
Analyzing .ai-context/current-task.md...

Detected domains:
✓ Frontend (React, charts, dashboard)
✓ Backend (REST API, cache)
✓ Data (queries, PostgreSQL, analytics)

Recommended profile: fullstack+data

Executing: ai-agents-activate frontend-developer ui-ux-designer backend-architect database-architect database-optimizer data-engineer

Result:
- Activated agents: 6
  • frontend-developer (Dashboard UI)
  • ui-ux-designer (Charts design)
  • backend-architect (API endpoints)
  • database-architect (Query optimization)
  • database-optimizer (Performance)
  • data-engineer (Analytics logic)
- Tokens: ~12k/15k (80%)

Claude is ready with ideal agents! 🎯
```

---

## ⚡ Super Quick Mode (One-Liner)

For quick activation (Gemini decides and executes):

```
Read .ai-context/agents-reference.md and .ai-context/current-task.md, determine the necessary agents and execute: ai-agents-activate <agent-list>
```

---

## 🔍 Analysis Only Mode (Without Activating)

To see suggestions without activating yet:

```
Read .ai-context/agents-reference.md and .ai-context/current-task.md, analyze the technical domains and suggest which agents should be activated. DO NOT execute any command yet, just explain your analysis and recommendation.
```

---

## 📊 Cost Comparison

| Approach | Tokens Used | Cost |
|----------|-------------|------|
| Claude analyzes manually | ~2-3k tokens | $$$ |
| Gemini analyzes + ai-agents-activate | ~500-1k tokens | $ |
| **Savings:** | **70-80%** | **70-80%** |

**Why is it cheaper?**
- Gemini reads agents-reference.md (has all agents)
- Gemini does intelligent analysis
- Script only copies files (mechanical)
- Claude receives ready agents (no need to analyze)

---

## 💡 Tips for Gemini

**Best Practices:**
- ✅ Read agents-reference.md to understand available agents
- ✅ Consider combinations (e.g.: frontend+security)
- ✅ Verify tokens stay < 15k
- ✅ Justify the choice based on the task

**Avoid:**
- ❌ Activating too many agents unnecessarily
- ❌ Ignoring the task type
- ❌ Forgetting to verify tokens
- ❌ Not explaining the recommendation

---

## 🎓 Ideal Response Template

When Gemini activates agents, it should respond like this:

```markdown
## ✅ Agents Activated

**Analyzed Task:**
[Brief task summary]

**Identified Domains:**
- Frontend (keywords: React, UI, components)
- Backend (keywords: API, database)

**Activated Profile:** fullstack

**Included Agents (4):**
1. frontend-developer - React components
2. backend-architect - API design
3. database-architect - Schema and queries
4. code-reviewer - Quality assurance

**Token Usage:** ~10k / 15k (67%)
Status: ✅ Optimal

**Justification:**
Task involves frontend and backend. Fullstack profile
provides necessary expertise without exceeding token budget.

**Claude Code:**
Agents auto-detected. Ready to work! 🚀
```

---

## 🔄 Complete Workflow

```bash
# 1. User describes task
echo "Add OAuth login" >> .ai-context/current-task.md

# 2. In Gemini console (complete prompt):
"Read .ai-context/agents-reference.md to know the agents,
 read .ai-context/current-task.md to understand the task,
 analyze and execute: ai-agents-activate <agent-list>"

# 3. Gemini:
   - Reads agents-reference.md (knows the 45 agents)
   - Reads current-task.md (understands: login + OAuth + security)
   - Analyzes: Needs frontend + backend + security
   - Decides: frontend-developer, backend-architect, frontend-security-coder, backend-security-coder
   - Executes: ai-agents-activate frontend-developer backend-architect frontend-security-coder backend-security-coder

# 4. Script copies the 4 agents to .claude/agents/

# 5. Claude auto-detects agents (no restart needed!)

# 6. Profit! 🎉
```

---

**Remember:** Claude does NOT need to restart! It auto-detects new agents via file watcher in `.claude/agents/`.
