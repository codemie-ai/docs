# AI/Run CodeMie Documentation

Official documentation for AI/Run CodeMie - an AI-powered development platform.

**Live Site**: [Documentation](https://codemie-ai.github.io/docs) • **Issues**: [GitHub Issues](https://github.com/codemie-ai/docs/issues)

## Quick Start for Contributors

**Prerequisites**:

- Node.js 24.0+
- GitLeaks (for pre-commit secret scanning)

### Installing GitLeaks

GitLeaks is required for local pre-commit hooks to scan for secrets before committing.

**macOS (Homebrew)**:

```bash
brew install gitleaks
```

**Windows (Scoop)**:

```bash
scoop install gitleaks
```

**Windows (Chocolatey)**:

```bash
choco install gitleaks
```

**Linux (Download Binary)**:

```bash
# Download latest release from https://github.com/gitleaks/gitleaks/releases
# Example for Linux x64:
wget https://github.com/gitleaks/gitleaks/releases/download/v8.30.0/gitleaks_8.30.0_linux_x64.tar.gz
tar -xzf gitleaks_8.30.0_linux_x64.tar.gz
sudo mv gitleaks /usr/local/bin/
```

**Verify Installation**:

```bash
gitleaks version
```

### Setup

```bash
# Install and activate the predefined Node.js version. (Optional)
nvm install

# Install dependencies
npm install

# Start dev server (http://localhost:3000)
npm start

# Build for production
npm run build
```

## Contributing

### Workflow

1. Fork and create a feature branch
2. Make your changes
3. Test locally with `npm start`
4. Run all checks: `npm run check`
5. Commit using [Conventional Commits](https://www.conventionalcommits.org/) format (e.g., `docs(aws): add section`)
6. Open a Pull Request (title must also follow Conventional Commits)

## Available Scripts

```bash
npm start                    # Dev server with hot reload
npm run build                # Production build

# Run ALL Checks
npm run check                # Run typecheck + lint + commit validation (recommended before commit)
npm run validate             # Run all checks including build

# Individual Checks
npm run typecheck            # TypeScript validation
npm run lint                 # Run all linters (ESLint, Prettier, Markdown, Spelling)
npm run format               # Auto-fix formatting issues
npm run commitlint:last      # Validate your last commit
npm run commitlint:test      # Test a commit message (via stdin)

# Security
npm run secrets:check        # Scan for secrets (current files only)
npm run secrets:check-git    # Scan for secrets (includes Git history)
npm run secrets:check-staged # Scan staged files (runs automatically in pre-commit hook)
```

### Testing Commit Messages

```bash
# Validate your last commit
npm run commitlint:last

# Test a message before committing
echo "docs(aws): add prerequisites" | npm run commitlint:test
```

## Commit Message Format

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>
```

**Types**: `docs`, `feat`, `fix`, `style`, `refactor`, `chore`, `revert`
**Scopes**: `aws`, `gcp`, `user-guide`, `deployment`, `getting-started`, `config`, `deps`

**Examples**:

```bash
docs(aws): add prerequisites section
feat(gcp): add manual deployment guide
fix(aws): correct image paths
chore(deps): update docusaurus to 3.9.2
```

Git hooks will automatically validate commit messages before allowing commits.

## CI/CD Pipeline

Pull requests are automatically validated:

- Conventional Commits format (commit messages and PR title)
- Secrets detection: Gitleaks scan for exposed credentials
- Code quality: TypeScript, ESLint, Prettier, Markdown, Spell checking
- Build verification

Merges to `main` auto-deploy to GitHub Pages.
