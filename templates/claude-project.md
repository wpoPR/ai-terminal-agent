# Project Context for Claude

> This file is auto-generated based on active agent profile.
> Managed by: AI Terminal Agent
> Profile: {{PROFILE_NAME}}
> Active Agents: {{AGENT_COUNT}}

## Project Overview

**Type**: {{PROJECT_TYPE}}
**Agent Profile**: {{PROFILE_NAME}}

## Active Agents

{{ACTIVE_AGENTS_LIST}}

## Agent System

Este projeto usa o **AI Terminal Agent** com gerenciamento dinâmico de agentes.

### Verificar Agentes Ativos

```bash
# Ver agentes ativos neste projeto
ai-agents active

# Ver estatísticas de tokens
ai-agents stats

# Listar todos os agentes disponíveis
ai-agents list
```

### Gerenciar Agentes

```bash
# Ativar um agente adicional
ai-agents enable <nome>

# Desativar um agente
ai-agents disable <nome>

# Trocar perfil
ai-agents profile <nome>
```

## Workflow com Agentes

### 1. Entender o Contexto
- Use `Plan` para explorar o codebase
- Use `Explore` para entender estrutura

### 2. Trabalhar com Agentes Ativos
Os agentes em `.claude/agents/` estão disponíveis para uso.
Apenas agentes ativos aparecem no contexto.

### 3. Sequential Thinking
Para tarefas complexas:
- Decomponha o problema
- Identifique agentes necessários
- Se um agente necessário não está ativo: `ai-agents enable <nome>`
- Execute em sequência
- Valide resultados

## Best Practices

### ✅ SEMPRE
- Verifique agentes ativos antes de começar (`ai-agents active`)
- Use Sequential Thinking para tarefas complexas
- Declare qual agente está usando e por quê
- Valide resultados

### ❌ EVITE
- Assumir que todos os agentes estão disponíveis
- Pular validação de resultados
- Usar agentes sem explicar o motivo

## Gerenciamento de Tokens

Current usage: Run `ai-agents stats`
- Limite recomendado: 15,000 tokens
- Seu perfil está otimizado para este projeto

Se precisar de agentes adicionais temporariamente:
```bash
ai-agents enable <nome>
# Quando terminar
ai-agents disable <nome>
```

## Referências

- Todos os agentes disponíveis: `ai-agents list`
- Documentação completa: `~/workspace/primavera/ai-terminal-agent/definitions.md`
- Sistema de agentes: `ai-agents help`

