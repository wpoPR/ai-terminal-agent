#!/bin/bash
# ai-context-init.sh - Initialize .ai-context/ structure with templates
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

# Get repository directory (resolve symlinks)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$REPO_DIR/templates/context"
CONTEXT_DIR=".ai-context"

show_help() {
  cat << 'EOF'
ai-context-init - Initialize AI Context Structure

USAGE:
  ai-context-init [options]

OPTIONS:
  --force           Overwrite existing files
  --minimal         Create minimal structure only
  --with-prompts    Generate initial prompts for AIs
  -h, --help        Show this help

DESCRIPTION:
  Creates the recommended .ai-context/ structure with template files
  for sharing information between AIs (Claude, Gemini, Codex).

STRUCTURE CREATED:
  .ai-context/
  ├── project-status.md     # Project overview and current state
  ├── current-task.md       # Active task tracking
  ├── decisions.md          # Technical decisions log
  ├── known-issues.md       # Bugs and limitations
  └── roadmap.md            # Future plans and milestones

EXAMPLES:
  ai-context-init                  # Initialize with templates
  ai-context-init --force          # Overwrite existing files
  ai-context-init --with-prompts   # Create initial prompts for AIs

EOF
}

# Parse arguments
FORCE=false
MINIMAL=false
WITH_PROMPTS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE=true
      shift
      ;;
    --minimal)
      MINIMAL=true
      shift
      ;;
    --with-prompts)
      WITH_PROMPTS=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check if templates exist
if [[ ! -d "$TEMPLATES_DIR" ]]; then
  print_error "Templates directory not found: $TEMPLATES_DIR"
  print_info "Please ensure ai-terminal-agent is properly installed"
  exit 1
fi

# Create .ai-context directory
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  Initializing AI Context Structure${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [[ -d "$CONTEXT_DIR" ]] && [[ "$FORCE" == "false" ]]; then
  print_warning "$CONTEXT_DIR already exists"
  read -p "Overwrite existing files? (y/n): " -r -n 1
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Cancelled"
    exit 0
  fi
fi

mkdir -p "$CONTEXT_DIR"
print_success "Created $CONTEXT_DIR/"

# Copy template files
FILES=(
  "project-status.md"
  "current-task.md"
  "decisions.md"
  "known-issues.md"
  "roadmap.md"
  "agents-reference.md"
)

if [[ "$MINIMAL" == "true" ]]; then
  FILES=("project-status.md" "current-task.md")
fi

echo ""
echo "Copying template files..."
echo ""

for file in "${FILES[@]}"; do
  if [[ -f "$TEMPLATES_DIR/$file" ]]; then
    if [[ -f "$CONTEXT_DIR/$file" ]] && [[ "$FORCE" == "false" ]]; then
      print_warning "$file already exists, skipping"
    else
      cp "$TEMPLATES_DIR/$file" "$CONTEXT_DIR/"
      print_success "$file"
    fi
  else
    print_error "Template not found: $file"
  fi
done

# Create README
cat > "$CONTEXT_DIR/README.md" << 'READMEEOF'
# AI Context Directory

This directory contains shared context files for AI assistants (Claude, Gemini, Codex).

## 📁 Files

- **project-status.md** - Overview of project state, tech stack, and structure
- **current-task.md** - Active task tracking and implementation plan
- **decisions.md** - Technical decisions and architecture choices (ADR style)
- **known-issues.md** - Bugs, limitations, and technical debt
- **roadmap.md** - Future plans, milestones, and feature roadmap
- **agents-reference.md** - Quick reference of all 45 available agents (for Gemini analysis)

## 🤖 Usage by AIs

### Claude (Analysis & Architecture)
**Read before:**
- Analyzing code
- Planning features
- Making architectural decisions

**Update after:**
- Major refactoring
- Architectural changes
- Code reviews

### Gemini (Research & Agent Selection)
**Read before:**
- Researching libraries
- Writing documentation  
- Comparing approaches
- **ANALYZING TASKS FOR AGENT SELECTION** ← Most important!

**For Agent Selection:**
1. Read **agents-reference.md** to know all 45 available agents
2. Read **current-task.md** to understand the task
3. Analyze which domains are involved
4. Execute: `ai-agents-activate <agent1> <agent2> ...`

**Update after:**
- Research completed
- Documentation written
- Agents activated

### Codex (Implementation)
**Read before:**
- Starting implementation
- Writing code
- Creating components

**Update after:**
- Features completed
- Bugs fixed
- Code written

## 💡 Best Practices

1. **Always read project-status.md first** when starting work
2. **Update current-task.md** as you progress
3. **Document decisions** in decisions.md with rationale
4. **Log bugs** in known-issues.md as you discover them
5. **Update roadmap.md** when priorities change

## 🔄 Workflow

```
1. AI reads project-status.md and current-task.md
2. AI performs work
3. AI updates relevant files
4. Next AI reads updated context
5. Repeat
```

## 📝 Tips

- Keep files concise but informative
- Use markdown formatting for readability
- Update dates when making changes
- Link related files and decisions
- Be specific about what changed and why

## 🤖 Agent Selection (Gemini)

**Gemini's special role:** Analyzing tasks and activating optimal agents

1. **Read** `.ai-context/agents-reference.md` (knows all 45 agents)
2. **Read** `.ai-context/current-task.md` (understands task)
3. **Analyze** which domains involved (frontend, backend, etc)
4. **Execute** `ai-agents-activate <agent1> <agent2> ...`
5. **Report** which agents activated and why

**Why Gemini?** Saves 70-80% tokens vs Claude analyzing!

**Example prompt:**
```
Read .ai-context/agents-reference.md and .ai-context/current-task.md,
analyze the task domains, and execute: ai-agents-activate <agents>
```

---

*This directory is managed by AI Terminal Agent*
*For more info: ai-tips sharing*
READMEEOF

print_success "README.md"

# Generate initial prompts if requested
if [[ "$WITH_PROMPTS" == "true" ]]; then
  echo ""
  echo "Generating initial prompts for AIs..."
  echo ""
  
  # Create prompts directory
  mkdir -p "$CONTEXT_DIR/initial-prompts"
  
  # Claude prompt
  cat > "$CONTEXT_DIR/initial-prompts/claude-init.md" << 'CLAUDEEOF'
# Initial Prompt for Claude

Run this in the Claude console after `ai-start`:

```
Please analyze this project and initialize the AI context files:

1. Read the project structure and key files
2. Fill in .ai-context/project-status.md with:
   - Project overview and description
   - Current state and completion estimate
   - Technical stack
   - Key files and structure
   - Known issues (if any)

3. Create an initial entry in .ai-context/current-task.md:
   - What's the current state?
   - What should be worked on next?

4. Document any technical decisions in .ai-context/decisions.md

5. List any obvious issues in .ai-context/known-issues.md

6. Create an initial roadmap in .ai-context/roadmap.md

Be thorough but concise. This will serve as the foundation for all
AIs working on this project.
```
CLAUDEEOF

  # Gemini prompt
  cat > "$CONTEXT_DIR/initial-prompts/gemini-init.md" << 'GEMINIEOF'
# Initial Prompt for Gemini

Run this in the Gemini console after Claude has initialized:

```
Please read .ai-context/project-status.md to understand this project.

Then, help improve the documentation:

1. Review the project-status.md for any gaps
2. Research best practices for the tech stack mentioned
3. Add suggestions to .ai-context/roadmap.md for:
   - Testing strategy
   - Documentation needs
   - Performance considerations
   - Security considerations

4. If any architectural decisions are unclear, note questions
   in .ai-context/decisions.md

Keep your additions concise and actionable.
```
GEMINIEOF

  # Codex prompt
  cat > "$CONTEXT_DIR/initial-prompts/codex-init.md" << 'CODEXEOF'
# Initial Prompt for Codex

Run this in the Codex console after Claude has initialized:

```
Please read .ai-context/project-status.md and .ai-context/current-task.md
to understand this project.

Then:

1. Review the codebase structure
2. Note any code quality issues in .ai-context/known-issues.md
3. Identify any missing tests or documentation
4. Add technical debt items you notice to .ai-context/known-issues.md

Don't make changes yet - just document what you observe.
```
CODEXEOF

  print_success "initial-prompts/claude-init.md"
  print_success "initial-prompts/gemini-init.md"
  print_success "initial-prompts/codex-init.md"
fi

# Show summary
echo ""
echo -e "${BOLD}${GREEN}✓ Context structure initialized!${NC}"
echo ""
echo -e "${CYAN}Structure created:${NC}"
echo ""
tree -L 2 "$CONTEXT_DIR" 2>/dev/null || find "$CONTEXT_DIR" -type f | sed 's|[^/]*/| |g'

echo ""
echo -e "${CYAN}Next steps:${NC}"
echo ""

if [[ "$WITH_PROMPTS" == "true" ]]; then
  echo -e "1. Start your AI workspace: ${GREEN}ai-start${NC}"
  echo "2. In Claude console, run the prompt from:"
  echo -e "   ${BLUE}cat .ai-context/initial-prompts/claude-init.md${NC}"
  echo ""
  echo "3. In Gemini console, run the prompt from:"
  echo -e "   ${BLUE}cat .ai-context/initial-prompts/gemini-init.md${NC}"
  echo ""
  echo "4. In Codex console, run the prompt from:"
  echo -e "   ${BLUE}cat .ai-context/initial-prompts/codex-init.md${NC}"
else
  echo -e "1. Fill in ${BLUE}.ai-context/project-status.md${NC} with project details"
  echo -e "2. Update ${BLUE}.ai-context/current-task.md${NC} with current work"
  echo "3. Tell your AIs to read these files before starting work"
  echo ""
  echo -e "Or run: ${GREEN}ai-context-init --with-prompts${NC}"
  echo "to generate initialization prompts for each AI"
fi

echo ""
echo -e "${CYAN}Learn more:${NC}"
echo -e "  ${GREEN}ai-tips sharing${NC}     - How AIs share context"
echo -e "  ${GREEN}cat $CONTEXT_DIR/README.md${NC}"
echo ""

