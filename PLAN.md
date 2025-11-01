# AI Terminal Launcher - Plano de Implementação Completo

## Visão Geral
Criar um sistema completo e robusto para gerenciar workspaces AI com Claude, Gemini e Codex no iTerm2, incluindo detecção automática, templates, configuração por projeto, health checks, backups, daily summaries, ferramentas de gerenciamento e Git Global Ignore para arquivos pessoais.

## Arquitetura da Solução

### Componentes Principais
1. **Shell Script Principal** (`ai-workspace-launcher.sh`)
2. **AppleScript** (`iterm-layout.applescript`)
3. **Context Sync Script** (`sync-contexts.sh`)
4. **Cleanup Script** (`ai-stop.sh`)
5. **Status Command** (`ai-status.sh`)
6. **Help Command** (`ai-help.sh`)
7. **Health Check Script** (`ai-health-check.sh`)
8. **Recent Workspaces** (`ai-recent.sh`)
9. **Diff/Merge Tool** (`ai-diff.sh`)
10. **Update Script** (`ai-update.sh`)
11. **Git Config Manager** (`ai-git-config.sh`)
12. **Daily Summary Generator** (`generate-daily-summary.sh`)
13. **Export/Import Tool** (`ai-export.sh`, `ai-import.sh`) - **NOVO**
14. **Sistema de Templates** (`~/templates/ai-contexts/`)
15. **Tracking System** (`~/.ai-workspace/`)
16. **Suporte Extensível para AIs** (configurável via `.ai-config`) - **NOVO**

### Comandos Disponíveis
```bash
ai-start [path]           # Inicia workspace AI
ai-start --check          # Health check sem abrir
ai-start --dry-run        # Mostra o que faria sem executar
ai-start --debug          # Modo verbose
ai-start --recent N       # Abre workspace recente

ai-stop                   # Fecha workspace com daily summary
ai-stop --no-summary      # Fecha sem gerar summary

ai-status                 # Status de workspaces ativos
ai-recent                 # Lista workspaces recentes
ai-recover                # Recupera workspaces após crash (NOVO)
ai-diff                   # Compara/merge context files
ai-update                 # Atualiza scripts
ai-git-config             # Gerencia git ignore global
ai-export [file]          # Exporta configurações (NOVO)
ai-import [file]          # Importa configurações (NOVO)
ai-help                   # Mostra ajuda completa
ai-help [command]         # Ajuda de comando específico
```

## Sistema de Git Global Ignore

### Problema
- Arquivos AI (claude.md, gemini.md, .ai-config) são pessoais
- Não queremos modificar .gitignore de cada projeto
- Não queremos comitar acidentalmente
- Outros colaboradores não devem ser afetados

### Solução: Git Global Exclude
Durante instalação, configura **ignore global do usuário**:

```bash
# Arquivo: ~/.gitignore_global
# AI Workspace - Personal files (never commit)
.ai-workspace-active
.ai-config
.ai-backups/
claude.md
gemini.md
agents.md
.ai-session-*.json

# Optional
.ai-summaries/
```

```bash
# Configuração Git (instalação faz isso)
git config --global core.excludesfile ~/.gitignore_global
```

### Vantagens
- ✅ Funciona em TODOS os projetos automaticamente
- ✅ NUNCA modifica .gitignore do projeto
- ✅ Totalmente pessoal (só você)
- ✅ Outros colaboradores não afetados
- ✅ Configuração única, vale para sempre

### Opt-in por Projeto
Se QUISER commitar context files em projeto específico:

```json
// .ai-config
{
  "git": {
    "commit_contexts": true,   // Commita claude.md, gemini.md, agents.md
    "commit_config": false,     // .ai-config continua pessoal
    "commit_backups": false     // Backups sempre pessoais
  }
}
```

Quando `commit_contexts: true`:
- Script remove context files do exclude local
- Permite commit normal
- Outros arquivos (.ai-config, etc) continuam ignorados

### Comandos de Gerenciamento
```bash
ai-git-config                    # Mostra status atual
ai-git-config --show             # Mostra ~/.gitignore_global
ai-git-config --check            # Verifica configuração
ai-git-config --setup            # Reconfigura global ignore
ai-git-config --add PATTERN      # Adiciona pattern ao global ignore
```

### Durante ai-start
Script verifica automaticamente:
```bash
# 1. Verifica se global ignore está configurado
if ! git config --global core.excludesfile; then
  echo "⚠️  Git global ignore não configurado"
  echo "Executar: ai-git-config --setup"
fi

# 2. Se projeto tem commit_contexts: true
if [[ .ai-config tem "commit_contexts": true ]]; then
  # Remove do exclude local do projeto
  # Permite commit
fi
```

## Layout iTerm2 (conforme imagem)
```
┌─────────────────────┬──────────────┐
│                     │   GEMINI     │
│                     │              │
│      CLAUDE         ├──────────────┤
│                     │   CODEX      │
│                     │              │
└─────────────────────┴──────────────┘
```

## Exemplo Completo de `.ai-config`
```json
{
  "layout": "default",
  "splits": {
    "claude": 0.6,
    "gemini": 0.5,
    "codex": 0.5
  },
  "flags": {
    "claude": "--dangerously-skip-permissions",
    "gemini": "",
    "codex": ""
  },
  "primary_ai": "claude",
  "auto_sync": true,
  "auto_backup": true,
  "backup": {
    "enabled": true,
    "retention_days": 3,
    "max_backups_per_project": 10
  },
  "template": "coding-project",
  "project_name": "Health Haven App",
  "summary": {
    "mode": "auto",
    "generator": "gemini",
    "template": "detailed",
    "auto_clipboard": true
  },
  "git": {
    "commit_contexts": false,
    "commit_config": false,
    "commit_backups": false
  }
}
```

## Estrutura Completa do Sistema

### Repositório Fonte (Versionado)
**Localização**: `/Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/`

```
ai-terminal-agent/                    # Repositório Git
├── README.md                         # Documentação completa
├── PLAN.md                           # Este plano (para consulta)
├── CHANGELOG.md                      # Histórico de mudanças
├── install.sh                        # Script de instalação
├── uninstall.sh                      # Script de desinstalação
│
├── bin/                              # Scripts principais
│   ├── ai-workspace-launcher.sh
│   ├── ai-stop.sh
│   ├── ai-status.sh
│   ├── ai-recent.sh
│   ├── ai-recover.sh
│   ├── ai-diff.sh
│   ├── ai-update.sh
│   ├── ai-help.sh
│   ├── ai-health-check.sh
│   ├── ai-git-config.sh
│   ├── ai-export.sh
│   ├── ai-import.sh
│   ├── iterm-layout.applescript
│   ├── sync-contexts.sh
│   └── generate-daily-summary.sh
│
├── templates/                        # Templates de context files
│   ├── coding-project.md
│   ├── writing-project.md
│   ├── research-project.md
│   └── homelab-project.md
│
├── config/                           # Configurações exemplo
│   ├── .ai-config.example
│   ├── gitignore_global.template
│   └── zshrc.snippet
│
├── docs/                             # Documentação detalhada
│   ├── installation.md
│   ├── usage.md
│   ├── configuration.md
│   ├── troubleshooting.md
│   └── architecture.md
│
└── tests/                            # Testes (futuro)
    └── health-check-tests.sh
```

### Scripts Instalados via Symlinks em `~/bin/`
```bash
# Todos apontam para o repositório fonte
~/bin/ai-start -> /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/bin/ai-workspace-launcher.sh
~/bin/ai-stop -> /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/bin/ai-stop.sh
~/bin/ai-status -> /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/bin/ai-status.sh
# ... etc
```

**Vantagens dessa abordagem:**
- ✅ **Versionamento**: Todo código em Git
- ✅ **Fácil atualização**: `cd repo && git pull && ai-update`
- ✅ **Portabilidade**: Clone em outra máquina e instale
- ✅ **Desenvolvimento**: Edite no repo, mudanças refletem imediatamente
- ✅ **Backup**: Código fonte sempre disponível
- ✅ **Compartilhamento**: Push para GitHub/GitLab

### Templates em `~/templates/ai-contexts/` (Copiados do Repo)
Durante instalação, templates são **copiados** (não symlinked) para permitir customização:
```
~/templates/ai-contexts/
├── coding-project.md
├── writing-project.md
├── research-project.md
└── homelab-project.md
```

### Sistema de Tracking em `~/.ai-workspace/`
```
~/.ai-workspace/
├── tracking.json
├── config.json
├── sessions/
│   └── YYYY-MM-DD/
├── backups/
│   └── project-name/
└── summaries/
    ├── daily/
    └── weekly/
```

### Arquivo Global Git
```
~/.gitignore_global    # Criado na instalação
```

## Sistema de Daily Summary (Detalhado)

### Quando ai-stop é executado:
```bash
ai-stop

# Processo completo:
# 1. Detecta TODOS workspaces ativos hoje
# 2. Para cada workspace:
#    a) Analisa context files (início vs fim)
#    b) Lista arquivos modificados
#    c) Lê git commits se disponível
#    d) Calcula tempo de trabalho
#    e) Extrai "Next steps" do context
# 
# 3. Usa Gemini (free!) para gerar summary estruturado
#    Fallback: template básico se Gemini não disponível
# 4. Salva em ~/.ai-workspace/summaries/daily/YYYY-MM-DD.md
# 5. Copia para clipboard (opcional)
# 6. Mostra no terminal

# Output exemplo:
📊 Daily Work Summary - 2024-11-01
═══════════════════════════════════

🚀 PROJECT: health-haven-app (4h 23m)
   Location: ~/workspace/health-haven-app
   
   ✨ What you accomplished:
   - Implemented user authentication system
   - Created logging utility with error handling
   - Set up database schema for users table
   
   📝 Key files modified:
   - src/auth/login.py (234 lines added)
   - src/utils/logger.py (new file, 156 lines)
   - db/schema.sql (45 lines added)
   
   🔧 Git commits:
   - feat: add user authentication (abc123)
   - feat: implement logging system (def456)
   
   💡 Next steps (from context):
   - Add password reset functionality
   - Implement JWT refresh tokens
   - Write unit tests for auth module

─────────────────────────────────────

🚀 PROJECT: blog-content (1h 45m)
   Location: ~/projects/blog-content
   
   ✨ What you accomplished:
   - Researched coffee brewing methods
   - Created blog outline (5-part series)
   - Drafted introduction for Part 1
   
   📝 Key files modified:
   - research/coffee-methods.md (new file)
   - outlines/series-outline.md (new file)
   - drafts/part-1-intro.md (new file)
   
   💡 Next steps (from context):
   - Complete Part 1 draft
   - Get feedback on tone/style

═══════════════════════════════════
⏱️  Total Work Time: 6h 8m
📂 Projects Worked On: 2
📄 Files Modified: 10
💾 Commits Made: 2
═══════════════════════════════════

Summary saved to: ~/.ai-workspace/summaries/daily/2024-11-01.md
Copied to clipboard! ✓
```

### Opções de Summary
```bash
ai-stop                          # Summary completo
ai-stop --no-summary             # Fecha sem summary
ai-stop --summary-only           # Gera mas não fecha
ai-stop --share                  # Formato para compartilhar
ai-stop --format markdown        # Formato específico
ai-stop --format slack           # Para Slack
ai-stop --clipboard              # Copia para clipboard
```

## Pré-requisitos e Setup

### iTerm2 Key Binding (OBRIGATÓRIO)
O sistema requer configuração do **Shift+Enter** no iTerm2 para permitir quebras de linha nos CLIs (Claude, Gemini, Codex).

**Por que é necessário:**
- CLIs AI precisam aceitar input multi-linha
- `Shift+Enter` = nova linha (sem enviar)
- `Enter` = enviar mensagem

Durante instalação, o script executa:
```bash
/terminal-setup
# Configura: iTerm2 → Preferences → Keys
# Adiciona: Shift+Enter → Send Text: \n (sem enviar comando)
```

## Detecção de Workspaces Ativos

### Estratégia Híbrida
O sistema usa múltiplas camadas para detectar e rastrear workspaces:

#### 1. Arquivo Local no Projeto
```bash
# .ai-workspace-active (no diretório do projeto)
{
  "pid": 12345,
  "iterm_session_id": "w0t0p0",
  "started_at": "2024-11-01T10:30:00Z",
  "project_path": "/Users/wesley/workspace/projeto"
}
```

#### 2. Tracking Global
```bash
# ~/.ai-workspace/tracking.json
{
  "active_workspaces": [
    {
      "path": "/Users/wesley/workspace/projeto",
      "pid": 12345,
      "iterm_session_id": "w0t0p0",
      "started_at": "2024-11-01T10:30:00Z",
      "last_heartbeat": "2024-11-01T14:45:00Z"
    }
  ]
}
```

#### 3. Verificações de Integridade
Durante `ai-start`, o sistema verifica:
```bash
# 1. Verifica se workspace já está ativo
if [[ -f .ai-workspace-active ]]; then
  pid=$(jq -r '.pid' .ai-workspace-active)

  # 2. Verifica se processo ainda existe
  if ps -p $pid > /dev/null 2>&1; then
    echo "⚠️  Workspace já está ativo (PID: $pid)"
    echo "Use: ai-status para verificar"
    exit 1
  else
    # Processo morreu, oferece recovery
    echo "⚠️  Workspace anterior não fechou corretamente"
    echo "Executar: ai-recover"
  fi
fi
```

#### 4. Recovery Automático
```bash
ai-recover
# - Remove .ai-workspace-active órfãos
# - Limpa tracking.json de processos mortos
# - Oferece gerar summary de sessão anterior
# - Lista backups disponíveis
```

### Vantagens da Abordagem
- ✅ **Simples**: Arquivo JSON + PID tracking
- ✅ **Robusto**: Detecta crashes e permite recovery
- ✅ **Multi-workspace**: Cada projeto rastreia seu próprio estado
- ✅ **Verificável**: iTerm session ID permite validar janela ativa

## Instalação Automatizada

### Primeira Instalação (Nova Máquina)

#### Opção 1: Clone do Repositório (Recomendado)
```bash
# Se já tem o repositório no GitHub/GitLab
cd ~/workspace/primavera
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
```

#### Opção 2: Criar Novo Repositório
```bash
# Primeira vez, criando do zero
mkdir -p /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent

# Inicializa Git
git init
git add .
git commit -m "Initial commit: AI Terminal Agent"

# Executa instalação
./install.sh
```

### Script `install.sh`
```bash
#!/bin/bash
# Instalação completa automatizada

set -e  # Exit on error

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$HOME/bin"
TEMPLATES_DIR="$HOME/templates/ai-contexts"
WORKSPACE_DIR="$HOME/.ai-workspace"

echo "🚀 AI Terminal Agent - Installation"
echo "═══════════════════════════════════"
echo "Repository: $REPO_DIR"
echo ""

# 1. Verifica dependências (iTerm2, npm, etc)
check_dependencies() {
  echo "📋 Checking dependencies..."
  # Verifica macOS, iTerm2, Git, jq, etc
}

# 2. Configura iTerm2 key binding (Shift+Enter)
setup_iterm_keybinding() {
  echo "🔧 Configurando iTerm2 key bindings..."
  if command -v /terminal-setup &> /dev/null; then
    /terminal-setup
    echo "✓ Shift+Enter configurado"
  else
    echo "⚠️  /terminal-setup não encontrado"
    echo "   Configure manualmente: iTerm2 → Preferences → Keys"
  fi
}

# 3. Verifica instalação de Claude, Gemini, Codex
check_ai_clis() {
  echo "🤖 Checking AI CLIs..."
  # Verifica cada CLI
}

# 4. Cria estrutura de diretórios
create_directories() {
  echo "📁 Creating directories..."
  mkdir -p "$BIN_DIR"
  mkdir -p "$TEMPLATES_DIR"
  mkdir -p "$WORKSPACE_DIR"/{sessions,backups,summaries/daily,summaries/weekly}
}

# 5. Cria symlinks em ~/bin/
create_symlinks() {
  echo "🔗 Creating symlinks in ~/bin/..."

  ln -sf "$REPO_DIR/bin/ai-workspace-launcher.sh" "$BIN_DIR/ai-start"
  ln -sf "$REPO_DIR/bin/ai-stop.sh" "$BIN_DIR/ai-stop"
  ln -sf "$REPO_DIR/bin/ai-status.sh" "$BIN_DIR/ai-status"
  ln -sf "$REPO_DIR/bin/ai-recent.sh" "$BIN_DIR/ai-recent"
  ln -sf "$REPO_DIR/bin/ai-recover.sh" "$BIN_DIR/ai-recover"
  ln -sf "$REPO_DIR/bin/ai-diff.sh" "$BIN_DIR/ai-diff"
  ln -sf "$REPO_DIR/bin/ai-update.sh" "$BIN_DIR/ai-update"
  ln -sf "$REPO_DIR/bin/ai-help.sh" "$BIN_DIR/ai-help"
  ln -sf "$REPO_DIR/bin/ai-health-check.sh" "$BIN_DIR/ai-health-check"
  ln -sf "$REPO_DIR/bin/ai-git-config.sh" "$BIN_DIR/ai-git-config"
  ln -sf "$REPO_DIR/bin/ai-export.sh" "$BIN_DIR/ai-export"
  ln -sf "$REPO_DIR/bin/ai-import.sh" "$BIN_DIR/ai-import"

  chmod +x "$REPO_DIR"/bin/*.sh

  echo "✓ Symlinks created"
}

# 6. Copia templates (permite customização)
install_templates() {
  echo "📝 Installing templates..."
  cp -n "$REPO_DIR"/templates/* "$TEMPLATES_DIR/" 2>/dev/null || true
  echo "✓ Templates installed"
}

# 7. Configura Git Global Ignore
setup_git_ignore() {
  echo "📦 Configuring Git global ignore..."

  if [[ ! -f ~/.gitignore_global ]]; then
    cp "$REPO_DIR/config/gitignore_global.template" ~/.gitignore_global
  fi

  git config --global core.excludesfile ~/.gitignore_global
  echo "✓ Git global ignore configured"
}

# 8. Atualiza .zshrc (se necessário)
update_zshrc() {
  echo "🐚 Updating .zshrc..."

  if ! grep -q "AI Terminal Agent" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    cat "$REPO_DIR/config/zshrc.snippet" >> ~/.zshrc
    echo "✓ .zshrc updated (restart shell or run: source ~/.zshrc)"
  else
    echo "✓ .zshrc already configured"
  fi
}

# 9. Salva localização do repo
save_repo_location() {
  echo "💾 Saving repository location..."
  echo "{\"repo_path\": \"$REPO_DIR\"}" > "$WORKSPACE_DIR/config.json"
}

# 10. Health check inicial
run_health_check() {
  echo ""
  echo "🏥 Running health check..."
  "$BIN_DIR/ai-health-check"
}

# 11. Mostra guia de início rápido
show_quickstart() {
  echo ""
  echo "✅ Installation Complete!"
  echo "═══════════════════════════════════"
  echo ""
  echo "📚 Quick Start:"
  echo "   cd ~/your-project"
  echo "   ai-start"
  echo ""
  echo "📖 Full documentation:"
  echo "   ai-help"
  echo ""
  echo "🔧 Repository location:"
  echo "   $REPO_DIR"
  echo ""
  echo "💡 To edit scripts:"
  echo "   cd $REPO_DIR"
  echo "   # Edit files in bin/"
  echo "   # Changes take effect immediately (symlinks)"
  echo ""
}

# Executa instalação
main() {
  check_dependencies
  setup_iterm_keybinding
  check_ai_clis
  create_directories
  create_symlinks
  install_templates
  setup_git_ignore
  update_zshrc
  save_repo_location
  run_health_check
  show_quickstart
}

main "$@"
```

### Uso em Múltiplas Máquinas

#### Primeira Máquina (Setup Inicial)
```bash
# 1. Cria repositório
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
git init

# 2. Desenvolve/instala
./install.sh

# 3. Commit e push para remoto
git add .
git commit -m "Initial setup"
git remote add origin https://github.com/seu-usuario/ai-terminal-agent.git
git push -u origin main
```

#### Segunda Máquina (Clone e Instala)
```bash
# 1. Clone do repositório
cd ~/workspace/primavera  # ou qualquer local
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent

# 2. Instala (cria symlinks, configs, etc)
./install.sh

# 3. Pronto! Todos comandos ai-* funcionando
ai-health-check
```

#### Atualizações e Sincronização
```bash
# Máquina A: Fez mudanças nos scripts
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
# ... edita bin/ai-status.sh
git add .
git commit -m "feat: improved status output"
git push

# Máquina B: Recebe atualizações
cd ~/workspace/primavera/ai-terminal-agent
git pull
# Mudanças já funcionam (symlinks)!

# Ou use o comando:
ai-update  # Faz git pull automaticamente
```

### Fluxo de Desenvolvimento

```bash
# 1. Edita scripts diretamente no repositório
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
code bin/ai-status.sh  # ou vim, nano, etc

# 2. Testa mudanças imediatamente
ai-status  # Usa o script editado (via symlink)

# 3. Commita quando satisfeito
git add bin/ai-status.sh
git commit -m "feat: add emoji to status output"

# 4. Push (opcional, para compartilhar)
git push

# 5. Outras máquinas recebem via:
ai-update  # Em outras máquinas
```

### Sistema de Update (`ai-update.sh`)

```bash
#!/bin/bash
# ai-update.sh

REPO_PATH=$(jq -r '.repo_path' ~/.ai-workspace/config.json)

if [[ ! -d "$REPO_PATH" ]]; then
  echo "❌ Repository not found: $REPO_PATH"
  exit 1
fi

cd "$REPO_PATH"

echo "🔄 Updating AI Terminal Agent..."
echo "Repository: $REPO_PATH"
echo ""

# Verifica se há mudanças locais
if [[ -n $(git status -s) ]]; then
  echo "⚠️  You have uncommitted changes:"
  git status -s
  echo ""
  read -p "Stash changes and update? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git stash
  else
    echo "Update cancelled"
    exit 0
  fi
fi

# Pull atualizações
git pull || {
  echo "❌ Update failed"
  exit 1
}

echo ""
echo "✅ Update complete!"
echo ""
echo "📝 Recent changes:"
git log --oneline -5

# Re-aplica permissões
chmod +x bin/*.sh

echo ""
echo "✓ All scripts updated and ready to use"
```

## Health Check Completo

O comando `ai-health-check` verifica toda a configuração necessária:

```bash
ai-health-check

🔍 AI Workspace Health Check
═══════════════════════════════════

✓ macOS detected
✓ iTerm2 installed (v3.4.19)
✓ Shift+Enter key binding configured
✓ Claude CLI installed and authenticated
✓ Gemini CLI installed and authenticated
✓ Codex CLI installed and authenticated
✓ Git global ignore configured
✓ ~/.ai-workspace/ structure exists
✓ Templates installed (4 templates)
✓ All scripts have execute permissions

Status: ✅ All systems operational

TIPS:
- Use 'ai-start' to launch a workspace
- Run '/terminal-setup' if Shift+Enter stops working
```

### Verificações Realizadas
```bash
# 1. Sistema operacional
uname -s | grep -q "Darwin"

# 2. iTerm2 instalado
[[ -d "/Applications/iTerm.app" ]]

# 3. Key binding configurado
defaults read com.googlecode.iterm2 2>/dev/null | grep -q "0xd-0x20000"

# 4. CLIs instalados e autenticados
command -v claude && claude --version
command -v gemini && gemini --version
command -v codex && codex --version

# 5. Git global ignore
git config --global core.excludesfile | grep -q "gitignore_global"

# 6. Estrutura de diretórios
[[ -d ~/.ai-workspace ]] && [[ -d ~/templates/ai-contexts ]]

# 7. Scripts instalados
command -v ai-start && command -v ai-stop
```

## Sistema de Daily Summary com Gemini

### Implementação do `generate-daily-summary.sh`

```bash
#!/bin/bash
# generate-daily-summary.sh

# 1. Coleta dados de todos workspaces do dia
collect_workspace_data() {
  # Lê tracking.json e backups
  # Analisa git diff e commits
  # Calcula tempo de trabalho
}

# 2. Prepara prompt para Gemini
prepare_prompt() {
  cat << EOF
You are an AI assistant that creates concise daily work summaries.

Analyze the following workspaces and generate a structured summary:

WORKSPACE 1: health-haven-app
Working time: 4h 23m
Context at start: [conteúdo inicial do claude.md]
Context at end: [conteúdo final do claude.md]
Files modified:
- src/auth/login.py (+234 lines)
- src/utils/logger.py (new file, 156 lines)
Git commits:
- feat: add user authentication (abc123)
- feat: implement logging system (def456)

WORKSPACE 2: blog-content
...

Generate a markdown summary with:
- Emoji section headers
- Accomplishments per project
- Key files modified
- Git commits (if any)
- Next steps extracted from contexts
- Total statistics

Format should be professional but friendly.
EOF
}

# 3. Chama Gemini API
generate_summary() {
  local prompt="$1"
  local summary_mode="${2:-auto}"

  if [[ "$summary_mode" == "basic" ]]; then
    # Usa template sem AI
    generate_basic_summary
  else
    # Tenta usar Gemini
    if command -v gemini &> /dev/null; then
      echo "$prompt" | gemini chat --mode=summary 2>/dev/null || {
        echo "⚠️  Gemini failed, using basic template"
        generate_basic_summary
      }
    else
      echo "⚠️  Gemini not available, using basic template"
      generate_basic_summary
    fi
  fi
}

# 4. Fallback: template básico
generate_basic_summary() {
  # Template simples sem AI
  # Lista de bullets com dados coletados
}
```

### Configuração no .ai-config

```json
{
  "summary": {
    "mode": "auto",           // "auto", "basic", "disabled"
    "generator": "gemini",    // "gemini", "claude", "basic"
    "template": "detailed",   // "detailed", "brief", "slack"
    "auto_clipboard": true,   // Copia para clipboard
    "save_format": "markdown" // "markdown", "json", "text"
  }
}
```

### Por que Gemini?
- ✅ **Gratuito**: até 1500 requests/dia
- ✅ **Rápido**: Gemini Flash é muito rápido
- ✅ **Grande contexto**: 1M tokens (analisa múltiplos context files)
- ✅ **Fallback robusto**: Se falhar, usa template básico
- ✅ **Zero configuração**: Se já tem `gemini` CLI, funciona direto

## Sistema de Help Completo

### `ai-help git`
```bash
ai-help git

AI Workspace - Git Integration
═══════════════════════════════

By default, AI Workspace files are ignored GLOBALLY:
  ✓ claude.md, gemini.md, agents.md
  ✓ .ai-config
  ✓ .ai-workspace-active
  ✓ .ai-backups/

This uses Git Global Exclude (~/.gitignore_global)
and NEVER modifies your project's .gitignore.

WHY?
- These files are personal workspace configuration
- Other collaborators may use different AI tools
- Prevents accidental commits of personal data

TO COMMIT CONTEXT FILES IN A PROJECT:
  1. Create/edit .ai-config in project
  2. Set: "git": { "commit_contexts": true }
  3. Context files become available for git add

COMMANDS:
  ai-git-config               Show current configuration
  ai-git-config --show        Display ~/.gitignore_global
  ai-git-config --check       Verify setup is correct
  ai-git-config --setup       Configure/reconfigure
  ai-git-config --add PATTERN Add custom pattern

EXAMPLES:
  ai-git-config --check
  ai-git-config --show
  ai-git-config --add "*.ai-temp"
```

## Casos de Uso Completos

### Caso 1: Projeto Novo
```bash
cd ~/novo-projeto
ai-start

# Sistema:
# 1. Health check
# 2. Oferece templates
# 3. Cria context files
# 4. Verifica git global ignore
# 5. Abre iTerm2
```

### Caso 2: Projeto Existente
```bash
cd ~/projeto-antigo  # Já tem contexts
ai-start

# Sistema:
# 1. Health check
# 2. Backup de contexts
# 3. Sincroniza contexts
# 4. Abre iTerm2
```

### Caso 3: Commitar Contexts
```bash
cd ~/projeto-compartilhado

# Criar .ai-config
cat > .ai-config << EOF
{
  "git": {
    "commit_contexts": true
  }
}
EOF

ai-start
# Contexts agora podem ser commitados
git add claude.md gemini.md agents.md
git commit -m "docs: add AI context files"

# .ai-config continua ignorado globalmente
```

### Caso 4: Verificar Setup Git
```bash
ai-git-config --check

# Output:
✓ Git global ignore configured
✓ ~/.gitignore_global exists
✓ Ignoring AI workspace files

Ignored patterns:
  - .ai-workspace-active
  - .ai-config
  - claude.md
  - gemini.md
  - agents.md
```

## Templates de Context Files

### Template: coding-project.md
```markdown
# Project: [PROJECT_NAME]

## Type
Software Development Project

## Tech Stack
- Languages: 
- Frameworks: 
- Database: 
- Tools: 

## Current Phase
[ ] Planning
[ ] Development
[ ] Testing
[ ] Deployment

## Project Structure
- src/
- tests/
- docs/

## Key Files
- 

## Decisions Made
- 

## Next Steps
1. 
2. 
3. 

## Development Guidelines
- Follow established code style
- Write tests for new features
- Update documentation as needed
```

### Template: writing-project.md
```markdown
# Project: [PROJECT_NAME]

## Type
Content Creation - [Blog/Video Script/Article/Book]

## Target Audience
- Demographics: 
- Knowledge level: 
- Interests: 

## Current Phase
[ ] Research
[ ] Outline
[ ] First Draft
[ ] Editing
[ ] Final Review

## Content Structure
- 

## Key Files
- research/ - Research findings
- outlines/ - Content outlines
- drafts/ - Draft versions

## Tone & Style
- Voice: 
- Formality: 
- Key terms to use: 
- Terms to avoid: 

## Decisions Made
- 

## Next Steps
1. 
2. 
3. 
```

### Template: research-project.md
```markdown
# Project: [PROJECT_NAME]

## Type
Research & Analysis

## Research Question
[Main question or hypothesis]

## Current Phase
[ ] Literature Review
[ ] Data Collection
[ ] Analysis
[ ] Documentation

## Methodology
- 

## Data Sources
- 

## Key Files
- sources/ - Reference materials
- data/ - Raw data
- analysis/ - Analysis results

## Findings So Far
- 

## Decisions Made
- 

## Next Steps
1. 
2. 
3. 
```

### Template: homelab-project.md
```markdown
# Project: [PROJECT_NAME]

## Type
Infrastructure/Homelab Project

## Infrastructure
- Hardware: 
- Network: 
- Services: 

## Current Phase
[ ] Planning
[ ] Setup
[ ] Configuration
[ ] Testing
[ ] Production

## Architecture
[Diagram or description]

## Key Files
- configs/ - Configuration files
- docs/ - Documentation
- scripts/ - Automation scripts

## Services Running
- 

## Decisions Made
- 

## Next Steps
1. 
2. 
3. 

## Troubleshooting Notes
- 
```

## Funcionalidades Completas Implementadas
1. ✅ Comando global em qualquer diretório
2. ✅ Detecção automática de workspace (PID + tracking.json)
3. ✅ Sistema de templates
4. ✅ Configuração customizável por projeto
5. ✅ Sincronização de context files
6. ✅ Layout iTerm2 configurável
7. ✅ Health check (inclui verificação de key binding)
8. ✅ Backup automático (retenção de 3 dias)
9. ✅ Daily summary agregado (usando Gemini - free!)
10. ✅ Sistema de status
11. ✅ Histórico de workspaces
12. ✅ Recovery de crashes (ai-recover)
13. ✅ Diff/merge de contexts
14. ✅ Sistema de update
15. ✅ Debug/verbose mode
16. ✅ Dry-run mode
17. ✅ Sistema de ajuda completo
18. ✅ Git Global Ignore (não modifica .gitignore do projeto)
19. ✅ Opt-in para commitar contexts por projeto
20. ✅ iTerm2 Shift+Enter setup (/terminal-setup)

## Estrutura de Documentação do Repositório

### README.md Principal
```markdown
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

## 🚀 Quick Start

### Installation
\```bash
cd ~/workspace/primavera
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
\```

### Usage
\```bash
cd ~/your-project
ai-start          # Launch workspace
ai-stop           # Close with summary
ai-status         # Check active workspaces
ai-help           # Full documentation
\```

## 📋 Prerequisites

- macOS (tested on 14+)
- iTerm2
- Claude CLI (`npm install -g @anthropic-ai/claude-code`)
- Gemini CLI (`npm install -g @google/generative-ai`)
- Codex CLI (`npm install -g @openai/codex`)

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Usage Guide](docs/usage.md)
- [Configuration](docs/configuration.md)
- [Architecture](docs/architecture.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Original Plan](PLAN.md)

## 🛠️ Development

Scripts are in `bin/`. Changes take effect immediately (via symlinks).

\```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
# Edit bin/ai-status.sh
ai-status  # Test immediately
git commit -am "feat: improved status"
\```

## 📦 Repository Structure

\```
ai-terminal-agent/
├── bin/              # All executable scripts
├── templates/        # Context file templates
├── config/           # Example configurations
├── docs/             # Detailed documentation
└── PLAN.md           # Original implementation plan
\```

## 🌐 Multi-Machine Setup

\```bash
# Machine 1: Push changes
git push

# Machine 2: Update
ai-update  # Auto git pull
\```

## 🤝 Contributing

This is a personal tool but improvements are welcome!
1. Fork the repo
2. Create your feature branch
3. Commit changes
4. Push and create PR

## 📄 License

MIT License - Use freely, modify as needed.

## 🙏 Credits

Built with love for AI-assisted development.
\```

### docs/installation.md
Documentação detalhada de instalação, troubleshooting, etc.

### docs/usage.md
Guia completo de uso de todos comandos.

### docs/configuration.md
Todas opções de `.ai-config` explicadas.

### docs/architecture.md
Como o sistema funciona internamente.

### CHANGELOG.md
```markdown
# Changelog

All notable changes to AI Terminal Agent.

## [1.0.0] - 2024-11-01

### Added
- Initial release
- Multi-AI workspace support (Claude, Gemini, Codex)
- Daily summaries with Gemini
- Git global ignore system
- Template system
- Backup with 3-day retention
- Recovery system for crashes
- Full documentation

### Features
- ai-start, ai-stop, ai-status
- ai-recover for crash recovery
- ai-export/import for portability
- ai-update for git-based updates
- ai-health-check with iTerm2 binding check
\```

## TODOs de Implementação

1. [ ] Criar ai-workspace-launcher.sh com health check, backup, dry-run, debug e verificação git
2. [ ] Criar iterm-layout.applescript com suporte a configurações customizadas
3. [ ] Criar sync-contexts.sh com suporte a templates e backup
4. [ ] Criar ai-stop.sh com geração de daily summary agregado de todos projetos
5. [ ] Criar ai-status.sh para mostrar workspaces ativos e status de sync
6. [ ] Criar ai-recent.sh com histórico e reabertura rápida
7. [ ] Criar ai-diff.sh para comparar e merge de context files
8. [ ] Criar ai-update.sh para atualização do sistema
8a. [ ] Adicionar seção no ai-health-check sobre verificação de key binding
9. [ ] Criar ai-help.sh com documentação completa incluindo git integration
10. [ ] Criar ai-health-check.sh para verificar instalação, autenticação e iTerm2 key binding
11. [ ] Criar ai-git-config.sh para gerenciar git global ignore e opt-in por projeto
11a. [ ] Criar ai-recover.sh para recuperar workspaces após crashes
12. [ ] Criar generate-daily-summary.sh que usa Gemini para gerar relatório (com fallback)
13. [ ] Criar 4 templates de context files: coding, writing, research, homelab
14. [ ] Criar estrutura de tracking em ~/.ai-workspace/ com JSON schemas
15. [ ] Criar ~/.gitignore_global com patterns de AI workspace
16. [ ] Criar exemplo de .ai-config com todas opções incluindo git settings
17. [ ] Criar install.sh com setup de git global ignore e configuração do /terminal-setup
18. [ ] Criar código para adicionar ao .zshrc com aliases e auto-detection
19. [ ] Criar estrutura de diretórios do repositório em /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/
20. [ ] Criar README.md completo incluindo quick start, features e multi-machine setup
21. [ ] Criar CHANGELOG.md para versionar mudanças
22. [ ] Criar docs/installation.md com guia detalhado
23. [ ] Criar docs/usage.md com todos os comandos
24. [ ] Criar docs/configuration.md com todas opções de .ai-config
25. [ ] Criar docs/architecture.md explicando como funciona
26. [ ] Criar docs/troubleshooting.md com problemas comuns
27. [ ] Criar ai-export.sh que exporta repositório + configs
28. [ ] Criar ai-import.sh que importa e instala automaticamente
29. [ ] Atualizar ai-update.sh para fazer git pull do repositório
30. [ ] Modificar install.sh para criar symlinks e salvar repo_path em config.json
31. [ ] Adicionar suporte a custom_ais no .ai-config e iterm-layout.applescript
32. [ ] Criar .gitignore no repositório (ignorar logs, etc)
33. [ ] Testar: clone em máquina nova, install.sh, ai-start
34. [ ] Testar: edição de script, mudança refletida imediatamente
35. [ ] Testar: git push/pull, ai-update
36. [ ] Testar: health check, git config, start, work, diff, stop com summary
37. [ ] Testar: export/import via tarball em outra máquina
38. [ ] Testar: adicionar AI customizada (cursor-ai) via .ai-config

## Funcionalidades Adicionadas ao v1.0

### Export/Import de Configurações

**IMPORTANTE**: Com o modelo baseado em repositório, export/import agora é simplificado:

#### Método Recomendado (Via Git)
```bash
# Máquina A: Já está tudo no repositório Git!
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
git push origin main

# Máquina B: Clone e instale
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
```

#### Método Alternativo (Sem Git Remoto)
Para transferir via arquivo (ex: pendrive, Airdrop):
```bash
# Máquina A: Exporta
ai-export ~/my-ai-setup.tar.gz

# Compacta:
# - O repositório completo (/workspace/primavera/ai-terminal-agent/)
# - Templates customizados (~/.ai-workspace/)
# - ~/.gitignore_global

# Máquina B: Importa
ai-import ~/my-ai-setup.tar.gz

# Descompacta em ~/workspace/primavera/ai-terminal-agent/
# Executa install.sh automaticamente
# Restaura templates e configurações
```

#### Implementação ai-export.sh
```bash
#!/bin/bash
# ai-export.sh

OUTPUT_FILE="${1:-$HOME/ai-terminal-agent-backup.tar.gz}"
REPO_PATH=$(jq -r '.repo_path' ~/.ai-workspace/config.json)

echo "📦 Exporting AI Terminal Agent..."
echo ""

# Cria tarball com repositório e configs
tar -czf "$OUTPUT_FILE" \
  -C "$(dirname "$REPO_PATH")" "$(basename "$REPO_PATH")" \
  -C "$HOME" "templates/ai-contexts" \
  -C "$HOME" ".gitignore_global"

echo "✅ Export complete!"
echo "File: $OUTPUT_FILE"
echo ""
echo "📁 Included:"
echo "   - Repository: $REPO_PATH"
echo "   - Templates: ~/templates/ai-contexts/"
echo "   - Git ignore: ~/.gitignore_global"
echo ""
echo "🚀 To import on another machine:"
echo "   ai-import $OUTPUT_FILE"
```

#### Implementação ai-import.sh
```bash
#!/bin/bash
# ai-import.sh

IMPORT_FILE="$1"
TARGET_DIR="$HOME/workspace/primavera"

if [[ ! -f "$IMPORT_FILE" ]]; then
  echo "❌ File not found: $IMPORT_FILE"
  exit 1
fi

echo "📥 Importing AI Terminal Agent..."
echo "File: $IMPORT_FILE"
echo ""

# Cria diretório de destino
mkdir -p "$TARGET_DIR"

# Extrai
tar -xzf "$IMPORT_FILE" -C "$TARGET_DIR"

# Localiza repositório extraído
REPO_PATH="$TARGET_DIR/ai-terminal-agent"

if [[ ! -d "$REPO_PATH" ]]; then
  echo "❌ Repository not found in archive"
  exit 1
fi

echo "✅ Files extracted"
echo ""

# Executa instalação
cd "$REPO_PATH"
./install.sh

echo ""
echo "🎉 Import complete and installed!"
echo "Repository: $REPO_PATH"
```

### Suporte Extensível para Mais AIs
```json
// .ai-config
{
  "custom_ais": [
    {
      "name": "cursor-ai",
      "command": "cursor-chat",
      "context_file": "cursor.md",
      "flags": "",
      "pane": "additional"  // Cria 4º painel
    },
    {
      "name": "opencode",
      "command": "opencode",
      "context_file": "opencode.md",
      "flags": "",
      "pane": "additional"
    }
  ]
}
```

Layout extensível automaticamente se detectar custom_ais.

## .gitignore do Repositório

```gitignore
# AI Terminal Agent - Repository .gitignore

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Logs e temporários
*.log
tmp/
temp/

# Não versionar configs locais do dev
config.local.json

# Não versionar testes locais
tests/local/

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Não ignorar:
# - bin/*.sh (scripts principais)
# - templates/*.md (templates)
# - config/*.example (exemplos)
# - docs/*.md (documentação)
```

## Resumo das Mudanças com Repositório

### Antes (Modelo Antigo)
```
~/bin/ai-*.sh              # Scripts copiados
~/templates/               # Templates copiados
~/.ai-workspace/           # Tracking
```
❌ Difícil versionar
❌ Difícil compartilhar
❌ Updates manuais

### Agora (Modelo Repositório)
```
/Users/wesleyoliveira/workspace/primavera/ai-terminal-agent/  # Fonte Git
├── bin/                   # Scripts (FONTE)
├── templates/             # Templates (FONTE)
├── docs/                  # Documentação
├── PLAN.md               # Este documento
└── README.md             # Doc principal

~/bin/ai-* -> repositório  # Symlinks
~/templates/               # Cópias (customizáveis)
~/.ai-workspace/           # Tracking + config.json (com repo_path)
```
✅ Versionamento Git
✅ Fácil compartilhar (git clone)
✅ Updates automáticos (ai-update / git pull)
✅ Edições refletem imediatamente (symlinks)
✅ Código fonte sempre disponível
✅ Portável entre máquinas

## Melhorias Futuras (v2.0)
- ai-uninstall - Desinstalação limpa
- Sistema de logs persistentes
- ai-quick [ai] - Modo rápido (só uma AI)
- Weekly/monthly summaries
- Integração com Obsidian
- Notificações de sync
- GitHub Actions para CI/CD
- Auto-update check

