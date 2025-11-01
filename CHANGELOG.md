# Changelog

All notable changes to AI Terminal Agent will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [Unreleased]

### Planned for v1.1
- Improved error messages
- Additional template types
- Performance optimizations
- Enhanced daily summary formats

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
