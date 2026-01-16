# Changelog

All notable changes to AI Terminal Agent will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-01-15

### Added - Multi-AI Bootstrap System

#### New Context Structure
- **`.ai-context/ai-handoff.md`**: Consolidated AI communication hub with session state, checkpoints, and handoff instructions
- **`.ai-context/ai-workflows.md`**: Quick reference guide with 10 common development scenarios (new feature, bug fix, refactoring, etc.)
- **`.ai-context/code-landmarks.md`**: Human-readable documentation of important code locations
- **`.ai-context/todos/`**: File-based todo system with YAML frontmatter (Gemini creates, Claude updates)
- **`.ai-context/stack-config.md`**: Auto-detected stack configuration with commands and quality limits

#### New Commands
- **`ai migrate`**: Migrate existing projects to new Multi-AI structure
  - Creates backup before migration
  - Preserves `decisions.md` and `agents-reference.md`
  - Removes deprecated files and regenerates configs
  - Options: `--dry-run`, `--force`, `--no-backup`

- **`ai-stack-detect`**: Automated stack detection
  - Detects 12+ stacks (TypeScript, Python, Go, C#, Rust, Java, etc.)
  - Searches in subdirectories (`src/`, `app/`, `lib/`, etc.)
  - Interactive stack selection when auto-detection fails
  - Generates quality limits and commands for detected stack

- **`ai-stop`**: End session with summary generation and state cleanup

#### Enhanced AI Templates
- **Claude (`claude.md`)**: TDD workflow, file responsibilities, recognized keywords (`!checkpoint`, `!handoff`, `!todo update`)
- **Gemini (`GEMINI.md`)**: Analysis role, code indexing, agent selection, keywords (`!analyze codebase`, `!analyze task`, `!select agents`)
- **Codex (`CODEX.md`)**: Support role, documentation, solution docs, keywords (`!document solution`, `!add tests`, `!update readme`)

#### Stack Detection Improvements
- Added 12 stack rules: TypeScript, JavaScript, Python, Go, Rust, Java, C#/.NET, Ruby, PHP, Flutter, Next.js, React, Capacitor
- Searches common subdirectories for project files
- Interactive menu when stack not detected
- Configurable via `~/.ai-workspace/config/stack-rules.json`

### Changed
- **`ai-workspace.sh`**: Integrated stack detection, uses `ai-context init` for full structure
- **`generate-project.sh`**: Now uses templates for all AIs (previously Claude used heredoc)
- **`lib/common.sh`**: Fixed path resolution for installed vs repo locations
- **README.md**: Added migration documentation section

### Deprecated
- **Old context files**: `current-task.md`, `known-issues.md`, `project-status.md`, `roadmap.md` (moved to `templates/context/deprecated/`)
- **`AGENTS.md`**: Renamed to `CODEX.md`
- **`CLAUDE.md`**: Now at `.claude/claude.md`

### Fixed
- Stack detection now finds files in subdirectories (e.g., `src/*.csproj`)
- `ai-context init` creates full structure instead of minimal fallback
- `generate-project` command works from both repo and installed locations
- Preserved files during migration retain original content
- **Gemini context overflow**: Added `.geminiignore` template to prevent Gemini CLI from reading entire codebase (400+ files = 600k+ tokens)

### Migration Guide (v2.0.0 → v2.1.0)

For existing projects:
```bash
cd ~/your-project
ai stop          # Optional: save current work
ai migrate       # Interactive migration with backup
```

For new projects:
```bash
cd ~/new-project
ai start         # Creates new structure automatically
```

---

## [2.0.0] - 2026-01-08

### Added
- **Unified CLI**: New `ai` command as single entry point with intuitive subcommands
  - `ai start`, `ai stop`, `ai status` as quick shortcuts
  - `ai workspace ...` for workspace management
  - `ai agents ...` for agent management (delegates to existing ai-agents.sh)
  - `ai context ...` for context management
  - `ai config ...` for configuration
  - `ai help [topic]` for contextual help
- **Shared Library** (`lib/common.sh`): Extracted common functions used across all scripts
  - Color/output helpers
  - JSON helpers with jq fallback
  - Configuration helpers
  - Token calculation
  - File and session helpers
- **Consolidated Scripts**:
  - `ai-workspace.sh`: Consolidates 6 workspace scripts (start, stop, status, recent, recover, console)
  - `ai-context.sh`: Consolidates 4 context scripts (init, check, sync, diff)
  - `ai-config.sh`: Consolidates 5 config scripts (doctor, git, export, import, update)
  - `generate-project.sh`: Unifies 3 generator scripts (claude, gemini, codex)
  - `ai-help-unified.sh`: Unified help system with topics

### Changed
- **Documentation**: README.md rewritten in English with new command structure
- **install.sh**: Updated to create symlinks for new unified CLI while maintaining backward compatibility

### Backward Compatibility
- All legacy commands (`ai-start`, `ai-stop`, `ai-agents`, etc.) still work
- No breaking changes for existing users
- Legacy scripts remain functional via symlinks

### Migration Guide
Old commands map to new commands:
- `ai-start` → `ai start` or `ai workspace start`
- `ai-stop` → `ai stop` or `ai workspace stop`
- `ai-status` → `ai status` or `ai workspace status`
- `ai-context-init` → `ai context init`
- `ai-health-check` → `ai config doctor`
- `ai-update` → `ai config update`
- `ai-git-config` → `ai config git`

## [1.3.1] - 2024-11-19

### Fixed
- **ai-start**: Now automatically generates configuration files for all AIs
  - **Claude**: Calls `generate-project-claude` to create `.claude/claude.md` with Sequential Thinking and agent references
  - **Gemini**: Calls `generate-project-gemini` to create `Gemini.md` with task analysis workflow and shared context rules
  - **Codex**: Calls `generate-project-codex` to create `Codex.md` with coordination rules and shared context access
  - Bug: Previously only loaded agents but didn't generate AI configuration files
  - Impact: AIs weren't reading project-specific rules, agent context, and shared file structure
  - Solution: Added automatic generation for all three AIs after loading agents
  - Users no longer need workarounds - everything works out of the box

### Added
- **Templates**: Created `gemini-project.md` and `codex-project.md` templates
- **Scripts**: Added `generate-project-gemini.sh` and `generate-project-codex.sh`
- **Shared Context Documentation**: All AIs now understand `.ai-context/` structure and file sharing rules
- **No-Agent Rule**: Clarified that Gemini and Codex don't use agents (only Claude does)

## [1.3.0] - 2024-11-13

### Added
- **Workspace Manager Agent**: New meta-agent that knows the entire ai-terminal-agent system
  - Expert in agent management and optimization
  - Reference for all 45 agents and their capabilities
  - Task-to-agent mapping guide
  - Multi-AI coordination strategies
  - Performance optimization guidelines
- **ai-agents-activate**: New command for mechanical agent activation
  - Simple file copier (no analysis logic)
  - Designed to be called by Gemini after intelligent analysis
  - Accepts space-separated agent list
  - Supports --profile and --list options
  - Auto-updates .ai-config

### Architecture
- **Intelligent Analysis Layer**: Gemini reads workspace-manager.md and analyzes tasks
- **Mechanical Execution Layer**: ai-agents-activate just copies files
- **Separation of Concerns**: AI does thinking, script does copying
- **Cost Optimization**: 70-80% token savings vs Claude analyzing

### Features
- Gemini can intelligently select agents based on task analysis
- Claude receives pre-selected agents (no restart needed!)
- Workspace-manager.md serves as knowledge base for all AIs
- Intelligent task-to-profile mapping
- Automatic performance monitoring guidelines
- Context-aware agent selection strategies

## [1.2.1] - 2024-11-13

### Fixed
- **Agent Setup Menu**: Menu now displays properly during `ai-start` interactive setup
- **ai-context-init**: Fixed symlink resolution to find templates directory correctly
- **ai-context-init**: Fixed color codes in output messages
- Improved descriptions for each profile option
- Better UX for profile selection with clear descriptions
- Fixed profile combination option to work correctly

### Improved
- More descriptive profile names in interactive menu
- Added "Opções especiais" section for better visibility
- Clearer instructions for combining profiles

## [1.2.0] - 2024-11-13

### Added
- **AI Context Structure Initialization**: New `ai-context-init` command
- **Context Templates**: 5 pre-defined templates for shared AI context
  - `project-status.md` - Project overview and current state
  - `current-task.md` - Active task tracking with implementation plan
  - `decisions.md` - Technical decisions log (ADR style)
  - `known-issues.md` - Bugs, limitations, and technical debt
  - `roadmap.md` - Future plans and milestones
- **Initial Prompts**: Auto-generated initialization prompts for Claude, Gemini, and Codex
- **Context README**: Comprehensive guide for using .ai-context/ structure

### Commands
- `ai-context-init` - Initialize .ai-context/ structure with templates
- `ai-context-init --with-prompts` - Include AI initialization prompts
- `ai-context-init --minimal` - Create minimal structure only
- `ai-context-init --force` - Overwrite existing files

### Documentation
- New section in README about AI Context Structure
- Step-by-step guide for initializing and using context files
- Best practices for context sharing between AIs

### Benefits
- **Organized Context**: Standardized structure for all projects
- **Less Repetition**: AIs read shared context instead of re-explaining
- **Better Continuity**: AIs build on each other's work
- **Documentation**: Automatic documentation of decisions and progress

## [1.1.1] - 2024-11-13

### Added
- **Context Sharing Documentation**: New `ai-tips sharing` command explains how AIs share context
- **Agent System Explainer**: New `ai-agents explain` command provides comprehensive guide to agent management
- Enhanced agent management documentation in all tips and help sections

### Improved
- `ai-tips` now includes "sharing" section explaining context files between AIs
- Better visibility of which files Claude, Gemini, and Codex can read
- More detailed explanation of CLAUDE.md files (global vs project-specific)
- Clearer documentation of `.ai-context/`, `.claude/agents/`, and `definitions.md` roles

### Documentation
- Added context sharing guide to `ai-tips`
- Enhanced help sections with agent system references
- Updated README with new commands

## [1.1.0] - 2024-11-13

### Added
- **Dynamic Agent Management System**: Complete overhaul of Claude agent loading
- **Agent Profiles**: 11 pre-defined profiles (frontend, backend, fullstack, mobile, devops, data, ai-ml, security, docs, research, minimal)
- **Token Optimization**: Reduced token usage from ~34k to ~8-12k (60-70% reduction)
- **Global Agent Library**: 45 specialized agents available system-wide
- **Project-Based Agent Activation**: Only load agents relevant to current project
- **New CLAUDE.md Structure**: 
  - Global `~/.claude/CLAUDE.md` with dynamic agent system instructions
  - Project-specific `CLAUDE.md` template with active agent list
  - `definitions.md` as comprehensive agent reference

### Commands
- `ai-agents list` - List all available agents
- `ai-agents active` - Show active agents in current project
- `ai-agents enable <name>` - Enable specific agent
- `ai-agents disable <name>` - Disable specific agent
- `ai-agents profile list` - List available profiles
- `ai-agents profile <name>` - Activate agent profile
- `ai-agents profile <p1>+<p2>` - Combine multiple profiles
- `ai-agents stats` - Show detailed token statistics
- `ai-agents suggest` - Suggest profile based on project
- `ai-agents doctor` - Run diagnostics
- `ai-agents info <name>` - Show agent information
- `ai-agents update` - Update agent library
- `ai-agents reset` - Reset to minimal profile
- `ai-agents search <keyword>` - Search agents by keyword

### Scripts
- `bin/ai-agents.sh` - Main agent management script
- `bin/ai-agents-setup-interactive.sh` - Interactive profile selection
- `bin/generate-agent-index.sh` - Generate agent metadata
- `bin/generate-project-claude.sh` - Generate project-specific CLAUDE.md

### Improved
- `ai-start` now includes interactive agent profile selection
- `ai-status` displays active agents, profile, and token usage
- Enhanced installation process with automatic agent library setup

### Documentation
- New `docs/agent-management.md` with comprehensive guide
- New `docs/claude-configuration.md` explaining CLAUDE.md structure
- New `config/CLAUDE-migration-note.md` with migration information
- Updated README with agent management section

## [1.0.0] - 2024-11-01

### Added
- Initial release of AI Terminal Agent
- Multi-AI workspace support (Claude, Gemini, Codex)
- iTerm2 layout management with configurable splits
- Context file synchronization between AIs
- Template system for different project types (coding, writing, research, homelab)
- Git global ignore system for personal AI files
- Daily summary generation using Gemini (free!)
- Automatic backup system with 3-day retention
- Workspace crash recovery system
- Health check system with iTerm2 key binding verification
- Repository-based architecture for easy versioning and portability

### Commands
- `ai-start` - Launch AI workspace with automatic detection
- `ai-stop` - Close workspace with optional daily summary
- `ai-status` - Show active workspaces and their status
- `ai-recent` - List recently used workspaces
- `ai-recover` - Recover workspaces after crashes
- `ai-health-check` - Verify installation and configuration
- `ai-git-config` - Manage git global ignore settings
- `ai-diff` - Compare and merge context files
- `ai-export` - Export configuration and repository
- `ai-import` - Import and install configuration
- `ai-update` - Update system via git pull
- `ai-help` - Display comprehensive help

### Features
- One-command workspace launch
- Automatic context synchronization
- Customizable layouts per project via `.ai-config`
- Support for custom AI tools via configuration
- Multi-machine support via Git
- Symlink-based installation for immediate script updates
- Comprehensive documentation
- Fallback mechanisms for robustness

### Documentation
- Complete README with quick start guide
- Detailed installation guide
- Usage documentation for all commands
- Configuration reference
- Architecture documentation
- Troubleshooting guide
- Original implementation plan (PLAN.md)

### Configuration
- `.ai-config` for per-project customization
- Template system for quick project setup
- Git integration with opt-in commit option
- Configurable summary generation (Gemini/basic/disabled)
- Customizable backup retention

### Developer Experience
- All source code included in repository
- Editable scripts with immediate effect (symlinks)
- Git-based version control
- Easy portability between machines
- Comprehensive inline documentation

## [1.1.0] - 2025-01-13

### Added
- **Agent Management System**: Complete dynamic agent management
  - 45 agents in global library (`~/.ai-workspace/agents/`)
  - 11 pre-defined profiles (frontend, backend, fullstack, mobile, devops, data, ai-ml, security, docs, research, minimal)
  - Interactive menu during `ai-start` for first-time setup
  - Token tracking and statistics (~34k → ~8-12k tokens reduction)
  - `ai-agents` command with multiple subcommands:
    - `list` - List all available agents
    - `active` - Show active agents in project
    - `enable/disable` - Manage individual agents
    - `profile` - Activate profiles (supports combining with `+`)
    - `stats` - Detailed token statistics
    - `suggest` - Intelligent profile suggestion based on project
    - `doctor` - System diagnostics
    - `search` - Search agents by keyword
    - `info` - Agent details
    - `update` - Update agent library
  - Automatic profile detection and loading on `ai-start`
  - Profile combination support (e.g., `frontend+security`)
  - Smart project analysis for profile suggestions
- Agent information in `ai-status` command
- New documentation: `docs/agent-management.md` (comprehensive guide)
- Agent profiles configuration in `config/agent-profiles/`
- Agent index generation script for metadata

### Changed
- Updated `install.sh` to setup agent library and profiles during installation
- Enhanced `ai-workspace-launcher.sh` with agent configuration workflow
- Updated `ai-status.sh` to display agent statistics and token usage
- Extended `.ai-config.example` with agents configuration section
- Updated `README.md` with agent management information and Quick Start
- Improved performance by reducing active agent tokens by 60-70%

### Technical Details
- Agents copied to `.claude/agents/` per project (project-specific)
- JSON-based profile configuration system
- Automatic token calculation (1 token ≈ 4 characters)
- jq-based configuration management
- Interactive menu with 11 profile options
- Support for combined profiles with union of agents
- Duplicate agent removal in combined profiles

## [Unreleased]

### Planned for v1.2
- Improved error messages
- Additional template types
- Performance optimizations
- Enhanced daily summary formats
- Custom agent creation wizard

### Planned for v2.0
- `ai-uninstall` - Clean uninstallation script
- Persistent logging system
- `ai-quick [ai]` - Quick mode with single AI
- Weekly and monthly summary aggregation
- Obsidian integration
- Sync notifications
- GitHub Actions for CI/CD
- Auto-update check and notification
- Plugin system for extensibility
- Web dashboard (optional)

## Version History

- **1.0.0** (2024-11-01) - Initial release with complete feature set
