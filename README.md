# AI Terminal Agent

Sistema completo para gerenciar workspaces AI (Claude, Gemini, Codex) no iTerm2.

## ✨ Features

- 🚀 **One-command workspace**: `ai-start` para abrir layout completo
- 🤖 **Agent Management**: Sistema dinâmico de agentes com perfis pré-definidos
- 🔄 **Context sync**: Sincroniza contextos entre AIs automaticamente
- 📊 **Daily summaries**: Relatório agregado gerado por Gemini (free!)
- 💾 **Auto backup**: Retenção de 3 dias
- 🔧 **Git integration**: Global ignore para arquivos pessoais
- 📝 **Templates**: Projetos coding, writing, research, homelab
- 🌐 **Multi-machine**: Use em várias máquinas via Git
- 💻 **Source included**: Código editável em `bin/`
- 🔄 **Auto recovery**: Detecta crashes e oferece recuperação
- 🏥 **Health check**: Verifica toda configuração automaticamente

## 🚀 Quick Start

### Installation

```bash
cd ~/workspace/primavera
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
```

### Usage

```bash
cd ~/your-project
ai-start          # Launch workspace
ai-stop           # Close with summary
ai-status         # Check active workspaces
ai-tips           # Quick tips and AI division of work
ai-help           # Full documentation
```

### Exemplo de Workflow

```
1. cd ~/meu-projeto && ai-start
   ↓
   iTerm2 abre com 3 AIs em split

2. Tab 1 - Claude (painel esquerdo):
   "Analise este projeto e crie .ai-context/project-status.md"
   ↓
   Claude cria resumo com: objetivo, progresso, próximos passos

3. Tab 1 - Gemini (painel superior direito):
   "Leia .ai-context/project-status.md"
   "Pesquise melhores bibliotecas JWT para Node.js"
   ↓
   Gemini pesquisa e recomenda

4. Tab 1 - Codex (painel inferior direito):
   "/init"
   "Leia .ai-context/project-status.md"
   "Implemente middleware JWT"
   ↓
   Codex escreve o código

5. Tab 1 - Claude (revisão):
   "Revise o código de auth criado pelo Codex"
   ↓
   Claude valida e sugere melhorias

6. Tab 2 - Control Console:
   ai-status  # Ver progresso
   ↓
   ai-stop    # Gera resumo do dia
```

**Resultado:** Cada AI fez o que faz melhor, compartilhando contexto via `.ai-context/`

## 📋 Prerequisites

- **macOS** (tested on 14+)
- **iTerm2** - Terminal emulator
- **Claude CLI** - `npm install -g @anthropic-ai/claude-code`
- **Gemini CLI** - `npm install -g @google/generative-ai`
- **Codex CLI** - `npm install -g @openai/codex`
- **jq** - JSON processor (`brew install jq`)

## 📚 Documentation

### Getting Started
- 🚀 **[Quick Reference](docs/quick-reference.md)** - Cheatsheet e comandos essenciais
- 📖 [Installation Guide](docs/installation.md) - Detailed installation steps
- 💡 [Usage Guide](docs/usage.md) - How to use all commands

### Workflows
- 🔍 **[Analyzing Existing Projects](docs/workflows/analyzing-existing-project.md)** - Como usar os 3 AIs em conjunto
- 🎯 Cenários práticos: bugs, features, refactoring, deploy, etc
- 💬 Como compartilhar contexto entre Claude, Gemini e Codex

### Advanced
- [Configuration](docs/configuration.md) - Configure your workspace
- [Architecture](docs/architecture.md) - How it works internally
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Original Plan](PLAN.md) - Complete implementation plan

## 🎯 Key Commands

```bash
# Workspace management
ai-start [path]           # Start AI workspace
ai-start --check          # Health check only
ai-start --dry-run        # Show what would happen
ai-stop                   # Close workspace with summary
ai-stop --no-summary      # Close without summary

# Status and history
ai-status                 # Show active workspaces and agents
ai-recent                 # List recent workspaces
ai-recover                # Recover from crashes

# Agent Management (NEW!)
ai-agents list            # List all available agents
ai-agents active          # Show active agents in project
ai-agents profile list    # List available profiles
ai-agents profile <name>  # Activate agent profile
ai-agents enable <name>   # Enable specific agent
ai-agents disable <name>  # Disable specific agent
ai-agents stats           # Show detailed token statistics
ai-agents suggest         # Suggest profile based on project
ai-agents doctor          # Run diagnostics
ai-agents explain         # Explain agent system

# Quick reference
ai-tips                   # Show quick tips and AI usage
ai-tips division          # Show AI division of work
ai-tips examples          # Show practical examples
ai-tips sharing           # Context sharing between AIs
ai-tips dicas             # Show important tips

# Configuration
ai-git-config             # Manage git global ignore
ai-health-check           # Verify installation
ai-context-init           # Initialize .ai-context/ structure
ai-help [command]         # Show help

# Maintenance
ai-update                 # Update from git
ai-export [file]          # Export configuration
ai-import [file]          # Import configuration
```

## 🤖 Agent Management

O sistema de agentes permite que você ative apenas os agentes especializados que precisa, reduzindo o uso de tokens de ~34k para ~8-12k.

### Perfis Disponíveis

- **frontend** (4 agentes) - React/Next.js, UI/UX, segurança frontend
- **backend** (4 agentes) - APIs, arquitetura backend, segurança
- **fullstack** (4 agentes) - Frontend + Backend + Database
- **mobile** (3 agentes) - Desenvolvimento mobile
- **devops** (5 agentes) - Kubernetes, Terraform, deployment
- **data** (4 agentes) - Engenharia de dados, analytics
- **ai-ml** (4 agentes) - AI/ML, MLOps, prompts
- **security** (4 agentes) - Auditoria e segurança
- **docs** (4 agentes) - Documentação e tutoriais
- **research** (3 agentes) - Pesquisa e performance
- **minimal** (2 agentes) - Apenas code review

### Quick Start

```bash
# Durante ai-start, escolha um perfil interativamente
cd ~/meu-projeto
ai-start

# Ou ative manualmente depois
ai-agents profile fullstack

# Adicionar/remover agentes individuais
ai-agents enable test-automator
ai-agents disable frontend-security-coder

# Combinar perfis
ai-agents profile frontend+security

# Ver estatísticas
ai-agents stats

# Sugestão automática baseada no projeto
ai-agents suggest
```

### Como Funciona

1. **Biblioteca Global**: 45+ agentes em `~/.ai-workspace/agents/`
2. **Agentes Ativos**: Cópias em `.claude/agents/` por projeto
3. **Perfis**: Combinações pré-definidas de agentes
4. **Token Tracking**: Monitoramento automático de uso
5. **Auto-Otimização**: Meta-agente workspace-manager pode auto-gerenciar configuração

### 🤖 Workspace Manager (NEW!)

Um meta-agente especialista no próprio ai-terminal-agent que pode:
- ✅ Analisar tarefas e sugerir perfis de agentes ideais
- ✅ Monitorar uso de tokens e otimizar automaticamente
- ✅ Coordenar workflows entre Claude, Gemini e Codex
- ✅ Detectar problemas de performance proativamente
- ✅ Sugerir mudanças de configuração com justificativa

**Uso:**
```bash
ai-agents enable workspace-manager

# No Claude:
"Analise a tarefa atual e sugira a configuração
ideal de agentes para otimizar o trabalho"
```

Para mais detalhes, veja [Agent Management Guide](docs/agent-management.md)

## 📂 AI Context Structure

A estrutura `.ai-context/` permite compartilhar informações entre Claude, Gemini e Codex de forma organizada.

### Inicialização Rápida

```bash
cd ~/meu-projeto
ai-context-init --with-prompts
```

### Estrutura Criada

```
.ai-context/
├── project-status.md     # Status geral do projeto
├── current-task.md       # Tarefa atual
├── decisions.md          # Decisões técnicas (ADR)
├── known-issues.md       # Bugs e limitações
├── roadmap.md            # Próximos passos
└── README.md             # Guia de uso
```

### Como Usar

**1. Inicialize a Estrutura**
```bash
ai-context-init --with-prompts  # Cria estrutura + prompts iniciais
```

**2. No Claude** (após `ai-start`)
```bash
cat .ai-context/initial-prompts/claude-init.md
# Copie e execute o prompt
```

**3. No Gemini**
```bash
cat .ai-context/initial-prompts/gemini-init.md
# Copie e execute o prompt
```

**4. No Codex**
```bash
cat .ai-context/initial-prompts/codex-init.md
# Copie e execute o prompt
```

### Benefícios

- **Contexto Compartilhado**: Todas as IAs leem os mesmos arquivos
- **Menos Repetição**: Não precisa explicar o projeto toda vez
- **Continuidade**: IAs trabalham com base no que outras fizeram
- **Organização**: Decisões e progresso documentados

Para mais detalhes: `ai-tips sharing`

## 🛠️ Development

Scripts are in `bin/`. Changes take effect immediately (via symlinks).

```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
# Edit bin/ai-status.sh
ai-status  # Test immediately
git commit -am "feat: improved status"
```

## 📦 Repository Structure

```
ai-terminal-agent/
├── bin/              # All executable scripts
│   ├── ai-workspace-launcher.sh
│   ├── ai-stop.sh
│   ├── ai-status.sh
│   ├── ai-recover.sh
│   └── ... (14 scripts total)
├── templates/        # Context file templates
│   ├── coding-project.md
│   ├── writing-project.md
│   ├── research-project.md
│   └── homelab-project.md
├── config/           # Example configurations
│   ├── .ai-config.example
│   ├── gitignore_global.template
│   └── zshrc.snippet
├── docs/             # Detailed documentation
└── PLAN.md           # Original implementation plan
```

## 🌐 Multi-Machine Setup

### First Machine (Setup)

```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
git init
./install.sh
git add .
git commit -m "Initial setup"
git remote add origin https://github.com/seu-usuario/ai-terminal-agent.git
git push -u origin main
```

### Second Machine (Clone)

```bash
cd ~/workspace/primavera  # or any location
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
# Done! All commands working
```

### Updates & Sync

```bash
# Machine A: Make changes
git push

# Machine B: Get updates
ai-update  # Auto git pull
```

## 💡 How It Works

1. **Installation** creates symlinks from `~/bin/ai-*` to repository scripts
2. **Scripts** are executed from repository (changes reflect immediately)
3. **Templates** are copied to `~/templates/` (customizable)
4. **Tracking** happens in `~/.ai-workspace/`
5. **Git global ignore** prevents accidental commits of personal AI files

## 🎨 Layout

```
┌─────────────────────┬──────────────┐
│                     │   GEMINI     │
│                     │              │
│      CLAUDE         ├──────────────┤
│                     │   CODEX      │
│                     │              │
└─────────────────────┴──────────────┘
```

## 🔐 Git Integration

AI Workspace files are **globally ignored** by default:
- `claude.md`, `gemini.md`, `agents.md`
- `.ai-config`, `.ai-workspace-active`
- `.ai-backups/`, `.ai-session-*.json`

This uses `~/.gitignore_global` and **never modifies** your project's `.gitignore`.

To commit context files in a specific project, add to `.ai-config`:
```json
{
  "git": {
    "commit_contexts": true
  }
}
```

## 🤝 Contributing

This is a personal tool but improvements are welcome!

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -am 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Create Pull Request

## 📄 License

MIT License - Use freely, modify as needed.

## 🙏 Credits

Built with love for AI-assisted development.

Inspired by the need to seamlessly work with multiple AI assistants while maintaining context and project organization.

## 🐛 Troubleshooting

If you encounter issues:

1. Run `ai-health-check` to verify installation
2. Check [Troubleshooting Guide](docs/troubleshooting.md)
3. Ensure iTerm2 Shift+Enter is configured (`/terminal-setup`)
4. Verify AI CLIs are authenticated

Common issues:
- **"ai-start: command not found"** → Add `~/bin` to PATH or restart shell
- **"Shift+Enter doesn't work"** → Run `/terminal-setup`
- **"Git global ignore not working"** → Run `ai-git-config --setup`

## 📈 Version

Current version: **1.0.0**

See [CHANGELOG.md](CHANGELOG.md) for version history.
