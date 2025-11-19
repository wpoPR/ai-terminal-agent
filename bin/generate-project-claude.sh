#!/bin/bash
# generate-project-claude.sh - Generate project-specific CLAUDE.md
# Version: 1.0.0

set -e

WORKSPACE_DIR="$HOME/.ai-workspace"
AI_CONFIG=".ai-config"
OUTPUT_FILE="${1:-.claude/claude.md}"

# Ensure .claude directory exists
mkdir -p .claude

# Check if in project with .ai-config
if [[ ! -f "$AI_CONFIG" ]]; then
  echo "Error: Not in a project directory (no .ai-config found)"
  exit 1
fi

# Get profile info
if command -v jq &> /dev/null; then
  PROFILE=$(jq -r '.agents.profile // "none"' "$AI_CONFIG" 2>/dev/null || echo "none")
  PROJECT_NAME=$(jq -r '.project_name // "Unknown Project"' "$AI_CONFIG" 2>/dev/null || echo "Unknown Project")
else
  PROFILE="none"
  PROJECT_NAME="Unknown Project"
fi

# Count active agents
AGENT_COUNT=0
ACTIVE_AGENTS=""

if [[ -d ".claude/agents" ]]; then
  for agent_file in .claude/agents/*.md; do
    if [[ -f "$agent_file" ]]; then
      agent_name=$(basename "$agent_file" .md)
      ACTIVE_AGENTS="${ACTIVE_AGENTS}- ${agent_name}\n"
      AGENT_COUNT=$((AGENT_COUNT + 1))
    fi
  done
fi

# Detect project type
PROJECT_TYPE="General"
if [[ -f "package.json" ]]; then
  if grep -q "react\|next" package.json 2>/dev/null; then
    PROJECT_TYPE="Frontend (React/Next.js)"
  elif grep -q "express\|fastify" package.json 2>/dev/null; then
    PROJECT_TYPE="Backend (Node.js)"
  fi
elif [[ -f "requirements.txt" ]]; then
  if grep -q "fastapi\|flask\|django" requirements.txt 2>/dev/null; then
    PROJECT_TYPE="Backend (Python)"
  elif grep -q "pandas\|numpy" requirements.txt 2>/dev/null; then
    PROJECT_TYPE="Data Science"
  fi
elif [[ -d "ios" ]] || [[ -d "android" ]]; then
  PROJECT_TYPE="Mobile App"
fi

# Generate CLAUDE.md
cat > "$OUTPUT_FILE" << EOF
# Project Context for Claude

> This file is auto-generated based on active agent profile.
> Managed by: AI Terminal Agent v1.1.0
> Profile: ${PROFILE}
> Active Agents: ${AGENT_COUNT}

## Project Overview

**Name**: ${PROJECT_NAME}
**Type**: ${PROJECT_TYPE}
**Agent Profile**: ${PROFILE}

## Active Agents

${ACTIVE_AGENTS}

## Agent System

Este projeto usa o **AI Terminal Agent** com gerenciamento dinâmico de agentes.

### Verificar Agentes Ativos

\`\`\`bash
# Ver agentes ativos neste projeto
ai-agents active

# Ver estatísticas de tokens
ai-agents stats

# Listar todos os agentes disponíveis
ai-agents list
\`\`\`

### Gerenciar Agentes

\`\`\`bash
# Ativar um agente adicional
ai-agents enable <nome>

# Desativar um agente
ai-agents disable <nome>

# Trocar perfil
ai-agents profile <nome>

# Combinar perfis
ai-agents profile frontend+security
\`\`\`

## Workflow com Agentes

### 1. Entender o Contexto
- Use \`Plan\` para explorar o codebase
- Use \`Explore\` para entender estrutura
- Verifique agentes disponíveis: \`ai-agents active\`

### 2. Trabalhar com Agentes Ativos
Os agentes em \`.claude/agents/\` estão disponíveis para uso.
**Apenas esses agentes estão no seu contexto.**

Para este projeto (perfil: **${PROFILE}**):
${ACTIVE_AGENTS}

### 3. Sequential Thinking
Para tarefas complexas:
1. Decomponha o problema
2. Identifique agentes necessários
3. Se um agente necessário não está ativo: \`ai-agents enable <nome>\`
4. Execute em sequência
5. Valide resultados

### 4. Adicionar Agentes Temporariamente

Se precisar de um agente que não está no perfil:

\`\`\`bash
# Exemplo: adicionar test-automator
ai-agents enable test-automator

# Restart Claude Code para carregar

# Quando terminar
ai-agents disable test-automator
\`\`\`

## Best Practices

### ✅ SEMPRE
- Verifique agentes ativos antes de começar (\`ai-agents active\`)
- Use Sequential Thinking para tarefas complexas
- Declare qual agente está usando e por quê
- Valide resultados
- Monitore tokens (\`ai-agents stats\`)

### ❌ EVITE
- Assumir que todos os agentes estão disponíveis
- Usar agentes sem explicar o motivo
- Ignorar limites de tokens (15k recomendado)
- Pular validação de resultados

## Gerenciamento de Tokens

Current usage: Run \`ai-agents stats\`

- **Limite recomendado**: 15,000 tokens
- **Seu perfil (${PROFILE})**: ~${AGENT_COUNT} agentes ativos

Se tokens estiverem altos:
\`\`\`bash
ai-agents stats              # Ver uso detalhado
ai-agents profile minimal    # Trocar para perfil leve
ai-agents disable <nome>     # Desativar agentes específicos
\`\`\`

## Template de Resposta

Para tarefas complexas:

\`\`\`
🔍 [Verificação Inicial]
- Agentes ativos: [listar]
- Agentes necessários: [listar]

🤔 [Sequential Thinking]
- Análise do problema
- Agentes a usar: [apenas ativos]
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
\`\`\`

## Referências

- **Agentes disponíveis**: \`ai-agents list\`
- **Documentação completa**: \`cat ~/workspace/primavera/ai-terminal-agent/definitions.md\`
- **Sistema de agentes**: \`ai-agents help\`
- **Guia de gerenciamento**: \`~/workspace/primavera/ai-terminal-agent/docs/agent-management.md\`

## Comandos Úteis

\`\`\`bash
# Visualização
ai-agents active             # Agentes ativos
ai-agents info <nome>        # Detalhes de um agente
ai-agents search <keyword>   # Buscar agente

# Gerenciamento
ai-agents profile list       # Ver perfis disponíveis
ai-agents suggest            # Sugestão baseada no projeto
ai-agents doctor             # Diagnóstico do sistema

# Integração com workflow
ai-status                    # Status + agentes ativos
\`\`\`

---

**Generated**: $(date)
**System**: AI Terminal Agent v1.1.0
**Profile**: ${PROFILE}
EOF

echo "✓ Generated $OUTPUT_FILE"
echo "  Profile: $PROFILE"
echo "  Agents: $AGENT_COUNT"

