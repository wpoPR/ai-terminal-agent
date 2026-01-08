# Contributing to AI Terminal Agent

Thank you for your interest in contributing to AI Terminal Agent! This document provides guidelines and instructions for contributing.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/wesleyoliveira/ai-terminal-agent/issues)
2. If not, create a new issue using the bug report template
3. Include:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (macOS version, shell, AI CLIs installed)
   - Output of `ai config doctor`

### Suggesting Features

1. Check if the feature has already been suggested in [Issues](https://github.com/wesleyoliveira/ai-terminal-agent/issues)
2. Create a new issue using the feature request template
3. Describe:
   - The problem you're trying to solve
   - Your proposed solution
   - Alternative solutions you've considered

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test your changes: `ai config doctor`
5. Commit with clear messages: `git commit -m "Add: description of change"`
6. Push to your fork: `git push origin feature/my-feature`
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/ai-terminal-agent.git
cd ai-terminal-agent

# Run installation (creates symlinks to your local copy)
./install.sh

# Make changes to scripts in bin/
# Changes take effect immediately (symlinks)

# Test your changes
ai config doctor
ai help
```

## Code Style

### Shell Scripts

- Use `#!/bin/bash` shebang
- Use 2-space indentation
- Quote variables: `"$variable"` not `$variable`
- Use `[[ ]]` for conditionals (bash-specific)
- Add comments for complex logic
- Use functions for reusable code

### Naming Conventions

- Scripts: `ai-*.sh` or `generate-*.sh`
- Functions: `snake_case`
- Variables: `UPPER_CASE` for constants, `lower_case` for locals
- Files: `kebab-case.md` for documentation

### Documentation

- Update relevant `.md` files when changing functionality
- Keep README.md in sync with features
- Update CHANGELOG.md for notable changes

## Project Structure

```
ai-terminal-agent/
├── bin/                  # Executable scripts
│   ├── ai                # Main CLI entry point
│   ├── ai-workspace.sh   # Workspace commands
│   ├── ai-context.sh     # Context commands
│   ├── ai-config.sh      # Configuration commands
│   ├── ai-agents.sh      # Agent management
│   └── ...
├── lib/                  # Shared libraries
│   └── common.sh         # Common functions
├── agents-list/          # Agent definitions (47 agents)
├── config/               # Configuration files
│   ├── agent-profiles/   # Profile definitions
│   └── ...
├── templates/            # Context templates
├── docs/                 # Documentation
└── install.sh            # Installation script
```

## Testing

Before submitting a PR:

```bash
# Run health check
ai config doctor

# Test main commands
ai help
ai agents list
ai agents profile list

# If you modified workspace commands
ai start --dry-run  # (if available)
```

## Commit Messages

Use clear, descriptive commit messages:

```
Add: new feature description
Fix: bug description
Update: what was updated
Remove: what was removed
Docs: documentation changes
Refactor: code refactoring
```

## Questions?

- Open an issue with the "question" label
- Check existing documentation in `docs/`

## Code of Conduct

Please read and follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Security

If you discover a security issue, please follow the instructions in
[SECURITY.md](SECURITY.md).

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
