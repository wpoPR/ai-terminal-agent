# Troubleshooting Guide

Common issues and their solutions.

## Installation Issues

### "ai-start: command not found"

**Cause**: `~/bin` is not in your PATH

**Solution**:
```bash
# Add to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Or restart terminal
```

**Verify**:
```bash
echo $PATH | grep "$HOME/bin"
```

### "Permission denied" when running scripts

**Cause**: Scripts are not executable

**Solution**:
```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
chmod +x install.sh bin/*.sh
```

### Git global ignore not working

**Cause**: Not configured or misconfigured

**Solution**:
```bash
# Check status
ai-git-config --check

# Reconfigure
ai-git-config --setup

# Verify
git config --global core.excludesfile
```

## AI CLI Issues

### Claude not authenticated

**Symptoms**:
- `ai-health-check` shows Claude not authenticated
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

**Solution**:
```bash
npm install -g @openai/codex
```

## iTerm2 Issues

### Shift+Enter doesn't create new line

**Cause**: Key binding not configured

**Solution 1** (Automatic):
```bash
/terminal-setup
```

**Solution 2** (Manual):
1. Open iTerm2
2. Preferences → Keys → Key Bindings
3. Click "+" to add
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

## Workspace Issues

### "Workspace already active" error

**Cause**: Previous session didn't close properly

**Solution 1** (Recommended):
```bash
ai-recover
```

**Solution 2** (Manual):
```bash
# Remove stale marker
cd ~/your-project
rm .ai-workspace-active

# Restart
ai-start
```

### Context files disappeared

**Cause**: Accidentally deleted or wrong directory

**Solution**:
```bash
# Check backups
ls ~/.ai-workspace/backups/your-project/

# Restore from backup
cp ~/.ai-workspace/backups/your-project/claude.md.TIMESTAMP.bak claude.md
```

### ai-status shows no workspaces but one is active

**Cause**: Tracking file corrupted

**Solution**:
```bash
# Rebuild tracking
ai-recover

# Or manually check
find ~/workspace ~/projects -name ".ai-workspace-active"
```

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

## Git Integration Issues

### Context files being committed accidentally

**Cause**: Git global ignore not working or overridden

**Solution**:
```bash
# Verify global ignore
ai-git-config --check

# Check if locally overridden
cat .git/info/exclude

# Re-setup if needed
ai-git-config --setup
```

### Want to commit contexts but they're ignored

**Cause**: Global ignore is working (as intended)

**Solution** (Opt-in per project):
```bash
# Create or edit .ai-config in project
cat > .ai-config << 'EOF'
{
  "git": {
    "commit_contexts": true
  }
}
EOF

# Now you can commit
git add claude.md gemini.md agents.md
git commit -m "docs: add AI context files"
```

## Update Issues

### ai-update fails with merge conflicts

**Cause**: Local changes conflict with remote

**Solution**:
```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent

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

### ai-update says "Not a git repository"

**Cause**: Repository not initialized with Git

**Solution**:
```bash
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent

# Initialize Git
git init

# Add remote (if you have one)
git remote add origin https://github.com/seu-usuario/ai-terminal-agent.git

# Or use without Git
# (manual updates only)
```

## Performance Issues

### ai-start is slow

**Causes**:
- Large backups directory
- Many old sessions

**Solution**:
```bash
# Clean old backups (keeps last 3 days by default)
find ~/.ai-workspace/backups -type f -mtime +3 -delete

# Clean old sessions
find ~/.ai-workspace/sessions -type d -mtime +30 -delete
```

### Context files are huge

**Cause**: Too much accumulated content

**Solution**:
- Archive old sections
- Start fresh periodically
- Use separate context files for different phases

## System-Wide Issues

### macOS says scripts are from "unidentified developer"

**Cause**: macOS Gatekeeper

**Solution**:
```bash
# Remove quarantine attribute
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
xattr -dr com.apple.quarantine bin/
```

### jq not found

**Symptoms**:
- Some commands show basic output only
- JSON parsing fails

**Solution**:
```bash
brew install jq
```

## Getting Help

If none of these solutions work:

### 1. Run Health Check
```bash
ai-health-check
```

### 2. Check Logs
```bash
# Check for error messages in recent commands
# Most scripts output to stderr

# Check system logs if needed
log show --predicate 'process == "iTerm2"' --last 1h
```

### 3. Verify Installation
```bash
# Re-run installation
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
./install.sh
```

### 4. Check Repository
```bash
# Verify all files are present
cd /Users/wesleyoliveira/workspace/primavera/ai-terminal-agent
ls -la bin/
ls -la templates/
ls -la config/
```

### 5. File an Issue
If problem persists, create an issue with:
- Output of `ai-health-check`
- Error messages
- Steps to reproduce
- Your macOS version
- AI CLI versions

## Common Error Messages

### "No context files found"
**Fix**: Run `ai-start` first to create context files

### "File not found: config.json"
**Fix**: Run `install.sh` again

### "Repository not found"
**Fix**: Check `~/.ai-workspace/config.json` has correct repo path

### "Tracking file corrupted"
**Fix**: Delete and rebuild: `rm ~/.ai-workspace/tracking.json && ai-recover`

## Prevention

### Regular Maintenance

```bash
# Weekly
ai-health-check
ai-update

# Monthly
# Clean old backups
find ~/.ai-workspace/backups -mtime +30 -delete

# Check disk space
du -sh ~/.ai-workspace/
```

### Best Practices

1. Always use `ai-stop` to close workspaces
2. Run `ai-recover` after system crashes
3. Keep AI CLIs updated: `npm update -g`
4. Backup important context files: `ai-export`
5. Test after updates: `ai-health-check`

## Still Having Issues?

- Check [Usage Guide](usage.md) for correct usage
- Review [Installation Guide](installation.md)
- See [Configuration](configuration.md) for options
- Check GitHub issues for similar problems
