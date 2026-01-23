# AI Terminal Agent

[![Version](https://img.shields.io/badge/version-2.1.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-contributor%20covenant-orange.svg)](CODE_OF_CONDUCT.md)
[![Security Policy](https://img.shields.io/badge/security-policy-blue.svg)](SECURITY.md)

> Multi-AI workspace manager for iTerm2 - orchestrate Claude, Gemini, and Codex in a single terminal.

![AI Terminal Agent - Claude, Gemini, and Codex running in iTerm2](docs/images/screenshot.png)

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
  - [Migrating Existing Projects](#migrating-existing-projects)
- [Commands](#commands)
- [Stack Detection](#stack-detection)
- [Agent Management](#agent-management)
- [Shared Context](#shared-context)
- [Workflow Example](#workflow-example)
- [Prerequisites](#prerequisites)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Security](#security)
- [License](#license)

## Features

- **Unified CLI** - Single `ai` command with intuitive subcommands
- **Multi-AI Orchestration** - Claude, Gemini, and Codex with defined roles
- **Dynamic Agents** - 47 specialized agents, 11 pre-defined profiles
- **Token Optimization** - Reduce usage from ~34k to ~8-12k tokens (60-70% savings)
- **Shared Context** - AIs share information via `.ai-context/`
- **Auto Stack Detection** - Detects 12+ stacks (TypeScript, Python, Go, C#, etc.)
- **Migration Tool** - Easy upgrade from older versions with `ai migrate`
- **Gemini Protection** - `.geminiignore` prevents context overflow
- **Shell Completion** - Tab completion for all commands
- **Git Integration** - Global ignore for AI workspace files

## Quick Start

### Installation

```bash
git clone https://github.com/wesleyoliveira/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
source ~/.zshrc
```

### Basic Usage

```bash
cd ~/your-project
ai start              # Launch workspace with iTerm2 splits
ai stop               # Close with daily summary
ai status             # Check active workspaces
ai help               # Full documentation
```

### Migrating Existing Projects

If you have projects using the old structure (AGENTS.md, CLAUDE.md, old `.ai-context/`):

```bash
cd ~/your-old-project
ai stop               # Optional: save current work
ai migrate            # Interactive migration with backup
```

**What `ai migrate` does:**
1. Creates backup in `.ai-migrate-backup-TIMESTAMP/`
2. Preserves `decisions.md` and `agents-reference.md`
3. Removes old files (AGENTS.md, CLAUDE.md, old .ai-context/)
4. Runs `ai-start` to create new structure
5. Restores preserved files

```bash
# Preview changes without making them
ai migrate --dry-run

# Non-interactive migration
ai migrate --force
```

## Commands

```bash
ai <command> [options]

# Quick shortcuts
ai start [path]           # Start AI workspace
ai stop                   # Stop workspace
ai status                 # Show status

# Workspace management
ai workspace start        # Launch with iTerm2 splits
ai workspace stop         # Close and generate summary
ai workspace status       # Show active workspaces
ai workspace recent       # List recent workspaces
ai workspace recover      # Recover from crashes

# Agent management
ai agents list            # List all 47 agents
ai agents profile <name>  # Activate profile (minimal, frontend, backend, etc.)
ai agents stats           # Show token usage
ai agents suggest         # Get profile recommendation

# Context management
ai context init           # Initialize .ai-context/
ai context check          # Diagnose context state
ai context sync           # Sync AI configurations

# Configuration
ai config doctor          # Health check
ai config git --setup     # Configure git ignore
ai config update          # Update from git

# Migration (for old projects)
ai migrate                # Migrate to new structure
ai migrate --dry-run      # Preview changes
ai migrate --force        # Non-interactive
```

## Stack Detection

`ai start` automatically detects your project's technology stack:

| Stack | Detection Files |
|-------|-----------------|
| TypeScript | `tsconfig.json`, `*.ts` |
| Python | `requirements.txt`, `pyproject.toml` |
| Go | `go.mod` |
| Rust | `Cargo.toml` |
| C#/.NET | `*.csproj`, `*.sln` |
| Next.js | `next.config.*` |
| React | `package.json` with react |

Detection generates `.ai-context/stack-config.md` with:
- Test/lint/build commands
- Code quality limits (lines per file, function params)
- Framework-specific guidelines

```bash
# Re-run detection manually
ai-stack-detect

# Interactive selection if auto-detection fails
ai-stack-detect  # Shows menu when no stack found
```

## Agent Management

Activate only the agents you need, reducing token usage significantly.

| Profile | Agents | Tokens | Best For |
|---------|--------|--------|----------|
| `minimal` | 2 | ~5k | Code review only |
| `frontend` | 4 | ~10k | React, Next.js, Vue |
| `backend` | 4 | ~11k | APIs, Node.js, Python |
| `fullstack` | 4 | ~11k | Full web applications |
| `mobile` | 3 | ~10k | iOS/Android, React Native |
| `devops` | 5 | ~14k | Kubernetes, Terraform |
| `data` | 4 | ~12k | Data engineering |
| `ai-ml` | 4 | ~12k | Machine learning |
| `security` | 4 | ~13k | Security audits |
| `docs` | 4 | ~10k | Documentation |
| `research` | 3 | ~10k | Research tasks |

```bash
# Activate a profile
ai agents profile fullstack

# Combine profiles
ai agents profile frontend+security

# Check token usage
ai agents stats
```

## Shared Context

The `.ai-context/` directory enables AIs to share information:

```
.ai-context/
├── ai-handoff.md         # AI communication hub (session state, checkpoints)
├── ai-workflows.md       # Quick reference for common scenarios
├── code-landmarks.md     # Important code locations
├── decisions.md          # Technical decisions
├── agents-reference.md   # Active agents documentation
├── stack-config.md       # Auto-detected stack (commands, limits)
├── todos/                # File-based task management
│   └── 001-example.md    # Individual todo files
└── backup/               # Migration backups
```

Additionally, a `.geminiignore` file is created to prevent Gemini CLI from reading the entire codebase at once (which causes context overflow).

```bash
# Initialize context structure
ai context init
```

## Workflow Example

```
1. ai start
   └── Creates .ai-context/, .geminiignore, detects stack
   └── iTerm2 opens with 3 AI panes

2. Gemini (top-right): "!analyze task Add user authentication"
   └── Creates todo in .ai-context/todos/001-add-auth.md
   └── Recommends agents (ai agents profile backend)

3. Claude (left): "Read .ai-context/ and implement auth"
   └── Uses TDD workflow, updates landmarks
   └── Marks todo as completed

4. Codex (bottom-right): "!document solution for auth implementation"
   └── Creates docs/solutions/auth-implementation.md

5. ai stop
   └── Generates summary in ai-handoff.md
```

### AI Roles

| AI | Role | Keywords |
|----|------|----------|
| **Gemini** | Analysis, task planning | `!analyze task`, `!select agents` |
| **Claude** | Implementation (TDD) | `!checkpoint`, `!handoff` |
| **Codex** | Documentation, tests | `!document solution`, `!add tests` |

### Layout

```
┌─────────────────────┬──────────────┐
│                     │   GEMINI     │
│                     │  (Analysis)  │
│      CLAUDE         ├──────────────┤
│  (Implementation)   │   CODEX      │
│                     │   (Docs)     │
└─────────────────────┴──────────────┘
```

## Prerequisites

| Requirement | Installation |
|-------------|--------------|
| **macOS** 14+ | - |
| **iTerm2** | [iterm2.com](https://iterm2.com/) |
| **Claude CLI** | `npm install -g @anthropic-ai/claude-code` |
| **Gemini CLI** | `npm install -g @google/generative-ai` (optional) |
| **jq** | `brew install jq` |

> **Note:** This project currently supports macOS only due to iTerm2 and AppleScript dependencies. Contributions for Linux (tmux) or Windows Terminal support are welcome!

## Documentation

- [Quick Reference](docs/quick-reference.md) - Command cheatsheet
- [Installation Guide](docs/installation.md) - Detailed setup
- [Usage Guide](docs/usage.md) - How to use
- [Agent Management](docs/agent-management.md) - Agent system
- [Multi-AI Workflow](docs/multi-ai-workflow.md) - AI coordination guide
- [Troubleshooting](docs/troubleshooting.md) - Common issues
- [Changelog](CHANGELOG.md) - Version history

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Security

If you discover a security issue, please follow the instructions in
[SECURITY.md](SECURITY.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**[View Changelog](CHANGELOG.md)** | **[Report Bug](https://github.com/wesleyoliveira/ai-terminal-agent/issues)** | **[Request Feature](https://github.com/wesleyoliveira/ai-terminal-agent/issues)**
