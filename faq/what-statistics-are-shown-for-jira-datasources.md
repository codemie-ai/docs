# What statistics are shown for Jira datasources? How can I see which documents were skipped during Confluence indexing? Where can I find information about tokens used in datasource processing? How to view detailed statistics for my datasources? What information is included in the datasource view popup?

When viewing Jira or Confluence datasources in CodeMie, you can access detailed statistics about the processed data by clicking the three dots menu next to the datasource and selecting "View". The information displayed includes:

For Jira Datasources:

- **Datasource name**: The name you provided when creating the datasource
- **Project**: The associated CodeMie project
- **Shared with Project Team**: Whether the datasource is available to all project members (true/false)
- **Data Source Type**: The type of datasource (Jira)
- **Imported Chunks Count**: Number of data chunks successfully imported
- **JQL expression**: The JQL query used to fetch the data
- **Input tokens used**: Number of tokens consumed for input processing
- **Output tokens used**: Number of tokens used for generating outputs
- **Money spent**: Cost associated with processing this datasource
- **Description**: The description provided when creating the datasource
- **Processing Summary**:
  - Total documents: Total number of Jira items found
  - Processed Documents Count: Number of documents successfully processed
  - Imported Chunks Count: Number of data chunks imported
  - Skipped Documents: Number of documents skipped during processing
- **Processed Data**: Sortable list of all processed documents

For Confluence Datasources:

- **Datasource name**: The name you provided when creating the datasource
- **Project**: The associated CodeMie project
- **Shared with Project Team**: Whether the datasource is available to all project members (true/false)
- **Data Source Type**: The type of datasource (Confluence)
- **Imported Chunks Count**: Number of data chunks successfully imported
- **Root confluence link**: Link to the root Confluence space
- **CQL expression**: The CQL query used to fetch the data
- **Input tokens used**: Number of tokens consumed for input processing
- **Output tokens used**: Number of tokens used for generating outputs
- **Money spent**: Cost associated with processing this datasource
- **Description**: The description provided when creating the datasource
- **Processing Summary**:
  - Total documents: Total number of Confluence pages found
  - Processed Documents Count: Number of pages successfully processed
  - Imported Chunks Count: Number of data chunks imported
  - Skipped Documents: Number of pages skipped during processing
- **Processed Data**: Sortable list of all processed documents

## Sources

- [Indexing Data Sources](https://docs.codemie.ai/user-guide/data-source/data-source-overview/indexing-data-sources)
