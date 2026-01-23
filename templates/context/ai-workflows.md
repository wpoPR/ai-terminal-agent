# 🔄 Multi-AI Workflows Guide

> Quick reference for common development scenarios using Gemini, Claude, and Codex.

---

## 📋 Quick Legend

| AI | Role | When to Use |
|----|------|-------------|
| 🟡 **Gemini** | Analysis & Planning | Start tasks, analyze code, create todos |
| 🔵 **Claude** | Implementation (TDD) | Write code, fix bugs, run tests |
| 🟢 **Codex** | Support & Docs | Documentation, extra tests, solutions |

---

## 1. 🆕 Nova Feature

**Scenario:** Implement a new feature from scratch.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Analyze & Plan                               │
│    Prompt: "!analyze task [feature description]"        │
│    Output: Todo file + agent recommendations            │
├─────────────────────────────────────────────────────────┤
│ 2. CLAUDE: Implement with TDD                           │
│    Prompt: "Read .ai-context/ai-handoff.md and         │
│            implement todo [ID]"                         │
│    Output: Working code with tests                      │
├─────────────────────────────────────────────────────────┤
│ 3. CODEX: Document (optional)                           │
│    Prompt: "!update readme" or "!document solution"     │
│    Output: Updated documentation                        │
└─────────────────────────────────────────────────────────┘
```

**Example:**
```
→ Gemini: "!analyze task Implement user authentication with JWT"
→ Claude: "Read ai-handoff.md and implement the auth feature"
→ Codex: "!update readme with auth configuration section"
```

---

## 2. 🐛 Bug Fix

**Scenario:** Find and fix a bug.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Analyze the bug                              │
│    Prompt: "!analyze codebase focusing on [area]"       │
│    Or: "!analyze task Fix bug: [description]"           │
├─────────────────────────────────────────────────────────┤
│ 2. CLAUDE: Fix with TDD                                 │
│    Prompt: "Fix this bug: [description]. Start with     │
│            a failing test."                             │
│    Output: Test + fix                                   │
├─────────────────────────────────────────────────────────┤
│ 3. CODEX: Document solution (if complex)                │
│    Prompt: "!document solution"                         │
│    Output: docs/solutions/[category]/[name].md          │
└─────────────────────────────────────────────────────────┘
```

**Example:**
```
→ Gemini: "!analyze task Fix: login fails when email has uppercase"
→ Claude: "Fix the email case sensitivity bug, TDD approach"
→ Codex: "!document solution" (if it was tricky)
```

---

## 3. ♻️ Refactoring

**Scenario:** Improve existing code without changing behavior.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Analyze code smells                          │
│    Prompt: "!analyze codebase looking for              │
│            refactoring opportunities in [area]"         │
├─────────────────────────────────────────────────────────┤
│ 2. CLAUDE: Refactor safely                              │
│    Prompt: "Refactor [component]. Ensure tests pass     │
│            after each change."                          │
│    Key: Small incremental changes, run tests often      │
├─────────────────────────────────────────────────────────┤
│ 3. CODEX: Add missing tests (if needed)                 │
│    Prompt: "!add tests for [refactored component]"      │
└─────────────────────────────────────────────────────────┘
```

**⚠️ Important:** Refactoring = behavior stays the same. If tests break, something went wrong.

---

## 4. 📝 Documentation

**Scenario:** Create or update documentation.

```
┌─────────────────────────────────────────────────────────┐
│ CODEX (Primary)                                         │
│    Prompt: "!update readme" or                          │
│            "Document the API endpoints in [file]"       │
│                                                         │
│ Alternative: GEMINI for analysis first                  │
│    Prompt: "!analyze codebase to understand the         │
│            architecture for documentation"              │
└─────────────────────────────────────────────────────────┘
```

**Example:**
```
→ Codex: "!update readme with installation and usage sections"
→ Codex: "Document all exported functions in src/utils/"
```

---

## 5. 🔍 Code Review

**Scenario:** Review a PR or code changes.

```
┌─────────────────────────────────────────────────────────┐
│ GEMINI: Quick review                                    │
│    Prompt: "!check pr size" (if concerned about size)   │
│    Or: "Review these changes for issues: [diff/files]"  │
│                                                         │
│ CLAUDE: Deep review (if complex)                        │
│    Prompt: "Review [files] for security and            │
│            performance issues"                          │
└─────────────────────────────────────────────────────────┘
```

---

## 6. 🚀 Performance Optimization

**Scenario:** Improve application performance.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Identify bottlenecks                         │
│    Prompt: "!analyze codebase for performance           │
│            issues in [area]"                            │
├─────────────────────────────────────────────────────────┤
│ 2. CLAUDE: Implement optimizations                      │
│    Prompt: "Optimize [component]. Measure before/after" │
├─────────────────────────────────────────────────────────┤
│ 3. CODEX: Document the optimization                     │
│    Prompt: "!document solution" (category: performance) │
└─────────────────────────────────────────────────────────┘
```

---

## 7. 🔐 Security Audit

**Scenario:** Check code for security vulnerabilities.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Analyze for vulnerabilities                  │
│    Prompt: "!analyze codebase for security issues,      │
│            focus on auth and input validation"          │
│                                                         │
│ 2. CLAUDE: Fix identified issues                        │
│    Prompt: "Fix these security issues: [list]"          │
│                                                         │
│ 3. CODEX: Document security patterns                    │
│    Prompt: "!document solution" (category: security)    │
└─────────────────────────────────────────────────────────┘
```

---

## 8. 📦 New Project Setup

**Scenario:** Start a brand new project.

```
┌─────────────────────────────────────────────────────────┐
│ 1. Run: ai-start                                        │
│    → Creates .ai-context/ structure                     │
│    → Detects stack (or asks for profile)                │
│    → Generates AI configs                               │
├─────────────────────────────────────────────────────────┤
│ 2. GEMINI: Plan the architecture                        │
│    Prompt: "!analyze task Set up [project type] with    │
│            [requirements]"                              │
├─────────────────────────────────────────────────────────┤
│ 3. CLAUDE: Implement structure                          │
│    Prompt: "Read ai-handoff.md and set up the project"  │
└─────────────────────────────────────────────────────────┘
```

---

## 9. ⏸️ Resume Previous Work

**Scenario:** Continue work from a previous session.

```
┌─────────────────────────────────────────────────────────┐
│ ANY AI:                                                 │
│    Prompt: "Read .ai-context/ai-handoff.md and         │
│            continue where we left off"                  │
│                                                         │
│ The ai-handoff.md contains:                             │
│    - Current state                                      │
│    - Files being modified                               │
│    - Next steps                                         │
│    - Resume instructions                                │
└─────────────────────────────────────────────────────────┘
```

**Tip:** Always run `ai-stop` before ending a session to save state!

---

## 10. 🔀 Large PR (Split Work)

**Scenario:** Task is too big for one PR.

```
┌─────────────────────────────────────────────────────────┐
│ 1. GEMINI: Check and split                              │
│    Prompt: "!check pr size" or                          │
│            "!analyze task [big task] - split into PRs"  │
│    Output: Multiple todo files, one per PR              │
├─────────────────────────────────────────────────────────┤
│ 2. CLAUDE: Implement one at a time                      │
│    Prompt: "Implement only todo [ID], keep scope small" │
│    Repeat for each todo/PR                              │
└─────────────────────────────────────────────────────────┘
```

**Rule:** Each PR should be < 400 lines changed.

---

## 🎯 Quick Commands Reference

### Terminal
```bash
ai-start              # Initialize workspace
ai-stop               # End session, save state
ai-agents active      # See loaded agents
ai-help               # Show all commands
```

### In Chat (use ! prefix)
```
!ai-help              # List all keywords
!analyze codebase     # (Gemini) Full code analysis
!analyze task         # (Gemini) Task planning
!select agents        # (Gemini) Agent recommendations
!todo create          # (Gemini) Create todo file
!checkpoint           # (Claude) Save progress
!handoff gemini       # (Claude) Pass to Gemini
!document solution    # (Codex) Create solution doc
!add tests            # (Codex) Add test coverage
```

---

## 💡 Pro Tips

1. **Always start with Gemini** for complex tasks - cheaper and better at planning
2. **Use `!checkpoint`** frequently in Claude - saves progress to ai-handoff.md
3. **Document solutions** for tricky bugs - you'll thank yourself later
4. **Check PR size** before starting - split big tasks early
5. **Read ai-handoff.md** when switching AIs - it has the context

---

*Last updated: {{DATE}}*
