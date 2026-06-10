# What file types does the Git data source index?

Git data sources index all text-based files (source code, Markdown, JSON, YAML, plain text,
etc.) as well as the following binary document formats:

- **PDF** (`.pdf`) — text extraction
- **Word** (`.docx`) — text and content extraction
- **Excel** (`.xlsx`) — markdown tables
- **PowerPoint** (`.pptx`) — text extraction
- **Email** (`.msg`, `.eml`) — text and metadata extraction
- **Images** (`.png`, `.jpg`, `.jpeg`) — semantic description via multimodal LLM

Image indexing requires a multimodal LLM model to be configured in the CodeMie instance. If
no multimodal model is available, image files are skipped.

Use the **Files Filter** field when creating the data source to include or exclude specific
formats (e.g., `*.pdf,*.docx` to index only documents).

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
