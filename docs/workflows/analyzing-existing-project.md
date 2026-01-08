# Workflow: Analyzing an Existing Project

## Objective

Use AI Terminal Agent to understand the current status of an ongoing project and share context between all AIs.

---

## Step by Step

### 1. Start the Workspace

```bash
cd ~/your-project
ai start
```

### 2. Use Claude for Initial Analysis (Left Panel)

In Claude's session, run:

```
Please analyze this project:

1. List all .md files in the project
2. Read README.md, PLAN.md, TODO.md (if they exist)
3. Analyze the folder structure
4. Identify:
   - Project objective
   - Current state (% complete)
   - Pending tasks
   - Next steps
   - Technologies used

Create an executive summary in .ai-context/project-status.md
```

### 3. Claude Creates Shared Context

Claude will create `.ai-context/project-status.md` with something like:

```markdown
# Project Status: Project Name

**Last Updated:** 2026-01-08
**Analyzed by:** Claude

## Executive Summary
Brief description of the project and current state.

## Overall Progress
- Completed: feature X, Y, Z
- In progress: feature A, B
- Pending: feature C, D

## Architecture
- Stack: React + Node.js + PostgreSQL
- Structure: src/, docs/, tests/

## Next Steps
1. Implement authentication
2. Add unit tests
3. Deploy to staging

## Technical Notes
Important decisions, known blockers, etc.
```

### 4. Share with Other AIs

**When you need each AI:**

- **Gemini** (Top Right Panel):
  ```
  Read .ai-context/project-status.md

  Now help me research: [your question about technologies, libraries, etc]
  ```

- **Codex** (Bottom Right Panel):
  ```
  Read .ai-context/project-status.md

  Now implement: [specific functionality]
  ```

### 5. Keep Context Updated

Whenever there are significant changes:

```bash
# Ask Claude:
Update .ai-context/project-status.md with today's changes
```

---

## Suggested Work Division

### Claude (Analysis & Architecture)
- Code analysis
- Documentation review
- Feature planning
- Complex refactoring
- Difficult debugging

### Gemini (Research & Documentation)
- Research libraries/tools
- Compare technical approaches
- Write documentation
- Generate usage examples
- Explore external APIs

### Codex (Fast Implementation)
- Write repetitive code
- Generate unit tests
- Create simple components
- Complete partial code
- Snippets and helpers

---

## Practical Example

### Scenario: Add authentication to the project

1. **Claude**: Analyze project and create implementation plan
   ```
   Based on .ai-context/project-status.md, create a detailed
   plan to add JWT authentication to the project.
   Save to .ai-context/auth-implementation-plan.md
   ```

2. **Gemini**: Research best practices
   ```
   Read .ai-context/auth-implementation-plan.md
   Research the best JWT libraries for Node.js and
   compare passport.js vs jsonwebtoken
   ```

3. **Codex**: Implement the code
   ```
   Read .ai-context/auth-implementation-plan.md
   Implement the authentication middleware according to the plan
   ```

4. **Claude**: Review the result
   ```
   Review the authentication code created by Codex.
   Check security and best practices.
   ```

---

## Tips

### Do
- Keep `.ai-context/` updated with important decisions
- Use each AI for its specialty
- Request short executive summaries (not long texts)
- Version `.ai-context/` in Git if useful for the team

### Don't
- Ask the same question to all 3 AIs (waste)
- Leave context outdated
- Ask for complex code from Gemini (use Claude/Codex)
- Ask for research from Codex (use Gemini)

---

## Useful Commands

```bash
# Check workspace status
ai status

# Create progress snapshot
echo "# $(date)" >> .ai-context/daily-log.md
echo "Today we implemented: ..." >> .ai-context/daily-log.md

# Close workspace with summary
ai stop
```

---

## Common Scenarios

### Scenario 1: Node.js/React Project with Outdated Docs

**Situation:** Old project, documentation doesn't reflect current code

**Workflow:**
1. **Claude (Analysis):**
   ```
   List all files in src/ and docs/
   Compare README.md with current code in src/
   What changed? What's outdated?
   Create .ai-context/docs-vs-code-diff.md with differences
   ```

2. **Claude (Update):**
   ```
   Based on the analysis, update README.md to reflect:
   - Current src/ structure
   - Current package.json scripts
   - New dependencies
   - API changes
   ```

3. **Gemini (Documentation):**
   ```
   Read .ai-context/docs-vs-code-diff.md
   Create updated usage examples for docs/examples/
   ```

### Scenario 2: Project with Pending Bugs

**Situation:** Various bugs reported, need to prioritize

**Workflow:**
1. **Claude (Analysis):**
   ```
   List all TODOs, FIXMEs in the code
   Read issues.md or TODO.md
   Analyze error logs if any
   Create .ai-context/bugs-prioritized.md classifying by:
   - Critical (breaks functionality)
   - High (impacts users)
   - Medium (inconveniences)
   - Low (cosmetic)
   ```

2. **Claude (Critical Fix):**
   ```
   Start with bug #1 from the critical list
   Analyze related code
   Implement the fix
   ```

3. **Codex (Tests):**
   ```
   Read .ai-context/bugs-prioritized.md
   Create unit tests to prevent regression of bug #1
   ```

### Scenario 3: Project Without Documentation

**Situation:** Working code but zero docs

**Workflow:**
1. **Claude (Reverse Engineering):**
   ```
   Analyze the entire project structure
   Identify:
   - Entry point (main.py, index.js, etc)
   - Main modules and their responsibilities
   - Data flow
   - Exposed APIs
   - External dependencies

   Create .ai-context/architecture-discovered.md with text diagram
   ```

2. **Claude (README):**
   ```
   Based on .ai-context/architecture-discovered.md
   Create complete README.md with:
   - What the project does
   - How to install
   - How to use (examples)
   - Folder structure
   ```

3. **Gemini (Detailed Docs):**
   ```
   Read .ai-context/architecture-discovered.md
   Create docs/API.md documenting all public endpoints/functions
   ```

### Scenario 4: Technology Migration

**Situation:** Migrate from JavaScript to TypeScript

**Workflow:**
1. **Claude (Planning):**
   ```
   Analyze all .js files
   Create migration plan in .ai-context/ts-migration-plan.md:
   - Migration order (dependencies first)
   - Most complex files
   - Custom types needed
   - Expected breaking changes
   ```

2. **Claude (Global Types):**
   ```
   Create types.d.ts with main interfaces
   Configure tsconfig.json
   ```

3. **Codex (File-by-File Migration):**
   ```
   Read .ai-context/ts-migration-plan.md
   Convert src/utils/helpers.js to helpers.ts
   Add type annotations
   ```

4. **Claude (Validation):**
   ```
   Review types created by Codex
   Check type safety
   Run tsc --noEmit
   ```

### Scenario 5: Prepare for Deploy/Production

**Situation:** Project is "ready" but never deployed

**Workflow:**
1. **Claude (Checklist):**
   ```
   Create .ai-context/production-checklist.md checking:
   - [ ] Environment variables configurable
   - [ ] Secrets not committed
   - [ ] Appropriate logs
   - [ ] Error handling
   - [ ] Tests passing
   - [ ] Optimized build
   - [ ] Deploy documentation
   ```

2. **Gemini (Deploy Research):**
   ```
   Research best practices for deploying [your stack]
   Compare: Heroku vs Vercel vs Railway vs AWS
   Create docs/deployment.md with recommendation
   ```

3. **Claude (Implementation):**
   ```
   Implement pending items from checklist
   Create Dockerfile if needed
   Configure basic CI/CD
   ```

4. **Codex (Scripts):**
   ```
   Create scripts/deploy.sh to automate deployment
   Add health check endpoint
   ```

### Scenario 6: Performance Audit

**Situation:** Application is slow, needs optimization

**Workflow:**
1. **Claude (Profiling):**
   ```
   Analyze code looking for:
   - O(n^2) or worse loops
   - N+1 queries in database
   - Unnecessary synchronous loading
   - Lack of cache
   - Heavy libraries not tree-shaken

   Create .ai-context/performance-bottlenecks.md
   ```

2. **Gemini (Research Alternatives):**
   ```
   Read .ai-context/performance-bottlenecks.md
   Research lighter libraries to replace [heavy lib]
   Compare benchmarks
   ```

3. **Claude (Refactoring):**
   ```
   Implement optimizations for bottleneck #1
   Add memoization where appropriate
   Implement lazy loading
   ```

4. **Codex (Performance Tests):**
   ```
   Create benchmarks to measure improvements
   Add performance tests in tests/
   ```

### Scenario 7: Security Audit

**Situation:** Need to verify security before release

**Workflow:**
1. **Claude (Security Analysis):**
   ```
   Look for:
   - [ ] SQL injection vulnerabilities
   - [ ] XSS vulnerabilities
   - [ ] CSRF protection
   - [ ] Sensitive data in logs
   - [ ] Hardcoded secrets
   - [ ] Dependencies with CVEs

   Create .ai-context/security-audit.md
   ```

2. **Gemini (OWASP Research):**
   ```
   Research OWASP Top 10 for [your app type]
   Check if vulnerabilities apply
   Document mitigations
   ```

3. **Claude (Fixes):**
   ```
   Implement priority fixes from audit
   Add input validation
   Sanitize outputs
   ```

---

## Prompt Templates by Project Type

### For Web Apps (React/Vue/Angular)

```
Analyze this web app:

1. Main components (src/components/)
2. State management (Redux/Context/etc)
3. API integration (how does it make requests?)
4. Routing (React Router/etc)
5. Styling approach (CSS/SCSS/Styled/Tailwind?)

Create .ai-context/webapp-status.md with:
- Complete vs incomplete components
- Working features
- Known UX issues
- Performance concerns
```

### For APIs/Backend

```
Analyze this API:

1. Framework (Express/FastAPI/etc)
2. Available endpoints (list all)
3. Authentication/Authorization
4. Database schema and ORM
5. Input validation
6. Error handling
7. Tests (coverage?)

Create .ai-context/api-status.md with:
- Documented vs undocumented endpoints
- Security implemented
- Performance (indexes, caching)
- Next endpoints to implement
```

### For CLI Tools

```
Analyze this CLI tool:

1. Available commands
2. Arguments and flags
3. Output formatting
4. Error messages
5. Help text
6. Config files

Create .ai-context/cli-status.md with:
- Working commands
- UX issues
- Missing commands
- Documentation needed
```

### For Libraries/SDKs

```
Analyze this library:

1. Public API (exported functions/classes)
2. Documentation (README, JSDoc, etc)
3. Usage examples
4. Tests and coverage
5. TypeScript types
6. Build output (CJS/ESM/UMD?)

Create .ai-context/library-status.md with:
- Stable vs experimental API
- Breaking changes since last version
- Missing docs
- Examples needed
```

---

## Communication Tips Between AIs

### Best Practices

**1. Concise Context:**
```markdown
<!-- .ai-context/current-task.md -->
# Current Task: Implement Auth

**Decided approach:** JWT with refresh tokens
**Stack:** passport.js + jsonwebtoken
**Affected files:**
- src/middleware/auth.js (create)
- src/routes/auth.js (create)
- src/models/User.js (modify)

**Status:** Claude already created plan in auth-plan.md
**Next:** Codex implement middleware
```

**2. Technical Decisions:**
```markdown
<!-- .ai-context/decisions.md -->
# Technical Decisions

## 2026-01-08: Authentication
**Decision:** Use JWT (not sessions)
**Reason:** Stateless API, mobile app needs it
**Alternatives considered:** Sessions, OAuth
**Decided by:** Claude

## 2026-01-08: Database
**Decision:** PostgreSQL (not MongoDB)
**Reason:** Relational data, ACID important
**Decided by:** Team + Gemini research
```

**3. Known Issues:**
```markdown
<!-- .ai-context/known-issues.md -->
# Known Issues

## Bug #1: Login timeout
- **Symptom:** Login takes 10+ seconds
- **Cause:** Query without index on users.email
- **Fix:** Claude will add index
- **Status:** Pending

## Limitation: File Upload
- **Situation:** Only accepts < 5MB
- **Reason:** Cloudflare limit
- **Workaround:** Use direct S3 upload
- **Status:** Documented
```

### Avoid

**Verbose Context:**
```markdown
<!-- DON'T do this -->
# Complete System Analysis

This document contains an extremely detailed analysis
of all aspects of the project, including complete history
of decisions since the beginning...

[50 pages of text]

<!-- Gemini/Codex won't read all this -->
```

**Outdated Information:**
```markdown
<!-- Remove obsolete information -->
# Status (2026-01-08)

- [x] Implement auth - Completed
- [ ] Add tests
```

---

## Remember

- `.ai-context/` is the "shared memory" of the AIs
- Keep files short and actionable
- Update when there are significant changes
- Use each AI for its specialty
