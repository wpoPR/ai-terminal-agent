# Claude Global Configuration

> Sistema de Agentes Dinâmicos - AI Terminal Agent v1.1.0

## Visão Geral

Você está trabalhando com um sistema de **gerenciamento dinâmico de agentes**. 
Os agentes disponíveis variam por projeto, baseado no perfil ativo.

## Sistema de Agentes

### Como Funciona

1. **Biblioteca Global**: 45 agentes especializados disponíveis
2. **Agentes por Projeto**: Apenas agentes do perfil ativo são carregados
3. **Gerenciamento**: Via comandos `ai-agents`

### Verificar Agentes Disponíveis

**SEMPRE verifique agentes disponíveis no projeto atual:**

```bash
ai-agents active    # Agentes ativos no projeto
ai-agents list      # Todos os 45 agentes disponíveis
ai-agents stats     # Estatísticas e tokens
```

### Perfis Disponíveis

- **frontend** - React/Next.js, UI/UX
- **backend** - APIs, arquitetura backend
- **fullstack** - Frontend + Backend + Database
- **mobile** - Apps mobile
- **devops** - Kubernetes, Terraform, deployment
- **data** - Engenharia de dados, analytics
- **ai-ml** - AI/ML, MLOps
- **security** - Auditoria e segurança
- **docs** - Documentação
- **research** - Pesquisa e performance
- **minimal** - Code review básico

## FLUXO OBRIGATÓRIO

### 1. SEMPRE começar com Sequential Thinking

Para TODA tarefa, primeiro use Sequential Thinking para:
- Decompor o problema em etapas
- Identificar qual(is) agente(s) usar
- Verificar se agentes necessários estão ativos
- Planejar a sequência de execução
- Documentar a estratégia

**Exemplo:**
```
🤔 [Sequential Thinking]
1. Problema: Criar API REST com autenticação
2. Agentes necessários:
   - backend-architect (definir design)
   - backend-security-coder (autenticação)
   - api-documenter (documentar)
   - code-reviewer (validar)
3. Verificação: ai-agents active
4. Status: backend-architect ✓, backend-security-coder ✓
          api-documenter ✗ (precisa ativar)
5. Sequência:
   a) backend-architect: design da API
   b) backend-security-coder: implementar auth
   c) Ativar api-documenter
   d) api-documenter: documentar
   e) code-reviewer: revisar
```

### 2. Identificar e usar agente(s) apropriado(s)

### 3. Validar resultados com Sequential Thinking

## Workflow Recomendado

### 1. Entender o Projeto

```bash
# Verificar qual perfil está ativo
ai-agents active

# Ver estatísticas
ai-agents stats
```

### 2. Trabalhar com Agentes Ativos

Os agentes em `.claude/agents/` do projeto estão disponíveis para uso.
**Apenas esses agentes estão no seu contexto.**

### 3. Adicionar Agentes Quando Necessário

Se precisar de um agente que não está ativo:

```bash
# Ativar temporariamente
ai-agents enable test-automator

# Ou trocar de perfil
ai-agents profile security
```

### 4. Executar com Sequential Thinking

Para tarefas complexas:

1. **Planejar** (Sequential Thinking): Decomponha o problema
2. **Verificar**: Quais agentes estão disponíveis? (`ai-agents active`)
3. **Ativar**: Se necessário, ative agentes adicionais
4. **Executar**: Use os agentes em sequência
5. **Validar**: Revise resultados (Sequential Thinking)

## Regras Importantes

### ✅ SEMPRE FAÇA

1. **Verifique agentes disponíveis** no início
2. Use Sequential Thinking para coordenação
3. Declare explicitamente qual agente está usando
4. Valide resultados de cada agente
5. Monitore uso de tokens (`ai-agents stats`)

### ❌ NUNCA FAÇA

1. Assumir que todos os agentes estão disponíveis
2. Usar agentes sem explicar o motivo
3. Ignorar limites de tokens
4. Pular validação de resultados

## Otimização de Tokens

O sistema gerencia tokens automaticamente:
- **Sem gerenciamento**: ~34k tokens (todos os agentes)
- **Com perfis**: ~8-12k tokens (perfil otimizado)
- **Limite recomendado**: 15k tokens

Se tokens estiverem altos:
```bash
ai-agents stats              # Ver uso atual
ai-agents profile minimal    # Trocar para perfil leve
ai-agents disable <nome>     # Desativar agentes específicos
```

## Comandos Úteis

```bash
# Visualização
ai-agents list               # Todos os agentes
ai-agents active             # Agentes ativos
ai-agents info <nome>        # Detalhes de um agente
ai-agents search <keyword>   # Buscar por palavra-chave

# Gerenciamento
ai-agents enable <nome>      # Ativar agente
ai-agents disable <nome>     # Desativar agente
ai-agents profile <nome>     # Trocar perfil
ai-agents profile <p1>+<p2>  # Combinar perfis

# Utilidades
ai-agents stats              # Estatísticas
ai-agents suggest            # Sugestão baseada no projeto
ai-agents doctor             # Diagnóstico
```

## Referência Completa de Agentes

Para ver todos os 45 agentes disponíveis e quando usar cada um:

```bash
cat ~/workspace/primavera/ai-terminal-agent/definitions.md
```

Ou veja no repositório: `~/workspace/primavera/ai-terminal-agent/definitions.md`

## Template de Resposta

Quando receber uma solicitação complexa:

```
🔍 [Verificação Inicial]
- Agentes ativos no projeto: [listar]
- Agentes necessários: [listar]
- Ações necessárias: [ativar agentes se preciso]

🤔 [Sequential Thinking]
- Análise do problema
- Agentes a usar: [apenas ativos ou recém-ativados]
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
- Próximos passos
- Tokens usados: [se relevante]
```

## Suporte

- Documentação: `ai-agents help`
- Guia completo: `~/workspace/primavera/ai-terminal-agent/docs/agent-management.md`
- Referência rápida: `ai-agents list`

---

**Versão**: AI Terminal Agent v1.1.0  
**Sistema**: Gerenciamento Dinâmico de Agentes
