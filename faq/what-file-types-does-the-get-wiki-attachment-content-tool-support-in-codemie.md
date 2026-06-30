# What file types does the Get Wiki Attachment Content tool support in CodeMie?

The **Get Wiki Attachment Content** tool supports the following file types:

| File type                                                          | How content is returned                                                                |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| Text files (`.txt`, `.md`, `.json`, `.xml`, `.csv`, `.yaml`, etc.) | UTF-8 text                                                                             |
| PDF (`.pdf`)                                                       | Extracted text; OCR via AI vision for image-only PDFs (requires a multimodal model)    |
| Images (`.png`, `.jpg`, `.gif`, `.bmp`, `.webp`)                   | AI vision description (requires a multimodal model); base64 fallback for files ≤ 50 KB |
| Word (`.docx`)                                                     | Extracted text                                                                         |
| PowerPoint (`.pptx`)                                               | Slide text                                                                             |
| Excel (`.xls`, `.xlsx`)                                            | Sheet content as text                                                                  |
| Other / binary                                                     | Base64-encoded content for files ≤ 50 KB; metadata only for larger files               |

PDF OCR and image description require a multimodal AI model to be configured in the
CodeMie instance. If no multimodal model is available, image attachments return
base64-encoded content (≤ 50 KB) or metadata only.

## Sources

- [Azure DevOps Wiki](https://docs.codemie.ai/user-guide/tools_integrations/tools/azure-devops/azure-devops-wiki)
