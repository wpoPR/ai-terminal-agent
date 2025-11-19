#!/bin/bash
# ai-context-check.sh - Diagnóstico inteligente do projeto
# Version: 1.0.0

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }

# Detectar path de instalação dinamicamente
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$REPO_DIR/templates/context"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "AI Context - Diagnóstico Inteligente"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# CENÁRIO 1: Primeira vez - nada existe
if [[ ! -d ".ai-context" ]]; then
  echo "📋 CENÁRIO: Primeira vez neste projeto"
  echo ""
  echo "✅ AÇÕES NECESSÁRIAS:"
  echo "   1. ai-context-init --with-prompts"
  echo "      → Cria estrutura .ai-context com templates e prompts iniciais"
  echo ""
  echo "   2. ai-start"
  echo "      → Abre workspace e configura agentes interativamente"
  echo ""
  echo "   3. No Claude, executar:"
  echo "      cat .ai-context/initial-prompts/claude-init.md"
  exit 0
fi

# CENÁRIO 2: Estrutura incompleta (falta agents-reference.md)
if [[ ! -f ".ai-context/agents-reference.md" ]]; then
  echo "⚠️  CENÁRIO: Estrutura .ai-context incompleta"
  echo ""
  echo "❌ FALTANDO:"
  echo "   • agents-reference.md (necessário para Gemini ativar agentes)"
  echo ""
  echo "✅ AÇÃO:"
  echo "   cp $TEMPLATES_DIR/agents-reference.md .ai-context/"
  echo ""
  echo "   Ou recriar tudo:"
  echo "   ai-context-init --force"
  exit 0
fi

# CENÁRIO 3: Tudo pronto, mas sem agentes ativos
if [[ ! -d ".claude/agents" ]] || [[ $(ls -A .claude/agents 2>/dev/null | wc -l) -eq 0 ]]; then
  echo "⚠️  CENÁRIO: Contexto pronto, mas sem agentes ativos"
  echo ""
  echo "✅ PRÓXIMAS AÇÕES:"
  echo ""
  echo "   Opção A - Deixar Claude decidir:"
  echo "     1. Preencher: .ai-context/current-task.md"
  echo "     2. No Claude: 'Ative agentes necessários para esta tarefa'"
  echo ""
  echo "   Opção B - Usar Gemini (mais barato):"
  echo "     1. Preencher: .ai-context/current-task.md"
  echo "     2. No Gemini:"
  echo "        'Leia .ai-context/agents-reference.md e current-task.md,"
  echo "         analise e execute: ai-agents-activate <agentes>'"
  echo ""
  echo "   Opção C - Ativar perfil:"
  echo "     ai-agents profile fullstack"
  exit 0
fi

# CENÁRIO 4: Tudo funcionando
echo "✅ CENÁRIO: Sistema totalmente configurado"
echo ""

# Contar agentes VÁLIDOS (arquivos não vazios)
count_valid_agents() {
  local count=0
  local min_size=50  # bytes
  
  shopt -s nullglob  # Evita erro se não houver arquivos .md
  for agent_file in .claude/agents/*.md; do
    [[ ! -f "$agent_file" ]] && continue
    
    # Verificar tamanho (compatível macOS e Linux)
    local size=$(stat -f%z "$agent_file" 2>/dev/null || stat -c%s "$agent_file" 2>/dev/null)
    if [[ $size -ge $min_size ]]; then
      ((count++))
    else
      print_warning "Agente vazio ou corrompido: $(basename "$agent_file")" >&2
    fi
  done
  shopt -u nullglob
  
  echo $count
}

NUM_AGENTS=$(count_valid_agents)

echo "📊 STATUS:"
echo "   • Estrutura .ai-context: ✓"
echo "   • Agentes ativos: $NUM_AGENTS"

# Verificar se arquivos de contexto estão vazios
if [[ -f ".ai-context/project-status.md" ]]; then
  LINES=$(wc -l < .ai-context/project-status.md 2>/dev/null | tr -d ' ')
  if [[ $LINES -lt 20 ]]; then
    echo ""
    print_warning ".ai-context/project-status.md parece vazio ou incompleto"
    echo "   → No Claude: 'Analise projeto e preencha .ai-context/project-status.md'"
  fi
fi

echo ""
echo "💡 COMANDOS ÚTEIS:"
echo "   ai-agents active     → Ver agentes ativos e uso de tokens"
echo "   ai-quick sync        → Como sincronizar contexto entre AIs"
echo "   ai-quick gemini      → Workflow Gemini para otimizar agentes"

