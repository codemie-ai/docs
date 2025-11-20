# Documentation Repository Guide

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Docusaurus-based documentation repository for AI/Run CodeMie. The repository follows standard Docusaurus conventions with some project-specific patterns.

**Tech Stack**:

- Docusaurus 3.x
- TypeScript for configuration
- MDX for documentation pages
- React components for interactive elements

---

## Directory Structure

```
docs/
├── docs/                           # Documentation content
│   ├── user-guide/                # User-facing documentation
│   └── deployment-guide/          # Deployment documentation
│       ├── aws/                   # AWS-specific deployment
│       │   ├── images/           # Local images for AWS docs
│       │   └── *.md              # AWS documentation pages
│       └── gcp/                   # GCP-specific deployment
│           ├── images/           # Local images for GCP docs
│           └── *.md              # GCP documentation pages
├── src/                           # React components and custom code
├── static/                        # Global static assets
├── sidebars.ts                    # Sidebar configuration
├── docusaurus.config.ts          # Main Docusaurus configuration
└── package.json                   # Dependencies
```

---

## Image Management Pattern

### Correct Pattern: Local Images

Images should be stored **locally** next to the documentation that uses them, not in the global `static/` folder.

```
docs/deployment-guide/aws/
├── images/                        # ✅ Images stored locally
│   ├── architecture.png
│   └── diagram.png
├── overview.md                    # ✅ References: ./images/architecture.png
└── prerequisites.md
```

**Markdown Reference**:

```markdown
# ✅ Correct - Relative path to local images

![Architecture Diagram](./images/architecture.png)

# ❌ Incorrect - Absolute path to static folder

![Architecture Diagram](/img/deployment-guide/aws/architecture.png)
```

**Benefits**:

- Images are colocated with content
- Easier to maintain and refactor
- Docusaurus can optimize image loading
- Clear ownership of assets

### Exception: Shared Assets

Only use `static/` folder for truly shared assets:

- Logo files
- Brand assets
- Icons used across multiple sections

---

## Front Matter and Document IDs

### Front Matter Structure

Every markdown file must have front matter with these required fields:

```yaml
---
id: overview # Used in sidebar references
title: Full Page Title # Displayed at top of page
sidebar_label: Short Label # Displayed in sidebar
sidebar_position: 1 # Order in sidebar
---
```

### Document IDs vs Filenames

**Critical Rule**: Sidebar configuration must reference the `id` from front matter, NOT the filename.

#### Example

**File**: `docs/deployment-guide/gcp/01-overview.md`

**Front Matter**:

```yaml
---
id: overview # ← This is the document ID
title: AI/Run Deployment Guide on GCP
sidebar_label: Overview
sidebar_position: 1
---
```

**Sidebar Configuration** (`sidebars.ts`):

```typescript
// ✅ Correct - Uses front matter ID
items: ['deployment-guide/gcp/overview', 'deployment-guide/gcp/prerequisites'];

// ❌ Incorrect - Uses filename
items: [
  'deployment-guide/gcp/01-overview', // Will cause error!
  'deployment-guide/gcp/02-prerequisites', // Will cause error!
];
```

### Numbering Convention

- **Filenames**: Can be numbered for filesystem ordering (`01-overview.md`, `02-prerequisites.md`)
- **Document IDs**: Should be clean, semantic names without numbers (`overview`, `prerequisites`)
- **Sidebar Position**: Use `sidebar_position` in front matter for ordering, not filename numbers

---

## MDX Syntax Guidelines

### Critical: Angle Brackets

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
# ❌ Will cause error in table cells

| URL                  | Description     |
| -------------------- | --------------- |
| https://app.<domain> | Application URL |

# ✅ Correct - Wrapped in backticks

| URL                    | Description     |
| ---------------------- | --------------- |
| `https://app.<domain>` | Application URL |
```

### Docusaurus Admonitions

Use Docusaurus admonitions instead of HTML for callouts:

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

```typescript
const config: Config = {
  title: 'Documentation',
};
```

# ❌ Avoid - No language

```
kubectl get pods
```
````

### Internal Links

Use relative paths for internal documentation links:

```markdown
# ✅ Correct - Relative path

See the [Prerequisites](./prerequisites) section.
Refer to [Infrastructure Deployment](./infrastructure-deployment).

# ❌ Incorrect - Absolute path

See the [Prerequisites](/docs/deployment-guide/gcp/prerequisites) section.
```

---

## Sidebar Configuration

### Structure

The `sidebars.ts` file uses TypeScript and defines the navigation structure.

```typescript
import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  mainSidebar: [
    {
      type: 'doc',
      id: 'index',
      label: 'Home',
    },
    {
      type: 'category',
      label: 'Deployment Guide',
      link: {
        type: 'doc',
        id: 'deployment-guide/aws/overview',
      },
      collapsed: false,
      items: [
        {
          type: 'category',
          label: 'AWS',
          items: [
            'deployment-guide/aws/overview', // Uses front matter ID
            'deployment-guide/aws/prerequisites', // Uses front matter ID
            'deployment-guide/aws/architecture', // Uses front matter ID
          ],
        },
      ],
    },
  ],
};

export default sidebars;
```

### Categories vs Documents

- **Category**: Groups multiple pages, can have nested categories
- **Document**: Single page reference using document ID from front matter

```typescript
// Category with nested items
{
  type: 'category',
  label: 'Infrastructure',
  items: [
    'path/to/doc1',
    'path/to/doc2',
  ],
}

// Single document
{
  type: 'doc',
  id: 'path/to/single-doc',
  label: 'Optional Label',
}

// Or just as string in items array
items: [
  'path/to/doc1',
  'path/to/doc2',
]
```

### Managing Nested Navigation and Dropdowns

**CRITICAL**: When documentation has nested subdirectories with multiple related pages, the sidebar MUST reflect this nested structure using categories with proper dropdowns. Failure to do so results in missing navigation and inaccessible pages.

#### Problem: Flat Structure with Nested Content

❌ **Incorrect** - Flat sidebar with nested file structure:

```typescript
// File structure:
// docs/deployment-guide/aws/
//   ├── infrastructure-deployment/
//   │   ├── index.md (id: infrastructure-deployment-overview)
//   │   ├── scripted-deployment.md (id: infrastructure-scripted-deployment)
//   │   └── manual-deployment.md (id: infrastructure-manual-deployment)

// Sidebar (WRONG):
items: [
  {
    type: 'doc',
    id: 'deployment-guide/aws/infrastructure-deployment/infrastructure-deployment-overview',
    label: 'Infrastructure Deployment',
  },
  // ❌ Sub-pages missing - no way to navigate to them!
];
```

**Result**: Pages like `manual-deployment.md` and `scripted-deployment.md` are orphaned with no navigation bar.

#### Solution: Nested Categories with Dropdowns

✅ **Correct** - Nested sidebar structure:

```typescript
items: [
  {
    type: 'category',
    label: 'Infrastructure Deployment',
    link: {
      type: 'doc',
      id: 'deployment-guide/aws/infrastructure-deployment/infrastructure-deployment-overview',
    },
    collapsed: true, // Creates dropdown
    items: [
      'deployment-guide/aws/infrastructure-deployment/infrastructure-scripted-deployment',
      'deployment-guide/aws/infrastructure-deployment/infrastructure-manual-deployment',
    ],
  },
];
```

**Result**: Parent page is clickable, dropdown arrow shows sub-pages, full navigation available.

#### When to Use Categories with Dropdowns

Use nested categories when:

1. **Directory has multiple files** - More than just an `index.md`
2. **Logical grouping exists** - Files are related sub-topics
3. **User needs navigation** - Users must access all pages from sidebar

#### Real-World Example: Multi-Level Nesting

```typescript
{
  type: 'category',
  label: 'Components Deployment',
  link: {
    type: 'doc',
    id: 'deployment-guide/aws/components-deployment/components-deployment-overview',
  },
  collapsed: true,
  items: [
    'deployment-guide/aws/components-deployment/components-scripted-deployment',
    {
      type: 'category',
      label: 'Manual Deployment',
      link: {
        type: 'doc',
        id: 'deployment-guide/aws/components-deployment/manual-deployment/manual-deployment-overview',
      },
      collapsed: true,
      items: [
        'deployment-guide/aws/components-deployment/manual-deployment/storage-and-ingress',
        'deployment-guide/aws/components-deployment/manual-deployment/security-and-identity',
        'deployment-guide/aws/components-deployment/manual-deployment/data-layer',
        'deployment-guide/aws/components-deployment/manual-deployment/core-components',
        'deployment-guide/aws/components-deployment/manual-deployment/plugin-engine',
        'deployment-guide/aws/components-deployment/manual-deployment/observability',
      ],
    },
  ],
}
```

#### Step-by-Step: Converting Flat to Nested Navigation

**Scenario**: You discover that `http://localhost:3000/docs/section/subsection/page` has no sidebar navigation.

1. **Audit File Structure**

```bash
find docs/section -type f -name "*.md" | sort
```

Check if there are multiple files in the subdirectory.

2. **Check Front Matter IDs**

```bash
grep "^id:" docs/section/subsection/*.md
```

Collect all document IDs from front matter. Add missing `id` fields if necessary.

3. **Update Sidebar Configuration**

Replace flat reference:

```typescript
// Before (WRONG)
{
  type: 'doc',
  id: 'section/subsection/index',
  label: 'Subsection',
}
```

With nested category:

```typescript
// After (CORRECT)
{
  type: 'category',
  label: 'Subsection',
  link: {
    type: 'doc',
    id: 'section/subsection/overview-page-id', // Index page ID
  },
  collapsed: true,
  items: [
    'section/subsection/page1-id',
    'section/subsection/page2-id',
    'section/subsection/page3-id',
  ],
}
```

4. **Verify All IDs Exist**

Ensure every ID in `items` array matches an `id` field in front matter. Use document IDs, not filenames.

5. **Test Navigation**

```bash
npm start
```

- Navigate to parent page - should be clickable
- Check dropdown arrow appears
- Verify all sub-pages accessible
- Confirm no console errors

#### Checklist: Adding New Section with Sub-Pages

- [ ] Create directory with descriptive name
- [ ] Add `index.md` with proper front matter including `id` field
- [ ] Create sub-page files with front matter including `id` fields
- [ ] Update `sidebars.ts` with nested category structure
- [ ] Use `type: 'category'` with `link` pointing to index page
- [ ] Add all sub-page IDs to `items` array
- [ ] Set `collapsed: true` for dropdown behavior
- [ ] Test all pages are accessible via navigation
- [ ] Verify dropdown arrows appear where expected

#### Common Mistake: Missing Index Page ID

❌ **Wrong**:

```yaml
# docs/section/index.md
---
sidebar_position: 4
title: Section Title
---
```

✅ **Correct**:

```yaml
# docs/section/index.md
---
id: section-overview # ← Must have ID for sidebar reference!
sidebar_position: 4
title: Section Title
---
```

Without the `id` field, you cannot reference the page as a category link in the sidebar.

---

## Common Markdown Conventions

### Headers

Use ATX-style headers with proper hierarchy:

```markdown
# Page Title (h1) - One per page

## Major Section (h2)

### Subsection (h3)

#### Minor Section (h4)
```

### Tables

Keep tables simple and readable:

```markdown
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Value 1  | Value 2  | Value 3  |
| Value 4  | Value 5  | Value 6  |
```

**For Complex Content**:

- Wrap URLs in backticks: `` `https://example.com` ``
- Wrap code snippets in backticks: `` `kubectl get pods` ``
- Keep cell content concise

### Lists

```markdown
# Unordered lists

- Item 1
- Item 2
  - Nested item
  - Another nested item
- Item 3

# Ordered lists

1. First step
2. Second step
   - Sub-point
   - Another sub-point
3. Third step

# Task lists

- [x] Completed task
- [ ] Pending task
- [ ] Another pending task
```

---

## Adding New Documentation

### Step-by-Step Process

#### 1. Create Markdown File

```bash
# Create file with numbered prefix for ordering
touch docs/deployment-guide/aws/05-new-section.md
```

#### 2. Add Front Matter

```yaml
---
id: new-section # Clean ID without numbers
title: New Section Title # Full title
sidebar_label: New Section # Short label for sidebar
sidebar_position: 5 # Order in sidebar
---
```

#### 3. Add Images (if needed)

```bash
# Create images folder if it doesn't exist
mkdir -p docs/deployment-guide/aws/images

# Copy images
cp /path/to/image.png docs/deployment-guide/aws/images/
```

#### 4. Reference Images

```markdown
![Description](./images/image.png)
```

#### 5. Update Sidebar

Edit `sidebars.ts`:

```typescript
items: [
  'deployment-guide/aws/overview',
  'deployment-guide/aws/prerequisites',
  'deployment-guide/aws/new-section', // Add document ID here
  'deployment-guide/aws/architecture',
];
```

#### 6. Test Locally

```bash
npm start
```

Visit `http://localhost:3000` and verify:

- Page renders correctly
- Sidebar shows the new page
- Images display properly
- Links work

---

## Troubleshooting Common Issues

### MDX Compilation Errors

#### Error: "Expected a closing tag for `<text>`"

**Cause**: Angle brackets interpreted as HTML tags

**Solution**: Wrap in backticks

```markdown
# Before (error)

Enter your <domain> here

# After (works)

Enter your `<domain>` here
```

#### Error: "Markdown image couldn't be resolved"

**Cause**: Image path is incorrect or file doesn't exist

**Solution**:

1. Verify image file exists
2. Use correct relative path
3. Check file extension matches

```markdown
# Check these:

- File exists at: docs/section/images/file.png
- Reference uses: ./images/file.png
- Extension matches (case-sensitive)
```

### Sidebar Errors

#### Error: "These sidebar document ids do not exist"

**Cause**: Sidebar references filename instead of front matter ID

**Solution**: Use the `id` from front matter

```typescript
// Check front matter in file
---
id: overview           // ← Use this in sidebar
---

// Sidebar should use:
'deployment-guide/aws/overview'  // ✅

// Not:
'deployment-guide/aws/01-overview'  // ❌
```

### Build Warnings

#### Warning: "onBrokenMarkdownLinks is deprecated"

This is a known Docusaurus v3 warning and can be ignored during migration.

---

## Best Practices Summary

### ✅ Do This

- Store images locally in `images/` folder next to docs
- Use relative paths for images: `./images/file.png`
- Reference document IDs from front matter in sidebar
- Wrap placeholders in backticks: `` `<placeholder>` ``
- Use Docusaurus admonitions: `:::info`, `:::warning`, `:::tip`
- Specify language in code blocks: ` ```bash `
- Number filenames for ordering: `01-overview.md`
- Use clean IDs in front matter: `id: overview`

### ❌ Don't Do This

- Don't store images in global `static/img/` folder
- Don't use absolute paths for images: `/img/file.png`
- Don't reference filenames in sidebar: `01-overview`
- Don't use raw angle brackets: `<placeholder>`
- Don't use HTML for callouts: `<div class="note">`
- Don't skip language in code blocks
- Don't use numbers in document IDs: `id: 01-overview`

---

## Quick Reference

### File Naming Convention

```
01-overview.md              → id: overview
02-prerequisites.md         → id: prerequisites
03-architecture.md          → id: architecture
```

### Image Reference

```markdown
![Alt Text](./images/filename.png)
```

### Sidebar Entry

```typescript
'section/subsection/document-id'; // From front matter ID
```

### Common Admonitions

```markdown
:::note
Standard note
:::

:::tip
Helpful tip
:::

:::info
Additional info
:::

:::warning
Caution
:::

:::danger
Critical warning
:::
```

### Code Block with Language

````markdown
```bash
command here
```

```typescript
const code: string = 'here';
```

```yaml
key: value
```
````

---

## Testing Checklist

Before committing documentation changes:

- [ ] Run `npm start` and verify no errors
- [ ] Check all pages render correctly
- [ ] Verify images display properly
- [ ] Test all internal links work
- [ ] Confirm sidebar navigation works
- [ ] Check for MDX compilation warnings
- [ ] Verify code blocks have syntax highlighting
- [ ] Test on both light and dark themes (if applicable)
- [ ] Stop server after testing
- [ ] Run `npm run typecheck` for TypeScript validation
- [ ] Run `npm run lint:eslint` for ESLint checks
- [ ] Run `npm run lint:prettier` for format validation
- [ ] Run `npm run lint:markdown` for Markdown linting

---

## Additional Resources

- [Docusaurus Documentation](https://docusaurus.io/docs)
- [MDX Documentation](https://mdxjs.com/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Docusaurus Markdown Features](https://docusaurus.io/docs/markdown-features)

---

## Getting Help

If you encounter issues not covered in this guide:

1. Check Docusaurus documentation
2. Review error messages carefully - they're usually specific
3. Look at existing documentation for patterns
4. Test changes locally before committing
