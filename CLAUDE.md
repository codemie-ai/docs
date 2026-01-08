# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docusaurus-based documentation site for AI/Run CodeMie, an AI-powered development platform. Deployed to GitHub Pages at https://codemie-ai.github.io/docs.

**Tech Stack**: Docusaurus 3.9+, TypeScript, React 19, MDX

## Development Commands

### Core Development

```bash
npm start                    # Dev server at http://localhost:3000
npm run build                # Production build (output to build/)
npm run serve                # Serve production build locally
```

### Quality Checks

```bash
npm run check                # Run typecheck + lint + commit validation (run before committing)
npm run validate             # Run all checks including build (comprehensive validation)
npm run typecheck            # TypeScript validation
npm run lint                 # All linters (ESLint, Prettier, Markdown, Spelling)
npm run format               # Auto-fix formatting issues
```

### Individual Linters

```bash
npm run lint:eslint          # ESLint only
npm run lint:prettier        # Prettier check only
npm run lint:markdown        # Markdown linting only
npm run lint:spelling        # Spell checking only
npm run format:eslint        # ESLint auto-fix
npm run format:prettier      # Prettier auto-fix
```

### Commit Message Validation

```bash
npm run commitlint:last      # Validate your last commit
npm run commitlint:test      # Test message: echo "docs(aws): add section" | npm run commitlint:test
```

### Security

```bash
npm run secrets:check        # Scan current files (requires Docker)
npm run secrets:check-git    # Scan Git history (requires Docker)
```

## Commit Message Format

**CRITICAL**: This project strictly enforces [Conventional Commits](https://www.conventionalcommits.org/). Git hooks will reject non-compliant commits.

**Format**: `<type>(<scope>): <subject>`

**Required Types**: `docs`, `feat`, `fix`, `style`, `refactor`, `chore`, `revert`

**Required Scopes**: `aws`, `gcp`, `user-guide`, `deployment`, `getting-started`, `config`, `deps`

**Examples**:

```bash
docs(aws): add prerequisites section
feat(gcp): add manual deployment guide
fix(user-guide): correct image paths
chore(deps): update docusaurus to 3.9.2
```

## Directory Structure

```
docs/                           # Documentation content (MDX files)
  ├── admin/                    # Administration guides
  │   ├── configuration/
  │   ├── deployment/
  │   └── update/
  └── user-guide/               # User-facing documentation
      ├── api/
      ├── applications/
      ├── assistants/
      ├── data-source/
      ├── getting-started/      # Onboarding content
      ├── ide/
      ├── integrations/
      ├── tools/
      └── workflows/

src/                            # React components and styling
  ├── components/               # Custom React components (FeatureCard, FeatureGrid)
  └── css/                      # Global styles

static/                         # Static assets (logo, favicon, global images only)
  └── img/

docusaurus.config.ts            # Main Docusaurus configuration
sidebars.ts                     # Documentation sidebar structure (700+ lines)
```

## Key Configuration Files

- **docusaurus.config.ts**: Site config, navbar, footer, theme, plugins (local search, image zoom)
- **sidebars.ts**: Large sidebar configuration (~700 lines) defining entire doc structure
- **cspell.config.yaml**: Spell checker with project dictionary
- **.prettierrc.json**: 2 spaces, single quotes, no trailing commas on embedded languages
- **.markdownlint.json**: Many rules disabled for flexibility
- **commitlint.config.js**: Commit message validation rules

## Docusaurus-Specific Configuration

- **Route Base Path**: Documentation is at root (`/`) not `/docs/`
- **MDX Support**: All documentation uses MDX (Markdown + JSX)
- **Versioning**: Currently only "Latest" version active
- **Edit URLs**: GitHub edit links point to `tree/main/`
- **Broken Links**: `onBrokenLinks: 'throw'` - build fails on broken internal links
- **Broken Markdown Links**: `onBrokenMarkdownLinks: 'warn'` - only warns
- **Plugins**: Local search (@easyops-cn/docusaurus-search-local), image zoom (docusaurus-plugin-image-zoom)

## Image Management Pattern

### CRITICAL: Use Local Images

Images must be stored **locally** next to the documentation, not in global `static/` folder.

**Correct Pattern**:

```
docs/user-guide/assistants/
├── images/                    # ✅ Images stored locally
│   ├── architecture.png
│   └── diagram.png
└── overview.md                # ✅ References: ./images/architecture.png
```

**Markdown Reference**:

```markdown
# ✅ Correct - Relative path to local images
![Architecture Diagram](./images/architecture.png)

# ❌ Incorrect - Absolute path to static folder
![Architecture Diagram](/img/user-guide/assistants/architecture.png)
```

**Benefits**: Images colocated with content, easier maintenance, Docusaurus optimization, clear ownership.

**Exception**: Only use `static/` for truly shared assets (logo, favicon, brand assets).

## Front Matter and Document IDs

### Required Front Matter

Every markdown file must have front matter:

```yaml
---
id: overview # Used in sidebar references
title: Full Page Title # Displayed at top of page
sidebar_label: Short Label # Displayed in sidebar
sidebar_position: 1 # Order in sidebar
---
```

### CRITICAL: Document IDs vs Filenames

Sidebar configuration must reference the `id` from front matter, NOT the filename.

**Example**:

**File**: `docs/admin/deployment/01-overview.md`

**Front Matter**:

```yaml
---
id: overview # ← This is the document ID
title: Deployment Overview
sidebar_label: Overview
sidebar_position: 1
---
```

**Sidebar Configuration** (`sidebars.ts`):

```typescript
// ✅ Correct - Uses front matter ID
items: ['admin/deployment/overview', 'admin/deployment/prerequisites'];

// ❌ Incorrect - Uses filename
items: ['admin/deployment/01-overview']; // Will cause error!
```

### Numbering Convention

- **Filenames**: Can be numbered for filesystem ordering (`01-overview.md`, `02-prerequisites.md`)
- **Document IDs**: Should be clean, semantic names without numbers (`overview`, `prerequisites`)
- **Sidebar Position**: Use `sidebar_position` in front matter for ordering

### Pagination Buttons (Previous/Next)

Control Previous/Next navigation using front matter. Use pagination to create logical flows through sequential content.

#### Navigation Patterns

**1. Linear Workflows (Deployment Guides, Multi-Step Processes)**

Chain pages together with both prev and next buttons:

```yaml
# Example: Deployment flow
pagination_prev: admin/deployment/aws/prerequisites
pagination_next: admin/deployment/aws/infrastructure-deployment/infrastructure-deployment-overview
```

**Complete flow**: Overview → Prerequisites → Architecture → Infrastructure → Components → Configuration

**2. Section Overview Pages**

Link back to parent, forward to recommended entry point:

```yaml
# Example: Components Deployment Overview
pagination_prev: admin/deployment/aws/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/components-scripted-deployment
```

**3. Multi-Step Sequential Sections**

Guide through each step, then to next section:

```yaml
# Manual deployment overview
pagination_prev: admin/deployment/aws/components-deployment/components-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/storage-and-ingress

# First step
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/data-layer

# Last step
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/configuration/index  # Transition to next major section
```

**4. Terminal Pages (Standalone Topics)**

Link back to section overview, no next button:

```yaml
# Configuration pages, reference docs, extension details
pagination_prev: admin/configuration/index
pagination_next: null
```

#### Decision Rules

**Use next button when:**

- Page is part of a sequential workflow
- There's a clear "what's next" step
- Users need guidance to the next logical action

**Use `pagination_next: null` when:**

- Page is standalone/reference material
- Multiple valid paths exist (let users choose from sidebar)
- Content doesn't require sequential reading

**Best Practices:**

- Use full document ID paths (`admin/deployment/aws/overview`)
- Create clear, linear flows for processes
- End workflows by guiding to the next logical section
- Test navigation to avoid dead ends

## MDX Syntax Guidelines

### CRITICAL: Angle Brackets

MDX interprets angle brackets `<text>` as JSX/HTML tags. Always wrap placeholder text in backticks.

```markdown
# ❌ Will cause MDX compilation error
Replace <your-domain> with your domain
Value: <public_or_private_ip>

# ✅ Correct - Wrapped in backticks
Replace `<your-domain>` with your domain
Value: `<public_or_private_ip>`
```

**In Tables**:

```markdown
# ❌ Error
| URL                  | Description     |
| -------------------- | --------------- |
| https://app.<domain> | Application URL |

# ✅ Correct
| URL                    | Description     |
| ---------------------- | --------------- |
| `https://app.<domain>` | Application URL |
```

### Docusaurus Admonitions

Use Docusaurus admonitions instead of HTML:

```markdown
# ❌ Avoid HTML
<div class="note">This is important</div>

# ✅ Use Docusaurus admonitions
:::note
This is important
:::

:::tip
Pro tip here
:::

:::info
Additional information
:::

:::warning
Be careful!
:::

:::danger
Critical warning!
:::
```

### Code Blocks

Always specify language for syntax highlighting:

````markdown
# ✅ Good - With language
```bash
kubectl get pods -n codemie
```

```yaml
apiVersion: v1
kind: ConfigMap
```

# ❌ Avoid - No language
```
kubectl get pods
```
````

### Internal Links

**CRITICAL**: Always use relative paths for internal documentation links. Absolute paths break in PR preview deployments to S3.

```markdown
# ✅ Correct - Relative paths (works in PR previews)
See the [Prerequisites](./prerequisites) section.
See the [AWS Guide](../deployment/aws/overview) from another section.

# ❌ Incorrect - Absolute path (breaks PR previews)
See the [Prerequisites](/docs/deployment-guide/gcp/prerequisites) section.
```

**Exception**: FeatureCard components in `.mdx` files use Docusaurus paths like `/configuration-guide/page` which are handled with correct baseUrl.

## Sidebar Configuration

### CRITICAL: Managing Nested Navigation and Dropdowns

When documentation has nested subdirectories with multiple related pages, the sidebar MUST reflect this nested structure using categories with proper dropdowns.

**Problem**: Flat sidebar with nested content results in missing navigation and inaccessible pages.

#### ❌ Incorrect - Flat Structure

```typescript
// File structure:
// docs/admin/deployment/
//   ├── infrastructure/
//   │   ├── index.md (id: infrastructure-overview)
//   │   ├── scripted.md (id: infrastructure-scripted)
//   │   └── manual.md (id: infrastructure-manual)

// Sidebar (WRONG):
items: [
  {
    type: 'doc',
    id: 'admin/deployment/infrastructure/infrastructure-overview',
    label: 'Infrastructure',
  },
  // ❌ Sub-pages missing - no way to navigate to them!
];
```

#### ✅ Correct - Nested Categories

```typescript
items: [
  {
    type: 'category',
    label: 'Infrastructure',
    link: {
      type: 'doc',
      id: 'admin/deployment/infrastructure/infrastructure-overview',
    },
    collapsed: true, // Creates dropdown
    items: [
      'admin/deployment/infrastructure/infrastructure-scripted',
      'admin/deployment/infrastructure/infrastructure-manual',
    ],
  },
];
```

### When to Use Categories with Dropdowns

Use nested categories when:

1. Directory has multiple files (more than just `index.md`)
2. Logical grouping exists (files are related sub-topics)
3. User needs navigation (must access all pages from sidebar)

### Checklist: Adding New Section with Sub-Pages

- [ ] Create directory with descriptive name
- [ ] Add `index.md` with proper front matter including `id` field
- [ ] Create sub-page files with front matter including `id` fields
- [ ] Update `sidebars.ts` with nested category structure
- [ ] Use `type: 'category'` with `link` pointing to index page
- [ ] Add all sub-page IDs to `items` array
- [ ] Set `collapsed: true` for dropdown behavior
- [ ] Test all pages accessible via navigation
- [ ] Verify dropdown arrows appear

## Adding New Documentation

### Step-by-Step Process

1. **Create Markdown File**

```bash
touch docs/user-guide/section/05-new-page.md
```

2. **Add Front Matter**

```yaml
---
id: new-page # Clean ID without numbers
title: New Page Title # Full title
sidebar_label: New Page # Short label for sidebar
sidebar_position: 5 # Order in sidebar
pagination_prev: section/overview # Link to section overview
pagination_next: null # No next button for terminal pages
---
```

3. **Add Images (if needed)**

```bash
mkdir -p docs/user-guide/section/images
cp /path/to/image.png docs/user-guide/section/images/
```

4. **Reference Images**

```markdown
![Description](./images/image.png)
```

5. **Update Sidebar** (`sidebars.ts`):

```typescript
items: [
  'user-guide/section/overview',
  'user-guide/section/new-page', // Add document ID here
  'user-guide/section/other',
];
```

6. **Test Locally**

```bash
npm start
```

Verify: page renders, sidebar shows it, images display, links work.

## Troubleshooting Common Issues

### MDX Compilation Errors

**Error**: "Expected a closing tag for `<text>`"

**Cause**: Angle brackets interpreted as HTML tags

**Solution**: Wrap in backticks: `Replace your \`<domain>\` here`

### Sidebar Errors

**Error**: "These sidebar document ids do not exist"

**Cause**: Sidebar references filename instead of front matter ID

**Solution**: Use the `id` from front matter, not filename:

```typescript
// ✅ Use: 'admin/deployment/overview'
// ❌ Not: 'admin/deployment/01-overview'
```

### Missing Navigation

**Problem**: Page exists but has no sidebar navigation

**Cause**: Flat sidebar structure for nested directory

**Solution**: Convert to nested category with dropdown (see Sidebar Configuration section)

## CI/CD Pipeline

Pull requests automatically validate:

- Conventional Commits format (commit messages and PR title)
- Secrets detection (Gitleaks scan)
- Code quality (TypeScript, ESLint, Prettier, Markdown, Spell checking)
- Build verification

Merges to `main` trigger automatic deployment to GitHub Pages.

## Husky Git Hooks

**Pre-commit**: Runs `npm run typecheck` and `npm run lint`

**Commit-msg**: Validates Conventional Commits format

If hooks fail, commit is blocked. Use `npm run check` before committing.

## Testing Checklist

Before committing documentation changes:

- [ ] Run `npm start` and verify no errors
- [ ] Check all pages render correctly
- [ ] Verify images display properly
- [ ] Test all internal links work
- [ ] Confirm sidebar navigation works
- [ ] Check for MDX compilation warnings
- [ ] Verify code blocks have syntax highlighting
- [ ] Stop server after testing
- [ ] Run `npm run check` to validate all quality checks
- [ ] Use `npm run format` to auto-fix formatting if needed

## Best Practices Summary

### ✅ Do This

- Store images locally in `images/` folder next to docs
- Use relative paths for images: `./images/file.png`
- Use relative paths for internal links: `./page` or `../section/page`
- Reference document IDs from front matter in sidebar
- Wrap placeholders in backticks: `` `<placeholder>` ``
- Use Docusaurus admonitions: `:::info`, `:::warning`, `:::tip`
- Specify language in code blocks: ` ```bash `
- Number filenames for ordering: `01-overview.md`
- Use clean IDs in front matter: `id: overview`
- Create nested categories for directories with multiple pages
- Configure pagination buttons: section overviews link to parent, terminal pages set `pagination_next: null`

### ❌ Don't Do This

- Don't store images in global `static/img/` folder (except shared assets)
- Don't use absolute paths for images: `/img/file.png`
- Don't use absolute paths for internal links (breaks PR previews)
- Don't reference filenames in sidebar: `01-overview`
- Don't use raw angle brackets: `<placeholder>`
- Don't use HTML for callouts: `<div class="note">`
- Don't skip language in code blocks
- Don't use numbers in document IDs: `id: 01-overview`
- Don't use flat sidebar structure for nested directories
