# Agent Reference - Quick Guide for AI Analysis

**Location:** Copy this to `.ai-context/agents-reference.md` for Gemini to consult

---

## 📋 All Available Agents (45 total)

### Frontend Development (4 agents)
- **frontend-developer** - React, Vue, Angular, Next.js, components
- **ui-ux-designer** - UI/UX design, accessibility, user experience
- **frontend-security-coder** - Frontend security, XSS, CSRF, validation

### Backend Development (4 agents)
- **backend-architect** - API design, microservices, system architecture
- **backend-security-coder** - Backend security, authentication, authorization
- **database-architect** - Database schema, relationships, migrations
- **database-optimizer** - Query optimization, indexing, performance

### Mobile Development (3 agents)
- **mobile-developer** - React Native, Flutter, iOS, Android
- **mobile-security-coder** - Mobile security, secure storage, encryption

### DevOps & Infrastructure (5 agents)
- **cloud-architect** - AWS, GCP, Azure, cloud architecture
- **kubernetes-architect** - K8s, containers, orchestration
- **terraform-specialist** - IaC, Terraform, infrastructure as code
- **deployment-engineer** - CI/CD, deployment pipelines
- **devops-troubleshooter** - System debugging, logs, monitoring

### Data & Analytics (4 agents)
- **data-engineer** - ETL, data pipelines, data processing
- **data-scientist** - Analytics, ML, data analysis
- **database-admin** - Database administration, backup, recovery

### AI & Machine Learning (4 agents)
- **ai-engineer** - AI/ML systems, model integration
- **ml-production-engineer** - ML deployment, serving, monitoring
- **mlops-engineer** - MLOps, model lifecycle, automation
- **prompt-engineer** - LLM prompts, AI optimization

### Security & Auditing (4 agents)
- **security-auditor** - Security audits, vulnerability assessment
- **network-engineer** - Network security, firewall, VPN

### Documentation & Content (4 agents)
- **docs-architect** - Technical documentation, API docs
- **tutorial-engineer** - Tutorials, guides, examples
- **api-documenter** - API documentation, OpenAPI, Swagger
- **content-marketer** - Content strategy, technical writing

### Code Quality & Testing (4 agents)
- **code-reviewer** - Code review, best practices, quality
- **test-automator** - Test automation, unit tests, integration tests
- **architect-review** - Architecture review, design patterns

### Performance & Optimization (3 agents)
- **performance-engineer** - Performance optimization, profiling
- **observability-engineer** - Monitoring, logging, tracing
- **dx-optimizer** - Developer experience optimization

### Specialized (5 agents)
- **business-analyst** - Requirements, business logic
- **graphql-architect** - GraphQL API design
- **mermaid-diagram-expert** - Diagrams, visualization
- **search-specialist** - Search optimization, Elasticsearch
- **reference-builder** - Reference documentation

### Programming Languages (3 agents)
- **javascript-pro** - Advanced JavaScript/TypeScript
- **python-pro** - Advanced Python
- **csharp-pro** - Advanced C#

### Finance & Analytics (2 agents)
- **quant-analyst** - Quantitative analysis, financial models
- **risk-manager** - Risk assessment, compliance

### Research (1 agent)
- **gemini-research-assistant** - Research coordination

### Management (1 agent)
- **workspace-manager** - AI Terminal Agent expert, knows all commands

---

## 🎯 Quick Selection Guide

### By Task Type

**Building a Web App (Full-stack):**
```
ai-agents-activate frontend-developer backend-architect database-architect code-reviewer
```

**Frontend Only (React/Next.js):**
```
ai-agents-activate frontend-developer ui-ux-designer code-reviewer
```

**Backend API:**
```
ai-agents-activate backend-architect database-architect backend-security-coder code-reviewer
```

**Mobile App:**
```
ai-agents-activate mobile-developer ui-ux-designer code-reviewer
```

**DevOps/Infrastructure:**
```
ai-agents-activate cloud-architect kubernetes-architect terraform-specialist deployment-engineer devops-troubleshooter
```

**Data Pipeline:**
```
ai-agents-activate data-engineer database-architect database-optimizer code-reviewer
```

**ML/AI Project:**
```
ai-agents-activate ai-engineer ml-production-engineer mlops-engineer data-scientist
```

**Security Audit:**
```
ai-agents-activate security-auditor backend-security-coder frontend-security-coder network-engineer
```

**Documentation:**
```
ai-agents-activate docs-architect api-documenter tutorial-engineer
```

**Performance Optimization:**
```
ai-agents-activate performance-engineer observability-engineer database-optimizer
```

---

## 📊 Token Estimates

| Agents | Estimated Tokens | Usage % |
|--------|------------------|---------|
| 2 | ~4k | 27% |
| 3 | ~6k | 40% |
| 4 | ~8-10k | 53-67% |
| 5 | ~10-12k | 67-80% |
| 6+ | ~12-15k+ | 80-100%+ |

**Target:** Keep under 12k tokens (80%) for optimal performance

---

## 🤖 Analysis Guidelines for AI

When analyzing a task:

1. **Identify Domains:**
   - Frontend keywords: React, Vue, UI, component, JSX, CSS
   - Backend keywords: API, server, endpoint, database, REST, GraphQL
   - Mobile keywords: iOS, Android, React Native, Flutter, app
   - DevOps keywords: Docker, K8s, deploy, CI/CD, infrastructure
   - Data keywords: ETL, pipeline, analytics, warehouse, SQL
   - Security keywords: auth, encryption, vulnerability, JWT, OAuth
   - ML keywords: model, training, ML, AI, LLM, TensorFlow

2. **Match to Agents:**
   - Select 3-5 agents that match the task domains
   - Always include code-reviewer for quality
   - Add security agents for auth/payment features
   - Consider performance agents for optimization tasks

3. **Verify Token Budget:**
   - Calculate total: agent count × ~2k tokens
   - Keep under 12k for best performance
   - If over, prioritize most critical agents

4. **Execute:**
   ```bash
   ai-agents-activate agent1 agent2 agent3 agent4
   ```

---

## ⚠️ Important Notes

- **Location:** All agents available in `~/.ai-workspace/agents/`
- **Activation:** Script copies to `.claude/agents/`
- **Detection:** Claude auto-detects (no restart needed!)
- **Deactivation:** Old agents removed when new ones activated
- **Config:** Updates `.ai-config` automatically

---

**For full details, see:** `~/workspace/primavera/ai-terminal-agent/agents-list/workspace-manager.md`

