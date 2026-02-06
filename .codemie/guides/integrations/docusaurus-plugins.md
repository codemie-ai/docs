# Docusaurus Plugins Integration

**Project**: AI/Run CodeMie Documentation
**Framework**: Docusaurus 3.9.2
**Plugins**: Search, Image Zoom

---

## Overview

This documentation site uses Docusaurus plugins to enhance functionality without backend infrastructure.

**Active Plugins**:

1. **Local Search** - Client-side search without external services
2. **Image Zoom** - Click-to-zoom functionality for documentation images

---

## Plugin: Local Search

### Package

**Name**: `@easyops-cn/docusaurus-search-local`
**Version**: ^0.52.1
**Purpose**: Client-side search index (no backend required)

### Configuration

```typescript
// Source: docusaurus.config.ts:52-63
[
  require.resolve('@easyops-cn/docusaurus-search-local'),
  {
    hashed: true,                              // Enable cache busting
    language: ['en'],                          // Search language
    indexDocs: true,                           // Index documentation pages
    indexBlog: false,                          // No blog in this site
    indexPages: false,                         // Don't index other pages
    docsRouteBasePath: '/',                    // Docs are at root
    highlightSearchTermsOnTargetPage: true,    // Highlight search terms
  },
]
```

### How It Works

1. **Build time**: Indexes all documentation content
2. **Runtime**: Loads search index in browser
3. **User search**: Searches locally (no server requests)

### Usage

- Search box appears in navbar
- Type to search across all documentation
- Click result to navigate
- Search terms are highlighted on target page

### Customization

To modify search behavior, edit `docusaurus.config.ts:52-63`:

```typescript
{
  // Index specific sections only
  indexDocs: true,

  // Change search language
  language: ['en', 'zh'],

  // Disable highlight on target page
  highlightSearchTermsOnTargetPage: false,
}
```

---

## Plugin: Image Zoom

### Package

**Name**: `docusaurus-plugin-image-zoom`
**Version**: ^3.0.1
**Purpose**: Click images to zoom/view full size

### Configuration

```typescript
// Source: docusaurus.config.ts:51, 141-147
plugins: [
  require.resolve('docusaurus-plugin-image-zoom'),
],

themeConfig: {
  zoom: {
    selector: '.markdown :not(em) > img:not(.no-zoom)',
    background: {
      light: 'rgb(255, 255, 255)',
      dark: 'rgb(50, 50, 50)',
    },
  },
}
```

### How It Works

1. **Selector**: Targets images in markdown content (excludes emoji and `.no-zoom` class)
2. **Click**: Image opens in overlay
3. **Background**: Adapts to light/dark theme
4. **Close**: Click outside or press ESC

### Usage

Images in markdown automatically support zoom:

```markdown
![Architecture Diagram](./images/architecture.png)
```

**Exclude specific images** from zoom:

```markdown
![Small Icon](./images/icon.png){.no-zoom}
```

Or in HTML:

```html
<img src="./images/icon.png" className="no-zoom" alt="Icon" />
```

### Customization

To modify zoom behavior, edit `docusaurus.config.ts:141-147`:

```typescript
zoom: {
  // Change selector to include all images
  selector: '.markdown img',

  // Change background colors
  background: {
    light: 'rgba(0, 0, 0, 0.8)',
    dark: 'rgba(0, 0, 0, 0.9)',
  },
}
```

---

## Adding New Plugins

### Installation

```bash
# Install plugin package
npm install --save plugin-name

# Or dev dependency
npm install --save-dev plugin-name
```

### Configuration

Add to `docusaurus.config.ts`:

```typescript
// Option 1: Simple plugin (no config)
plugins: [
  'plugin-name',
],

// Option 2: Plugin with configuration
plugins: [
  [
    'plugin-name',
    {
      option1: 'value',
      option2: true,
    },
  ],
],

// Option 3: Plugin with require.resolve
plugins: [
  [
    require.resolve('plugin-name'),
    { /* config */ },
  ],
],
```

### Common Plugin Categories

| Category    | Purpose                  | Examples                                                                |
| ----------- | ------------------------ | ----------------------------------------------------------------------- |
| Search      | Add search functionality | `docusaurus-search-local`, `docusaurus-lunr-search`                     |
| Analytics   | Track page views         | `@docusaurus/plugin-google-analytics`, `@docusaurus/plugin-google-gtag` |
| SEO         | Improve search ranking   | `@docusaurus/plugin-sitemap`, `docusaurus-plugin-seo`                   |
| Content     | Enhance content          | `docusaurus-plugin-image-zoom`, `@docusaurus/plugin-ideal-image`        |
| Development | Dev tools                | `@docusaurus/plugin-debug`, `docusaurus-plugin-sass`                    |

---

## Plugin Resources

### Official Plugins

https://docusaurus.io/docs/api/plugins

**Commonly used**:

- `@docusaurus/plugin-content-docs` (included in preset)
- `@docusaurus/plugin-content-blog` (included in preset)
- `@docusaurus/plugin-sitemap` (included in preset)

### Community Plugins

https://docusaurus.io/community/resources#community-plugins

**Search for plugins**: https://www.npmjs.com/search?q=docusaurus-plugin

---

## Troubleshooting

### Search Not Working

**Issue**: Search box doesn't appear or returns no results

**Solutions**:

1. Rebuild the site: `npm run build`
2. Clear browser cache
3. Check `indexDocs: true` in config
4. Verify `docsRouteBasePath` matches your setup

### Image Zoom Not Working

**Issue**: Clicking images doesn't zoom

**Solutions**:

1. Check image is in markdown content area
2. Verify image doesn't have `.no-zoom` class
3. Check browser console for errors
4. Ensure plugin is in `plugins` array

### Plugin Installation Fails

**Issue**: `npm install` fails for plugin

**Solutions**:

1. Check Node.js version: `node --version` (must be 18.0+)
2. Clear npm cache: `npm cache clean --force`
3. Delete `node_modules` and reinstall: `rm -rf node_modules && npm install`
4. Check plugin compatibility with Docusaurus version

---

## Best Practices

### Plugin Selection

| ✅ DO                                      | ❌ DON'T                    |
| ------------------------------------------ | --------------------------- |
| Use maintained plugins with recent updates | Use abandoned plugins       |
| Check plugin reviews and downloads         | Install without research    |
| Test plugins locally before deploying      | Deploy untested plugins     |
| Keep plugins updated                       | Ignore update notifications |

### Performance

- **Minimize plugins**: Each plugin adds to bundle size
- **Lazy load**: Use dynamic imports for non-critical plugins
- **Monitor build time**: Plugins can slow builds
- **Test production build**: `npm run build && npm run serve`

### Configuration

- **Comment configs**: Explain non-obvious settings
- **Group plugins**: Organize by category in config
- **Version lock**: Use exact versions for stability
- **Document custom plugins**: Add notes to README

---

## Quick Reference

| Task               | Location                     | Command                                |
| ------------------ | ---------------------------- | -------------------------------------- |
| View plugins       | `docusaurus.config.ts:50-64` | -                                      |
| View plugin config | `docusaurus.config.ts`       | -                                      |
| Install plugin     | Terminal                     | `npm install <plugin>`                 |
| Build with plugins | Terminal                     | `npm run build`                        |
| Test locally       | Terminal                     | `npm start`                            |
| Plugin docs        | Browser                      | https://docusaurus.io/docs/api/plugins |

---

## Current Plugin Versions

| Plugin                                | Version | Purpose             |
| ------------------------------------- | ------- | ------------------- |
| `@easyops-cn/docusaurus-search-local` | ^0.52.1 | Local search        |
| `docusaurus-plugin-image-zoom`        | ^3.0.1  | Image zoom          |
| `@docusaurus/preset-classic`          | ^3.9.2  | Core plugins bundle |

**Update check**: `npm outdated`
