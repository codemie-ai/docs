# How do I deselect default datasource tools in an assistant?

Attaching a code data source automatically selects **Get Repository File Tree** and **Search Code Repo**, and attaching a knowledge base data source selects **Search Knowledge Base**. To stop the assistant from using one of them, open the assistant form, find the tool in the **Available Tools** section and clear its checkbox, then save the assistant.

The tool stays deselected when another data source of the same type is attached, and the choice is kept across assistant versions, export/import and workflows. Deselecting **Get Repository File Tree** is useful for very large repositories, where the full file tree would consume much of the model's context.

## Sources

- [Codebase Tools](https://docs.codemie.ai/user-guide/tools_integrations/tools/codebase-tools#default-datasource-tools)
