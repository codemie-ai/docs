# Does the Azure DevOps Work Items data source index comments and attachments?

Yes. The Azure DevOps Work Items data source indexes three types of content per work item:

- **Work item fields** — title, description, type, state, priority, and other standard fields
- **Comments** — all discussion comments, including author name and timestamp, grouped into
  one document per work item
- **Attachments** — supported file types are downloaded, text is extracted, and indexed
  alongside the work item

Supported attachment formats include PDF, Word (`.docx`), Excel (`.xlsx`, `.xls`),
PowerPoint (`.pptx`), images (JPEG, PNG, GIF, BMP, WebP), and common text formats.
Unsupported attachment types are skipped gracefully — metadata is recorded and indexing
continues without failing.

Image OCR requires a multimodal AI model to be configured in the CodeMie instance.

## Sources

- [Add and Index Azure DevOps Work Items Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-azure-devops-work-items-data-source)
