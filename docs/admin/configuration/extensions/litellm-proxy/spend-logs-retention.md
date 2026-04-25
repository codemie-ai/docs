---
id: spend-logs-retention
title: Spend Logs Retention
sidebar_label: Spend Logs Retention
sidebar_position: 2
pagination_prev: admin/configuration/index
pagination_next: null
---

# Spend Logs Retention

This guide covers LiteLLM Spend Logs configuration, including what they are, how to access them, and how to manage their retention period.

## What are Spend Logs?

Spend logs are request logs that track all API calls made through LiteLLM Proxy. These logs capture detailed information about each request, including:

- Model used
- Tokens consumed (input and output)
- Cost per request
- Request timestamp
- User information
- Response time
- Request and response metadata

## Enabling Spend Logs

Spend logs need to be enabled in the LiteLLM configuration before they can be accessed. By default, spend logs may be disabled to reduce database load.

To enable spend logs, update the LiteLLM proxy configuration:

```yaml
general_settings:
  # ... other general settings ...
  disable_spend_logs: false  # Set to false to enable spend logs
```

:::info Important
Setting `disable_spend_logs: false` enables detailed request logging. If set to `true`, detailed request logs won't be recorded, but aggregate data such as budgets, spending by models, API keys, and teams will still be available, as they are stored in separate database tables.
:::

After enabling spend logs, the LiteLLM proxy pods need to be restarted for the changes to take effect.

## Accessing Spend Logs

Spend logs can be viewed and analyzed through the **LiteLLM UI**:

1. Navigate to the LiteLLM Proxy UI endpoint
2. Log in with administrative credentials
3. Go to the **"Logs"** section

Spend logs provide visibility into:

- API usage patterns
- Cost tracking and analysis
- Performance monitoring
- User activity
- Debugging and troubleshooting

## Retention Period Configuration

LiteLLM can automatically delete old spend logs from the database based on a configured retention period. This prevents the database from growing indefinitely and helps maintain optimal performance.

The cleanup process runs on a schedule (using cron syntax) and removes logs older than the specified retention period.

### Default Configuration

Configure the following settings in the LiteLLM proxy configuration:

```yaml
general_settings:
  # ... other general settings ...
  maximum_spend_logs_retention_period: "30d"
  maximum_spend_logs_cleanup_cron: "0 2 * * *"
```

After configuring retention settings, the LiteLLM proxy pods need to be restarted for the changes to take effect.

### Advanced Configuration

#### Cleanup Capacity

Each cleanup run can delete a **maximum of 500,000 logs**. If the database has more logs than this limit accumulated beyond the retention period, multiple cleanup cycles may be required to fully catch up.

The cleanup process has built-in limits (configured via LiteLLM environment variables) to prevent database performance issues:

```bash
SPEND_LOG_CLEANUP_BATCH_SIZE=1000  # 1,000 logs per batch
SPEND_LOG_RUN_LOOPS=500            # 500 iterations maximum

# Maximum logs deleted per cleanup run:
# 1,000 × 500 = 500,000 logs
```

#### Verifying Log Volume

To understand how many logs are being generated, use this SQL query to check the current log volume and calculate the average daily log count:

```sql
SELECT
    COUNT(*) FILTER (WHERE "startTime" >= NOW() - INTERVAL '14 days') as logs_14_days,
    COUNT(*) FILTER (WHERE "startTime" >= NOW() - INTERVAL '14 days') / 14 as avg_logs_per_day
FROM "LiteLLM_SpendLogs";
```

This query shows:

- `logs_14_days`: Total number of logs from the last 14 days
- `avg_logs_per_day`: Average number of logs generated per day

Understanding the average daily log volume helps:

- Choose an appropriate retention period
- Estimate database storage requirements
- Plan for cleanup capacity (remember the 500,000 logs per cleanup run limit)

#### Manual Cleanup for Large Log Volumes

If the database already contains millions of log records, manual cleanup is recommended before automatic retention is enabled. The built-in LiteLLM cleanup process is not optimized for large-scale deletions and may cause performance issues.

##### Step 1: Check Table Size

First, check the current size of the spend logs table:

```sql
SELECT
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('"LiteLLM_SpendLogs"')) as table_size
FROM "LiteLLM_SpendLogs";
```

This query returns:

- `total_records`: Total number of log records
- `table_size`: Total size including indexes

##### Step 2: Check Logs by Date

Determine how many logs exist before a specific date:

```sql
SELECT COUNT(*)
FROM "LiteLLM_SpendLogs"
WHERE "startTime" < '2025-12-31 10:00:00';
```

Replace the date with the desired cutoff point to see how many logs will be deleted.

##### Step 3: Delete Logs in Batches

Delete logs in batches of 100,000 records to avoid overloading the database:

```sql
DELETE FROM "LiteLLM_SpendLogs"
WHERE request_id IN (
    SELECT request_id
    FROM "LiteLLM_SpendLogs"
    WHERE "startTime" < '2025-12-31 10:00:00'
    LIMIT 100000
);
```

**Performance note:** Deleting 100,000 records takes approximately **15 seconds**.

:::tip Batch Deletion Strategy
Run this query multiple times until all unwanted logs are deleted. Using batches prevents database locks and maintains system availability during cleanup.
:::

##### Step 4: Reclaim Disk Space

After deleting logs, run `VACUUM FULL` to reclaim disk space:

:::danger Maintenance Window Required
`VACUUM FULL` locks the table and prevents any read or write operations during execution. **Schedule this operation during a maintenance window** when the system is not in active use.
:::

```sql
VACUUM FULL ANALYZE "LiteLLM_SpendLogs";
```

This command reclaims disk space and updates PostgreSQL query planner statistics, ensuring optimal query performance after the cleanup.

##### Step 5: Enable Automatic Retention

After manually cleaning old logs, enable the automatic retention configuration:

```yaml
general_settings:
  maximum_spend_logs_retention_period: "30d"
  maximum_spend_logs_cleanup_cron: "0 2 * * *"
```

This ensures future logs are automatically cleaned and prevents the table from growing uncontrollably again.

## See Also

- [LiteLLM Official Documentation - Spend Logs Deletion](https://docs.litellm.ai/docs/proxy/spend_logs_deletion)
- [LiteLLM Proxy Installation Guide](../../../deployment/extensions/litellm-proxy/index.md)
- [Budget Configuration](./budget-configuration.md)
