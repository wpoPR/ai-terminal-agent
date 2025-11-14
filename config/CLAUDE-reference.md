# Instruções do Projeto Claude Code - Uso Automático de Agentes

## FLUXO OBRIGATÓRIO

### 1. SEMPRE começar com Sequential Thinking
Para TODA tarefa, primeiro use Sequential Thinking para:
- Decompor o problema em etapas
- Identificar qual(is) agente(s) usar
- Planejar a sequência de execução
- Documentar a estratégia

### 2. Identificar e chamar o(s) agente(s) apropriado(s)
### 3. Validar resultados com Sequential Thinking

---

## MAPEAMENTO DE TAREFAS → AGENTES

### 📝 QUANDO RECEBER REQUISITOS DE CÓDIGO

**Análise inicial:**
- Use `Plan` para explorar o codebase
- Use `Explore` para entender estrutura existente

**Desenvolvimento:**
- Frontend (React/Next.js) → `frontend-developer`
- Backend/API → `backend-architect` ou `python-pro`/`javascript-pro`
- Mobile → `mobile-developer`
- C#/.NET → `csharp-pro`
- GraphQL → `graphql-architect`

---

### 🔍 QUANDO PRECISAR PESQUISAR/INVESTIGAR

**Pesquisa geral:**
- Tópicos complexos → `general-purpose`
- Busca web profunda → `search-specialist`
- Pesquisa com Gemini AI → `gemini-research-assistant`

**Investigação técnica:**
- Problemas de produção → `devops-troubleshooter`
- Performance issues → `performance-engineer`
- Problemas de rede → `network-engineer`

---

### 📚 QUANDO CRIAR DOCUMENTAÇÃO

**Por tipo:**
- Documentação técnica geral → `docs-architect`
- Referência de API → `api-documenter` ou `reference-builder`
- Tutoriais passo a passo → `tutorial-engineer`
- Diagramas visuais → `mermaid-diagram-expert`

---

### 🔒 QUANDO TRATAR SEGURANÇA

**Por camada:**
- Frontend security → `frontend-security-coder`
- Backend security → `backend-security-coder`
- Mobile security → `mobile-security-coder`
- Auditoria completa → `security-auditor`

---

### 🏗️ QUANDO TRABALHAR COM INFRAESTRUTURA

**Por tipo de infraestrutura:**
- Cloud geral → `cloud-architect`
- Híbrido/multi-cloud → `hybrid-cloud-architect`
- Kubernetes → `kubernetes-architect`
- Terraform/IaC → `terraform-specialist`

**DevOps:**
- CI/CD pipelines → `deployment-engineer`
- Monitoramento → `observability-engineer`
- Troubleshooting → `devops-troubleshooter`

---

### 💾 QUANDO TRABALHAR COM DADOS

**Por necessidade:**
- Otimização de queries → `database-optimizer`
- Pipelines de dados → `data-engineer`
- Operações de DB → `database-admin`
- Design de schema → `database-architect`
- ML em produção → `ml-production-engineer`
- MLOps → `mlops-engineer`
- Data science → `data-scientist`

---

### 🤖 QUANDO TRABALHAR COM AI/ML

**Por tipo:**
- LLMs/RAG/Agentes → `ai-engineer`
- ML em produção → `ml-production-engineer`
- Infraestrutura ML → `mlops-engineer`
- Análise estatística → `data-scientist`
- Design de prompts → `prompt-engineer`

---

### ✅ QUANDO REVISAR/VALIDAR CÓDIGO

**Por foco:**
- Revisão completa → `code-reviewer`
- Decisões arquiteturais → `architect-review`
- Testes automatizados → `test-automator`

---

### 💼 QUANDO TRATAR ASPECTOS DE NEGÓCIO

- Análise de negócios → `business-analyst`
- Trading/Finanças → `quant-analyst`
- Gestão de risco → `risk-manager`
- Content marketing → `content-marketer`

---

### 🛠️ QUANDO MELHORAR EXPERIÊNCIA DO DEV

- Setup de projeto → `dx-optimizer`
- Configuração de statusline → `statusline-setup`

---

## EXEMPLOS DE FLUXO COMPLETO

### Exemplo 1: "Criar API REST com autenticação"
```
1. Sequential Thinking: Planejar arquitetura
2. Plan: Explorar estrutura existente do projeto
3. backend-architect: Definir design da API
4. python-pro/javascript-pro: Implementar endpoints
5. backend-security-coder: Implementar autenticação segura
6. test-automator: Criar testes
7. api-documenter: Documentar API
8. code-reviewer: Revisar código final
```

### Exemplo 2: "Otimizar performance do frontend"
```
1. Sequential Thinking: Identificar gargalos
2. Explore: Analisar componentes atuais
3. performance-engineer: Diagnosticar problemas
4. frontend-developer: Implementar otimizações
5. code-reviewer: Validar mudanças
```

### Exemplo 3: "Deploy de modelo ML em produção"
```
1. Sequential Thinking: Planejar pipeline
2. ml-production-engineer: Preparar modelo
3. mlops-engineer: Setup de infraestrutura
4. kubernetes-architect: Deploy em K8s
5. observability-engineer: Configurar monitoramento
```

### Exemplo 4: "Auditoria de segurança completa"
```
1. Sequential Thinking: Definir escopo
2. security-auditor: Análise geral
3. frontend-security-coder: Revisar frontend
4. backend-security-coder: Revisar backend
5. code-reviewer: Validar correções
6. docs-architect: Documentar findings
```

---

## REGRAS DE EXECUÇÃO

### ✅ SEMPRE FAÇA:
1. Declare explicitamente qual agente vai usar e por quê
2. Use Sequential Thinking para coordenar múltiplos agentes
3. Chame agentes usando a ferramenta Task com subagent_type correto
4. Relate os resultados de cada agente

### ❌ NUNCA FAÇA:
1. Tentar fazer tudo sozinho sem chamar agentes
2. Chamar agentes sem explicar o motivo
3. Ignorar agentes especializados quando disponíveis
4. Pular o Sequential Thinking em tarefas complexas

---

## PRIORIZAÇÃO

**Alta prioridade (sempre usar quando aplicável):**
- Sequential Thinking (planejamento)
- Plan/Explore (compreensão de codebase)
- code-reviewer (validação)

**Média prioridade (usar conforme necessidade):**
- Agentes especializados de desenvolvimento
- Agentes de documentação
- Agentes de segurança

**Baixa prioridade (usar em casos específicos):**
- Agentes de negócio/marketing
- Utilitários específicos

---

## TEMPLATE DE RESPOSTA

Quando receber uma solicitação, estruture assim:
```
🤔 [Sequential Thinking]
- Análise do problema
- Agentes necessários: [lista]
- Sequência de execução

🔧 [Agente 1 - nome]
- Por que uso: [razão]
- [executar tarefa]
- Resultado: [resumo]

🔧 [Agente 2 - nome]
- Por que uso: [razão]
- [executar tarefa]
- Resultado: [resumo]

✅ [Validação Final]
- Revisão com Sequential Thinking
- Próximos passos (se houver)
```