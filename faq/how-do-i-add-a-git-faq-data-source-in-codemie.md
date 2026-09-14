# How do I add a Git FAQ data source in CodeMie?

Git FAQ is selected from the same **Choose Datasource Type** dropdown as a regular **Git** data source, but it uses a dedicated indexing pipeline built for Markdown-based FAQ content: each `.md` file in the repository is indexed as a single FAQ article instead of raw code.

To add one:

1. Open **Data Sources** and click **+ Create Datasource**.
2. Choose **Git FAQ** as the datasource type.
3. Fill in the Repository Link, Branch, and (optionally) a Files Filter to scope which `.md` files get indexed — for example `faq/**/*.md`.
4. Select a Git integration for private repositories, or leave it empty for a publicly accessible repository.
5. Optionally configure an embedding model and a reindex schedule.
6. Click **+ Create** and wait for indexing to finish.

Only `.md` files are indexed — `.mdx` files are ignored. There is no separate "FAQ path" field; use the Files Filter to scope indexing to a subfolder if needed.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources#git-faq-data-source)
