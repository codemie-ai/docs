# Architecture Guide - Docusaurus Documentation Site

**Project**: AI/Run CodeMie Documentation
**Style**: Static Site Generator (Docusaurus)
**Language**: TypeScript/JavaScript | **Framework**: Docusaurus 3.9.2 + React 19

---

## Architecture Overview

This is a Docusaurus-based documentation website following a content-first, plugin-enhanced architecture.

```
Browser ──► Static HTML/JS Bundle
              │
              ├─► Documentation Content (MDX)
              ├─► React Components (UI)
              ├─► Plugins (Search, Zoom)
              └─► Theme & Styling
```

**Key Decision**: Static site generation for fast performance, SEO optimization, and simple deployment. No backend required.

---

## Component Structure

```
docs/
├── docs/                      # Documentation content (MDX files)
│   ├── user-guide/           # End-user documentation
│   ├── deployment-guide/     # Deployment documentation
│   │   ├── aws/             # AWS-specific docs with local images
│   │   ├── azure/           # Azure-specific docs
│   │   └── gcp/             # GCP-specific docs
│   └── index.md             # Homepage
├── src/                      # React components and customization
│   ├── components/          # Custom React components
│   └── css/                 # Custom styling
├── static/                   # Global static assets (logos, favicons)
├── sidebars.ts              # Navigation structure (references doc IDs)
├── docusaurus.config.ts     # Main configuration
└── package.json             # Dependencies and scripts
```

---

## Design Patterns

| Pattern                  | Usage                             | Location                     |
| ------------------------ | --------------------------------- | ---------------------------- |
| **Static Generation**    | Build-time HTML generation        | `npm run build`              |
| **Content Routing**      | File-based routing via MDX        | `docs/**/*.md`               |
| **Plugin Architecture**  | Extend functionality via plugins  | `docusaurus.config.ts:50-64` |
| **Component Override**   | Theme customization via swizzling | `src/components/`            |
| **Front Matter Pattern** | Metadata in YAML headers          | Each `.md` file              |

### Primary Pattern: Content-Driven Architecture

```typescript
// Source: docusaurus.config.ts:28-40
docs: {
  routeBasePath: '/',              // Root-level docs
  sidebarPath: './sidebars.ts',    // Centralized navigation
  sidebarCollapsible: true,        // Interactive navigation
  lastVersion: 'current',
}
```

**When to use**: Static documentation sites with version control, no dynamic backend needed.

---

## Module Responsibilities

| Component              | Responsibility       | Depends On             | Depended By     |
| ---------------------- | -------------------- | ---------------------- | --------------- |
| `docs/`                | Content source (MDX) | Front matter schema    | Build process   |
| `sidebars.ts`          | Navigation structure | Document IDs           | Docusaurus core |
| `docusaurus.config.ts` | Site configuration   | Plugins, theme         | Build process   |
| `src/`                 | Custom UI components | React, Docusaurus APIs | Theme layer     |
| `static/`              | Global assets        | -                      | HTML output     |

---

## Content Organization Rules

**Navigation Pattern** (sidebars.ts:1-693):

- Sidebar references **document IDs** from front matter, NOT filenames
- Categories create dropdowns for nested navigation
- Collapsed state controls default expansion

**File Naming Convention**:

```
Filename:    01-overview.md          (numbered for filesystem order)
Front Matter: id: overview           (clean ID without numbers)
Sidebar:     'path/to/overview'      (references front matter ID)
```

**Dependency Rules:**

| Rule                                           | Enforced By                      |
| ---------------------------------------------- | -------------------------------- |
| Sidebar IDs must match front matter `id` field | Build validation                 |
| Images stored locally next to content          | Convention (see CLAUDE.md:40-81) |
| MDX syntax: angle brackets in backticks        | MDX compiler                     |

**Violations to avoid:**

- ❌ Referencing filenames in sidebar instead of document IDs
- ❌ Storing images in global `static/img/` for section-specific content
- ❌ Using raw angle brackets `<text>` in MDX (causes parse errors)

---

## Content Flow

```
Write MDX → Add Front Matter → Update sidebars.ts → Build → Deploy
   │            │                    │                 │        │
   │        (id, title)         (navigation)      (static)  (GitHub Pages)
   │            │                    │                 │        │
   └────────────┴────────────────────┴─────────────────┴────────┘
                        Local Preview: npm start
```

**Example flow** (Adding new documentation page):

1. Create `docs/section/new-page.md` with front matter
2. Add `id: new-page` to front matter
3. Reference `section/new-page` in `sidebars.ts`
4. Run `npm start` to preview
5. Validate with `npm run check`

---

## Key Abstractions

| Abstraction         | Purpose                        | Location                 |
| ------------------- | ------------------------------ | ------------------------ |
| `SidebarsConfig`    | Type-safe navigation structure | `sidebars.ts:1`          |
| `Config`            | Docusaurus configuration type  | `docusaurus.config.ts:5` |
| Front Matter Schema | Document metadata contract     | Each `.md` header        |

```typescript
// Source: sidebars.ts:1-3
import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = { ... };
```

---

## Adding New Documentation

### To add new documentation page:

1. **Create file**: `docs/section/topic.md`

   ```yaml
   ---
   id: topic
   title: Full Topic Title
   sidebar_label: Short Label
   sidebar_position: 3
   ---
   ```

2. **Add to sidebar**: Update `sidebars.ts`

   ```typescript
   items: [
     'section/existing',
     'section/topic',  // ← Add document ID
   ]
   ```

3. **Add images** (if needed): Create `docs/section/images/` and reference:
   ```markdown
   ![Diagram](./images/diagram.png)
   ```

### To add new documentation section with sub-pages:

1. Create directory: `docs/new-section/`
2. Add index page with `id` field
3. Create sub-pages with `id` fields
4. Update sidebar with nested category:
   ```typescript
   {
     type: 'category',
     label: 'New Section',
     link: { type: 'doc', id: 'new-section/index' },
     collapsed: true,
     items: [
       'new-section/page1',
       'new-section/page2',
     ],
   }
   ```

---

## Configuration & Plugins

| Config Type | Location                     | Purpose                    |
| ----------- | ---------------------------- | -------------------------- |
| Site Config | `docusaurus.config.ts`       | URL, title, theme, plugins |
| Navigation  | `sidebars.ts`                | Sidebar structure          |
| Styling     | `src/css/custom.css`         | Custom CSS overrides       |
| Plugins     | `docusaurus.config.ts:50-64` | Search, image zoom         |

**Active Plugins**:

- `docusaurus-plugin-image-zoom` - Image zoom functionality
- `@easyops-cn/docusaurus-search-local` - Local search

---

## Build & Deployment

| Command         | Purpose                      | Output                  |
| --------------- | ---------------------------- | ----------------------- |
| `npm start`     | Dev server                   | `http://localhost:3000` |
| `npm run build` | Production build             | `build/` directory      |
| `npm run serve` | Serve production build       | Local preview           |
| Deploy          | Automatic on merge to `main` | GitHub Pages            |

---

## Boundaries Summary

| ✅ DO                                | ❌ DON'T                          |
| ------------------------------------ | --------------------------------- |
| Reference document IDs in sidebar    | Reference filenames in sidebar    |
| Store images locally next to content | Store all images in `static/img/` |
| Use front matter for metadata        | Hardcode titles in content        |
| Wrap `<placeholders>` in backticks   | Use raw angle brackets in MDX     |
| Test locally with `npm start`        | Push without local validation     |
| Number filenames for order           | Number document IDs               |

---

## Quick Reference

| Need                   | Location               | Pattern                        |
| ---------------------- | ---------------------- | ------------------------------ |
| Add documentation page | `docs/section/`        | Create `.md` with front matter |
| Update navigation      | `sidebars.ts`          | Add document ID to items array |
| Add React component    | `src/components/`      | Standard React component       |
| Configure plugins      | `docusaurus.config.ts` | Add to `plugins` array         |
| Add global assets      | `static/`              | Logo, favicon only             |
| Custom styling         | `src/css/custom.css`   | CSS overrides                  |
| Run quality checks     | `npm run check`        | Typecheck + lint + commitlint  |
