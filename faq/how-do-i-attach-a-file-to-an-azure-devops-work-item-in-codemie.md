# How do I attach a file to an Azure DevOps work item in CodeMie?

Both the **Create Work Item** and **Update Work Item** operations support file attachments.
To attach a file to an existing work item, ask the assistant in natural language:

> "Attach the file report.pdf to work item 1042"

The assistant uploads the file and associates it with the work item. On success, it returns
confirmation along with the attachment metadata (name, link, size).

File size and type limits are enforced by the Azure DevOps API. The user account used for
the integration must have permission to update the target work item and add attachments.

## Sources

- [Azure DevOps Work Items](https://docs.codemie.ai/user-guide/tools_integrations/tools/azure-devops/azure-devops-work-items)
