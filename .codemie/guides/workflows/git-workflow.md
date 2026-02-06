# Git Workflow - Documentation Repository

## Quick Summary

Git workflow for AI/Run CodeMie Documentation: Conventional Commits, pull requests, automated validation, and GitHub Pages deployment.

**Category**: Standards
**Complexity**: Simple
**Prerequisites**: Git basics, GitHub account

---

## Branching Strategy

| Branch Type | Pattern                      | Purpose                                   |
| ----------- | ---------------------------- | ----------------------------------------- |
| Main        | `main`                       | Production (auto-deploys to GitHub Pages) |
| Feature     | `feature/[description]`      | New documentation sections                |
| Bugfix      | `bugfix/[description]`       | Documentation fixes                       |
| Enhancement | `docs/[scope]-[description]` | Documentation improvements                |

**Example Branches**:

- `feature/aws-deployment-guide`
- `docs/gcp-prerequisites-update`
- `bugfix/fix-broken-image-links`

---

## Contribution Workflow

```bash
# 1. Fork repository and create branch
git checkout main
git pull
git checkout -b docs/aws-add-prerequisites

# 2. Make changes, test locally
npm start                    # Preview at http://localhost:3000

# 3. Run quality checks
npm run check                # TypeCheck + Lint + Commitlint

# 4. Stage and commit
git add docs/deployment-guide/aws/prerequisites.md
git commit -m "docs(aws): add prerequisites section"

# 5. Push and create PR
git push origin docs/aws-add-prerequisites
# Create PR via GitHub UI
```

---

## Commit Format (Conventional Commits)

**Format**:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

| Type       | Use When                                   |
| ---------- | ------------------------------------------ |
| `docs`     | Documentation content changes              |
| `feat`     | New documentation features or sections     |
| `fix`      | Fix typos, broken links, incorrect info    |
| `style`    | Formatting, whitespace (no content change) |
| `refactor` | Restructure docs without content change    |
| `chore`    | Build, dependencies, config changes        |
| `revert`   | Revert a previous commit                   |

### Scopes

| Scope             | Use When                                  |
| ----------------- | ----------------------------------------- |
| `aws`             | AWS deployment documentation              |
| `gcp`             | GCP deployment documentation              |
| `azure`           | Azure deployment documentation            |
| `user-guide`      | User guide documentation                  |
| `deployment`      | General deployment topics                 |
| `getting-started` | Getting started guides                    |
| `config`          | Configuration files (docusaurus, sidebar) |
| `deps`            | Dependencies update                       |

### Examples

```bash
# Documentation changes
docs(aws): add prerequisites section
docs(gcp): update architecture diagram
fix(aws): correct image paths

# Feature additions
feat(user-guide): add workflows section
feat(gcp): add manual deployment guide

# Infrastructure changes
chore(deps): update docusaurus to 3.9.2
style(config): format sidebar configuration
```

---

## Commit Message Validation

**Enforced by**: Husky pre-commit hook + CI pipeline

```bash
# Test commit message before committing
echo "docs(aws): add prerequisites" | npm run commitlint:test

# Validate your last commit
npm run commitlint:last
```

**Validation Rules** (from commitlint.config.js):

- Type must be lowercase
- Subject must be lowercase
- Max subject length: 100 characters
- No period at end of subject
- Body must have blank line separator (if present)

---

## Commit Rules

| ✅ DO                             | ❌ DON'T                    |
| --------------------------------- | --------------------------- |
| One logical change per commit     | Mix unrelated changes       |
| Descriptive, specific messages    | "fix stuff", "update docs"  |
| Present tense: "add section"      | Past tense: "added section" |
| Reference issues: "fix #123"      | Skip context                |
| Run `npm run check` before commit | Skip validation             |
| Follow Conventional Commits       | Random format               |

---

## Pull Request Process

### PR Title

**Must follow Conventional Commits format** (enforced by CI):

```
docs(aws): add prerequisites section
feat(gcp): add manual deployment guide
fix(deployment): correct kubectl commands
```

### PR Description Template

```markdown
## Summary
Brief description of changes.

## Changes
- Added prerequisites section to AWS deployment guide
- Updated architecture diagrams
- Fixed broken image links

## Testing
- [ ] Tested locally with `npm start`
- [ ] All links work
- [ ] Images display correctly
- [ ] Sidebar navigation works

## Validation
- [ ] `npm run check` passes
- [ ] No MDX compilation errors
- [ ] Commit messages follow Conventional Commits
```

### PR Checklist

Before submitting PR:

- [ ] Fork repository and create feature branch
- [ ] Test locally with `npm start`
- [ ] Run all checks: `npm run check`
- [ ] Commit messages follow Conventional Commits
- [ ] PR title follows Conventional Commits
- [ ] Images stored locally (not in `static/img/`)
- [ ] No placeholders like `<text>` without backticks
- [ ] Sidebar references document IDs, not filenames

---

## Automated CI/CD Validation

**On Pull Request**, GitHub Actions validates:

1. **Commit Messages**: Conventional Commits format
2. **PR Title**: Conventional Commits format
3. **Secrets Detection**: Gitleaks scan for exposed credentials
4. **Code Quality**:
   - TypeScript type checking
   - ESLint validation
   - Prettier formatting
   - Markdown linting
   - Spell checking
5. **Build Verification**: `npm run build` succeeds

**On Merge to `main`**:

- Automatic deployment to GitHub Pages
- Site available at: https://codemie-ai.github.io/docs

---

## Code Review Guidelines

### Reviewer Checklist

- [ ] Documentation is accurate and clear
- [ ] Grammar and spelling are correct
- [ ] Images display properly and are locally stored
- [ ] Code examples are correct and formatted
- [ ] Links work (internal and external)
- [ ] Sidebar navigation is correct
- [ ] No raw angle brackets in MDX
- [ ] Front matter is complete and correct
- [ ] Commit messages follow Conventional Commits

### Review Comments

**Be specific**:

```
✅ "This image path should be ./images/diagram.png (local), not /img/diagram.png"
✅ "Sidebar should reference 'aws/prerequisites' (ID), not 'aws/01-prerequisites' (filename)"

❌ "Fix this"
❌ "Wrong"
```

---

## Merge Strategy

**Project Standard**: Squash and merge (enforced on GitHub)

All commits in a PR are squashed into a single commit with the PR title as the commit message.

**After Merge**:

- Branch is automatically deleted
- Deployment to GitHub Pages is triggered
- Changes live within minutes

---

## Common Git Commands

### Daily Workflow

```bash
# Check status
git status

# Stage files
git add docs/section/file.md

# Commit with validation
git commit -m "docs(section): add new content"

# Push to remote
git push origin feature/branch-name

# Update from main
git checkout main
git pull
git checkout feature/branch-name
git rebase main
```

### Fixing Mistakes

```bash
# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (keep changes unstaged)
git reset HEAD~1

# Amend last commit message (if not pushed)
git commit --amend -m "docs(aws): corrected commit message"

# Discard local changes to file
git checkout -- docs/section/file.md
```

### Branch Management

```bash
# List all branches
git branch -a

# Delete local branch
git branch -d feature/branch-name

# Delete remote branch
git push origin --delete feature/branch-name

# Switch to main and update
git checkout main
git pull origin main
```

---

## Troubleshooting

### Commit Hook Fails

**Issue**: Pre-commit hook rejects commit

**Common Causes**:

1. Commit message doesn't follow Conventional Commits
2. ESLint errors
3. TypeScript errors
4. Prettier formatting issues

**Solution**:

```bash
# Fix commit message format
git commit -m "docs(scope): lowercase subject"

# Fix code quality issues
npm run format              # Auto-fix formatting
npm run check               # Verify all checks pass
```

### CI Pipeline Fails

**Issue**: GitHub Actions validation fails on PR

**Check**:

1. PR title follows Conventional Commits
2. All commits follow Conventional Commits
3. No secrets detected by Gitleaks
4. Build succeeds locally: `npm run build`

**Solution**:

```bash
# Test locally first
npm run validate            # Runs all checks + build
```

---

## Pre-commit Hook Details

**Location**: `.husky/pre-commit`

**Runs automatically on `git commit`**:

1. TypeScript type checking (`npm run typecheck`)
2. Linting (`npm run lint`)
3. Commit message validation (via `commitlint`)

**Bypass (not recommended)**:

```bash
git commit --no-verify -m "message"
```

---

## References

- **Conventional Commits**: https://www.conventionalcommits.org/
- **Commitlint Config**: `commitlint.config.js`
- **Husky Hooks**: `.husky/`
- **GitHub Actions**: `.github/workflows/`
- **Contributing Guide**: `README.md` (lines 26-99)
