# Installation Guide

## Prerequisites

Before installing AI Terminal Agent, ensure you have:

### Required
- **macOS** 14.0 or later
- **iTerm2** - Download from [iterm2.com](https://iterm2.com/)
- **Git** - Install via `xcode-select --install`
- **At least one AI CLI**:
  - Claude: `npm install -g @anthropic-ai/claude-code`
  - Gemini: `npm install -g @google/generative-ai`
  - Codex: `npm install -g @openai/codex`

### Recommended
- **jq** - JSON processor: `brew install jq`
- **Homebrew** - Package manager for macOS

## Installation Methods

### Method 1: Fresh Installation

If this is your first time installing:

```bash
# 1. Create directory
mkdir -p ~/workspace/primavera
cd ~/workspace/primavera

# 2. Clone repository (or create from scratch)
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent

# 3. Run installation
./install.sh
```

### Method 2: Manual Setup

If you're setting up without Git initially:

```bash
# 1. Create directory structure
mkdir -p /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent

# 2. Download files or copy the repository contents here

# 3. Initialize Git (optional but recommended)
git init
git add .
git commit -m "Initial setup"

# 4. Run installation
./install.sh
```

## What install.sh Does

The installation script performs the following steps:

1. **Dependency Check** - Verifies macOS, iTerm2, Git, jq
2. **iTerm2 Configuration** - Sets up Shift+Enter key binding
3. **AI CLI Check** - Verifies Claude, Gemini, Codex installation
4. **Directory Creation** - Creates `~/.ai-workspace/`, `~/templates/`
5. **Symlink Creation** - Links `~/bin/ai-*` to repository scripts
6. **Template Installation** - Copies templates to `~/templates/ai-contexts/`
7. **Git Configuration** - Sets up `~/.gitignore_global`
8. **Shell Configuration** - Updates `~/.zshrc`
9. **Repository Registration** - Saves repo path in config
10. **Health Check** - Verifies installation

## Post-Installation

After installation:

### 1. Restart Shell
```bash
source ~/.zshrc
# or restart your terminal
```

### 2. Verify Installation
```bash
ai-health-check
```

### 3. Configure iTerm2 (if needed)
If `/terminal-setup` wasn't available:

1. Open iTerm2
2. Go to Preferences → Keys → Key Bindings
3. Click "+" to add new binding
4. Set: Keyboard Shortcut: `Shift+Enter`
5. Action: "Send Text"
6. Value: `\n`

### 4. Authenticate AI CLIs

```bash
# Claude
claude auth login

# Gemini (if required)
gemini auth login

# Codex (if required)
codex auth login
```

## Troubleshooting Installation

### Issue: "ai-start: command not found"
**Solution**: Add `~/bin` to PATH or restart shell
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: "Permission denied" when running scripts
**Solution**: Make scripts executable
```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
chmod +x bin/*.sh
chmod +x install.sh
```

### Issue: Git global ignore not working
**Solution**: Reconfigure
```bash
ai-git-config --setup
```

### Issue: AI CLIs not installed
**Solution**: Install via npm
```bash
# Install all three
npm install -g @anthropic-ai/claude-code
npm install -g @google/generative-ai
npm install -g @openai/codex
```

## Multi-Machine Installation

### First Machine (Setup)
```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
./install.sh

# Push to remote repository
git remote add origin https://github.com/seu-usuario/ai-terminal-agent.git
git push -u origin main
```

### Additional Machines
```bash
cd ~/workspace/primavera
git clone https://github.com/seu-usuario/ai-terminal-agent.git
cd ai-terminal-agent
./install.sh
```

## Uninstallation

To remove AI Terminal Agent:

```bash
# 1. Remove symlinks
rm ~/bin/ai-*

# 2. Remove templates (optional)
rm -rf ~/templates/ai-contexts

# 3. Remove tracking data (optional)
rm -rf ~/.ai-workspace

# 4. Remove Git global ignore entry (optional)
# Edit ~/.gitignore_global and remove AI Workspace lines

# 5. Remove zshrc entries (optional)
# Edit ~/.zshrc and remove AI Terminal Agent section

# 6. Remove repository
rm -rf /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
```

## Next Steps

After installation:
- Read [Usage Guide](usage.md) to learn how to use the system
- Check [Configuration](configuration.md) for customization options
- See [Troubleshooting](troubleshooting.md) for common issues
