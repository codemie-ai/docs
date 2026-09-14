# How do I add a Git FAQ data source in CodeMie?

Git FAQ is not a separate entry in the datasource type dropdown — it's a processing option of the regular **Git** data source, for indexing Markdown-based FAQ content instead of code. Each `.md` file in the repository is indexed as a single FAQ article.

To add one:

1. Open **Data Sources** and click **+ Create Datasource**.
2. Choose **Git** as the datasource type.
3. In the **Content Processing Strategy** field that appears, choose **FAQ** (instead of the default **Default** option used for code).
4. Fill in the Repository Link, Branch, and (optionally) a Files Filter to scope which `.md` files get indexed — for example `faq/**/*.md`.
5. Select a Git integration for private repositories, or leave it empty for a publicly accessible repository.
6. Optionally configure an embedding model and a reindex schedule.
7. Click **+ Create** and wait for indexing to finish.

Only `.md` files are indexed — `.mdx` files are ignored. There is no separate "FAQ path" field; use the Files Filter to scope indexing to a subfolder if needed. The Content Processing Strategy choice can't be changed later — switching between Default and FAQ requires creating a new data source.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources#git-faq-data-source)
