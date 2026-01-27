# Multi-AI Workflow Guide

This guide explains how to use Gemini, Claude, and Codex together for maximum productivity.

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     COMPOUND ENGINEERING CYCLE                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   0. SETUP (ai-start script)                                    │
│      ├── ai-context-init (creates structure)                    │
│      ├── ai-stack-detect (detects PROJECT stack)                │
│      └── ai-agents profile (loads agents)                       │
│                                                                  │
│   1. PLAN (Gemini)                                              │
│      ├── Read stack-config.md (already detected)                │
│      ├── Analyze TASK complexity                                │
│      ├── Choose level: MINIMAL / MORE / A LOT                   │
│      ├── Create todo file in .ai-context/todos/                 │
│      ├── Select agents for Claude (!select agents)              │
│      └── Output prompt for Claude                               │
│                                                                  │
│   2. WORK (Claude)                                              │
│      ├── Read todo file and stack-config.md                     │
│      ├── TDD Loop (RED → GREEN → VALIDATE)                      │
│      │   └── (Skip TDD if no test command in stack-config)      │
│      ├── Update work log in todo file                           │
│      ├── Mark todo as complete                                  │
│      └── Output prompt for next AI                              │
│                                                                  │
│   3. REVIEW (Gemini or Claude)                                  │
│      ├── Check PR size                                          │
│      ├── Verify tests pass                                      │
│      └── Approve or request changes                             │
│                                                                  │
│   4. COMPOUND (Codex - Optional)                                │
│      ├── Document solution in docs/solutions/                   │
│      ├── Update README if needed                                │
│      └── Knowledge is now searchable for future                 │
│                                                                  │
│   5. REPEAT                                                     │
│      └── Each cycle makes the next easier                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Initialize Workspace

```bash
cd ~/your-project
ai-start
```

This will:
- Create `.ai-context/` structure
- Detect your project stack
- Load appropriate agents

### 2. Start with Gemini

Open Gemini and say:

```
Read .ai-context/stack-config.md and .ai-context/ai-handoff.md.
I need to implement [your feature].
Use !analyze task to create a todo.
```

Gemini will:
- Analyze complexity (MINIMAL/MORE/A LOT)
- Create a todo file in `.ai-context/todos/`
- Select appropriate agents
- Output a prompt for Claude

### 3. Continue with Claude

Copy Gemini's output prompt and paste to Claude:

```
Read .ai-context/ai-handoff.md and implement the feature using TDD.
Context: Todo created, stack is Node/Vitest, agents selected.
```

Claude will:
- Read the todo file
- Follow TDD workflow (RED → GREEN → VALIDATE)
- Update the todo with work log
- Mark as complete when done

### 4. Document with Codex (Optional)

If the solution was complex or non-obvious:

```
Read .ai-context/ai-handoff.md.
Use !document solution to save this fix for future reference.
```

Codex will create a solution doc in `docs/solutions/`.

---

## AI Responsibilities

| Task | Gemini | Claude | Codex |
|------|--------|--------|-------|
| Stack detection | READ | READ | READ |
| Code indexing | ✅ WRITE | READ | READ |
| Task analysis | ✅ | - | - |
| Create todos | ✅ CREATE | UPDATE | READ |
| Implementation | - | ✅ | Backup |
| TDD workflow | - | ✅ | - |
| Extra tests | - | - | ✅ |
| Documentation | - | - | ✅ |
| Solution docs | - | - | ✅ |

---

## Keywords Reference

### Gemini Keywords

| Keyword | Action |
|---------|--------|
| `!analyze codebase` | Generate code-index.json |
| `!analyze task` | Determine complexity, create todo |
| `!select agents` | Recommend agents for task |
| `!todo create` | Create new todo file |
| `!check pr size` | Verify changes are within limits |
| `!handoff claude` | Output prompt for Claude |

### Claude Keywords

| Keyword | Action |
|---------|--------|
| `!checkpoint` | Save session state |
| `!todo update` | Update work log in todo |
| `!todo complete` | Mark todo as complete |
| `!handoff gemini` | Output prompt for Gemini |
| `!handoff codex` | Output prompt for Codex |

### Codex Keywords

| Keyword | Action |
|---------|--------|
| `!document solution` | Create solution doc |
| `!add tests` | Generate additional tests |
| `!update readme` | Update README |
| `!handoff claude` | Output prompt for Claude |
| `!handoff gemini` | Output prompt for Gemini |

---

## File Structure

```
project/
├── .ai-context/
│   ├── todos/                  # File-based todo system
│   │   ├── 001-add-auth.md
│   │   └── 002-fix-bug.md
│   ├── backup/                 # Migrated old files
│   ├── ai-handoff.md           # Communication hub
│   ├── stack-config.md         # Auto-detected stack (READ ONLY)
│   ├── code-index.json         # Function index (Gemini writes)
│   ├── code-landmarks.md       # Important locations (Claude writes)
│   └── decisions.md            # Technical decisions
├── docs/
│   └── solutions/              # Knowledge base (Codex writes)
│       ├── performance-issues/
│       ├── database-issues/
│       └── ...
├── .claude/
│   └── agents/                 # Active agents
├── CLAUDE.md                   # Claude's instructions
├── GEMINI.md                   # Gemini's instructions
└── CODEX.md                    # Codex's instructions
```

---

## Example: Complete Workflow

### Task: Add User Authentication

**Step 1: Gemini Analysis**

```
User: I need to add user authentication with JWT.

Gemini: !analyze task

## Analysis
- Complexity: MORE (2-3 hours)
- Domains: Backend, Security, Database
- Planning level: MORE

## Created Todo
File: .ai-context/todos/001-add-user-auth.md
Status: pending
Priority: p1

## Selected Agents
- backend-architect (~2,600 tokens)
- security-auditor (~1,800 tokens)
- database-architect (~2,400 tokens)
Total: ~6,800 tokens

---
**To continue with Claude, copy and paste:**

```
Read .ai-context/ai-handoff.md and implement user authentication using TDD.
Context: Todo 001 created, stack is Node/Vitest, 3 agents selected.
```
---
```

**Step 2: Claude Implementation**

```
User: [pastes Gemini's prompt]

Claude: Reading context...

## TDD Loop

### RED Phase
Creating test: src/auth/login.test.ts
Running: npm test
Result: 1 failing test ✓

### GREEN Phase
Implementing: src/auth/login.ts
Running: npm test
Result: All tests passing ✓

### VALIDATE Phase
Running: npm run lint
Result: No errors ✓

## Updated Todo
Status changed to: complete

---
**To continue with Codex, copy and paste:**

```
Read .ai-context/ai-handoff.md and document the JWT implementation.
Context: Auth implemented with TDD, 2 new files, ~150 lines.
```
---
```

**Step 3: Codex Documentation**

```
User: [pastes Claude's prompt]

Codex: !document solution

## Created Solution Doc
File: docs/solutions/security-issues/jwt-auth-implementation.md

Contents:
- Symptoms: No authentication
- Solution: JWT with refresh tokens
- Prevention: Always use httpOnly cookies

---
**Knowledge compounded for future reference!**
```

---

## Terminal Commands

| Command | Description |
|---------|-------------|
| `ai-start` | Initialize workspace |
| `ai-stop` | End session with summary |
| `ai-agents active` | List active agents |
| `ai-agents profile X` | Switch agent profile |
| `ai-stack-detect` | Re-detect project stack |
| `ai context sync` | Regenerate AI configs |
| `ai-help` | Show all commands |

---

## Tips

### 1. Always Start with Gemini
Gemini is cheaper and creates the todo structure Claude needs.

### 2. Use TDD with Claude
Claude's TDD workflow ensures quality code.

### 3. Document Complex Solutions
If it took > 30 min to solve, use Codex to document it.

### 4. Check Handoff Before Switching
Always read `ai-handoff.md` when switching AIs.

### 5. Keep Todos Updated
Update the work log in todos for traceability.

---

## Troubleshooting

### "Stack not detected"
Run `ai-stack-detect` manually or check if your project has the expected files (package.json, requirements.txt, etc.)

### "No test command"
Configure tests in your project. Claude will warn but continue without TDD.

### "Agents not loading"
Run `ai-agents doctor` to diagnose issues.

### "Context files missing"
Run `ai-context-init --force` to recreate the structure.
