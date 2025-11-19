---
id: indexing-data-sources
title: Indexing Data Sources
sidebar_label: Indexing Data Sources
---

# Indexing Data Sources

Learn how to index data sources for better searchability and access.

Once a data source is added to the AI/Run CodeMie platform, you can proceed with indexing it. Indexing enables assistants and workflows to interact with the data within the data source. Assistants can only access data that has been indexed, so you need to re-index the data source each time it is updated. Otherwise, AI/Run CodeMie will not recognize the new data.

## Automatic Indexing

By default, AI/Run CodeMie automatically indexes new data sources as soon as they are added to the platform:

![Automatic Indexing](./indexing-data-sources/auto-indexing.png)

:::info
You don't have to wait till a data source is fully indexed. You can already add this data source into your assistants.
:::

## Manual Reindexing

To manually trigger data source reindexing, click the actions button and select **Full Reindex** or **Incremental Index**:

![Reindex Options](./indexing-data-sources/reindex-options.png)

### Indexing Types

#### Full Reindex

A complete reindexing of the data source. This involves scanning and updating all data from the source, regardless of any changes.

**When to use Full Reindex:**
- After major updates to the data source
- When data integrity issues are suspected
- For initial indexing of large data sources
- When switching indexing strategies or configurations

#### Incremental Index

This option is currently only supported for Jira data sources. With this option only new or changed data from the source will be updated. It only reindexes the data that has been modified since the last reindex.

**When to use Incremental Index:**
- For frequent, small updates to Jira data sources
- To save time and resources on large Jira projects
- For regular synchronization of Jira issues
- When only recent changes need to be reflected

:::note Alternative Access
Full reindex is also available on **Data Source Details** page: Data Source tab → Selected data source → 3 dots → View → scroll the page to the bottom
:::

## Resuming Indexing

If indexing is interrupted or paused, you can resume the process by clicking the **Resume Indexing** button:

![Resume Indexing](./indexing-data-sources/resume-indexing.png)

## Indexing Best Practices

### Regular Reindexing Schedule

- **Git Repositories**: Reindex after major commits or releases
- **Confluence**: Reindex when documentation is updated
- **Jira**: Use incremental indexing for daily updates, full reindex weekly or monthly
- **Files**: Reindex when files are modified or replaced
- **Google Docs**: Reindex after document updates

### Monitoring Indexing Status

Keep track of your data source indexing status:

- Check the **STATUS** column in the data sources list
- Monitor indexing progress for large data sources
- Verify successful completion of indexing operations
- Review any indexing errors or warnings

### Optimizing Indexing Performance

- **Schedule Large Reindexes**: Perform full reindexes during off-peak hours
- **Use Incremental Indexing**: Leverage incremental indexing for Jira when possible
- **Batch Updates**: Group multiple changes before triggering reindex
- **Clean Up First**: Remove outdated or unnecessary data before reindexing

## Indexing Status Indicators

Data sources display different statuses during the indexing process:

- **Indexing**: Currently being indexed
- **Indexed**: Successfully indexed and ready to use
- **Failed**: Indexing encountered an error
- **Pending**: Waiting to start indexing
- **Paused**: Indexing process is paused

## Troubleshooting Indexing Issues

### Indexing Fails

**Common causes:**
- Network connectivity issues
- Insufficient permissions to access data source
- Data source contains corrupted or unsupported files
- Resource limitations during indexing

**Solutions:**
- Verify network connection and data source accessibility
- Check integration credentials and permissions
- Review data source for problematic files
- Retry indexing after resolving issues

### Slow Indexing

**Common causes:**
- Large data source size
- High concurrent indexing operations
- Network bandwidth limitations
- Complex data structures

**Solutions:**
- Schedule indexing during low-traffic periods
- Break large repositories into smaller data sources
- Use incremental indexing when available
- Monitor system resources during indexing

### Data Not Appearing in Assistant

**Common causes:**
- Indexing not completed
- Data source not attached to assistant
- Recent changes not yet indexed

**Solutions:**
- Wait for indexing to complete
- Verify data source is added to assistant configuration
- Trigger a reindex to capture recent changes
- Check assistant's data source settings

## Impact of Indexing on Assistant Performance

### Data Freshness

- Assistants use the most recently indexed version of data
- Updates to data sources are not reflected until reindexed
- Regular reindexing ensures assistants have current information

### Search Quality

- Well-indexed data sources improve assistant response accuracy
- Proper indexing enables faster information retrieval
- Quality indexing reduces irrelevant responses

### Response Time

- Indexed data provides faster assistant responses
- Large indexed datasets may require more processing time
- Incremental indexing minimizes performance impact

## Next Steps

After indexing your data sources:

- [Configure assistants](../../assistants/) to use indexed data sources
- [Monitor indexing duration](./indexing-duration) for optimization
- [Set up workflows](../../workflows/) that leverage indexed data
- Review assistant performance with indexed data

:::tip Best Practice
Establish a regular indexing schedule based on your data update frequency. For frequently updated sources like Jira, consider daily incremental indexing with weekly full reindexes.
:::

Now your data sources are indexed and ready to be used by assistants and workflows for enhanced AI-powered operations.
