# How do I add an xWiki data source in CodeMie?

To index an xWiki space in CodeMie:

1. Create an xWiki integration on the **Integrations** tab with the instance base URL and HTTP Basic credentials (username and token or password). If the xWiki instance is deployed under `/xwiki`, include that prefix in the URL — for example `https://wiki.example.com/xwiki`.
2. Navigate to **Data Sources** and click **+ Create Datasource**.
3. Select **xWiki** as the datasource type.
4. Enter the **Space** key (e.g., `KB`) — the selected space and all its descendant spaces will be indexed. Leave the **Wiki** field empty to use the default `xwiki` wiki.
5. Select the integration and an embeddings model, then click **+ Create**.

Indexing starts automatically. Once complete, add the data source to an assistant via the **Data Source Context** section to enable wiki search.

## Sources

- [Add and Index xWiki Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-xwiki-data-source)
