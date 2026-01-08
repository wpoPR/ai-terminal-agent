#compdef ai

# AI Terminal Agent - Zsh Completion
# Version: 2.0.0

_ai() {
  local -a commands
  local -a workspace_commands
  local -a agents_commands
  local -a context_commands
  local -a config_commands
  local -a help_topics

  commands=(
    'start:Start AI workspace'
    'stop:Stop AI workspace'
    'status:Show workspace status'
    'workspace:Workspace management'
    'agents:Agent management'
    'context:Context management'
    'config:Configuration'
    'help:Show help'
  )

  workspace_commands=(
    'start:Start AI workspace'
    'stop:Stop workspace with summary'
    'status:Show active workspaces'
    'recent:List recent workspaces'
    'recover:Recover from crashes'
    'console:Show control console'
  )

  agents_commands=(
    'list:List all available agents'
    'active:Show active agents'
    'enable:Enable an agent'
    'disable:Disable an agent'
    'profile:Manage profiles'
    'stats:Show token statistics'
    'suggest:Suggest profile for project'
    'doctor:Run diagnostics'
    'search:Search agents'
    'info:Show agent details'
    'update:Update agent library'
    'reset:Reset to minimal profile'
  )

  context_commands=(
    'init:Initialize .ai-context/'
    'check:Diagnose context state'
    'sync:Sync AI configurations'
    'diff:Compare context files'
  )

  config_commands=(
    'doctor:Run health check'
    'git:Manage git ignore'
    'export:Export configuration'
    'import:Import configuration'
    'update:Update from git'
  )

  help_topics=(
    'start:Help for ai start'
    'workspace:Workspace help'
    'agents:Agent management help'
    'context:Context help'
    'workflow:Recommended workflow'
    'division:Work division between AIs'
    'tips:Quick tips'
    'quick:FAQ'
  )

  _arguments -C \
    '1: :->command' \
    '2: :->subcommand' \
    '3: :->args' \
    '*::arg:->args'

  case "$state" in
    command)
      _describe -t commands 'ai commands' commands
      ;;

    subcommand)
      case "$words[2]" in
        workspace|ws)
          _describe -t workspace_commands 'workspace commands' workspace_commands
          ;;
        agents|agent|a)
          _describe -t agents_commands 'agents commands' agents_commands
          ;;
        context|ctx|c)
          _describe -t context_commands 'context commands' context_commands
          ;;
        config|cfg)
          _describe -t config_commands 'config commands' config_commands
          ;;
        help)
          _describe -t help_topics 'help topics' help_topics
          ;;
        start)
          _files -/
          ;;
      esac
      ;;

    args)
      case "$words[2]" in
        agents|agent|a)
          case "$words[3]" in
            enable|disable|info)
              # Complete with agent names from library
              local agents_dir="$HOME/.ai-workspace/agents"
              if [[ -d "$agents_dir" ]]; then
                local -a agents
                agents=(${(f)"$(ls "$agents_dir"/*.md 2>/dev/null | xargs -I {} basename {} .md)"})
                _describe -t agents 'agents' agents
              fi
              ;;
            profile)
              local -a profiles
              profiles=(
                'list:List available profiles'
                'minimal:Minimal profile (2 agents)'
                'frontend:Frontend profile (4 agents)'
                'backend:Backend profile (4 agents)'
                'fullstack:Fullstack profile (4 agents)'
                'mobile:Mobile profile (3 agents)'
                'devops:DevOps profile (5 agents)'
                'data:Data profile (4 agents)'
                'ai-ml:AI/ML profile (4 agents)'
                'security:Security profile (4 agents)'
                'docs:Documentation profile (4 agents)'
                'research:Research profile (3 agents)'
              )
              _describe -t profiles 'profiles' profiles
              ;;
          esac
          ;;
        context|ctx|c)
          case "$words[3]" in
            init)
              local -a init_opts
              init_opts=(
                '--with-prompts:Include AI prompts'
                '--force:Overwrite existing files'
                '--minimal:Create minimal structure'
              )
              _describe -t init_opts 'init options' init_opts
              ;;
          esac
          ;;
        config|cfg)
          case "$words[3]" in
            git)
              local -a git_opts
              git_opts=(
                '--setup:Configure git ignore'
                '--show:Show gitignore contents'
                '--check:Check configuration'
              )
              _describe -t git_opts 'git options' git_opts
              ;;
            import)
              _files -g '*.tar.gz'
              ;;
          esac
          ;;
        workspace|ws)
          case "$words[3]" in
            start)
              _files -/
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

# Register completion
compdef _ai ai
