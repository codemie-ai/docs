# AI/Run CodeMie Documentation

Official documentation for AI/Run CodeMie - an AI-powered development platform.

**Live Site**: [Documentation](#) • **Issues**: [GitHub Issues](https://github.com/codemie-ai/docs/issues)

## Quick Start for Contributors

**Prerequisites**: Node.js 18.0+

```bash
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
4. Commit with pattern: `EPMCDME-XXXX: Description`
5. Open a Pull Request (title must match commit pattern)

## Available Scripts

```bash
npm start              # Dev server with hot reload
npm run build          # Production build
npm run typecheck      # TypeScript validation
npm run lint:eslint    # ESLint checks
npm run lint:prettier  # Format validation
npm run lint:markdown  # Markdown linting
```

## CI/CD Pipeline

Pull requests are automatically validated:

- Commit/PR pattern: `EPMCDME-XXXX: Description` (required)
- Code quality: TypeScript, ESLint, Prettier, Markdown
- Build verification

Merges to `main` auto-deploy to GitHub Pages.
