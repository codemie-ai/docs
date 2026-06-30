# How do I add Azure DevOps Work Items as a data source in CodeMie?

To index Azure DevOps Work Items as a data source:

1. Navigate to the **Data Sources** section and click **+ Create Datasource**.
2. Select **Azure DevOps Work Items** as the datasource type.
3. Select an Azure DevOps integration and an embedding model.
4. Optionally, enter a WIQL query to filter which work items are indexed (e.g.,
   `SELECT [System.Id] FROM WorkItems WHERE [System.TeamProject] = @project`).
   Leave the field empty to index all work items in the project.
5. Configure an optional reindex schedule, then click **+ Create**.

Indexing begins automatically. Once complete, the data source can be attached to an
assistant to enable work item search and retrieval.

An Azure DevOps integration with a Personal Access Token must be configured before
adding this data source.

## Sources

- [Add and Index Azure DevOps Work Items Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-azure-devops-work-items-data-source)
