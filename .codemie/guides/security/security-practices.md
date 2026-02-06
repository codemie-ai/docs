# Security Practices - Documentation Site

**Project**: AI/Run CodeMie Documentation
**Type**: Static Documentation Site (Docusaurus)
**Deployment**: GitHub Pages (public)

---

## Documentation Security Overview

This is a **public documentation site** with no backend, authentication, or user data. Security focuses on:

1. **Preventing secrets exposure** in documentation content
2. **Secrets scanning** in CI/CD pipeline
3. **Safe documentation practices** (no malicious content)
4. **Dependency security** (keeping packages updated)

---

## Secrets Detection

### Gitleaks Scanner

**Tool**: Gitleaks (Docker-based)
**Purpose**: Detect exposed credentials, API keys, tokens, passwords in code and git history

### Commands

| Command                     | Scan Type          | When to Use    |
| --------------------------- | ------------------ | -------------- |
| `npm run secrets:check`     | Current files only | Before commit  |
| `npm run secrets:check-git` | Full git history   | Periodic audit |

### Implementation

```bash
# Source: package.json:24-25

# Scan current files (no git history)
npm run secrets:check

# Scan including git history
npm run secrets:check-git
```

**Docker command** (manual execution):

```bash
# Current files only
docker run --rm -v "$(pwd):/path" ghcr.io/gitleaks/gitleaks:latest detect --source="/path" --verbose --no-git

# With git history
docker run --rm -v "$(pwd):/path" ghcr.io/gitleaks/gitleaks:latest detect --source="/path" --verbose
```

### What Gitleaks Detects

- AWS keys
- API tokens
- Private keys
- Passwords in config
- Database connection strings
- OAuth secrets
- Generic secrets patterns

---

## CI/CD Security Validation

**GitHub Actions Pipeline** validates every pull request:

### Secrets Scanning

```yaml
# Runs on every PR
- Gitleaks scan (full git history)
- Fails PR if secrets detected
```

**Result**: PRs with exposed secrets are blocked from merging.

---

## Safe Documentation Practices

### Content Security Rules

| ✅ DO                                             | ❌ DON'T                              |
| ------------------------------------------------- | ------------------------------------- |
| Use example values: `your-api-key`, `example.com` | Include real API keys or credentials  |
| Use placeholders: `<your-domain>` in backticks    | Commit actual domain names or secrets |
| Generic examples: `user@example.com`              | Real email addresses (PII)            |
| Public endpoints only                             | Internal/private endpoints            |
| Sanitized logs/outputs                            | Logs containing tokens or keys        |

### Code Examples in Documentation

When documenting commands or configurations:

```bash
# ✅ GOOD - Generic placeholder
export API_KEY="your-api-key-here"

# ❌ BAD - Real credential
export API_KEY="sk_live_51H..."
```

```yaml
# ✅ GOOD - Example values
database:
  host: "your-database.example.com"
  password: "your-secure-password"

# ❌ BAD - Real credentials
database:
  host: "prod-db.internal.company.com"
  password: "ActualPassword123!"
```

### Markdown Tables with Sensitive Info

```markdown
| Parameter | Example Value |
|-----------|---------------|
| API Key | `your-api-key` |
| Database Password | `your-password` |
| JWT Secret | `your-jwt-secret` |
```

**Never include**:

- Real API keys
- Actual passwords
- Private endpoints
- Internal hostnames
- Personal data

---

## Dependency Security

### Automated Checks

**Dependabot** (GitHub):

- Automatically creates PRs for dependency updates
- Security vulnerability alerts
- Weekly update checks

### Manual Checks

```bash
# Check for vulnerabilities
npm audit

# Fix automatically fixable issues
npm audit fix

# View detailed report
npm audit --json
```

### Update Process

```bash
# Check for outdated packages
npm outdated

# Update specific package
npm update <package-name>

# Update all packages (careful!)
npm update

# Always test after updates
npm start
npm run build
```

**Lock file**: `package-lock.json` - ✅ Always commit after updates

---

## Configuration Security

### Environment Variables (N/A)

This is a **static site** - no runtime environment variables.

Configuration is in:

- `docusaurus.config.ts` - Public configuration
- `sidebars.ts` - Navigation structure
- Both files are public (deployed to GitHub Pages)

**No secrets should be in these files.**

---

## Build & Deployment Security

### GitHub Pages Deployment

**Trigger**: Automatic on merge to `main` branch

**Security**:

- Static HTML/CSS/JS only (no backend)
- Served over HTTPS
- No user data processing
- No authentication required
- Public access by design

### Build Process

```bash
# Local production build
npm run build

# Output: build/ directory (static files)
```

**Security notes**:

- No server-side code execution
- No database connections
- No API keys needed at runtime
- All content is public by design

---

## Common Security Issues

### Issue: Secret Detected in Commit

**Symptoms**: Gitleaks fails, PR blocked

**Solution**:

1. **Remove secret from file**:

   ```bash
   # Edit file, replace real secret with placeholder
   vim docs/section/file.md
   ```

2. **Commit the fix**:

   ```bash
   git add docs/section/file.md
   git commit -m "fix: remove exposed credential"
   ```

3. **If already pushed, rotate the secret**:
   - Invalidate the exposed credential
   - Generate new credential
   - Update in secure location (not in docs)

4. **If in git history**:

   ```bash
   # Rewrite history (dangerous, coordinate with team)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all

   # Force push (requires coordination)
   git push --force
   ```

### Issue: Dependency Vulnerability

**Symptoms**: `npm audit` reports vulnerabilities

**Solution**:

```bash
# Try automatic fix first
npm audit fix

# If fix not available, update manually
npm update <vulnerable-package>

# Test thoroughly
npm start
npm run build

# Commit the update
git add package.json package-lock.json
git commit -m "chore(deps): fix security vulnerability in <package>"
```

---

## Security Checklist

### Before Committing Documentation

- [ ] No real API keys, tokens, or credentials
- [ ] No real passwords or secrets
- [ ] No internal/private hostnames
- [ ] No personal data (emails, names, unless public)
- [ ] Run `npm run secrets:check` locally
- [ ] Use placeholders like `<your-value>` in backticks
- [ ] Example values are generic: `example.com`, `user@example.com`

### Before Merging PR

- [ ] Gitleaks scan passes in CI
- [ ] All secrets are placeholders
- [ ] Dependencies are up to date
- [ ] No `npm audit` vulnerabilities

### Periodic (Monthly)

- [ ] Run `npm run secrets:check-git` (full history scan)
- [ ] Check for dependency updates: `npm outdated`
- [ ] Review Dependabot PRs
- [ ] Rotate any exposed secrets (if detected)

---

## Security Anti-Patterns

| ❌ NEVER                         | ✅ INSTEAD                     | Risk            |
| -------------------------------- | ------------------------------ | --------------- |
| Commit real API keys in examples | Use `your-api-key` placeholder | Key exposure    |
| Include actual passwords         | Use `your-password`            | Credential leak |
| Document internal endpoints      | Use `api.example.com`          | Info disclosure |
| Commit `.env` files              | Add to `.gitignore`            | Secret exposure |
| Ignore `npm audit` warnings      | Fix vulnerabilities promptly   | Dependency risk |
| Push before secrets scan         | Run `npm run secrets:check`    | Accidental leak |

---

## Responsible Disclosure

If you discover a security issue:

1. **Do NOT create a public issue**
2. Email security contact (see README or SECURITY.md if exists)
3. Include:
   - Description of the issue
   - Steps to reproduce
   - Potential impact
4. Wait for acknowledgment before public disclosure

---

## Quick Reference

| Security Need                    | Command                     | Purpose          |
| -------------------------------- | --------------------------- | ---------------- |
| Scan for secrets (current files) | `npm run secrets:check`     | Pre-commit check |
| Scan for secrets (git history)   | `npm run secrets:check-git` | Full audit       |
| Check vulnerabilities            | `npm audit`                 | Dependency check |
| Fix vulnerabilities              | `npm audit fix`             | Auto-fix issues  |
| Check outdated deps              | `npm outdated`              | Update check     |
| Update dependencies              | `npm update`                | Apply updates    |

---

## References

- **Gitleaks**: https://github.com/gitleaks/gitleaks
- **npm audit**: https://docs.npmjs.com/cli/v10/commands/npm-audit
- **Dependabot**: https://docs.github.com/en/code-security/dependabot
- **Scripts**: `package.json` (lines 24-25)
