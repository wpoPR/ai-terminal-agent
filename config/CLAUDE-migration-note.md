# CLAUDE.md Migration Notes

## Mudanças na v1.1.0

Com a implementação do **Sistema de Gerenciamento Dinâmico de Agentes**, a estrutura do CLAUDE.md foi reorganizada.

### Antes (v1.0.0)

- **CLAUDE.md global** com lista completa de 45 agentes
- Arquivo estático com mapeamento completo
- Todos os agentes sempre carregados (~34k tokens)

### Depois (v1.1.0)

- **CLAUDE.md global** (`~/.claude/CLAUDE.md`) - Instruções sobre sistema de agentes
- **Template por projeto** (`templates/claude-project.md`) - Adapta-se ao perfil
- **definitions.md** - Referência completa de agentes (preservado)
- **Agentes dinâmicos** - Apenas perfil ativo carregado (~8-12k tokens)

### Arquivos

1. **`~/.claude/CLAUDE.md`** (novo)
   - Instruções globais
   - Sistema de gerenciamento de agentes
   - Workflow recomendado
   - Como verificar/ativar agentes

2. **`templates/claude-project.md`** (novo)
   - Template para projetos
   - Adapta-se ao perfil ativo
   - Instruções específicas do projeto

3. **`definitions.md`** (já existia)
   - Referência completa de todos os 45 agentes
   - Mapeamento detalhado de quando usar cada agente
   - Exemplos de fluxos completos

4. **`config/CLAUDE-reference.md`** (antigo CLAUDE.md renomeado)
   - Backup do arquivo original
   - Referência histórica

### Como Usar Agora

#### Setup Inicial
```bash
# O novo CLAUDE.md global já está em ~/.claude/CLAUDE.md
# Criado automaticamente durante a implementação
```

#### Por Projeto
```bash
cd ~/meu-projeto
ai-start

# Menu interativo aparece
# Escolhe perfil (frontend, backend, fullstack, etc)
# Agentes são configurados automaticamente

# Verificar agentes ativos
ai-agents active

# Ver estatísticas
ai-agents stats
```

#### Adicionar Agentes Temporariamente
```bash
# Precisa de um agente que não está no perfil?
ai-agents enable test-automator

# Restart Claude Code para carregar
```

### Benefícios

1. **Performance**: 60-70% menos tokens
2. **Flexibilidade**: Perfis por tipo de projeto
3. **Controle**: Ativar/desativar agentes dinamicamente
4. **Organização**: Cada projeto com seus agentes
5. **Manutenção**: Mais fácil de gerenciar

### Comandos para Referência

```bash
# Ver todos os agentes disponíveis
ai-agents list

# Ver mapeamento completo (como no CLAUDE.md antigo)
cat ~/workspace/primavera/ai-terminal-agent/definitions.md

# Documentação completa do sistema de agentes
cat ~/workspace/primavera/ai-terminal-agent/docs/agent-management.md
```

### Migração de Projetos Existentes

Se você já tem projetos com o sistema antigo:

```bash
cd ~/projeto-existente
ai-start

# Se não tiver .ai-config, o menu interativo aparece
# Escolha o perfil apropriado

# Ou configure manualmente
ai-agents profile fullstack
```

### Dúvidas?

- Sistema de agentes: `ai-agents help`
- Documentação completa: `docs/agent-management.md`
- Referência de agentes: `definitions.md`
- Diagnóstico: `ai-agents doctor`

---

**Data da Migração**: 2025-01-13  
**Versão**: v1.1.0  
**Sistema**: Agent Management System

