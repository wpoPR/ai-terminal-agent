# Installation Guide

Complete guide to installing AI Terminal Agent.

## Prerequisites

### Required

- **macOS** 14.0 or later
- **iTerm2** - Download from [iterm2.com](https://iterm2.com/)
- **Git** - Install via `xcode-select --install`
- **At least one AI CLI**:
  - Claude: `npm install -g @anthropic-ai/claude-code`
  - Gemini: `npm install -g @google/generative-ai` (optional)
  - Codex: OpenAI CLI (optional)

### Recommended

- **jq** - JSON processor: `brew install jq`
- **Homebrew** - Package manager for macOS

---

## Quick Installation

```bash
# Clone repository
cd ~/workspace
git clone https://github.com/your-user/ai-terminal-agent.git
cd ai-terminal-agent

# Run installation
./install.sh

# Restart shell
source ~/.zshrc
```

---

## What install.sh Does

The installation script performs:

| Step | Description |
|------|-------------|
| 1 | Checks dependencies (macOS, iTerm2, Git, jq) |
| 2 | Configures iTerm2 Shift+Enter key binding |
| 3 | Verifies AI CLIs (Claude, Gemini, Codex) |
| 4 | Creates directories (`~/.ai-workspace/`, `~/templates/`) |
| 5 | Creates symlinks in `~/bin/` |
| 6 | Installs templates |
| 7 | Sets up agent management system (47 agents, 11 profiles) |
| 8 | Configures Git global ignore |
| 9 | Updates `~/.zshrc` |
| 10 | Runs health check |

---

## Post-Installation

### 1. Restart Shell

```bash
source ~/.zshrc
# or restart terminal
```

### 2. Verify Installation

```bash
ai config doctor
```

### 3. Configure iTerm2 (if needed)

If automatic setup didn't work:

1. Open iTerm2
2. Go to **Preferences** > **Keys** > **Key Bindings**
3. Click **+** to add new binding
4. Set Keyboard Shortcut: `Shift+Enter`
5. Action: "Send Text"
6. Value: `\n`

### 4. Authenticate AI CLIs

```bash
# Claude (required)
claude auth login

# Gemini (optional)
gemini auth login

# Codex (optional)
codex auth login
```

---

## Directory Structure Created

```
~/.ai-workspace/
├── agents/           # 47 agent definitions
├── agent-profiles/   # 11 profile configs
├── sessions/         # Active session tracking
├── backups/          # Context file backups
├── summaries/
│   ├── daily/        # Daily work summaries
│   └── weekly/       # Weekly summaries
└── config.json       # Installation config

~/bin/
├── ai                # Main unified CLI
├── ai-workspace      # Workspace management
├── ai-context        # Context management
├── ai-config         # Configuration
├── ai-agents         # Agent management
└── ...               # Legacy commands

~/templates/ai-contexts/
├── project-status.md
├── current-task.md
└── ...
```

---

## Multi-Machine Setup

### First Machine

```bash
cd ~/workspace
git clone https://github.com/your-user/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh

# Push to your remote
git remote add origin https://github.com/your-user/ai-terminal-agent.git
git push -u origin main
```

### Additional Machines

```bash
cd ~/workspace
git clone https://github.com/your-user/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
```

### Keep Synced

```bash
ai config update    # Pull latest changes
```

---

## Troubleshooting Installation

### "ai: command not found"

```bash
# Add ~/bin to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "Permission denied"

```bash
cd ~/workspace/ai-terminal-agent
chmod +x install.sh bin/*.sh bin/ai
```

### Git global ignore not working

```bash
ai config git --setup
```

### AI CLIs not installed

```bash
# Claude (main AI)
npm install -g @anthropic-ai/claude-code

# Gemini (research, summaries)
npm install -g @google/generative-ai

# OpenAI (optional)
npm install -g openai
```

---

## Uninstallation

```bash
# 1. Remove symlinks
rm ~/bin/ai ~/bin/ai-*

# 2. Remove templates (optional)
rm -rf ~/templates/ai-contexts

# 3. Remove workspace data (optional)
rm -rf ~/.ai-workspace

# 4. Remove global CLAUDE.md (optional)
rm ~/.claude/CLAUDE.md

# 5. Edit ~/.zshrc - remove AI Terminal Agent section

# 6. Edit ~/.gitignore_global - remove AI Workspace entries

# 7. Remove repository
rm -rf ~/workspace/ai-terminal-agent
```

---

## Verify Installation

After installation, run:

```bash
ai config doctor
```

Expected output:
```
AI Terminal Agent - Health Check
================================

System
------
[OK] macOS detected
[OK] iTerm2 installed
[OK] Git installed
[OK] jq installed

AI CLIs
-------
[OK] Claude CLI installed
[OK] Gemini CLI installed
[WARN] Codex CLI not found (optional)

Configuration
-------------
[OK] ~/bin in PATH
[OK] Git global ignore configured
[OK] Agent library present (47 agents)
[OK] Profiles configured (11 profiles)

Status: All systems operational
```

---

## Next Steps

After successful installation:

1. **Start your first workspace**:
   ```bash
   cd ~/your-project
   ai start
   ```

2. **Learn the commands**:
   ```bash
   ai help
   ```

3. **Read documentation**:
   - [Usage Guide](usage.md)
   - [Agent Management](agent-management.md)
   - [Quick Reference](quick-reference.md)
