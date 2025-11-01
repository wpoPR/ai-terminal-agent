# AI Terminal Agent

Sistema completo para gerenciar workspaces AI (Claude, Gemini, Codex) no iTerm2.

## ✨ Features

- 🚀 **One-command workspace**: `ai-start` para abrir layout completo
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
ai-status                 # Show active workspaces
ai-recent                 # List recent workspaces
ai-recover                # Recover from crashes

# Configuration
ai-git-config             # Manage git global ignore
ai-health-check           # Verify installation
ai-help [command]         # Show help

# Maintenance
ai-update                 # Update from git
ai-export [file]          # Export configuration
ai-import [file]          # Import configuration
```

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
