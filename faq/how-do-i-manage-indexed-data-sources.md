# How do I manage indexed Data Sources? How can I update, reindex, or delete a Data Source?

To manage your indexed Data Sources:

1. Open the **Data Sources** tab
2. Find the Data Source by name
3. Click the **"…"** button (three dots)

## Available actions:

- Delete - Completely remove the Data Source and all associated data. Use this if the data is no longer relevant or to free up space.
- Incremental Index - Update only changed or modified data since the last indexing. Saves time and resources. _(Currently works only with Jira)_
- Full Reindex - Completely scan and update all data, regardless of changes. Useful for significant data structure changes or fixing indexing errors.
- View - Preview the Data Source contents without modifying anything.
- Edit - Modify integrations, indexing parameters, or content settings.
- Resume Indexing - Continue indexing if the process previously failed.

### 1.1.25. How do multiple Data Sources work when the model has two files as Data Sources with different rules? How are these rules applied is it sequential or is there a priority system? What happens in case there are contradictions in the rules? There is no priority or sequential system in place. Everything depends on the given instructions. It is possible to instruct the model to use a specific Data Source for a particular use case or provide a description for the Data Source when it is created. Data Source descriptions are provided to the model so it can understand better use cases for it.

## Sources

- [Indexing Data Sources](https://docs.codemie.ai/user-guide/data-source/data-source-overview/indexing-data-sources)
