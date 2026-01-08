# Troubleshooting Guide

Common issues and their solutions for AI Terminal Agent.

---

## Installation Issues

### "ai: command not found"

**Cause**: `~/bin` is not in your PATH

**Solution**:
```bash
# Add to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Verify**:
```bash
echo $PATH | grep "$HOME/bin"
which ai
```

### "Permission denied" when running scripts

**Cause**: Scripts are not executable

**Solution**:
```bash
cd ~/workspace/ai-terminal-agent
chmod +x install.sh bin/*.sh bin/ai lib/*.sh
```

### Git global ignore not working

**Cause**: Not configured or misconfigured

**Solution**:
```bash
# Check status
ai config git --check

# Reconfigure
ai config git --setup

# Verify
git config --global core.excludesfile
```

### jq not found

**Cause**: jq JSON processor not installed

**Solution**:
```bash
brew install jq
```

---

## AI CLI Issues

### Claude not authenticated

**Symptoms**:
- `ai config doctor` shows Claude not authenticated
- Claude commands fail

**Solution**:
```bash
claude auth login
```

### Gemini not working

**Solution**:
```bash
# Check if installed
which gemini

# Install if missing
npm install -g @google/generative-ai

# Authenticate if required
gemini auth login
```

### Codex not found

**Note**: Codex is optional. If you need it:

```bash
# Install OpenAI CLI
npm install -g openai

# Or use alternative
# Codex functionality works through OpenAI API
```

---

## iTerm2 Issues

### Shift+Enter doesn't create new line

**Cause**: Key binding not configured

**Solution 1** (Automatic):
```bash
/terminal-setup
```

**Solution 2** (Manual):
1. Open iTerm2
2. **Preferences** > **Keys** > **Key Bindings**
3. Click **+** to add
4. Keyboard Shortcut: Press `Shift+Enter`
5. Action: "Send Text"
6. Value: `\n`

### iTerm2 not found

**Cause**: iTerm2 not installed or in non-standard location

**Solution**:
```bash
# Install iTerm2
brew install --cask iterm2

# Or download from https://iterm2.com/
```

### Splits not opening correctly

**Cause**: AppleScript permissions

**Solution**:
1. Open **System Preferences** > **Security & Privacy** > **Privacy**
2. Select **Automation**
3. Enable access for Terminal/iTerm2

---

## Workspace Issues

### "Workspace already active" error

**Cause**: Previous session didn't close properly

**Solution 1** (Recommended):
```bash
ai workspace recover
```

**Solution 2** (Manual):
```bash
# Remove stale marker
cd ~/your-project
rm .ai-workspace-active

# Restart
ai start
```

### Context files disappeared

**Cause**: Accidentally deleted or wrong directory

**Solution**:
```bash
# Check backups
ls ~/.ai-workspace/backups/

# Find project backups
find ~/.ai-workspace/backups -name "*.bak"

# Restore from backup
cp ~/.ai-workspace/backups/project-name/file.md.TIMESTAMP.bak .ai-context/file.md
```

### ai status shows no workspaces but one is active

**Cause**: Tracking file corrupted

**Solution**:
```bash
# Rebuild tracking
ai workspace recover

# Or manually check
find ~ -name ".ai-workspace-active" 2>/dev/null
```

---

## Agent Issues

### Agents not appearing in Claude Code

**Cause**: Agents not copied to project directory

**Solution**:
```bash
# Check if agents exist
ls -la .claude/agents/

# If empty, reactivate profile
ai agents profile <name>

# Restart Claude Code
```

### Token usage too high

**Cause**: Too many agents active

**Solution**:
```bash
# Check current usage
ai agents stats

# Switch to lighter profile
ai agents profile minimal

# Or disable specific agents
ai agents disable <name>
```

### Agent library not found

**Cause**: Library not installed

**Solution**:
```bash
# Update library
ai agents update

# Or re-run installation
cd ~/workspace/ai-terminal-agent
./install.sh
```

### Profile not saving

**Cause**: jq not installed or .ai-config corrupted

**Solution**:
```bash
# Install jq
brew install jq

# Check .ai-config syntax
cat .ai-config | jq .

# Recreate if needed
ai agents profile <name>
```

---

## Summary Generation Issues

### Summary not generating

**Cause**: Gemini not installed or available

**Solution**:
```bash
# Check Gemini
which gemini

# Install if needed
npm install -g @google/generative-ai

# Or use basic summary mode
# Edit .ai-config:
{
  "summary": {
    "mode": "basic"
  }
}
```

### Summary is empty

**Cause**: No context files to summarize

**Solution**:
```bash
# Check context files exist
ls -la .ai-context/

# Initialize if needed
ai context init
```

---

## Git Integration Issues

### Context files being committed accidentally

**Cause**: Git global ignore not working or overridden

**Solution**:
```bash
# Verify global ignore
ai config git --check

# Check if locally overridden
cat .git/info/exclude

# Re-setup if needed
ai config git --setup
```

### Want to commit contexts but they're ignored

**Cause**: Global ignore is working (as intended)

**Solution** (Opt-in per project):
```bash
# Edit .ai-config
cat > .ai-config << 'EOF'
{
  "git": {
    "commit_contexts": true
  }
}
EOF

# Add files manually
git add -f .ai-context/
git commit -m "Add AI context files"
```

---

## Update Issues

### ai config update fails with merge conflicts

**Cause**: Local changes conflict with remote

**Solution**:
```bash
cd ~/workspace/ai-terminal-agent

# Stash changes
git stash

# Update
git pull

# Review stashed changes
git stash list
git stash show

# Apply if safe
git stash pop
```

### "Not a git repository" error

**Cause**: Repository not initialized with Git

**Solution**:
```bash
cd ~/workspace/ai-terminal-agent

# Initialize Git
git init

# Add remote (if you have one)
git remote add origin https://github.com/your-user/ai-terminal-agent.git
```

---

## Performance Issues

### ai start is slow

**Causes**:
- Large backups directory
- Many old sessions

**Solution**:
```bash
# Clean old backups (keeps last 3 days)
find ~/.ai-workspace/backups -type f -mtime +3 -delete

# Clean old sessions
find ~/.ai-workspace/sessions -type d -mtime +30 -delete
```

### Context files are huge

**Cause**: Too much accumulated content

**Solution**:
- Archive old sections
- Start fresh periodically
- Use separate files for different phases
- Consider splitting large files

---

## System Issues

### macOS says scripts are from "unidentified developer"

**Cause**: macOS Gatekeeper

**Solution**:
```bash
# Remove quarantine attribute
cd ~/workspace/ai-terminal-agent
xattr -dr com.apple.quarantine bin/
xattr -dr com.apple.quarantine lib/
```

### Scripts hang or timeout

**Cause**: Network issues or API rate limits

**Solution**:
- Check internet connection
- Wait and retry
- Check AI provider status pages

---

## Diagnostic Commands

### Run Health Check

```bash
ai config doctor
```

Shows:
- System status
- AI CLI status
- Configuration status
- Agent library status

### Check Agent Status

```bash
ai agents doctor
```

Shows:
- Agent library health
- Profile configuration
- Token usage

### Check Context Status

```bash
ai context check
```

Shows:
- Context file existence
- File contents summary
- Sync status

### View Active Workspaces

```bash
ai status
```

Shows:
- Active workspaces
- Project paths
- Start times

---

## Common Error Messages

| Error | Fix |
|-------|-----|
| "No context files found" | Run `ai context init` |
| "File not found: config.json" | Run `./install.sh` again |
| "Repository not found" | Check `~/.ai-workspace/config.json` |
| "Tracking file corrupted" | Run `ai workspace recover` |
| "Agent library empty" | Run `ai agents update` |
| "Profile not found" | Run `ai agents profile list` |
| "jq: command not found" | Run `brew install jq` |

---

## Prevention

### Regular Maintenance

```bash
# Weekly
ai config doctor
ai config update

# Monthly
# Clean old backups
find ~/.ai-workspace/backups -mtime +30 -delete

# Check disk space
du -sh ~/.ai-workspace/
```

### Best Practices

1. **Always use `ai stop`** to close workspaces properly
2. **Run `ai workspace recover`** after system crashes
3. **Keep AI CLIs updated**: `npm update -g`
4. **Backup important contexts**: `ai config export`
5. **Test after updates**: `ai config doctor`

---

## Getting More Help

If none of these solutions work:

### 1. Run Full Diagnostics

```bash
ai config doctor
ai agents doctor
ai context check
```

### 2. Check Repository

```bash
cd ~/workspace/ai-terminal-agent
ls -la bin/
ls -la lib/
ls -la templates/
```

### 3. Re-run Installation

```bash
cd ~/workspace/ai-terminal-agent
./install.sh
```

### 4. File an Issue

If problem persists, create an issue with:
- Output of `ai config doctor`
- Error messages
- Steps to reproduce
- Your macOS version
- AI CLI versions

---

## Additional Resources

- [Installation Guide](installation.md) - Setup issues
- [Usage Guide](usage.md) - How to use commands
- [Agent Management](agent-management.md) - Agent issues
- [Quick Reference](quick-reference.md) - Command reference
