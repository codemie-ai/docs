# How do I read file attachments from Azure DevOps Wiki pages in CodeMie?

The **Get Wiki Attachment Content** tool retrieves and parses the actual content of files
attached to Azure DevOps wiki pages. It can be used in two ways:

- **Direct URL** — provide the attachment URL returned by the Get Wiki Page By ID or
  Get Wiki Page By Path tools. This is the recommended approach when the URL is already
  available.
- **Discovery mode** — provide the wiki page identifier (page ID or page path) and the
  attachment file name. The tool locates the attachment automatically by parsing the
  page content.

To use it, ask the assistant in natural language:

> "Get the content of the file `spec.pdf` attached to the `/Architecture/API` wiki page"

## Sources

- [Azure DevOps Wiki](https://docs.codemie.ai/user-guide/tools_integrations/tools/azure-devops/azure-devops-wiki)
