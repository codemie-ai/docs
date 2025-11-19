---
id: indexing-duration
title: Indexing Duration
sidebar_label: Indexing Duration
---

# Indexing Duration

Understanding the time required for indexing different data sources.

When indexing data sources in AI/Run CodeMie, it's important to understand that indexing can be time-consuming, depending on the size and complexity of the data source. This guide helps you understand expected indexing durations and how to optimize the process.

## Expected Indexing Time

Duration can range from a few minutes to **up to 30-60 minutes**, depending on:

- **Data source size**: Larger repositories or datasets take longer to index
- **Data complexity**: Complex file structures and relationships increase processing time
- **File types**: Some file formats require more processing than others
- **Network speed**: For remote data sources, network bandwidth affects indexing speed
- **System resources**: Available CPU and memory impact indexing performance

## Monitoring Indexing Progress

You can monitor the indexing progress by clicking the **Indexing** tab in the data source details:

![Indexing Progress](./indexing-duration/indexing-progress.png)

The indexing progress view shows:
- Current indexing status
- Percentage of completion
- Estimated time remaining (when available)
- Number of files/items processed
- Any errors or warnings encountered

## Optimizing Indexing Duration

### 1. Specify Relevant File Extensions

To expedite the process, specify relevant file extensions, ensuring only necessary files are indexed.

**Benefits:**
- Reduces total data volume to process
- Focuses indexing on relevant content
- Decreases overall indexing time
- Improves search relevance

**How to specify file extensions:**
- Configure file patterns during data source creation
- Use inclusion/exclusion filters
- Define specific file types for your use case

### 2. Use Incremental Indexing

For existing repository indexes, you can perform:
- **Incremental reindex**: Only new or changed data (exclusively for Jira/Confluence datasources)
- **Full reindex**: Re-create the index from scratch with the same settings

Access these options in the **Actions** dialog by clicking respective icon buttons with tooltips:

![Reindex Actions](./indexing-duration/reindex-actions.png)

## Indexing Time by Data Source Type

### Git Repositories
- **Small repositories** (< 100 files): 2-5 minutes
- **Medium repositories** (100-1000 files): 5-15 minutes
- **Large repositories** (1000+ files): 15-60 minutes

**Factors affecting duration:**
- Number of files
- File sizes
- Repository history depth
- Code complexity

### Confluence Pages
- **Small spaces** (< 50 pages): 2-5 minutes
- **Medium spaces** (50-500 pages): 5-20 minutes
- **Large spaces** (500+ pages): 20-45 minutes

**Factors affecting duration:**
- Number of pages
- Page content size
- Attachments
- Embedded media

### Jira Projects
- **Small projects** (< 100 issues): 2-5 minutes
- **Medium projects** (100-1000 issues): 5-15 minutes
- **Large projects** (1000+ issues): 15-40 minutes

**Factors affecting duration:**
- Number of issues
- Custom fields
- Attachments
- Comments volume

### File Data Sources
- **Small files** (< 10 files): 1-3 minutes
- **Medium collections** (10-100 files): 3-10 minutes
- **Large collections** (100+ files): 10-30 minutes

**Factors affecting duration:**
- Number of files
- Total file size
- File formats
- Document complexity

### Google Docs
- **Small collections** (< 20 docs): 2-5 minutes
- **Medium collections** (20-100 docs): 5-15 minutes
- **Large collections** (100+ docs): 15-35 minutes

**Factors affecting duration:**
- Number of documents
- Document size
- Embedded content
- Sharing permissions

## Best Practices for Managing Indexing Duration

### Schedule Indexing Appropriately

- **Large repositories**: Schedule full reindexing during off-peak hours
- **Frequent updates**: Use incremental indexing to minimize duration
- **Initial indexing**: Allow sufficient time for first-time indexing
- **Production systems**: Plan indexing windows to avoid service disruption

### Break Down Large Data Sources

For very large data sources:
- Split into smaller, logical data sources
- Index different branches or modules separately
- Use multiple data sources for different components
- Combine results through assistant configuration

### Monitor and Adjust

- Track indexing completion times
- Identify slow-indexing data sources
- Adjust file filters based on performance
- Remove unnecessary files from indexing scope

## Troubleshooting Long Indexing Times

### Indexing Takes Longer Than Expected

**Possible causes:**
- Large data source size
- Complex file structures
- Network latency issues
- High system load
- Resource limitations

**Solutions:**
- Verify data source size and complexity
- Check network connectivity
- Reduce scope by filtering files
- Schedule during low-usage periods
- Consider splitting into smaller data sources

### Indexing Stuck or Not Progressing

**Possible causes:**
- Network connection interrupted
- System resource exhaustion
- Corrupted files in data source
- Permission issues

**Solutions:**
- Check indexing progress tab for errors
- Verify network connectivity
- Review system resources
- Check data source permissions
- Cancel and restart indexing if necessary

### Frequent Reindexing Required

**Possible causes:**
- Rapid data source updates
- Unstable network connection
- Configuration changes

**Solutions:**
- Use incremental indexing (for Jira/Confluence)
- Establish regular indexing schedule
- Stabilize data source updates
- Review and optimize configuration

## Impact on Assistant Availability

:::info Important
You don't have to wait until a data source is fully indexed. You can already add this data source to your assistants, and they will use whatever data has been indexed so far.
:::

**Partial indexing benefits:**
- Start using data immediately
- Gradual improvement in response quality
- No downtime while indexing completes

**Considerations:**
- Initial responses may be incomplete
- Quality improves as indexing progresses
- Full functionality available after complete indexing

## Planning Your Indexing Strategy

### For New Projects

1. Start with critical data sources
2. Use full reindex for initial setup
3. Allow adequate time for first indexing
4. Verify quality before proceeding

### For Ongoing Operations

1. Establish regular reindexing schedule
2. Use incremental indexing when available
3. Monitor indexing performance
4. Adjust strategy based on needs

### For Large Enterprises

1. Prioritize high-impact data sources
2. Stagger indexing across time zones
3. Use multiple data sources for scalability
4. Implement automated monitoring

## Next Steps

After understanding indexing duration:

- [Monitor indexing progress](../indexing-data-sources) regularly
- [Configure assistants](../../assistants/) to use indexed data
- [Optimize data source configuration](../data-source-overview) for performance
- Set up automated reindexing schedules

:::tip Performance Tip
For repositories with many files, specifying file extensions can reduce indexing time by up to 70%. Focus on indexing only the file types your assistants need to work with.
:::

Now you understand indexing duration expectations and can plan your data source indexing strategy effectively.
