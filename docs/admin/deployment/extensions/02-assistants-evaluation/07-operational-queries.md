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
  - `blob_storage_file_log`
  - `scores`
  - Other Langfuse tables and views

- **`system`** - ClickHouse internal database containing metadata ([Located in the `system` database](https://clickhouse.com/docs/operations/system-tables/overview)):
  - Server states, processes, and environment
  - Server's internal processes
  - Query history, logs, and performance metrics

You may need to manage retention and cleanup for both databases depending on your disk usage patterns.
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

Displays tables sorted by size, including their engine type, row count, and total size.

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

Choose the appropriate query based on your needs:

- **[Compressed Size by Month (Fast)](#compressed-size-by-month-fast)** - Actual compressed disk usage and row counts by month
- **[Row Count by Day (Fast)](#by-day-row-count-fast)** - Number of records by day
- **[Uncompressed Size by Day (Heavy)](#uncompressed-size-by-day-heavy)** - Decompresses data to calculate approximate size. Not actual disk usage - use only for comparing relative data volume between days

:::note
Per-day compressed size is not available because ClickHouse partitions data by month (`PARTITION BY toYYYYMM()`).
:::

#### Compressed Size by Month (Fast)

Reads partition metadata from `system.parts`. Shows actual compressed disk usage by month.

<Tabs>
  <TabItem value="observations" label="Observations" default>

```sql
SELECT
    partition AS month,
    sum(rows) AS rows,
    formatReadableSize(sum(bytes_on_disk)) AS compressed_size
FROM system.parts
WHERE database = 'default' AND table = 'observations' AND active
GROUP BY partition
ORDER BY partition ASC;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT
    partition AS month,
    sum(rows) AS rows,
    formatReadableSize(sum(bytes_on_disk)) AS compressed_size
FROM system.parts
WHERE database = 'default' AND table = 'traces' AND active
GROUP BY partition
ORDER BY partition ASC;
```

  </TabItem>
</Tabs>

#### By Day: Row Count (Fast)

Executes instantly by reading indices only.

<Tabs>
  <TabItem value="observations" label="Observations" default>

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT
    toDate(timestamp) AS day,
    count() AS rows
FROM default.traces
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
SELECT
    toDate(created_at) AS day,
    count() AS rows
FROM default.blob_storage_file_log
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
</Tabs>

#### Uncompressed Size by Day (Heavy)

<Tabs>
  <TabItem value="observations" label="Observations" default>

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT
    toDate(timestamp) AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.traces
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
</Tabs>

:::note Blob Storage Logs Table
The `blob_storage_file_log` table does not have `PARTITION BY` in its schema, so compressed size by month cannot be queried from `system.parts`. Use [Row Count by Day](#by-day-row-count-fast) to analyze this table's data distribution.
:::

:::tip Date Column Names
Check the date column name for your table:

- `default.observations` uses **`start_time`**
- `default.traces` and `default.scores` uses **`timestamp`**

To verify the date column for other tables, see [Table Structure](#2-table-structure) section.
:::

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

<Tabs>
  <TabItem value="observations" label="Observations" default>

```sql
-- Delete all records older than a specific date
ALTER TABLE default.observations
DELETE WHERE toDate(start_time) < toDate('2025-07-13');
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
-- Delete all records older than a specific date
ALTER TABLE default.traces
DELETE WHERE toDate(timestamp) < toDate('2025-07-13');
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
-- Delete all records older than a specific date
ALTER TABLE default.blob_storage_file_log
DELETE WHERE toDate(created_at) < toDate('2025-07-13');
```

  </TabItem>
</Tabs>

### Check Mutation Status

Since deletion is not instant, check the progress here:

<Tabs>
  <TabItem value="observations" label="Observations" default>

```sql
SELECT command, is_done
FROM system.mutations
WHERE table = 'observations'
ORDER BY create_time DESC
LIMIT 5;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT command, is_done
FROM system.mutations
WHERE table = 'traces'
ORDER BY create_time DESC
LIMIT 5;
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
SELECT command, is_done
FROM system.mutations
WHERE table = 'blob_storage_file_log'
ORDER BY create_time DESC
LIMIT 5;
```

  </TabItem>
</Tabs>

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
