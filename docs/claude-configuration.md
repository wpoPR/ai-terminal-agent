# Claude Configuration Guide

Guia completo sobre a configuração do CLAUDE.md no AI Terminal Agent v1.1.0

## Visão Geral

Com o sistema de gerenciamento dinâmico de agentes, a configuração do Claude foi reestruturada para suportar:
- Agentes dinâmicos por projeto
- Perfis especializados
- Configuração global + configuração por projeto

## Estrutura de Arquivos

### 1. CLAUDE.md Global (`~/.claude/CLAUDE.md`)

**Localização**: `~/.claude/CLAUDE.md`  
**Propósito**: Instruções globais sobre o sistema de agentes  
**Criado**: Automaticamente durante `install.sh`

Este arquivo instrui o Claude sobre:
- Sistema de gerenciamento dinâmico de agentes
- Como verificar agentes disponíveis
- Como ativar/desativar agentes
- Workflow recomendado
- Comandos úteis

**Quando é usado**: Para todos os projetos, como contexto base

### 2. CLAUDE.md por Projeto (Opcional)

**Localização**: `<projeto>/CLAUDE.md`  
**Propósito**: Contexto específico do projeto  
**Criado**: Via `generate-project-claude`

Este arquivo contém:
- Perfil ativo no projeto
- Lista de agentes ativos
- Instruções específicas do projeto
- Tipo de projeto detectado

**Quando é usado**: Como contexto adicional específico do projeto

### 3. definitions.md (Referência)

**Localização**: `~/workspace/primavera/ai-terminal-agent/definitions.md`  
**Propósito**: Referência completa de todos os 45 agentes  
**Criado**: Parte do repositório

Este arquivo contém:
- Mapeamento completo: Tarefa → Agente
- Exemplos de fluxos completos
- Quando usar cada agente
- Priorização de agentes

**Quando é usado**: Como referência quando precisar de informações sobre agentes específicos

## Comparação: Antes vs Depois

### Antes (v1.0.0)

```
config/CLAUDE.md (único arquivo)
├── Lista completa de 45 agentes
├── Mapeamento estático
└── Sempre carregado (~34k tokens)
```

### Depois (v1.1.0)

```
~/.claude/CLAUDE.md (global)
├── Instruções sobre sistema de agentes
├── Como verificar/ativar agentes
└── Workflow dinâmico

<projeto>/CLAUDE.md (opcional, gerado)
├── Perfil ativo
├── Agentes específicos do projeto
└── Contexto do projeto

definitions.md (referência)
├── Mapeamento completo de agentes
└── Exemplos detalhados
```

## Como Funciona

### 1. Instalação

Durante `./install.sh`:
```bash
# Cria ~/.claude/CLAUDE.md global
cp templates/claude-global.md ~/.claude/CLAUDE.md
```

### 2. Primeiro Uso em Projeto

```bash
cd ~/meu-projeto
ai-start

# Menu interativo aparece
# Escolhe perfil: frontend, backend, fullstack, etc
# Agentes são copiados para .claude/agents/
```

### 3. Gerar CLAUDE.md do Projeto (Opcional)

```bash
# No diretório do projeto
generate-project-claude

# Gera CLAUDE.md com:
# - Perfil ativo
# - Agentes carregados
# - Instruções específicas
```

### 4. Claude Lê Contexto

Quando Claude inicia em um projeto:
1. Lê `~/.claude/CLAUDE.md` (global)
2. Lê `.claude/agents/*.md` (agentes ativos)
3. Lê `CLAUDE.md` do projeto (se existir)

## Comandos

### Gerenciar CLAUDE.md Global

```bash
# Ver CLAUDE.md global
cat ~/.claude/CLAUDE.md

# Editar CLAUDE.md global
nano ~/.claude/CLAUDE.md

# Restaurar do template
cp ~/workspace/primavera/ai-terminal-agent/templates/claude-global.md ~/.claude/CLAUDE.md
```

### Gerenciar CLAUDE.md por Projeto

```bash
# Gerar CLAUDE.md para projeto atual
cd ~/meu-projeto
generate-project-claude

# Gerar com nome customizado
generate-project-claude PROJECT-CLAUDE.md

# Regenerar quando mudar perfil
ai-agents profile backend
generate-project-claude
```

### Ver Referência Completa

```bash
# Ver todos os agentes e quando usar
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Buscar por palavra-chave
grep -i "frontend" ~/workspace/primavera/ai-terminal-agent/definitions.md
```

## Workflows

### Workflow 1: Novo Projeto

```bash
# 1. Iniciar projeto
cd ~/novo-projeto
ai-start

# 2. Escolher perfil no menu interativo
# (ex: fullstack)

# 3. (Opcional) Gerar CLAUDE.md do projeto
generate-project-claude

# 4. Trabalhar normalmente
# Claude conhece o sistema e os agentes ativos
```

### Workflow 2: Trocar Perfil

```bash
# 1. Trocar perfil
ai-agents profile devops

# 2. Regenerar CLAUDE.md do projeto
generate-project-claude

# 3. Restart Claude Code
# Novos agentes são carregados
```

### Workflow 3: Adicionar Agente Temporário

```bash
# 1. Verificar agentes ativos
ai-agents active

# 2. Adicionar agente
ai-agents enable test-automator

# 3. (Opcional) Regenerar CLAUDE.md
generate-project-claude

# 4. Restart Claude Code
```

## Templates

### Template Global (`templates/claude-global.md`)

Instruções globais sobre:
- Sistema de agentes dinâmicos
- Como verificar agentes disponíveis
- Comandos ai-agents
- Workflow recomendado
- Otimização de tokens

### Template por Projeto (`templates/claude-project.md`)

Template com placeholders:
- `{{PROFILE_NAME}}`
- `{{AGENT_COUNT}}`
- `{{ACTIVE_AGENTS_LIST}}`
- `{{PROJECT_TYPE}}`

O script `generate-project-claude` substitui esses placeholders.

## Customização

### Customizar CLAUDE.md Global

```bash
# Editar template
nano ~/workspace/primavera/ai-terminal-agent/templates/claude-global.md

# Re-instalar
cd ~/workspace/primavera/ai-terminal-agent
./install.sh
```

### Customizar Template de Projeto

```bash
# Editar template
nano ~/workspace/primavera/ai-terminal-agent/templates/claude-project.md

# Usar template customizado
generate-project-claude
```

### Adicionar Instruções Específicas

No projeto, edite o CLAUDE.md gerado:
```bash
# Gerar base
generate-project-claude

# Adicionar suas instruções
nano CLAUDE.md
```

## Migração de Projetos Existentes

Se você tem projetos com o CLAUDE.md antigo:

```bash
cd ~/projeto-existente

# 1. Backup do antigo (se existir)
mv CLAUDE.md CLAUDE-old.md

# 2. Configurar agentes
ai-start  # Ou: ai-agents profile <nome>

# 3. Gerar novo
generate-project-claude

# 4. Comparar e mesclar customizações
diff CLAUDE-old.md CLAUDE.md
```

## Best Practices

### ✅ Recomendado

1. **Mantenha o global simples**: Instruções gerais em `~/.claude/CLAUDE.md`
2. **Use perfis**: Deixe o sistema gerenciar agentes
3. **Gere por projeto**: Use `generate-project-claude` para contexto específico
4. **Regenere ao trocar perfil**: Mantenha sincronizado
5. **Consulte definitions.md**: Para referência de agentes

### ❌ Evite

1. **Não modifique agentes em .claude/agents/**: Use comandos `ai-agents`
2. **Não duplique definitions.md**: Use como referência
3. **Não hardcode lista de agentes**: Deixe dinâmico
4. **Não ignore tokens**: Monitore com `ai-agents stats`

## Troubleshooting

### CLAUDE.md global não existe

```bash
# Re-instalar
cd ~/workspace/primavera/ai-terminal-agent
./install.sh
```

### CLAUDE.md do projeto desatualizado

```bash
# Regenerar
generate-project-claude
```

### Claude não reconhece agentes

```bash
# Verificar agentes ativos
ai-agents active

# Verificar .claude/agents/
ls -la .claude/agents/

# Restart Claude Code
```

### Referência de agente não encontrada

```bash
# Ver mapeamento completo
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Ou buscar
ai-agents search <keyword>
```

## Estrutura Completa

```
Sistema CLAUDE.md v1.1.0
│
├── Global (~/.claude/CLAUDE.md)
│   ├── Instruções sobre sistema de agentes
│   ├── Comandos ai-agents
│   └── Workflow recomendado
│
├── Por Projeto (<projeto>/CLAUDE.md)
│   ├── Perfil ativo
│   ├── Agentes carregados
│   └── Contexto específico
│
├── Agentes Ativos (<projeto>/.claude/agents/)
│   ├── frontend-developer.md
│   ├── backend-architect.md
│   └── ... (conforme perfil)
│
└── Referência (definitions.md)
    ├── Mapeamento completo
    └── Exemplos de uso
```

## Referências

- [Agent Management Guide](agent-management.md)
- [Migration Notes](../config/CLAUDE-migration-note.md)
- [Definitions](../definitions.md)
- [Quick Reference](quick-reference.md)

---

**Versão**: v1.1.0  
**Sistema**: Agent Management System

