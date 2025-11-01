# Quick Reference: AI Terminal Agent

## 🚀 Início Rápido

```bash
cd ~/seu-projeto
ai-start
```

iTerm2 abrirá com:
- **Tab 1 "AIs":** Claude (esq) | Gemini (dir-top) | Codex (dir-bottom)
- **Tab 2 "Control":** Console de comandos

---

## 📋 Comandos Essenciais

| Comando | Descrição |
|---------|-----------|
| `ai-start` | Inicia workspace no projeto atual |
| `ai-stop` | Fecha workspace e gera resumo |
| `ai-status` | Mostra workspaces ativos |
| `ai-tips` | Quick tips: divisão de trabalho, exemplos, dicas |
| `ai-help` | Ajuda completa |

---

## 🤖 Quando Usar Cada AI

### Claude 🧠 (Análise & Arquitetura)
```
✅ Análise de código complexo
✅ Planejamento de features
✅ Refatoração
✅ Debug difícil
✅ Code review

❌ Pesquisa web
❌ Código repetitivo simples
```

**Exemplo:**
```
Analise este projeto e crie .ai-context/project-status.md
com: objetivo, progresso, próximos passos
```

### Gemini 🔍 (Pesquisa & Docs)
```
✅ Pesquisar bibliotecas
✅ Comparar tecnologias
✅ Escrever documentação
✅ Gerar exemplos
✅ Consultar APIs

❌ Implementar código
❌ Debug complexo
```

**Exemplo:**
```
Pesquise as melhores bibliotecas JWT para Node.js
Compare jsonwebtoken vs jose vs paseto
```

### Codex 💻 (Implementação)
```
✅ Código repetitivo
✅ Testes unitários
✅ Componentes simples
✅ Snippets
✅ Completar código

❌ Decisões arquiteturais
❌ Análise profunda
```

**Exemplo:**
```
/init

[após iniciar]
Crie testes unitários para src/auth/jwt.js
```

---

## 📁 Sistema de Contexto Compartilhado

### Estrutura Recomendada

```
seu-projeto/
├── .ai-context/              # "Memória" compartilhada dos AIs
│   ├── project-status.md     # Status geral do projeto
│   ├── current-task.md       # Tarefa atual
│   ├── decisions.md          # Decisões técnicas
│   ├── known-issues.md       # Bugs e limitações
│   └── roadmap.md            # Próximos passos
├── docs/                     # Documentação pública
└── [seu código]
```

### Como Compartilhar Conhecimento

**1. Claude analisa e cria contexto:**
```
Analise o projeto e crie .ai-context/project-status.md
```

**2. Outros AIs leem o contexto:**
```
# No Gemini ou Codex:
Leia .ai-context/project-status.md

[sua tarefa específica]
```

**3. Mantenha atualizado:**
```
# No Claude (após mudanças):
Atualize .ai-context/project-status.md com o que fizemos hoje
```

---

## 🎯 Workflows Comuns

### 1️⃣ Novo Projeto
```
1. ai-start
2. Claude: "Crie estrutura inicial do projeto [tipo]"
3. Claude: "Crie .ai-context/project-status.md"
4. Gemini: "Pesquise melhores práticas para [stack]"
5. Codex: "Implemente boilerplate básico"
```

### 2️⃣ Projeto Existente (Primeira Vez)
```
1. ai-start
2. Claude: "Analise este projeto e crie .ai-context/project-status.md"
3. Claude: "Liste próximos passos em .ai-context/roadmap.md"
4. [Trabalhe normalmente]
5. ai-stop (gera resumo)
```

### 3️⃣ Adicionar Feature
```
1. ai-start
2. Claude: "Leia .ai-context/project-status.md
           Crie plano para feature X em .ai-context/feature-x-plan.md"
3. Gemini: "Pesquise melhores libs para [aspecto da feature]"
4. Codex: "Implemente feature X conforme plano"
5. Claude: "Revise código e atualize documentação"
6. ai-stop
```

### 4️⃣ Fix Bug
```
1. ai-start
2. Claude: "Analise o bug: [descrição]
           Reproduza o problema
           Identifique a causa"
3. Claude: "Implemente fix"
4. Codex: "Crie teste para prevenir regressão"
5. ai-stop
```

### 5️⃣ Refatoração
```
1. ai-start
2. Claude: "Analise [módulo/arquivo]
           Identifique code smells
           Crie plano de refatoração"
3. Claude: "Execute refatoração step by step"
4. Claude: "Verifique testes ainda passam"
5. ai-stop
```

---

## 💡 Dicas Práticas

### ✅ Faça

1. **Use apenas 1 AI para análise inicial**
   - Evita duplicação de trabalho
   - Claude é melhor para análise profunda

2. **Mantenha .ai-context/ atualizado**
   - É a "memória" compartilhada
   - Atualizar após mudanças importantes

3. **Seja específico nos prompts**
   ```
   ✅ "Crie testes para src/auth/jwt.js"
   ❌ "Faça testes"
   ```

4. **Use Tab 2 (Control) para verificar status**
   ```bash
   ai-status      # Ver workspaces ativos
   ai-recent      # Ver histórico
   ```

5. **Feche com ai-stop**
   - Gera resumo automático do dia
   - Mantém histórico organizado

### ❌ Evite

1. **Não faça a mesma pergunta para os 3 AIs**
   - Desperdício de tempo/recursos

2. **Não deixe contexto desatualizado**
   - AIs vão trabalhar com info errada

3. **Não misture especialidades**
   - Use cada AI para o que faz melhor

4. **Não crie contextos gigantes**
   - AIs podem não ler tudo
   - Prefira arquivos focados e concisos

---

## 📖 Prompt Templates

### Análise Inicial de Projeto
```
Analise este projeto e me dê:

1. **Objetivo:** O que o projeto faz?
2. **Stack:** Tecnologias usadas
3. **Estrutura:** Organização de pastas/arquivos
4. **Status:** O que está pronto? O que falta?
5. **Próximos Passos:** Prioridade 1, 2, 3

Crie .ai-context/project-status.md com estas informações.
```

### Planejamento de Feature
```
Quero adicionar: [descreva a feature]

Com base em .ai-context/project-status.md:

1. Crie plano de implementação
2. Liste arquivos que serão criados/modificados
3. Identifique dependências necessárias
4. Estime complexidade (simples/médio/complexo)

Salve em .ai-context/feature-[nome]-plan.md
```

### Pesquisa de Solução
```
Preciso: [descreva o problema/necessidade]

Pesquise e compare:
- Opção A vs B vs C
- Prós e contras
- Recomendação com justificativa

Foco em: [critérios importantes: performance, tamanho, community, etc]
```

### Debug de Problema
```
Bug: [descreva o sintoma]

Passos para reproduzir:
1. [passo 1]
2. [passo 2]
3. [erro aparece]

Por favor:
1. Localize o código relacionado
2. Identifique a causa raiz
3. Proponha fix
4. Implemente se aprovado
```

---

## 🔗 Links Úteis

- **Docs Completas:** `~/workspace/primavera/ai-terminal-agent/docs/`
- **Workflows:** `docs/workflows/analyzing-existing-project.md`
- **Templates:** `~/templates/ai-contexts/`

---

## 🆘 Troubleshooting

### iTerm2 não abre splits automaticamente
```bash
# Teste manual:
osascript ~/workspace/primavera/ai-terminal-agent/bin/iterm-layout.applescript "$(pwd)"

# Se falhar, configure manualmente:
# Tab 1: ⌘+D (split vertical), depois ⌘+Shift+D (split horizontal)
```

### Comandos ai-* não encontrados
```bash
# Adicione ao PATH:
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Contexto não está sendo compartilhado
```bash
# Verifique se .ai-context/ existe:
ls -la .ai-context/

# Se não existir:
mkdir .ai-context
```

---

**Pro Tip:** Crie alias personalizados em `.zshrc`:
```bash
alias ai='ai-start'
alias ais='ai-status'
alias aix='ai-stop'
```
