# Development Practices - Docusaurus Documentation

**Project**: AI/Run CodeMie Documentation
**Language**: TypeScript/JavaScript | **Framework**: Docusaurus 3.9.2
**Linter**: ESLint 9.39.1 | **Formatter**: Prettier 3.6.2

---

## Code Style

### File Naming Conventions

| Element          | Convention       | Example                                  |
| ---------------- | ---------------- | ---------------------------------------- |
| Markdown files   | `kebab-case.md`  | `getting-started.md`, `prerequisites.md` |
| Config files     | `kebab-case.ts`  | `docusaurus.config.ts`, `sidebars.ts`    |
| React components | `PascalCase.tsx` | `HomepageFeatures.tsx`                   |
| Directories      | `kebab-case/`    | `deployment-guide/`, `user-guide/`       |
| Images           | `kebab-case.png` | `architecture-diagram.png`               |

### Numbered Files for Ordering

```
Filename:    01-overview.md              # Filesystem order
Front Matter: id: overview               # Sidebar reference
Sidebar:     'section/overview'          # Uses ID, not filename
```

### MDX File Structure

```markdown
---
id: clean-semantic-id           # No numbers, no file extension
title: Full Page Title          # Displayed at top of page
sidebar_label: Short Label      # Displayed in sidebar
sidebar_position: 1             # Order in sidebar
---

# Page Title (matches front matter title)

Introduction paragraph.

## Major Section

Content here.

### Subsection

More content.
```

---

## Code Quality

### Commands

| Action          | Command                 | Auto-fix                  |
| --------------- | ----------------------- | ------------------------- |
| Lint (all)      | `npm run lint`          | `npm run format`          |
| Lint (ESLint)   | `npm run lint:eslint`   | `npm run format:eslint`   |
| Lint (Prettier) | `npm run lint:prettier` | `npm run format:prettier` |
| Lint (Markdown) | `npm run lint:markdown` | -                         |
| Lint (Spelling) | `npm run lint:spelling` | -                         |
| Type check      | `npm run typecheck`     | -                         |
| All checks      | `npm run check`         | -                         |
| Full validation | `npm run validate`      | -                         |

### Configuration Files

| Tool         | Config File                | Purpose                       |
| ------------ | -------------------------- | ----------------------------- |
| ESLint       | `eslint.config.js`         | JavaScript/TypeScript linting |
| Prettier     | `.prettierrc`              | Code formatting               |
| Markdownlint | `.markdownlint-cli2.jsonc` | Markdown style                |
| CSpell       | `cspell.json`              | Spell checking                |
| TypeScript   | `tsconfig.json`            | Type checking                 |
| Commitlint   | `commitlint.config.js`     | Commit message format         |

### Pre-commit Hooks

```bash
# Automatically installed with npm install
# Managed by Husky in .husky/
```

**Runs on commit**:

- TypeScript type checking
- ESLint validation
- Prettier format check
- Markdown linting
- Spell checking
- Commit message validation (Conventional Commits)

---

## MDX Syntax Patterns

### Critical: Angle Brackets

MDX interprets `<text>` as JSX/HTML tags. **Always wrap placeholders in backticks**.

```markdown
❌ Wrong - Causes compilation error:
Replace <your-domain> with your domain

✅ Correct - Wrapped in backticks:
Replace `<your-domain>` with your domain
```

### Code Blocks

Always specify language for syntax highlighting:

````markdown
✅ Correct:
```bash
npm install
```

```typescript
const config: Config = { ... };
```

❌ Wrong - No language:
```
npm install
```
````

### Admonitions

Use Docusaurus admonitions instead of HTML:

```markdown
:::note
This is important information.
:::

:::tip
Helpful tip here.
:::

:::warning
Be careful with this.
:::

:::danger
Critical warning!
:::
```

### Internal Links

Use relative paths for internal documentation links:

```markdown
✅ Correct:
See the [Prerequisites](./prerequisites) section.

❌ Wrong - Absolute path:
See the [Prerequisites](/docs/deployment-guide/prerequisites) section.
```

---

## Front Matter Patterns

### Required Fields

Every markdown file must have front matter with these fields:

```yaml
---
id: semantic-name              # Clean ID without numbers
title: Full Page Title         # Displayed at top
sidebar_label: Short Label     # Displayed in sidebar
sidebar_position: 1            # Order in sidebar (optional)
---
```

### Document IDs vs Filenames

**Critical Rule**: Sidebar configuration references the `id` field, NOT the filename.

```typescript
// File: docs/deployment-guide/aws/01-prerequisites.md
// Front matter: id: prerequisites

// Sidebar (CORRECT):
'deployment-guide/aws/prerequisites'

// Sidebar (WRONG):
'deployment-guide/aws/01-prerequisites'  // ❌ Will cause error
```

---

## Image Management

### Local Images Pattern

Store images **locally** next to the documentation that uses them:

```
docs/deployment-guide/aws/
├── images/                    # ✅ Images stored locally
│   ├── architecture.png
│   └── diagram.png
├── overview.md               # References: ./images/architecture.png
└── prerequisites.md
```

### Markdown Reference

```markdown
✅ Correct - Relative path:
![Architecture Diagram](./images/architecture.png)

❌ Wrong - Absolute path to static folder:
![Architecture Diagram](/img/deployment-guide/aws/architecture.png)
```

### Global Assets Exception

Only use `static/img/` for truly shared assets:

- Logo files
- Brand assets
- Favicon
- Icons used across multiple sections

---

## Sidebar Configuration

### Nested Navigation Pattern

**Critical**: When a directory has multiple files, use nested categories with dropdowns:

```typescript
// ✅ Correct - Nested category for multi-page section:
{
  type: 'category',
  label: 'Infrastructure Deployment',
  link: {
    type: 'doc',
    id: 'deployment-guide/aws/infrastructure-deployment/infrastructure-deployment-overview',
  },
  collapsed: true,
  items: [
    'deployment-guide/aws/infrastructure-deployment/infrastructure-scripted-deployment',
    'deployment-guide/aws/infrastructure-deployment/infrastructure-manual-deployment',
  ],
}

// ❌ Wrong - Flat reference misses sub-pages:
{
  type: 'doc',
  id: 'deployment-guide/aws/infrastructure-deployment/infrastructure-deployment-overview',
  label: 'Infrastructure Deployment',
}
// Sub-pages are now orphaned with no navigation!
```

### Category vs Document

```typescript
// Single page reference
'path/to/document-id'

// Or with label override
{
  type: 'doc',
  id: 'path/to/document-id',
  label: 'Custom Label',
}

// Category with multiple pages
{
  type: 'category',
  label: 'Section Name',
  link: { type: 'doc', id: 'path/to/index-page' },
  collapsed: true,
  items: [
    'path/to/page1',
    'path/to/page2',
  ],
}
```

---

## Common Patterns

### Tables with Code

Wrap URLs and code in backticks within table cells:

```markdown
| Parameter | Value | Description |
|-----------|-------|-------------|
| URL | `https://app.<domain>` | Application URL |
| Command | `kubectl get pods` | List pods |
```

### Adding New Documentation

1. **Create file** with numbered prefix: `docs/section/05-new-topic.md`
2. **Add front matter** with clean `id`:
   ```yaml
   ---
   id: new-topic
   title: New Topic
   sidebar_label: New Topic
   sidebar_position: 5
   ---
   ```
3. **Update sidebar** with document ID: `'section/new-topic'`
4. **Test locally**: `npm start`
5. **Validate**: `npm run check`

---

## Quality Checklist

Before committing documentation changes:

- [ ] Run `npm start` and verify no errors
- [ ] Check all pages render correctly
- [ ] Verify images display properly
- [ ] Test all internal links work
- [ ] Confirm sidebar navigation works
- [ ] Check for MDX compilation warnings
- [ ] Verify code blocks have syntax highlighting
- [ ] Run `npm run check` to validate all quality checks
- [ ] Use `npm run format` to auto-fix formatting issues if needed

---

## Don't Do

| ❌ Avoid                           | ✅ Instead               | Why                      |
| ---------------------------------- | ------------------------ | ------------------------ |
| Raw angle brackets: `<text>`       | Wrapped: `` `<text>` ``  | MDX parse error          |
| Filename in sidebar: `01-overview` | Document ID: `overview`  | Sidebar validation error |
| Global images: `/img/section/`     | Local: `./images/`       | Maintainability          |
| Absolute internal links            | Relative: `./page`       | Portability              |
| Code blocks without language       | ` ```bash `              | No syntax highlighting   |
| HTML for callouts: `<div>`         | Admonitions: `:::note`   | Docusaurus convention    |
| Skip `npm run check`               | Always run before commit | CI will fail             |

---

## Troubleshooting

### Error: "Expected a closing tag for `<text>`"

**Cause**: Angle brackets interpreted as HTML tags

**Solution**: Wrap in backticks: `` `<text>` ``

### Error: "These sidebar document ids do not exist"

**Cause**: Sidebar references filename instead of front matter `id`

**Solution**: Use `id` from front matter, not filename

### Warning: "Markdown image couldn't be resolved"

**Cause**: Image path is incorrect or file doesn't exist

**Solution**:

1. Verify image file exists at correct path
2. Use relative path: `./images/file.png`
3. Check file extension matches (case-sensitive)

---

## Quick Reference

| Need                 | Location                   |
| -------------------- | -------------------------- |
| ESLint config        | `eslint.config.js`         |
| Prettier config      | `.prettierrc`              |
| Markdown linter      | `.markdownlint-cli2.jsonc` |
| Spell checker config | `cspell.json`              |
| TypeScript config    | `tsconfig.json`            |
| Commitlint config    | `commitlint.config.js`     |
| Pre-commit hooks     | `.husky/`                  |
| Quality check script | `npm run check`            |
| Validation script    | `npm run validate`         |
