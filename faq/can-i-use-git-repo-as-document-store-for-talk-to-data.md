# Can I use a Git repository as a document store for Talk-to-your-Data?

Yes. Git data sources now index PDF, MS Office (DOCX, XLSX, PPTX), email (MSG, EML), and
image files in addition to source code. This makes Git repositories suitable as a document
management store — all indexed content becomes available for Talk-to-your-Data scenarios
through CodeMie assistants.

To set this up:

1. Add a Git data source pointing to the repository branch that contains the documents.
2. Optionally use the **Files Filter** field to restrict indexing to document formats only
   (e.g., `*.pdf,*.docx,*.xlsx,*.pptx`).
3. Attach the data source to an assistant and use it to query the documents.

Image content requires a multimodal LLM model to be configured in the CodeMie instance.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
