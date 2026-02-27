---
id: data-volume-maintenance
title: Data Volume Maintenance
sidebar_label: Data Volume Maintenance
sidebar_position: 1
description: ClickHouse data volume maintenance queries for Langfuse - disk usage analysis, data cleanup, and TTL monitoring
pagination_prev: null
pagination_next: null
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Data Volume Maintenance

This guide provides SQL queries for maintaining ClickHouse data volume in your Langfuse deployment. Use these queries to monitor disk usage, clean up old data, and verify retention policies.

## Connect to ClickHouse

To execute these queries, you need access to the ClickHouse pod. Here's how to connect:

#### Find the ClickHouse Pod

```bash
kubectl get pods -n langfuse | grep clickhouse
```

#### Connect to ClickHouse Pod

```bash
kubectl exec -it langfuse-clickhouse-shard0-X -n langfuse -- /bin/bash
```

Replace `X` with your shard number.

#### Get ClickHouse Password

```bash
kubectl get secret langfuse-clickhouse -n langfuse -o jsonpath='{.data.admin-password}' | base64 --decode; echo
```

#### Connect using ClickHouse Client

Inside the pod, connect to ClickHouse using the password from above:

```bash
clickhouse-client --password <password_from_above>
```

---

## 1. Disk Usage Analysis

### Top Tables by Disk Size

This query identifies which tables are consuming the most disk space.

<details>
<summary>Database Types</summary>

ClickHouse contains two types of databases:

- **`default`** – Langfuse application database containing business data (Langfuse uses `default` as the [database name by default](https://langfuse.com/self-hosting/configuration#:~:text=CLICKHOUSE_DB,Name%20of%20the%20ClickHouse%20database%20to%20use.)):
  - `observations`
  - `traces`
  - `blob_storage_file_log`
  - `scores`
  - Other Langfuse tables and views

- **`system`** – ClickHouse internal database containing metadata ([Located in the `system` database](https://clickhouse.com/docs/operations/system-tables/overview)):
  - `trace_log`
  - `zookeeper_log`
  - `metric_log`
  - `opentelemetry_span_log`
  - Other ClickHouse tables

</details>

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

- **[Compressed Size by Month (Fast)](#compressed-size-by-month-fast)** – Actual compressed disk usage and row counts by month
- **[Row Count by Day (Fast)](#by-day-row-count-fast)** – Number of records by day
- **[Uncompressed Size by Day (Heavy)](#uncompressed-size-by-day-heavy)** – Decompresses data to calculate approximate size. Not actual disk usage – use only for comparing relative data volume between days

:::note
Per-day compressed size is not available because ClickHouse partitions data by month (`PARTITION BY toYYYYMM()`).
:::

#### Compressed Size by Month (Fast)

Shows actual compressed disk usage by month. Reads partition metadata from `system.parts`.

<Tabs groupId="table-type">
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
  <TabItem value="blob_storage" label="Blob Storage Logs">

The `blob_storage_file_log` table does not have `PARTITION BY` in its schema, so compressed size by month cannot be queried from `system.parts`. Use [Row Count by Day](#by-day-row-count-fast) to analyze this table's data distribution.

  </TabItem>
  <TabItem value="system_logs" label="System Logs">

#### You can replace `query_log` with any of the following system log tables. {#system-log-tables}

<details>
<summary>Show supported tables</summary>

- `trace_log`, `zookeeper_log`, `metric_log`
- `asynchronous_metric_log`, `text_log`, `part_log`
- `processors_profile_log`, `latency_log`, `session_log`
- `asynchronous_insert_log`, `error_log`

</details>

```sql {6}
SELECT
    partition AS month,
    sum(rows) AS rows,
    formatReadableSize(sum(bytes_on_disk)) AS compressed_size
FROM system.parts
WHERE database = 'system' AND table = 'query_log' AND active
GROUP BY partition
ORDER BY partition ASC;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT
    partition AS month,
    sum(rows) AS rows,
    formatReadableSize(sum(bytes_on_disk)) AS compressed_size
FROM system.parts
WHERE database = 'system' AND table = 'opentelemetry_span_log' AND active
GROUP BY partition
ORDER BY partition ASC;
```

  </TabItem>
</Tabs>

#### By Day: Row Count (Fast)

Shows row count per day. Executes instantly by reading indices only.

<Tabs groupId="table-type">
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
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {4}
SELECT
    event_date AS day,
    count() AS rows
FROM system.query_log
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT
    finish_date AS day,
    count() AS rows
FROM system.opentelemetry_span_log
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
</Tabs>

#### Uncompressed Size by Day (Heavy)

<Tabs groupId="table-type">
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
  <TabItem value="blob_storage" label="Blob Storage Logs">

The `blob_storage_file_log` table does not have `PARTITION BY` in its schema, so uncompressed size by day cannot be queried from `system.parts`. Use [Row Count by Day](#by-day-row-count-fast) to analyze this table's data distribution.

  </TabItem>
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {5}
SELECT
    event_date AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(query)))) AS approx_size
FROM system.query_log
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT
    finish_date AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(attribute)))) AS approx_size
FROM system.opentelemetry_span_log
GROUP BY day
ORDER BY day ASC;
```

  </TabItem>
</Tabs>

:::tip Date Column Names
Check the date column name for your table:

- `default.observations` uses **`start_time`**
- `default.traces` and `default.scores` uses **`timestamp`**

To verify the date column for other tables, see [Table Structure](#3-table-structure) section.
:::

---

## 2. Data Cleanup

This section covers both manual and automatic data cleanup strategies.

### Manual Data Deletion

If you need to clean up data manually (e.g., before applying a new TTL or for testing), use the `ALTER ... DELETE` command.

:::danger Important

This operation is a **Mutation**. It is asynchronous and resource-intensive. ClickHouse effectively rewrites the data parts without the deleted rows.

Always use `toDate()` or specific date strings. Using non-deterministic functions like `now()` or `today()` can cause errors in replicated tables.

:::

### Delete Data Older Than a Specific Date

<Tabs groupId="table-type">
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
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {1}
ALTER TABLE system.query_log
DELETE WHERE toDate(event_date) < toDate('2025-07-13');
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
ALTER TABLE system.opentelemetry_span_log
DELETE WHERE toDate(finish_date) < toDate('2025-07-13');
```

  </TabItem>
</Tabs>

#### Check Mutation Status

Since deletion is not instant, check the progress here:

<Tabs groupId="table-type">
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
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {3}
SELECT command, is_done
FROM system.mutations
WHERE table = 'query_log'
ORDER BY create_time DESC
LIMIT 5;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT command, is_done
FROM system.mutations
WHERE table = 'opentelemetry_span_log'
ORDER BY create_time DESC
LIMIT 5;
```

  </TabItem>
</Tabs>

### TTL Monitoring

Monitor automatic data deletion through Time-To-Live (TTL) policies.

:::tip First: Verify TTL is Configured
Before monitoring, check if TTL exists in your table definition: [Table Structure](#3-table-structure). Look for the `TTL` line – if missing, automatic deletion is not configured.
:::

#### Verify Old Data Deletion

Shows the 15 oldest days with data to check if TTL is deleting old records as expected.

<Tabs groupId="table-type">
  <TabItem value="observations" label="Observations" default>

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT
    toDate(timestamp) AS day,
    count() AS rows
FROM default.traces
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
SELECT
    toDate(created_at) AS day,
    count() AS rows
FROM default.blob_storage_file_log
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

  </TabItem>
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {4}
SELECT
    event_date AS day,
    count() AS rows
FROM system.query_log
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT
    finish_date AS day,
    count() AS rows
FROM system.opentelemetry_span_log
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

  </TabItem>
</Tabs>

#### TTL Expiration Status

Check when ClickHouse will delete expired data. ClickHouse stores data in physical files called **parts**. Each part contains multiple rows, and TTL is checked during background merges.

<Tabs groupId="table-type">
  <TabItem value="observations" label="Observations" default>

```sql
SELECT
    partition,
    name AS part_name,
    toDateTime(delete_ttl_info_min) AS min_ttl,
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'default' AND table = 'observations' AND active
ORDER BY min_ttl;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SELECT
    partition,
    name AS part_name,
    toDateTime(delete_ttl_info_min) AS min_ttl,
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'default' AND table = 'traces' AND active
ORDER BY min_ttl;
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
SELECT
    partition,
    name AS part_name,
    toDateTime(delete_ttl_info_min) AS min_ttl,
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'default' AND table = 'blob_storage_file_log' AND active
ORDER BY min_ttl;
```

  </TabItem>
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {7}
SELECT
    partition,
    name AS part_name,
    toDateTime(delete_ttl_info_min) AS min_ttl,
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'system' AND table = 'query_log' AND active
ORDER BY min_ttl;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SELECT
    partition,
    name AS part_name,
    toDateTime(delete_ttl_info_min) AS min_ttl,
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'system' AND table = 'opentelemetry_span_log' AND active
ORDER BY min_ttl;
```

  </TabItem>
</Tabs>

##### Column Meaning

Since each partition contains multiple rows with different timestamps:

- **`min_ttl`**: When the **oldest** row in this partition will expire
- **`max_ttl`**: When the **newest** row in this partition will expire
- **`partition`**: The monthly partition (format: `YYYYMM`)

##### How to Interpret Status

Compare `min_ttl` with the **current date/time**:

| `min_ttl` Value  | Status                | What it means                                                                                                                         |
| :--------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| **`1970-01-01`** | **TTL Not Processed** | TTL rule exists but hasn't been evaluated yet. ClickHouse will process it during the next background merge.                           |
| **Past Date**    | **Expired (Pending)** | Data should be deleted but still exists on disk. ClickHouse deletes it during the next merge. This is normal "lazy cleanup" behavior. |
| **Future Date**  | **Active**            | Data is within retention period. It will be automatically deleted when this date is reached.                                          |

**Why isn't expired data deleted immediately?**
ClickHouse performs TTL cleanup during background merges to avoid impacting query performance.

:::tip Force Immediate Cleanup
If expired data still occupies disk space and you need to free it immediately:

```sql
OPTIMIZE TABLE default.observations FINAL;
```

This forces ClickHouse to merge all parts and apply TTL rules immediately.
:::

---

## 3. Table Structure

Use this command to view the full table definition. This is critical for:

1. **Column Names:** Finding the correct date column (e.g., `start_time` vs `timestamp`).
2. **TTL Verification:** Checking if a retention policy is currently configured.

<Tabs groupId="table-type">
  <TabItem value="observations" label="Observations" default>

```sql
SHOW CREATE TABLE default.observations;
```

  </TabItem>
  <TabItem value="traces" label="Traces">

```sql
SHOW CREATE TABLE default.traces;
```

  </TabItem>
  <TabItem value="blob_storage" label="Blob Storage Logs">

```sql
SHOW CREATE TABLE default.blob_storage_file_log;
```

  </TabItem>
  <TabItem value="system_logs" label="System Logs">

You can replace `query_log` with a table from [this list](#system-log-tables).

```sql {1}
SHOW CREATE TABLE system.query_log;
```

  </TabItem>
  <TabItem value="opentelemetry" label="OpenTelemetry Span Log">

```sql
SHOW CREATE TABLE system.opentelemetry_span_log;
```

  </TabItem>
</Tabs>

:::tip What to Look For

- **`PARTITION BY`**: How data is split (usually by month).
- **`TTL`**: The automatic deletion rule (e.g., `TTL toDateTime(start_time) + INTERVAL 60 DAY DELETE`). **If this line is missing, no retention is active.**

:::
