---
id: operational-queries
title: Operational Queries
sidebar_label: Operational Queries
sidebar_position: 8
description: ClickHouse queries for monitoring and analyzing Langfuse data
pagination_prev: admin/deployment/extensions/assistants-evaluation/assistants-evaluation
pagination_next: null
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Operational Queries

This page provides useful SQL queries for monitoring and analyzing ClickHouse data in your Langfuse deployment. These queries help you understand storage usage, analyze data patterns, verify retention policies, and troubleshoot issues.

## Prerequisites

To execute these queries, you need access to the ClickHouse pod. Here's how to connect:

### Find the ClickHouse Pod

```bash
kubectl get pods -n langfuse | grep clickhouse
```

### Connect to ClickHouse Pod

```bash
kubectl exec -it langfuse-clickhouse-shard0-X -n langfuse -- /bin/bash
```

Replace `X` with your shard number.

### Get ClickHouse Password

```bash
kubectl get secret langfuse-clickhouse -n langfuse -o jsonpath='{.data.admin-password}' | base64 --decode; echo
```

### Connect to ClickHouse Client

Inside the pod, connect to ClickHouse using the password from above:

```bash
clickhouse-client --password <password_from_above>
```

---

## 1. Disk Usage Analysis

### Top Tables by Disk Size

This query identifies which tables are consuming the most disk space.

:::info Database Types
ClickHouse contains two types of databases:

- **`default`** - Langfuse application database containing business data (Langfuse uses `default` as the [database name by default](https://langfuse.com/self-hosting/configuration#:~:text=CLICKHOUSE_DB,Name%20of%20the%20ClickHouse%20database%20to%20use.)):
  - `observations`
  - `traces`
  - `scores`
  - Other Langfuse tables and views

- **`system`** - ClickHouse internal database containing metadata ([Located in the `system` database](https://clickhouse.com/docs/operations/system-tables/overview)):
  - Server states, processes, and environment
  - Server's internal processes
  - Query history, logs, and performance metrics

You may need to manage retention and cleanup for both databases depending on your disk usage patterns.
:::

:::note
This query returns only tables that contain at least one record. **Empty tables** or **Views** (Virtual tables) will not be listed here because they do not have physical data parts on the disk.
:::

```sql
SELECT
    database,
    `table`,
    formatReadableSize(sum(bytes_on_disk)) AS size
FROM system.parts
WHERE active
GROUP BY
    database,
    `table`
ORDER BY
    database ASC,
    sum(bytes_on_disk) DESC;
```

### List All Tables

Displays tables sorted by size, including their engine type, row count, and total size. This is the best way to distinguish between real storage and virtual views.

**Key Columns:**

- **`engine`**:
  - `MergeTree` / `Replicated...`: Real tables that store data.
  - `View`: Virtual tables (saved queries) that take up **0 bytes**.
- **`total_rows`**: The number of records in the table.

<Tabs>
  <TabItem value="default" label="Langfuse (default)" default>

Query to list all Langfuse application tables in the `default` database:

```sql
SELECT
    name AS table_name,
    engine,
    total_rows,
    formatReadableSize(total_bytes) AS size
FROM system.tables
WHERE database = 'default'
ORDER BY total_bytes DESC;
```

  </TabItem>
  <TabItem value="system" label="ClickHouse (system)">

Query to list all ClickHouse internal tables in the `system` database:

```sql
SELECT
    name AS table_name,
    engine,
    total_rows,
    formatReadableSize(total_bytes) AS size
FROM system.tables
WHERE database = 'system'
ORDER BY total_bytes DESC;
```

  </TabItem>
</Tabs>

---

### Data Distribution by Time Period

The following queries help you understand how data is distributed over time and identify which periods consume the most storage.

:::info Fast vs Heavy Queries
ClickHouse does not store per-day or per-month disk usage metrics in system tables. Therefore:

- **Fast queries (Row Count)** - Execute instantly by reading indices only. Shows the number of records.
- **Heavy queries (With Size)** - Physically read and decompress data to calculate approximate uncompressed size. This is **NOT** the actual compressed disk usage, but the raw text size (significantly larger). These queries can be slow on large datasets. Use this only when you need to understand relative size distribution, not actual disk space.
  :::

:::tip Date Column Names
Check the date column name for your table:

- `default.observations` uses **`start_time`**
- `default.traces` and `default.scores` uses **`timestamp`**

To verify the date column for other tables, see [Table Structure](#2-table-structure) section.
:::

#### By Month: Row Count (Fast)

Executes instantly by reading indices only.

```sql
SELECT
    toYYYYMM(start_time) AS month,
    count() AS rows
FROM default.observations
GROUP BY month
ORDER BY month ASC;
```

#### By Month: Approximate Uncompressed Size (Heavy)

```sql
SELECT
    toYYYYMM(start_time) AS month,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.observations
GROUP BY month
ORDER BY month ASC;
```

#### By Day: Row Count (Fast)

Executes instantly by reading indices only.

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

#### By Day: Approximate Uncompressed Size (Heavy)

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

---

## 2. Table Structure

Use this command to view the full table definition. This is critical for:

1. **Column Names:** Finding the correct date column (e.g., `start_time` vs `timestamp`).
2. **TTL Verification:** Checking if a retention policy is currently configured.

```sql
SHOW CREATE TABLE default.observations;
```

:::tip What to Look For

- **`PARTITION BY`**: How data is split (usually by month).
- **`TTL`**: The automatic deletion rule (e.g., `TTL toDateTime(start_time) + INTERVAL 60 DAY DELETE`). **If this line is missing, no retention is active.**

:::

---

## 3. Manual Data Deletion

If you need to clean up data manually (e.g., before applying a new TTL or for testing), use the `ALTER ... DELETE` command.

:::danger Important

This operation is a **Mutation**. It is asynchronous and resource-intensive. ClickHouse effectively rewrites the data parts without the deleted rows.

Always use `toDate()` or specific date strings. Using non-deterministic functions like `now()` or `today()` can cause errors in replicated tables.

:::

### Delete Data Older Than a Specific Date

```sql
-- Delete all records older than a specific date
ALTER TABLE default.observations
DELETE WHERE toDate(start_time) < toDate('2025-07-13');
```

### Check Mutation Status

Since deletion is not instant, check the progress here:

```sql
SELECT command, is_done
FROM system.mutations
WHERE table = 'observations'
ORDER BY create_time DESC
LIMIT 5;
```

---

## 4. TTL Monitoring

### Retention Check (Oldest Data)

Shows the oldest available days to verify if TTL is working correctly.

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

### TTL Expiration Status

Check the physical parts to see exactly when ClickHouse schedules data deletion.

```sql
SELECT
    partition,
    name AS part_name,
    -- When the FIRST row in this part expires (Partial cleanup required)
    toDateTime(delete_ttl_info_min) AS min_ttl,
    -- When the LAST row in this part expires (Whole part deletion)
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'default' AND table = 'observations' AND active
ORDER BY min_ttl;
```

#### Column Meaning

Since data is stored in files (parts) containing multiple rows:

- **`min_ttl`**: The expiration time of the **oldest** row in the file.
- **`max_ttl`**: The expiration time of the **newest** row in the file.

#### How to Interpret Status

Compare `min_ttl` with the **Current Time**:

| Value            | Status             | Meaning                                                                                    |
| :--------------- | :----------------- | :----------------------------------------------------------------------------------------- |
| **`1970-01-01`** | **Not Calculated** | TTL rules applied but not processed yet. Wait for the next background merge.               |
| **Past Date**    | **Expired**        | Retention period passed. Data physically exists but is queued for deletion (lazy cleanup). |
| **Future Date**  | **Active**         | Data is safe. It is scheduled for deletion on this specific date.                          |

:::tip Force Cleanup
If you see expired dates but disk space is not freed yet, force a cleanup manually:

```sql
OPTIMIZE TABLE default.observations FINAL;
```

:::
