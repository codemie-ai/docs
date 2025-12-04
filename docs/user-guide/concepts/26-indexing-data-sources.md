---
id: indexing-data-sources
title: 2.6 Indexing Data Sources
sidebar_label: Indexing Data Sources
sidebar_position: 6
---

# 2.6 Indexing Data Sources

Once a data source is added to the AI/RunTM CodeMie platform, you can proceed with indexing it. Indexing enables assistants and workflows to interact with the data within the data source. Assistants can only access data that has been indexed, so you need to re-index the data source each time it is updated. Otherwise, AI/RunTM CodeMie will not recognize the new data. By default, AI/RunTM CodeMie automatically indexes new data sources as soon as they are added to the platform:

![Data source auto-indexing interface](../images/image58.png)

To manually trigger data source reindexing, click the **Actions** button and select **Full Reindex** or **Incremental Index**:

![Manual reindex options menu](../images/image80.png)

:::note
You don't have to wait till a data source is fully indexed. You can already add this data source into your assistants.
:::

If a data source indexing failed, you can continue indexing it by clicking the **Resume Indexing** button:

![Resume indexing button interface](../images/image153.png)

## Reindexing Options

- **Full Reindex**: A complete reindexing of the data source. This involves scanning and updating all data from the source, regardless of any changes.

- **Incremental Index**: This option is currently only supported for Jira data sources. With this option only new or changed data from the source will be updated. It only reindexes the data that has been modified since the last reindex.

:::note
Full reindex is also available on Data Source Details page (Data Source tab -> Selected data source -> 3 dots -> **View** -> scroll the page to the bottom)
:::

![Full reindex option on details page](../images/image140.png)

## Additional Options

Additional options available in the Data Sources tab include:

- **View**: Allows you to view the contents of the data source without modifying it. Useful for checking data before performing operations. Data source details list may vary depending on a data source type.

- **Edit**: Enables editing the integration or content of the data source, including access integration, indexing parameters, and more.

  :::note
  For File and Google data sources there is no option to update file/link to doc and reindex it. You need to add a new data source.
  :::

- **Delete**: Completely removes the selected data source from your system, including all associated data. Use this action if the data is no longer relevant, or you need to free up space.

- **CopyID**: The data Source ID is copied to the clipboard.

- **Export**: Allows to download details about your data source, which can be useful for record-keeping, analysis, or migrating information to another system. The exported information will typically include details such as: Name, Source Type, Description, Documents Count, Code Settings, Processed Data, Processing Info. This feature is particularly useful for keeping a backup of your data source details or for sharing information with team members or stakeholders.

:::note
Data source details list may vary depending on a data source type.
:::
