#!/bin/bash
# ai-tips.sh - Quick reference for AI Terminal Agent
# Version: 1.0.0
#
# Usage: ai-tips [section]
#   ai-tips           - Show all tips
#   ai-tips division  - Show AI division of work
#   ai-tips examples  - Show practical examples
#   ai-tips dicas     - Show tips only

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SECTION="${1:-all}"

show_header() {
  echo ""
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}  AI Terminal Agent - Quick Tips${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

show_division() {
  echo -e "${BOLD}${CYAN}🤖 Divisão de Trabalho Sugerida${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${GREEN}Claude${NC} ${BOLD}(Análise & Arquitetura)${NC}"
  echo "  ✅ Análise de código existente"
  echo "  ✅ Revisão de documentação"
  echo "  ✅ Planejamento de features"
  echo "  ✅ Refatoração complexa"
  echo "  ✅ Debug de problemas difíceis"
  echo ""

  echo -e "${GREEN}Gemini${NC} ${BOLD}(Pesquisa & Documentação)${NC}"
  echo "  ✅ Pesquisar bibliotecas/ferramentas"
  echo "  ✅ Comparar abordagens técnicas"
  echo "  ✅ Escrever documentação"
  echo "  ✅ Gerar exemplos de uso"
  echo "  ✅ Explorar APIs externas"
  echo ""

  echo -e "${GREEN}Codex${NC} ${BOLD}(Implementação Rápida)${NC}"
  echo "  ✅ Escrever código repetitivo"
  echo "  ✅ Gerar testes unitários"
  echo "  ✅ Criar componentes simples"
  echo "  ✅ Completar código parcial"
  echo "  ✅ Snippets e helpers"
  echo ""
}

show_examples() {
  echo -e "${BOLD}${CYAN}💡 Exemplo Prático: Adicionar Autenticação${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${YELLOW}1. Claude:${NC} Analise o projeto e crie plano de implementação"
  echo "   ${CYAN}→${NC} \"Com base no .ai-context/project-status.md, crie um plano\""
  echo "   ${CYAN}→${NC} \"detalhado para adicionar autenticação JWT ao projeto.\""
  echo "   ${CYAN}→${NC} \"Salve em .ai-context/auth-implementation-plan.md\""
  echo ""

  echo -e "${YELLOW}2. Gemini:${NC} Pesquise melhores práticas"
  echo "   ${CYAN}→${NC} \"Leia .ai-context/auth-implementation-plan.md\""
  echo "   ${CYAN}→${NC} \"Pesquise as melhores bibliotecas JWT para Node.js e\""
  echo "   ${CYAN}→${NC} \"compare passport.js vs jsonwebtoken\""
  echo ""

  echo -e "${YELLOW}3. Codex:${NC} Implemente o código"
  echo "   ${CYAN}→${NC} \"Leia .ai-context/auth-implementation-plan.md\""
  echo "   ${CYAN}→${NC} \"Implemente o middleware de autenticação conforme o plano\""
  echo ""

  echo -e "${YELLOW}4. Claude:${NC} Revise o resultado"
  echo "   ${CYAN}→${NC} \"Revise o código de autenticação criado pelo Codex.\""
  echo "   ${CYAN}→${NC} \"Verifique segurança e boas práticas.\""
  echo ""
}

show_tips() {
  echo -e "${BOLD}${CYAN}✨ Dicas Importantes${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${GREEN}✅ Faça:${NC}"
  echo "  • Mantenha .ai-context/ atualizado com decisões importantes"
  echo "  • Use cada AI para sua especialidade"
  echo "  • Peça resumos executivos curtos (não textos longos)"
  echo "  • Versione o .ai-context/ no Git se útil para a equipe"
  echo ""

  echo -e "${YELLOW}❌ Evite:${NC}"
  echo "  • Fazer a mesma pergunta para os 3 AIs (desperdício)"
  echo "  • Deixar contexto desatualizado"
  echo "  • Pedir código complexo ao Gemini (use Claude/Codex)"
  echo "  • Pedir pesquisa ao Codex (use Gemini)"
  echo ""
}

show_context_structure() {
  echo -e "${BOLD}${CYAN}📁 Estrutura de Contexto Recomendada${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo "  .ai-context/"
  echo "  ├── project-status.md     # Status geral do projeto"
  echo "  ├── current-task.md       # Tarefa atual"
  echo "  ├── decisions.md          # Decisões técnicas"
  echo "  ├── known-issues.md       # Bugs e limitações"
  echo "  └── roadmap.md            # Próximos passos"
  echo ""

  echo -e "${CYAN}💡 Dica:${NC} Este é o 'cérebro compartilhado' dos AIs!"
  echo ""
}

show_context_sharing() {
  echo -e "${BOLD}${CYAN}🔄 Compartilhamento de Contexto${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${BOLD}Arquivos que os AIs compartilham:${NC}"
  echo ""
  
  echo -e "${GREEN}1. Contexto Compartilhado (.ai-context/)${NC}"
  echo "   • Todos os AIs podem ler e escrever"
  echo "   • Use para compartilhar informações entre AIs"
  echo "   • Exemplos: project-status.md, decisions.md"
  echo ""

  echo -e "${GREEN}2. Agentes Ativos (.claude/agents/)${NC}"
  echo "   • Apenas Claude Code lê automaticamente"
  echo "   • Agentes especializados por projeto"
  echo "   • Gerenciado via: ai-agents"
  echo ""

  echo -e "${GREEN}3. Configuração Global${NC}"
  echo "   • ${CYAN}~/.claude/CLAUDE.md${NC} - Instruções globais para Claude"
  echo "   • ${CYAN}definitions.md${NC} - Referência completa de agentes"
  echo ""

  echo -e "${BOLD}Como funcionam os agentes:${NC}"
  echo ""
  echo "  Claude Code (você) lê:"
  echo "  ├── ${CYAN}~/.claude/CLAUDE.md${NC} (regras globais)"
  echo "  ├── ${CYAN}.claude/agents/*.md${NC} (agentes ativos do projeto)"
  echo "  └── ${CYAN}CLAUDE.md${NC} (contexto do projeto, se existir)"
  echo ""

  echo -e "${CYAN}💡 Comandos úteis:${NC}"
  echo "  ${GREEN}ai-agents active${NC}    - Ver quais agentes estão ativos"
  echo "  ${GREEN}ai-agents explain${NC}   - Explicar sistema de agentes"
  echo "  ${GREEN}ai-status${NC}           - Ver agentes + tokens usados"
  echo ""
}

show_quick_start() {
  echo -e "${BOLD}${CYAN}🚀 Quick Start para Projeto Existente${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  echo -e "${YELLOW}No Claude (após ai-start):${NC}"
  echo ""
  echo "  Por favor, analise este projeto:"
  echo ""
  echo "  1. Liste todos os arquivos .md do projeto"
  echo "  2. Leia README.md, PLAN.md, TODO.md (se existirem)"
  echo "  3. Analise a estrutura de pastas"
  echo "  4. Identifique:"
  echo "     - Objetivo do projeto"
  echo "     - Estado atual (% completo)"
  echo "     - Tarefas pendentes"
  echo "     - Próximos passos"
  echo "     - Tecnologias usadas"
  echo ""
  echo "  Crie um resumo executivo em .ai-context/project-status.md"
  echo ""

  echo -e "${CYAN}Depois compartilhe com outros AIs:${NC}"
  echo "  • Gemini: \"Leia .ai-context/project-status.md\""
  echo "  • Codex: \"Leia .ai-context/project-status.md\""
  echo ""
}

show_footer() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${CYAN}📚 Documentação completa:${NC}"
  echo "  cat ~/workspace/primavera/ai-terminal-agent/docs/workflows/analyzing-existing-project.md"
  echo ""
  echo -e "${CYAN}🔗 Quick Reference:${NC}"
  echo "  cat ~/workspace/primavera/ai-terminal-agent/docs/quick-reference.md"
  echo ""
  echo -e "${CYAN}💡 Comandos úteis:${NC}"
  echo "  ai-tips division   - Mostrar divisão de trabalho"
  echo "  ai-tips examples   - Mostrar exemplos práticos"
  echo "  ai-tips dicas      - Mostrar dicas"
  echo "  ai-tips sharing    - Como AIs compartilham contexto"
  echo "  ai-tips quickstart - Quick start para projeto existente"
  echo ""
  echo -e "${CYAN}🤖 Sistema de Agentes:${NC}"
  echo "  ai-agents active   - Ver agentes ativos"
  echo "  ai-agents explain  - Explicar sistema de agentes"
  echo "  ai-agents help     - Ajuda completa"
  echo ""
}

# Main
case "$SECTION" in
  all)
    show_header
    show_division
    show_examples
    show_tips
    show_context_structure
    show_footer
    ;;

  division|divisao)
    show_header
    show_division
    show_footer
    ;;

  examples|exemplos|example)
    show_header
    show_examples
    show_footer
    ;;

  tips|dicas)
    show_header
    show_tips
    show_footer
    ;;

  context|contexto)
    show_header
    show_context_structure
    show_footer
    ;;

  sharing|compartilhamento|share)
    show_header
    show_context_sharing
    show_footer
    ;;

  quickstart|start|inicio)
    show_header
    show_quick_start
    show_footer
    ;;

  help|ajuda|-h|--help)
    show_header
    echo -e "${BOLD}Uso:${NC}"
    echo "  ai-tips              - Mostra todos os tips"
    echo "  ai-tips division     - Divisão de trabalho entre AIs"
    echo "  ai-tips examples     - Exemplos práticos"
    echo "  ai-tips dicas        - Dicas importantes"
    echo "  ai-tips context      - Estrutura do .ai-context/"
    echo "  ai-tips sharing      - Como AIs compartilham contexto"
    echo "  ai-tips quickstart   - Quick start para projeto existente"
    echo ""
    ;;

  *)
    echo -e "${YELLOW}⚠${NC}  Seção desconhecida: $SECTION"
    echo ""
    echo "Seções disponíveis:"
    echo "  all, division, examples, dicas, context, sharing, quickstart"
    echo ""
    echo "Use: ai-tips help"
    exit 1
    ;;
esac
