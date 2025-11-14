# Agent Management Guide

Guia completo do sistema de gerenciamento de agentes do AI Terminal Agent.

## Visão Geral

O sistema de agentes permite que você ative apenas os agentes especializados que precisa para cada projeto, reduzindo drasticamente o uso de tokens:

- **Sem gerenciamento**: ~34.3k tokens (45 agentes ativos)
- **Com gerenciamento**: ~8-12k tokens (3-5 agentes por perfil)
- **Benefício**: 60-70% de redução, melhor performance

## Conceitos

### Biblioteca Global

Todos os agentes disponíveis ficam em `~/.ai-workspace/agents/`:
- 45 agentes especializados
- Mantidos sincronizados com o repositório
- Atualizados via `ai-agents update`

### Agentes Ativos

Agentes copiados para `.claude/agents/` do projeto atual:
- Apenas os agentes necessários para o projeto
- Claude Code lê automaticamente
- Gerenciados via comandos `ai-agents`

### Perfis

Combinações pré-definidas de agentes:
- 11 perfis disponíveis
- Baseados em tipos de projeto
- Customizáveis via comandos

### Token Tracking

Monitoramento automático de uso:
- Cálculo aproximado (1 token ≈ 4 caracteres)
- Limite recomendado: 15,000 tokens
- Alertas quando ultrapassa 80%

## Perfis Disponíveis

### frontend (4 agentes, ~10.4k tokens)
- frontend-developer
- frontend-security-coder
- ui-ux-designer
- code-reviewer

**Ideal para**: React, Next.js, Vue, Angular, design systems

### backend (4 agentes, ~11.2k tokens)
- backend-architect
- backend-security-coder
- api-documenter
- code-reviewer

**Ideal para**: APIs REST/GraphQL, microserviços, Node.js, Python backends

### fullstack (4 agentes, ~10.6k tokens)
- frontend-developer
- backend-architect
- database-architect
- code-reviewer

**Ideal para**: Aplicações web completas, MVPs, startups

### mobile (3 agentes, ~9.8k tokens)
- mobile-developer
- backend-architect
- mobile-security-coder

**Ideal para**: Apps iOS/Android, React Native, Flutter

### devops (5 agentes, ~14.2k tokens)
- kubernetes-architect
- terraform-specialist
- deployment-engineer
- observability-engineer
- devops-troubleshooter

**Ideal para**: Infraestrutura, CI/CD, deployment, monitoring

### data (4 agentes, ~11.8k tokens)
- data-engineer
- database-architect
- database-optimizer
- data-scientist

**Ideal para**: Pipelines de dados, analytics, otimização de queries

### ai-ml (4 agentes, ~12.4k tokens)
- ai-engineer
- ml-production-engineer
- mlops-engineer
- prompt-engineer

**Ideal para**: LLMs, RAG, modelos ML, deployment de AI

### security (4 agentes, ~11.6k tokens)
- security-auditor
- frontend-security-coder
- backend-security-coder
- code-reviewer

**Ideal para**: Auditorias de segurança, pen testing, compliance

### docs (4 agentes, ~10.8k tokens)
- docs-architect
- api-documenter
- tutorial-engineer
- mermaid-diagram-expert

**Ideal para**: Documentação técnica, APIs, tutoriais, diagramas

### research (3 agentes, ~8.6k tokens)
- gemini-research-assistant
- search-specialist
- performance-engineer

**Ideal para**: Pesquisa, investigação, análise de performance

### minimal (2 agentes, ~5.2k tokens)
- code-reviewer
- architect-review

**Ideal para**: Code review apenas, projetos simples

## Comandos

### Visualização

```bash
# Listar todos os agentes disponíveis
ai-agents list

# Listar agentes de uma categoria
ai-agents list --category web

# Ver agentes ativos no projeto atual
ai-agents active

# Ver informações de um agente
ai-agents info frontend-developer

# Buscar agentes por palavra-chave
ai-agents search react
```

### Perfis

```bash
# Listar perfis disponíveis
ai-agents profile list

# Ver perfil atual
ai-agents profile

# Ativar um perfil
ai-agents profile fullstack

# Combinar múltiplos perfis
ai-agents profile frontend+security

# Voltar ao perfil minimal
ai-agents reset
```

### Gerenciamento Individual

```bash
# Ativar um agente específico
ai-agents enable test-automator

# Desativar um agente
ai-agents disable frontend-security-coder
```

### Estatísticas e Diagnóstico

```bash
# Ver estatísticas detalhadas de tokens
ai-agents stats

# Sugerir perfil baseado no projeto
ai-agents suggest

# Diagnóstico completo do sistema
ai-agents doctor

# Atualizar biblioteca de agentes
ai-agents update
```

## Workflows

### Novo Projeto

```bash
cd ~/meu-novo-projeto
ai-start

# Menu interativo aparece
# Escolha perfil baseado no tipo de projeto
# Agentes são configurados automaticamente
```

### Projeto Existente

```bash
cd ~/projeto-existente
ai-start

# Se já tem .ai-config, carrega perfil salvo
# Senão, menu interativo aparece
```

### Trocar de Perfil

```bash
# Você está trabalhando com frontend, mas agora precisa de DevOps
ai-agents profile devops

# Restart Claude Code para carregar novos agentes
```

### Adicionar Agente Temporário

```bash
# Precisa de testes apenas agora
ai-agents enable test-automator

# Restart Claude Code

# Quando terminar
ai-agents disable test-automator
```

### Combinar Perfis

```bash
# Projeto full stack com foco em segurança
ai-agents profile fullstack+security

# Resultado: união dos agentes dos dois perfis (sem duplicatas)
```

## Integração com ai-status

O `ai-status` mostra automaticamente informações sobre agentes:

```bash
ai-status

# Output includes:
# Agent Management
# ════════════════
# Profile: fullstack
# Active Agents: 4
# Tokens: ~10,600 / 15,000 (70%)
#
# Commands:
#   ai-agents stats     - Detailed agent statistics
#   ai-agents active    - List active agents
```

## Sugestão Inteligente

O comando `ai-agents suggest` analisa o projeto e sugere o perfil mais adequado:

```bash
ai-agents suggest

# Analyzing project...
# 
# ✓ Detected: React/Next.js → frontend profile
# ✓ Detected: Node.js backend → backend profile
# 
# Recommendation: fullstack profile
# 
# Confidence: 40%
# 
# To activate: ai-agents profile fullstack
```

### Detecção Automática

O sistema detecta:
- **Frontend**: `package.json` com react, next, vue, angular
- **Backend**: `package.json` com express, fastify, koa
- **Python Backend**: `requirements.txt` com fastapi, flask, django
- **Mobile**: `ios/Podfile`, `android/build.gradle`
- **DevOps**: `Dockerfile`, `k8s/`, `*.tf`
- **Data**: `requirements.txt` com pandas, numpy
- **AI/ML**: `requirements.txt` com tensorflow, pytorch

## Troubleshooting

### Agentes não aparecem no Claude Code

**Problema**: Ativei agentes mas Claude não os reconhece

**Solução**:
```bash
# Verificar se agentes estão em .claude/agents/
ls -la .claude/agents/

# Se não existir, ativar perfil novamente
ai-agents profile <nome>

# Restart Claude Code/Cursor
```

### Token usage muito alto

**Problema**: Mesmo com perfil, tokens estão altos

**Solução**:
```bash
# Ver detalhes
ai-agents stats

# Trocar para perfil mais leve
ai-agents profile minimal

# Ou desativar agentes específicos
ai-agents disable <nome>
```

### Agent library not found

**Problema**: `ai-agents list` retorna erro

**Solução**:
```bash
# Atualizar biblioteca
ai-agents update

# Ou re-executar instalação
cd ~/workspace/primavera/ai-terminal-agent
./install.sh
```

### Perfil não salva no .ai-config

**Problema**: Toda vez que rodo `ai-start`, pergunta perfil

**Solução**:
```bash
# Verificar se jq está instalado
brew install jq

# Verificar .ai-config
cat .ai-config

# Re-aplicar perfil
ai-agents profile <nome>
```

## Best Practices

### 1. Use Perfis Apropriados

- **Não use devops** para projetos frontend simples
- **Não use fullstack** se só precisa de backend
- **Use minimal** para code review rápido

### 2. Monitore Tokens

```bash
# Sempre verifique após ativar agentes
ai-agents stats

# Se > 80%, considere trocar perfil
```

### 3. Combine Perfis Quando Necessário

```bash
# Em vez de adicionar agentes individuais
ai-agents profile frontend+security

# Mais organizado e fácil de gerenciar
```

### 4. Use Sugestão Automática

```bash
# Em novos projetos, sempre rode
ai-agents suggest

# Pode revelar necessidades não óbvias
```

### 5. Atualize Regularmente

```bash
# A cada update do repositório
ai-agents update

# Mantém agentes sincronizados
```

## Configuração Avançada

### Custom Token Limit

No `.ai-config`:

```json
{
  "agents": {
    "profile": "fullstack",
    "enabled": [...],
    "token_limit": 12000
  }
}
```

### Desativar Auto-update

```json
{
  "agents": {
    "auto_update": false
  }
}
```

### Pre-configurar Perfil

Ao criar projeto, adicione `.ai-config` com perfil:

```json
{
  "agents": {
    "profile": "frontend"
  }
}
```

Quando rodar `ai-start`, carrega automaticamente.

## FAQ

**P: Posso ter agentes diferentes em cada projeto?**  
R: Sim! Cada projeto tem seu próprio `.claude/agents/` e `.ai-config`.

**P: Preciso reiniciar Claude toda vez que mudo agentes?**  
R: Sim, Claude lê agentes apenas no startup.

**P: Posso customizar os perfis?**  
R: Sim, edite os arquivos JSON em `~/.ai-workspace/agent-profiles/`.

**P: Os agentes afetam performance do Claude?**  
R: Sim, mais agentes = mais tokens = performance levemente impactada.

**P: Posso adicionar meus próprios agentes?**  
R: Sim, adicione arquivos `.md` em `~/.ai-workspace/agents/` e rode `ai-agents update`.

**P: O que acontece se deletar `.claude/agents/`?**  
R: Agentes são desativados. Rode `ai-agents profile <nome>` para reativar.

## Recursos Adicionais

- [Quick Reference](quick-reference.md) - Comandos rápidos
- [Installation Guide](installation.md) - Instalação detalhada
- [Troubleshooting](troubleshooting.md) - Problemas comuns
- [README](../README.md) - Visão geral do projeto

## Suporte

Se encontrar problemas:

1. Rode `ai-agents doctor` para diagnóstico
2. Verifique [Troubleshooting](troubleshooting.md)
3. Abra issue no GitHub com output do `doctor`

