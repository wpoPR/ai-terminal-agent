# Workflow: Analisando Projeto Existente

## Objetivo
Usar o AI Terminal Agent para entender o status atual de um projeto em andamento e compartilhar esse contexto entre todos os AIs.

## Passo a Passo

### 1. Inicie o Workspace
```bash
cd ~/seu-projeto
ai-start
```

### 2. Use Claude para Análise Inicial (Tab 1, Painel Esquerdo)

Na sessão do Claude, execute:

```
Por favor, analise este projeto:

1. Liste todos os arquivos .md do projeto
2. Leia README.md, PLAN.md, TODO.md (se existirem)
3. Analise a estrutura de pastas
4. Identifique:
   - Objetivo do projeto
   - Estado atual (% completo)
   - Tarefas pendentes
   - Próximos passos
   - Tecnologias usadas

Crie um resumo executivo em .ai-context/project-status.md
```

### 3. Claude Criará o Contexto Compartilhado

Claude irá criar `.ai-context/project-status.md` com algo como:

```markdown
# Project Status: Nome do Projeto

**Última Atualização:** 2025-11-01
**Analisado por:** Claude

## Resumo Executivo
Breve descrição do projeto e estado atual.

## Progresso Geral
- ✅ Completado: feature X, Y, Z
- 🚧 Em andamento: feature A, B
- ⏳ Pendente: feature C, D

## Arquitetura
- Stack: React + Node.js + PostgreSQL
- Estrutura: src/, docs/, tests/

## Próximos Passos
1. Implementar autenticação
2. Adicionar testes unitários
3. Deploy em staging

## Notas Técnicas
Decisões importantes, bloqueios conhecidos, etc.
```

### 4. Compartilhe com os Outros AIs

**Quando precisar de cada AI:**

- **Gemini** (Tab 1, Painel Superior Direito):
  ```
  Leia .ai-context/project-status.md

  Agora me ajude a pesquisar: [sua pergunta sobre tecnologias, bibliotecas, etc]
  ```

- **Codex** (Tab 1, Painel Inferior Direito):
  ```
  /init

  [Após iniciar]
  Leia .ai-context/project-status.md

  Agora implemente: [funcionalidade específica]
  ```

### 5. Mantenha o Contexto Atualizado

Sempre que houver mudanças significativas:

```bash
# No tab de Control Console:
echo "$(date): Feature X completada" >> .ai-context/changelog.md
```

Ou peça ao Claude:
```
Atualize .ai-context/project-status.md com as mudanças que fizemos hoje
```

## Divisão de Trabalho Sugerida

### Claude (Análise & Arquitetura)
- ✅ Análise de código existente
- ✅ Revisão de documentação
- ✅ Planejamento de features
- ✅ Refatoração complexa
- ✅ Debug de problemas difíceis

### Gemini (Pesquisa & Documentação)
- ✅ Pesquisar bibliotecas/ferramentas
- ✅ Comparar abordagens técnicas
- ✅ Escrever documentação
- ✅ Gerar exemplos de uso
- ✅ Explorar APIs externas

### Codex (Implementação Rápida)
- ✅ Escrever código repetitivo
- ✅ Gerar testes unitários
- ✅ Criar componentes simples
- ✅ Completar código parcial
- ✅ Snippets e helpers

## Exemplo Prático

### Cenário: Adicionar autenticação ao projeto

1. **Claude**: Analise o projeto e crie plano de implementação
   ```
   Com base no .ai-context/project-status.md, crie um plano
   detalhado para adicionar autenticação JWT ao projeto.
   Salve em .ai-context/auth-implementation-plan.md
   ```

2. **Gemini**: Pesquise melhores práticas
   ```
   Leia .ai-context/auth-implementation-plan.md
   Pesquise as melhores bibliotecas JWT para Node.js e
   compare passport.js vs jsonwebtoken
   ```

3. **Codex**: Implemente o código
   ```
   Leia .ai-context/auth-implementation-plan.md
   Implemente o middleware de autenticação conforme o plano
   ```

4. **Claude**: Revise o resultado
   ```
   Revise o código de autenticação criado pelo Codex.
   Verifique segurança e boas práticas.
   ```

## Dicas

### ✅ Faça
- Mantenha `.ai-context/` atualizado com decisões importantes
- Use cada AI para sua especialidade
- Peça resumos executivos curtos (não textos longos)
- Versione o `.ai-context/` no Git se útil para a equipe

### ❌ Evite
- Fazer a mesma pergunta para os 3 AIs (desperdício)
- Deixar contexto desatualizado
- Pedir código complexo ao Gemini (use Claude/Codex)
- Pedir pesquisa ao Codex (use Gemini)

## Atalhos Úteis

```bash
# Ver status do workspace
ai-status

# Criar snapshot do progresso
echo "# $(date)" >> .ai-context/daily-log.md
echo "Hoje implementamos: ..." >> .ai-context/daily-log.md

# Fechar workspace com resumo
ai-stop
```

## Próximos Passos

Após análise inicial:
1. Execute os testes existentes
2. Identifique débito técnico
3. Priorize próximas tarefas
4. Divida trabalho entre os AIs

---

## Cenários Comuns

### 📦 Cenário 1: Projeto Node.js/React com Docs Desatualizadas

**Situação:** Projeto antigo, documentação não reflete código atual

**Workflow:**
1. **Claude (Análise):**
   ```
   Liste todos os arquivos em src/ e docs/
   Compare README.md com o código atual em src/
   O que mudou? O que está desatualizado?
   Crie .ai-context/docs-vs-code-diff.md com as diferenças
   ```

2. **Claude (Atualização):**
   ```
   Com base na análise, atualize README.md para refletir:
   - Estrutura atual de src/
   - Scripts package.json atuais
   - Novas dependências
   - Mudanças na API
   ```

3. **Gemini (Documentação):**
   ```
   Leia .ai-context/docs-vs-code-diff.md
   Crie exemplos de uso atualizados para docs/examples/
   ```

### 🐛 Cenário 2: Projeto com Bugs Pendentes

**Situação:** Vários bugs relatados, precisa priorizar

**Workflow:**
1. **Claude (Análise):**
   ```
   Liste todos os TODOs, FIXMEs no código
   Leia issues.md ou TODO.md
   Analise logs de erro se houver
   Crie .ai-context/bugs-prioritized.md classificando por:
   - Crítico (quebra funcionalidade)
   - Alto (impacta usuários)
   - Médio (inconveniências)
   - Baixo (cosméticos)
   ```

2. **Claude (Fix Crítico):**
   ```
   Começe pelo bug #1 da lista crítica
   Analise o código relacionado
   Implemente a correção
   ```

3. **Codex (Testes):**
   ```
   Leia .ai-context/bugs-prioritized.md
   Crie testes unitários para prevenir regressão do bug #1
   ```

### 🏗️ Cenário 3: Projeto Sem Documentação

**Situação:** Código funcional mas zero docs

**Workflow:**
1. **Claude (Reverse Engineering):**
   ```
   Analise toda a estrutura do projeto
   Identifique:
   - Ponto de entrada (main.py, index.js, etc)
   - Módulos principais e suas responsabilidades
   - Fluxo de dados
   - APIs expostas
   - Dependências externas

   Crie .ai-context/architecture-discovered.md com diagrama textual
   ```

2. **Claude (README):**
   ```
   Com base em .ai-context/architecture-discovered.md
   Crie README.md completo com:
   - O que o projeto faz
   - Como instalar
   - Como usar (exemplos)
   - Estrutura de pastas
   ```

3. **Gemini (Docs Detalhadas):**
   ```
   Leia .ai-context/architecture-discovered.md
   Crie docs/API.md documentando todos os endpoints/funções públicas
   ```

### 🔄 Cenário 4: Migração de Tecnologia

**Situação:** Migrar de JavaScript para TypeScript

**Workflow:**
1. **Claude (Planejamento):**
   ```
   Analise todos os arquivos .js
   Crie plano de migração em .ai-context/ts-migration-plan.md:
   - Ordem de migração (dependências primeiro)
   - Arquivos mais complexos
   - Tipos customizados necessários
   - Breaking changes esperados
   ```

2. **Claude (Tipos Globais):**
   ```
   Crie types.d.ts com interfaces principais
   Configure tsconfig.json
   ```

3. **Codex (Migração Arquivo por Arquivo):**
   ```
   Leia .ai-context/ts-migration-plan.md
   Converta src/utils/helpers.js para helpers.ts
   Adicione type annotations
   ```

4. **Claude (Validação):**
   ```
   Revise os tipos criados pelo Codex
   Verifique type safety
   Execute tsc --noEmit
   ```

### 🚀 Cenário 5: Preparar Deploy/Produção

**Situação:** Projeto está "pronto" mas nunca foi deployado

**Workflow:**
1. **Claude (Checklist):**
   ```
   Crie .ai-context/production-checklist.md verificando:
   - [ ] Variáveis de ambiente configuráveis
   - [ ] Secrets não commitados
   - [ ] Logs apropriados
   - [ ] Error handling
   - [ ] Testes passando
   - [ ] Build otimizado
   - [ ] Documentação de deploy
   ```

2. **Gemini (Pesquisa de Deploy):**
   ```
   Pesquise melhores práticas para deploy de [seu stack]
   Compare: Heroku vs Vercel vs Railway vs AWS
   Crie docs/deployment.md com recomendação
   ```

3. **Claude (Implementação):**
   ```
   Implemente os itens pendentes do checklist
   Crie Dockerfile se necessário
   Configure CI/CD básico
   ```

4. **Codex (Scripts):**
   ```
   Crie scripts/deploy.sh para automatizar deploy
   Adicione health check endpoint
   ```

### 📊 Cenário 6: Performance Audit

**Situação:** Aplicação está lenta, precisa otimizar

**Workflow:**
1. **Claude (Profiling):**
   ```
   Analise o código procurando por:
   - Loops O(n²) ou pior
   - Queries N+1 em banco de dados
   - Carregamento síncrono desnecessário
   - Falta de cache
   - Bibliotecas pesadas não tree-shaked

   Crie .ai-context/performance-bottlenecks.md
   ```

2. **Gemini (Pesquisa de Alternativas):**
   ```
   Leia .ai-context/performance-bottlenecks.md
   Pesquise bibliotecas mais leves para substituir [lib pesada]
   Compare benchmarks
   ```

3. **Claude (Refatoração):**
   ```
   Implemente otimizações do bottleneck #1
   Adicione memoização onde apropriado
   Implemente lazy loading
   ```

4. **Codex (Testes de Performance):**
   ```
   Crie benchmarks para medir melhorias
   Adicione performance tests em tests/
   ```

### 🔐 Cenário 7: Security Audit

**Situação:** Precisa verificar segurança antes de release

**Workflow:**
1. **Claude (Análise de Segurança):**
   ```
   Procure por:
   - [ ] SQL injection vulnerabilities
   - [ ] XSS vulnerabilities
   - [ ] CSRF protection
   - [ ] Sensitive data em logs
   - [ ] Secrets hardcoded
   - [ ] Dependências com CVEs

   Crie .ai-context/security-audit.md
   ```

2. **Gemini (Pesquisa OWASP):**
   ```
   Pesquise OWASP Top 10 para [seu tipo de app]
   Verifique se as vulnerabilidades se aplicam
   Documente mitigações
   ```

3. **Claude (Correções):**
   ```
   Implemente correções prioritárias do audit
   Adicione input validation
   Sanitize outputs
   ```

---

## Templates de Prompt por Tipo de Projeto

### Para Web Apps (React/Vue/Angular)

```
Analise este web app:

1. Componentes principais (src/components/)
2. State management (Redux/Context/etc)
3. API integration (como faz requests?)
4. Routing (React Router/etc)
5. Styling approach (CSS/SCSS/Styled/Tailwind?)

Crie .ai-context/webapp-status.md com:
- Componentes completos vs incompletos
- Features funcionais
- UX issues conhecidos
- Performance concerns
```

### Para APIs/Backend

```
Analise esta API:

1. Framework (Express/FastAPI/etc)
2. Endpoints disponíveis (liste todos)
3. Autenticação/Autorização
4. Database schema e ORM
5. Validação de input
6. Error handling
7. Testes (coverage?)

Crie .ai-context/api-status.md com:
- Endpoints documentados vs não documentados
- Segurança implementada
- Performance (indexes, caching)
- Próximos endpoints a implementar
```

### Para CLI Tools

```
Analise esta CLI tool:

1. Comandos disponíveis
2. Argumentos e flags
3. Output formatting
4. Error messages
5. Help text
6. Config files

Crie .ai-context/cli-status.md com:
- Comandos funcionais
- UX issues
- Missing commands
- Documentation needed
```

### Para Libraries/SDKs

```
Analise esta biblioteca:

1. API pública (funções/classes exportadas)
2. Documentação (README, JSDoc, etc)
3. Exemplos de uso
4. Testes e coverage
5. TypeScript types
6. Build output (CJS/ESM/UMD?)

Crie .ai-context/library-status.md com:
- API estável vs experimental
- Breaking changes desde última versão
- Docs missing
- Examples needed
```

---

## Dicas de Comunicação Entre AIs

### ✅ Boas Práticas

**1. Contexto Conciso:**
```markdown
<!-- .ai-context/current-task.md -->
# Tarefa Atual: Implementar Auth

**Abordagem decidida:** JWT com refresh tokens
**Stack:** passport.js + jsonwebtoken
**Arquivos afetados:**
- src/middleware/auth.js (criar)
- src/routes/auth.js (criar)
- src/models/User.js (modificar)

**Status:** Claude já criou o plano em auth-plan.md
**Próximo:** Codex implementar middleware
```

**2. Decisões Técnicas:**
```markdown
<!-- .ai-context/decisions.md -->
# Decisões Técnicas

## 2025-11-01: Autenticação
**Decisão:** Usar JWT (não sessions)
**Motivo:** API stateless, mobile app precisa
**Alternativas consideradas:** Sessions, OAuth
**Quem decidiu:** Claude

## 2025-11-01: Database
**Decisão:** PostgreSQL (não MongoDB)
**Motivo:** Dados relacionais, ACID importante
**Quem decidiu:** Time + Gemini research
```

**3. Problemas Conhecidos:**
```markdown
<!-- .ai-context/known-issues.md -->
# Problemas Conhecidos

## 🐛 Bug #1: Login timeout
- **Sintoma:** Login leva 10+ segundos
- **Causa:** Query sem index em users.email
- **Fix:** Claude vai adicionar index
- **Status:** Pendente

## ⚠️ Limitação: File Upload
- **Situação:** Apenas aceita < 5MB
- **Motivo:** Cloudflare limit
- **Workaround:** Usar direct S3 upload
- **Status:** Documentado
```

### ❌ Evite

**Contexto Verboso:**
```markdown
<!-- NÃO faça assim -->
# Análise Completa do Sistema

Este documento contém uma análise extremamente detalhada
de todos os aspectos do projeto, incluindo histórico completo
de decisões desde o início...

[50 páginas de texto]

<!-- Gemini/Codex não vão ler isso tudo -->
```

**Informação Desatualizada:**
```markdown
<!-- Remova informação obsoleta -->
# Status ~~(2025-10-15)~~ (2025-11-01)

~~- [ ] Implementar auth~~ ✅ Completo
- [ ] Adicionar testes
```

---

**Lembre-se:**
- `.ai-context/` é a "memória compartilhada" dos AIs
- Mantenha arquivos curtos e acionáveis
- Atualize quando houver mudanças significativas
- Use cada AI para sua especialidade
