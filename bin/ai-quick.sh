#!/bin/bash
# ai-quick.sh - Respostas rápidas e inteligentes (FAQ)
# Version: 2.0.0

# Detectar se foi sourced ou executado
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  EXIT_CMD="exit"
else
  EXIT_CMD="return"
fi

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

case "$1" in
  sync|sincronizar)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❓ Como sincronizar contexto entre Claude, Gemini e Codex?"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⚠️  IMPORTANTE: Não existe sincronização automática!"
    echo ""
    echo "✅ WORKFLOW CORRETO:"
    echo ""
    echo "1️⃣  Claude analisa e documenta (primeira vez):"
    echo "    'Analise este projeto e preencha .ai-context/project-status.md"
    echo "     com arquitetura, tecnologias, estrutura e decisões principais'"
    echo ""
    echo "2️⃣  Gemini lê antes de trabalhar:"
    echo "    'Leia .ai-context/project-status.md e current-task.md'"
    echo ""
    echo "3️⃣  Codex lê antes de implementar:"
    echo "    '/init' → 'Leia .ai-context/project-status.md'"
    echo ""
    echo "📁 ARQUIVOS COMPARTILHADOS:"
    echo "   • project-status.md    → Visão geral do projeto"
    echo "   • current-task.md      → Tarefa atual e contexto"
    echo "   • decisions.md         → Decisões técnicas"
    echo "   • known-issues.md      → Problemas conhecidos"
    echo "   • roadmap.md           → Próximos passos"
    echo ""
    echo "💡 DICA: Cada AI lê manualmente. Não é automático!"
    ;;
    
  gemini-agents|gemini)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❓ Como fazer Gemini analisar tarefa e ativar agentes?"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # DETECÇÃO INTELIGENTE
    if [[ ! -f ".ai-context/agents-reference.md" ]]; then
      echo "⚠️  PASSO NECESSÁRIO PRIMEIRO:"
      echo "   Você precisa do arquivo agents-reference.md"
      echo ""
      echo "   Opção A - Copiar manualmente:"
      echo "   cp $TEMPLATES_DIR/agents-reference.md .ai-context/"
      echo ""
      echo "   Opção B - Recriar estrutura:"
      echo "   ai-context-init --force"
      echo ""
      $EXIT_CMD 1
    fi
    
    echo "✅ WORKFLOW COMPLETO:"
    echo ""
    echo "1️⃣  Documentar tarefa atual:"
    echo "    echo '## Tarefa Atual' > .ai-context/current-task.md"
    echo "    echo 'Implementar autenticação JWT...' >> .ai-context/current-task.md"
    echo ""
    echo "2️⃣  No Gemini CLI, copie este prompt:"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Leia .ai-context/agents-reference.md e .ai-context/current-task.md, analise quais agentes são necessários e execute: ai-agents-activate <lista-de-agentes>"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "3️⃣  Gemini vai:"
    echo "    • Ler os 45 agentes disponíveis"
    echo "    • Analisar sua tarefa"
    echo "    • Escolher 3-5 agentes relevantes"
    echo "    • Executar: ai-agents-activate backend-architect security-coder ..."
    echo ""
    echo "4️⃣  Claude detecta automaticamente (sem restart!)"
    echo ""
    echo "💰 ECONOMIA: Gemini é 15x mais barato que Claude!"
    ;;
    
  shared|compartilhado|documentos|docs)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❓ Quais documentos são compartilhados entre AIs?"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📁 COMPARTILHADOS (Claude, Gemini, Codex):"
    echo "   Localização: .ai-context/"
    echo ""
    echo "   ✓ project-status.md       → Visão geral, arquitetura, tecnologias"
    echo "   ✓ current-task.md         → Tarefa atual com contexto detalhado"
    echo "   ✓ decisions.md            → Decisões técnicas e justificativas"
    echo "   ✓ known-issues.md         → Bugs, limitações, workarounds"
    echo "   ✓ roadmap.md              → Próximas features e prioridades"
    echo "   ✓ agents-reference.md     → Lista de 45 agentes disponíveis"
    echo ""
    echo "🤖 EXCLUSIVOS DO CLAUDE:"
    echo "   Localização: .claude/"
    echo ""
    echo "   • agents/*.md             → Agentes ativos no projeto atual"
    echo "   • ~/.claude/CLAUDE.md     → Configuração global"
    echo ""
    echo "⚙️  CONFIGURAÇÃO:"
    echo "   • .ai-config              → Perfil de agentes, layout, flags"
    ;;
    
  check|diagnostico|status)
    # Chama o novo ai-context-check
    if command -v ai-context-check &> /dev/null; then
      ai-context-check
    else
      echo "⚠️  ai-context-check não instalado"
      echo "   Execute: cd $REPO_DIR && ./install.sh"
    fi
    ;;
    
  *)
    echo "ai-quick - Respostas Rápidas e Inteligentes"
    echo ""
    echo "PERGUNTAS FREQUENTES:"
    echo ""
    echo "  ai-quick sync          → Como sincronizar contexto entre Claude, Gemini e Codex?"
    echo "  ai-quick gemini        → Workflow Gemini para analisar tarefa e ativar agentes"
    echo "  ai-quick shared        → Quais arquivos são compartilhados entre os AIs?"
    echo "  ai-quick check         → Diagnóstico inteligente do estado atual do projeto"
    echo ""
    echo "💡 Use ai-quick <comando> para respostas instantâneas!"
    ;;
esac

