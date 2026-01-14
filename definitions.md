# Claude Code Project Instructions - Automatic Agent Usage

## MANDATORY FLOW

### 1. ALWAYS start with Sequential Thinking
For EVERY task, first use Sequential Thinking to:
- Break down the problem into steps
- Identify which agent(s) to use
- Plan execution sequence
- Document the strategy

### 2. Identify and call appropriate agent(s)
### 3. Validate results with Sequential Thinking

---

## TASK → AGENT MAPPING

### 📝 WHEN RECEIVING CODE REQUIREMENTS

**Initial analysis:**
- Use `Plan` to explore the codebase
- Use `Explore` to understand existing structure

**Development:**
- Frontend (React/Next.js) → `frontend-developer`
- Backend/API → `backend-architect` or `python-pro`/`javascript-pro`
- Mobile → `mobile-developer`
- C#/.NET → `csharp-pro`
- GraphQL → `graphql-architect`

---

### 🔍 WHEN RESEARCHING/INVESTIGATING

**General research:**
- Complex topics → `general-purpose`
- Deep web search → `search-specialist`
- Research with Gemini AI → `gemini-research-assistant`

**Technical investigation:**
- Production issues → `devops-troubleshooter`
- Performance issues → `performance-engineer`
- Network problems → `network-engineer`

---

### 📚 WHEN CREATING DOCUMENTATION

**By type:**
- General technical documentation → `docs-architect`
- API reference → `api-documenter` or `reference-builder`
- Step-by-step tutorials → `tutorial-engineer`
- Visual diagrams → `mermaid-diagram-expert`

---

### 🔒 WHEN HANDLING SECURITY

**By layer:**
- Frontend security → `frontend-security-coder`
- Backend security → `backend-security-coder`
- Mobile security → `mobile-security-coder`
- Complete audit → `security-auditor`

---

### 🏗️ WHEN WORKING WITH INFRASTRUCTURE

**By infrastructure type:**
- General cloud → `cloud-architect`
- Hybrid/multi-cloud → `hybrid-cloud-architect`
- Kubernetes → `kubernetes-architect`
- Terraform/IaC → `terraform-specialist`

**DevOps:**
- CI/CD pipelines → `deployment-engineer`
- Monitoring → `observability-engineer`
- Troubleshooting → `devops-troubleshooter`

---

### 💾 WHEN WORKING WITH DATA

**By need:**
- Query optimization → `database-optimizer`
- Data pipelines → `data-engineer`
- DB operations → `database-admin`
- Schema design → `database-architect`
- ML in production → `ml-production-engineer`
- MLOps → `mlops-engineer`
- Data science → `data-scientist`

---

### 🤖 WHEN WORKING WITH AI/ML

**By type:**
- LLMs/RAG/Agents → `ai-engineer`
- ML in production → `ml-production-engineer`
- ML infrastructure → `mlops-engineer`
- Statistical analysis → `data-scientist`
- Prompt design → `prompt-engineer`

---

### ✅ WHEN REVIEWING/VALIDATING CODE

**By focus:**
- Complete review → `code-reviewer`
- Architectural decisions → `architect-review`
- Automated tests → `test-automator`

---

### 💼 WHEN HANDLING BUSINESS ASPECTS

- Business analysis → `business-analyst`
- Trading/Finance → `quant-analyst`
- Risk management → `risk-manager`
- Content marketing → `content-marketer`

---

### 🛠️ WHEN IMPROVING DEV EXPERIENCE

- Project setup → `dx-optimizer`
- Statusline configuration → `statusline-setup`

---

## COMPLETE FLOW EXAMPLES

### Example 1: "Create REST API with authentication"
```
1. Sequential Thinking: Plan architecture
2. Plan: Explore existing project structure
3. backend-architect: Define API design
4. python-pro/javascript-pro: Implement endpoints
5. backend-security-coder: Implement secure authentication
6. test-automator: Create tests
7. api-documenter: Document API
8. code-reviewer: Review final code
```

### Example 2: "Optimize frontend performance"
```
1. Sequential Thinking: Identify bottlenecks
2. Explore: Analyze current components
3. performance-engineer: Diagnose issues
4. frontend-developer: Implement optimizations
5. code-reviewer: Validate changes
```

### Example 3: "Deploy ML model to production"
```
1. Sequential Thinking: Plan pipeline
2. ml-production-engineer: Prepare model
3. mlops-engineer: Setup infrastructure
4. kubernetes-architect: Deploy to K8s
5. observability-engineer: Configure monitoring
```

### Example 4: "Complete security audit"
```
1. Sequential Thinking: Define scope
2. security-auditor: General analysis
3. frontend-security-coder: Review frontend
4. backend-security-coder: Review backend
5. code-reviewer: Validate fixes
6. docs-architect: Document findings
```

---

## EXECUTION RULES

### ✅ ALWAYS DO:
1. Explicitly declare which agent you'll use and why
2. Use Sequential Thinking to coordinate multiple agents
3. Call agents using Task tool with correct subagent_type
4. Report results from each agent

### ❌ NEVER DO:
1. Try to do everything yourself without calling agents
2. Call agents without explaining the reason
3. Ignore specialized agents when available
4. Skip Sequential Thinking on complex tasks

---

## PRIORITIZATION

**High priority (always use when applicable):**
- Sequential Thinking (planning)
- Plan/Explore (codebase understanding)
- code-reviewer (validation)

**Medium priority (use as needed):**
- Specialized development agents
- Documentation agents
- Security agents

**Low priority (use in specific cases):**
- Business/marketing agents
- Specific utilities

---

## RESPONSE TEMPLATE

When receiving a request, structure like this:
```
🤔 [Sequential Thinking]
- Problem analysis
- Required agents: [list]
- Execution sequence

🔧 [Agent 1 - name]
- Why I'm using it: [reason]
- [execute task]
- Result: [summary]

🔧 [Agent 2 - name]
- Why I'm using it: [reason]
- [execute task]
- Result: [summary]

✅ [Final Validation]
- Review with Sequential Thinking
- Next steps (if any)
```
