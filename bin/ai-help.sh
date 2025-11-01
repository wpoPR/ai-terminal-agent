#!/bin/bash
# ai-help.sh - Display help for AI Terminal Agent
# Version: 2.0.0

COMMAND="${1:-}"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

show_main_help() {
  printf "%b\n" "$(cat << EOF
${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}
${BOLD}${BLUE}  AI Terminal Agent - Help${NC}
${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}

${BOLD}${CYAN}QUICK START:${NC}
  cd ~/your-project
  ai-start              ${CYAN}→${NC} Abre iTerm2 com 3 AIs em split
  ai-tips               ${CYAN}→${NC} Dicas de como usar cada AI
  ai-stop               ${CYAN}→${NC} Fecha com resumo do dia

${BOLD}${CYAN}WORKSPACE COMMANDS:${NC}
  ${GREEN}ai-start${NC} [path]      Inicia workspace (iTerm2 splits)
    --check             Health check apenas
    --dry-run           Simula o que vai acontecer
    --debug             Modo verbose

  ${GREEN}ai-stop${NC}              Fecha workspace com resumo Gemini
    --no-summary        Fecha sem gerar resumo

  ${GREEN}ai-status${NC}            Mostra workspaces ativos
  ${GREEN}ai-recent${NC}            Lista workspaces recentes
  ${GREEN}ai-recover${NC}           Recupera de crashes

${BOLD}${CYAN}QUICK REFERENCE:${NC}
  ${GREEN}ai-tips${NC}              Dicas rápidas e divisão de trabalho
  ${GREEN}ai-tips division${NC}     Quando usar Claude/Gemini/Codex
  ${GREEN}ai-tips examples${NC}     Exemplos práticos completos
  ${GREEN}ai-tips dicas${NC}        Melhores práticas
  ${GREEN}ai-tips quickstart${NC}   Analisar projeto existente

${BOLD}${CYAN}CONFIGURATION:${NC}
  ${GREEN}ai-git-config${NC}        Gerencia git global ignore
  ${GREEN}ai-health-check${NC}      Verifica instalação
  ${GREEN}ai-update${NC}            Atualiza do repositório
  ${GREEN}ai-export${NC} [file]     Exporta configuração
  ${GREEN}ai-import${NC} [file]     Importa configuração
  ${GREEN}ai-diff${NC}              Compara arquivos de contexto

${BOLD}${CYAN}COMO USAR OS 3 AIs:${NC}
  ${YELLOW}Claude:${NC}   Análise, planejamento, arquitetura, debug
  ${YELLOW}Gemini:${NC}   Pesquisa, comparações, documentação
  ${YELLOW}Codex:${NC}    Implementação rápida, testes, snippets

  ${CYAN}Contexto compartilhado:${NC} .ai-context/
  - Claude analisa e cria .ai-context/project-status.md
  - Outros AIs leem o contexto antes de trabalhar

${BOLD}${CYAN}DOCUMENTATION:${NC}
  ${GREEN}Quick Reference:${NC}
    cat ~/workspace/primavera/ai-terminal-agent/docs/quick-reference.md

  ${GREEN}Workflows Detalhados:${NC}
    cat ~/workspace/primavera/ai-terminal-agent/docs/workflows/analyzing-existing-project.md

  ${GREEN}Cenários Práticos:${NC}
    - Projeto com docs desatualizadas
    - Bugs pendentes (priorização)
    - Projeto sem documentação
    - Migração de tecnologia
    - Deploy/produção
    - Performance audit
    - Security audit

${BOLD}${CYAN}EXAMPLES:${NC}
  ${CYAN}# Novo projeto:${NC}
  cd ~/my-new-project
  ai-start

  ${CYAN}# Projeto existente - análise completa:${NC}
  cd ~/existing-project
  ai-start
  ${YELLOW}# No Claude:${NC} "Analise este projeto e crie .ai-context/project-status.md"
  ${YELLOW}# No Gemini:${NC} "Leia .ai-context/project-status.md"
  ${YELLOW}# No Codex:${NC}  "/init" → "Leia .ai-context/project-status.md"

  ${CYAN}# Adicionar feature:${NC}
  ai-tips examples      ${CYAN}→${NC} Ver workflow completo

  ${CYAN}# Fechar workspace:${NC}
  ai-stop               ${CYAN}→${NC} Gera resumo automático via Gemini

${BOLD}${CYAN}DETAILED HELP:${NC}
  ai-help start         Ajuda detalhada do ai-start
  ai-help stop          Ajuda detalhada do ai-stop
  ai-help context       Sobre .ai-context/ e contexto compartilhado
  ai-help workflow      Workflow recomendado
  ai-help division      Divisão de trabalho entre AIs

${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}
${CYAN}💡 Dica:${NC} Execute ${GREEN}ai-tips${NC} para ver dicas rápidas no terminal
EOF
)"
}

show_command_help() {
  case "$1" in
    start)
      cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ai-start - Iniciar Workspace AI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
  ai-start [OPTIONS] [PATH]

OPTIONS:
  --check       Health check apenas (não abre iTerm2)
  --dry-run     Mostra o que vai acontecer (sem executar)
  --debug       Modo verbose com mais logs
  --recent N    Abre workspace recente N

DESCRIPTION:
  Lança iTerm2 com layout automático:

  Tab 1 "AIs":
    ├─ Claude (esquerda, 60%)
    ├─ Gemini (direita superior)
    └─ Codex (direita inferior)

  Tab 2 "Control":
    └─ Console de comandos (ai-status, ai-stop, etc)

  Cria automaticamente:
  - .ai-context/ (se não existir)
  - .ai-workspace-active (tracking)
  - Backup de contextos

EXAMPLES:
  ai-start                    # Workspace no diretório atual
  ai-start ~/my-project       # Workspace em path específico
  ai-start --check            # Verifica setup sem abrir
  ai-start --dry-run          # Simula execução

NEXT STEPS:
  1. Claude analisa projeto: ai-tips quickstart
  2. Trabalhe normalmente com os 3 AIs
  3. Feche com: ai-stop

SEE ALSO:
  ai-help stop
  ai-help workflow
  ai-tips division
EOF
      ;;

    stop)
      cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ai-stop - Fechar Workspace
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE:
  ai-stop [OPTIONS]

OPTIONS:
  --no-summary     Fecha sem gerar resumo
  --summary-only   Gera resumo mas não fecha

DESCRIPTION:
  Fecha workspace ativo e gera resumo automático:

  1. Coleta contextos de .ai-context/
  2. Usa Gemini (free) para criar resumo agregado
  3. Salva em ~/.ai-workspace/summaries/daily/
  4. Remove tracking do workspace
  5. Cria backup final

  Resumo inclui:
  - O que foi feito hoje
  - Decisões técnicas importantes
  - Próximos passos
  - Bloqueios encontrados

EXAMPLES:
  ai-stop                     # Fecha com resumo
  ai-stop --no-summary        # Fecha rápido (sem resumo)

NOTES:
  - Resumo usa Gemini (free API, sem custo)
  - Backups mantidos por 3 dias
  - Summaries ficam em ~/.ai-workspace/summaries/

SEE ALSO:
  ai-help start
  ai-recent
EOF
      ;;

    context|contexto)
      cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
.ai-context/ - Contexto Compartilhado dos AIs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CONCEITO:
  .ai-context/ é a "memória compartilhada" dos 3 AIs.
  Ao invés de repetir análise 3x, você:

  1. Claude analisa e cria .ai-context/project-status.md
  2. Gemini/Codex leem esse contexto antes de trabalhar
  3. Todos compartilham o mesmo entendimento

ESTRUTURA RECOMENDADA:
  .ai-context/
  ├── project-status.md     # Status geral do projeto
  ├── current-task.md       # O que está sendo feito agora
  ├── decisions.md          # Decisões técnicas importantes
  ├── known-issues.md       # Bugs e limitações conhecidas
  └── roadmap.md            # Próximos passos planejados

WORKFLOW:
  # 1. Claude analisa (primeira vez):
  "Analise este projeto e crie .ai-context/project-status.md"

  # 2. Gemini usa contexto:
  "Leia .ai-context/project-status.md
   Pesquise melhores bibliotecas para [funcionalidade]"

  # 3. Codex implementa com contexto:
  "Leia .ai-context/project-status.md
   Implemente [feature] conforme arquitetura atual"

BEST PRACTICES:
  ✅ Mantenha arquivos curtos e objetivos
  ✅ Atualize quando houver mudanças importantes
  ✅ Use markdown para formatação
  ✅ Versione no Git se útil para o time

  ❌ Não deixe informação desatualizada
  ❌ Não crie arquivos gigantes de texto
  ❌ Não duplique informação do README

EXAMPLES:
  # Ver estrutura recomendada:
  ai-tips context

  # Prompt pronto para análise:
  ai-tips quickstart

SEE ALSO:
  ai-help workflow
  ai-tips examples
EOF
      ;;

    workflow)
      cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Workflow Recomendado
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PROJETO NOVO:
  1. ai-start
  2. Claude: Criar estrutura inicial
  3. Claude: Criar .ai-context/project-status.md
  4. Trabalhar normalmente
  5. ai-stop

PROJETO EXISTENTE (Primeira Vez):
  1. ai-start
  2. Claude: ai-tips quickstart → copiar prompt
  3. Claude cria .ai-context/project-status.md
  4. Compartilhar com Gemini/Codex quando precisar
  5. ai-stop

ADICIONAR FEATURE:
  1. ai-start
  2. Claude: "Leia .ai-context/project-status.md
              Crie plano para feature X"
  3. Gemini: "Pesquise melhores práticas/libs"
  4. Codex: "Implemente conforme plano"
  5. Claude: "Revise código criado"
  6. ai-stop

FIX BUG:
  1. ai-start
  2. Claude: "Analise bug: [descrição]
              Identifique causa raiz"
  3. Claude: "Implemente correção"
  4. Codex: "Crie testes para prevenir regressão"
  5. ai-stop

DIVISÃO DE TRABALHO:
  Claude  → Análise, arquitetura, planejamento, debug
  Gemini  → Pesquisa, comparações, documentação
  Codex   → Implementação, testes, código repetitivo

  💡 Use: ai-tips division

CONTEXTO COMPARTILHADO:
  - Claude analisa primeiro
  - Cria .ai-context/project-status.md
  - Outros AIs leem antes de trabalhar
  - Evita repetição de análise

  💡 Use: ai-help context

CENÁRIOS COMPLETOS:
  Ver documentação detalhada:
  cat ~/workspace/primavera/ai-terminal-agent/docs/workflows/analyzing-existing-project.md

  Ou use: ai-tips examples

SEE ALSO:
  ai-tips quickstart    # Prompt para análise
  ai-tips examples      # Exemplos práticos
  ai-help context       # Sobre .ai-context/
EOF
      ;;

    division|divisao)
      cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Divisão de Trabalho: Claude vs Gemini vs Codex
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLAUDE (Análise & Arquitetura):
  ✅ Análise de código existente
  ✅ Revisão de documentação
  ✅ Planejamento de features
  ✅ Refatoração complexa
  ✅ Debug de problemas difíceis
  ✅ Code review
  ✅ Decisões arquiteturais

  ❌ Pesquisa web
  ❌ Código repetitivo simples

GEMINI (Pesquisa & Documentação):
  ✅ Pesquisar bibliotecas/ferramentas
  ✅ Comparar tecnologias (A vs B vs C)
  ✅ Escrever documentação
  ✅ Gerar exemplos de uso
  ✅ Explorar APIs externas
  ✅ Melhores práticas

  ❌ Implementar código
  ❌ Debug complexo

CODEX (Implementação Rápida):
  ✅ Escrever código repetitivo
  ✅ Gerar testes unitários
  ✅ Criar componentes simples
  ✅ Completar código parcial
  ✅ Snippets e helpers
  ✅ Boilerplate

  ❌ Decisões arquiteturais
  ❌ Pesquisa de soluções

EXEMPLO PRÁTICO:
  Adicionar autenticação JWT:

  1. Claude → Planejar arquitetura
  2. Gemini → Pesquisar libs JWT
  3. Codex → Implementar middleware
  4. Claude → Revisar segurança

REGRAS DE OURO:
  ✅ Use apenas 1 AI para análise inicial
  ✅ Compartilhe contexto via .ai-context/
  ✅ Use cada AI para sua especialidade

  ❌ Não faça mesma pergunta pros 3
  ❌ Não misture especialidades

QUICK ACCESS:
  ai-tips division     # Ver no terminal
  ai-tips examples     # Exemplos completos

SEE ALSO:
  ai-help workflow
  ai-help context
EOF
      ;;

    tips)
      echo "Executando ai-tips..."
      echo ""
      if command -v ai-tips &> /dev/null; then
        ai-tips
      else
        echo "ai-tips não encontrado. Execute: ai-update"
      fi
      ;;

    *)
      echo -e "${YELLOW}⚠${NC}  Ajuda não disponível para: $1"
      echo ""
      echo "Comandos disponíveis:"
      echo "  ai-help start"
      echo "  ai-help stop"
      echo "  ai-help context"
      echo "  ai-help workflow"
      echo "  ai-help division"
      echo ""
      echo "Ou execute: ai-help (sem argumentos)"
      ;;
  esac
}

if [[ -z "$COMMAND" ]]; then
  show_main_help
else
  show_command_help "$COMMAND"
fi
