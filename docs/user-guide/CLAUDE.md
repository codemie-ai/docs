# User Guide — Cross-Reference Analysis

When adding new documentation anywhere under `docs/user-guide/`, scan for **hub pages** that
link to or list related content and will need updating when the new documentation is added.

## Hub pages to check

- **Section overview/index pages** — pages that contain tables or lists of all items in a
  section (e.g., `tools/overview.md` listing all tools, `integrations/index.md` listing all
  integrations). Read these files to check whether the new content belongs in their tables.
- **Parent category pages** — if the new content is a subcategory, check whether the parent
  category page has a "child topics" section or navigation table that needs a new row.
- **Getting started or capabilities pages** — pages like `codemie-capabilities.md` or
  `getting-started/index.md` that list platform features at a high level.
- **`docs/user-guide/index.mdx`** — the user-guide landing page with `<FeatureCard>` tiles.
  Read it if the new content is a **new top-level section** directly under `docs/user-guide/`.

## How to identify hub pages

```bash
# Look for index/overview files in the target section
ls docs/user-guide/[target-section]/
```

Then read candidate files and scan for markdown tables (`|`) or lists that enumerate
sibling/child topics. If a table lists peer items (e.g., every tool in the Tools section),
the new page must be added as a new row.

Build a **"pending cross-references" list** — file path + what needs to be added/updated —
and apply all updates after the new documentation is written.

## Special case: user-guide/index.mdx FeatureCard

When the new documentation adds a **new top-level section** directly under `docs/user-guide/`
(e.g., `docs/user-guide/my-new-section/`), add a `<FeatureCard>` entry to
`docs/user-guide/index.mdx`.

**Component syntax:**

```mdx
<FeatureCard
  icon="/img/icons/<icon-name>.svg"
  iconType="image"
  title="Section Title"
  description="One or two sentences describing what the section covers and the value it provides."
  link="/user-guide/<section-slug>/"
/>
```

**Placement:** Add the new card at the end of the existing `<FeatureGrid>` block, before
the closing `</FeatureGrid>` tag, unless there is a logical grouping reason to insert it
elsewhere.

## Available icons (`static/img/icons/`)

| Icon file           | Best used for                                |
| ------------------- | -------------------------------------------- |
| `assistant.svg`     | Assistants, AI agents                        |
| `workflow.svg`      | Workflows, automation, pipelines             |
| `integration.svg`   | Integrations, connections, third-party tools |
| `datasource.svg`    | Data sources, knowledge bases                |
| `applications.svg`  | Applications, extensions, plugins            |
| `analytics.svg`     | Analytics, monitoring, metrics               |
| `api.svg`           | API, SDK, programmatic access                |
| `cli.svg`           | CLI tools, command-line                      |
| `ide.svg`           | IDE extensions, development environments     |
| `plugin.svg`        | Plugins, custom extensions                   |
| `lightning.svg`     | Skills, quick actions, reusable components   |
| `cloud-data.svg`    | Cloud storage, cloud services                |
| `configuration.svg` | Configuration, settings                      |
| `server.svg`        | Server tools, infrastructure                 |
| `tool.svg`          | Generic tools                                |
| `user.svg`          | User management, profiles                    |
| `chat.svg`          | Chat, conversations                          |
| `enterprise.svg`    | Enterprise features                          |

Choose the icon that best matches the section's primary purpose. Use `tool.svg` as fallback.
