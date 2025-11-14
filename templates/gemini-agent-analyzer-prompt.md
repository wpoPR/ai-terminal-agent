# Prompt para Gemini - Análise e Ativação de Agentes

Use este prompt no console do Gemini para que ele analise a tarefa e ative os agentes ideais.

**IMPORTANTE:** Gemini faz a análise inteligente, o script apenas copia arquivos!

---

## 📋 Prompt Completo (Recomendado)

```
Por favor, atue como especialista em otimização de agentes do ai-terminal-agent.

Tarefa:
1. Leia workspace-manager.md para conhecer TODOS os 45 agentes disponíveis
2. Leia .ai-context/current-task.md para entender a tarefa atual
3. Analise inteligentemente quais domínios técnicos estão envolvidos:
   - Frontend? (React, Vue, UI, componentes)
   - Backend? (API, database, server)
   - Mobile? (iOS, Android, React Native)
   - DevOps? (Docker, K8s, CI/CD)
   - Data? (ETL, analytics, pipelines)
   - Security? (Auth, encryption)
   - AI/ML? (models, training, LLMs)

4. Consulte a tabela "Task → Profile Mapping" no workspace-manager.md

5. Determine os agentes específicos necessários (não apenas perfil)

6. Execute o comando com a lista de agentes:

   ai-agents-activate <agent1> <agent2> <agent3> ...

Exemplo:
   ai-agents-activate frontend-developer backend-architect database-architect security-auditor

O script irá:
- Copiar APENAS os agentes especificados para .claude/agents/
- Remover agentes antigos
- Claude detectará automaticamente (sem restart!)

Após executar, forneça um resumo:
- Agentes ativados (lista completa)
- Estimativa de tokens (~Xk/15k)
- Justificativa de cada agente escolhido
- Perfil equivalente (se houver)

Seja específico e inteligente na análise!
```

---

## 🎯 Prompt Alternativo (Com Explicação Detalhada)

Se você quiser que o Gemini explique antes de ativar:

```
Por favor, analise a tarefa atual e sugira configuração de agentes:

1. **Leitura:**
   - Abra e leia .ai-context/current-task.md
   - Identifique keywords e domínios técnicos

2. **Análise:**
   - Frontend? (React, Vue, UI, componentes)
   - Backend? (API, database, server)
   - Mobile? (iOS, Android, React Native)
   - DevOps? (Docker, K8s, CI/CD)
   - Data? (ETL, analytics, pipelines)
   - Security? (Auth, encryption, vulnerabilities)
   - AI/ML? (models, training, LLMs)

3. **Consulta:**
   - Consulte workspace-manager.md
   - Veja a tabela "Task → Profile Mapping"
   - Identifique o perfil ideal

4. **Recomendação:**
   Forneça:
   - Perfil recomendado
   - Agentes específicos
   - Estimativa de tokens (~Xk/15k)
   - Justificativa

5. **Ativação:**
   Após confirmação, execute:
   ai-agents-analyze --auto

Seja conciso e técnico!
```

---

## 🚀 Exemplo de Uso Real

### Cenário: Adicionar Dashboard de Analytics

**Tarefa em .ai-context/current-task.md:**
```markdown
# Current Task

Adicionar dashboard de analytics ao app React com:
- Gráficos interativos (Chart.js)
- API REST para buscar métricas
- Queries otimizadas no PostgreSQL
- Cache com Redis
```

**Gemini Executa:**
```
Analisando .ai-context/current-task.md...

Domínios detectados:
✓ Frontend (React, gráficos, dashboard)
✓ Backend (API REST, cache)
✓ Data (queries, PostgreSQL, analytics)

Perfil recomendado: fullstack+data

Executando: ai-agents-analyze --auto

Resultado:
- Perfil ativado: fullstack+data
- Agentes: 6
  • frontend-developer (Dashboard UI)
  • ui-ux-designer (Charts design)
  • backend-architect (API endpoints)
  • database-architect (Query optimization)
  • database-optimizer (Performance)
  • data-engineer (Analytics logic)
- Tokens: ~12k/15k (80%)

Claude está pronto com os agentes ideais! 🎯
```

---

## ⚡ Modo Super Rápido (One-Liner)

Para ativação rápida (Gemini decide e executa):

```
Leia workspace-manager.md e .ai-context/current-task.md, determine os agentes necessários e execute: ai-agents-activate <lista-de-agentes>
```

---

## 🔍 Modo Análise Apenas (Sem Ativar)

Para ver sugestões sem ativar ainda:

```
Leia workspace-manager.md e .ai-context/current-task.md, analise os domínios técnicos e sugira quais agentes devem ser ativados. NÃO execute nenhum comando ainda, apenas explique sua análise e recomendação.
```

---

## 📊 Comparação de Custos

| Abordagem | Tokens Usados | Custo |
|-----------|---------------|-------|
| Claude analisa manualmente | ~2-3k tokens | $$$ |
| Gemini analisa + ai-agents-activate | ~500-1k tokens | $ |
| **Economia:** | **70-80%** | **70-80%** |

**Por que é mais barato?**
- Gemini lê workspace-manager.md (tem todos os agentes)
- Gemini faz análise inteligente
- Script apenas copia arquivos (mecânico)
- Claude recebe agentes prontos (não precisa analisar)

---

## 💡 Dicas para Gemini

**Boas Práticas:**
- ✅ Leia o workspace-manager.md para entender os perfis
- ✅ Considere combinações (ex: frontend+security)
- ✅ Verifique se tokens ficam < 15k
- ✅ Justifique a escolha baseado na tarefa

**Evite:**
- ❌ Ativar muitos agentes desnecessariamente
- ❌ Ignorar o tipo de tarefa
- ❌ Esquecer de verificar tokens
- ❌ Não explicar a recomendação

---

## 🎓 Template de Resposta Ideal

Quando o Gemini ativar agentes, ele deve responder assim:

```markdown
## ✅ Agentes Ativados

**Tarefa Analisada:**
[Breve resumo da tarefa]

**Domínios Identificados:**
- Frontend (keywords: React, UI, components)
- Backend (keywords: API, database)

**Perfil Ativado:** fullstack

**Agentes Incluídos (4):**
1. frontend-developer - Componentes React
2. backend-architect - API design
3. database-architect - Schema e queries
4. code-reviewer - Quality assurance

**Token Usage:** ~10k / 15k (67%)
Status: ✅ Optimal

**Justificativa:**
Tarefa envolve frontend e backend. Fullstack profile
fornece expertise necessária sem exceder token budget.

**Claude Code:**
Agentes detectados automaticamente. Pronto para trabalhar! 🚀
```

---

## 🔄 Workflow Completo

```bash
# 1. Usuário descreve tarefa
echo "Adicionar login com OAuth" >> .ai-context/current-task.md

# 2. No Gemini console (prompt completo):
"Leia workspace-manager.md para conhecer os agentes,
 leia .ai-context/current-task.md para entender a tarefa,
 analise e execute: ai-agents-activate <lista-de-agentes>"

# 3. Gemini:
   - Lê workspace-manager.md (conhece os 45 agentes)
   - Lê current-task.md (entende: login + OAuth + security)
   - Analisa: Preciso frontend + backend + security
   - Decide: frontend-developer, backend-architect, frontend-security-coder, backend-security-coder
   - Executa: ai-agents-activate frontend-developer backend-architect frontend-security-coder backend-security-coder

# 4. Script copia os 4 agentes para .claude/agents/

# 5. Claude auto-detecta os agentes (sem restart!)

# 6. Profit! 🎉
```

---

**Lembre-se:** Claude NÃO precisa reiniciar! Ele detecta novos agentes automaticamente via file watcher em `.claude/agents/`.

