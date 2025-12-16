---
id: operational-queries
title: Operational Queries
sidebar_label: Operational Queries
sidebar_position: 8
description: ClickHouse queries for monitoring and analyzing Langfuse data
---

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

This query identifies which tables are consuming the most disk space across the entire server. It includes both business data (Langfuse) and internal system logs.

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

### List All Langfuse Tables

Displays tables in the `default` database, sorted so that the largest tables appear at the top. Including their engine type, row count, and total size. This is the best way to distinguish between real storage and virtual views.

**Key Columns:**

- **`engine`**:
  - `MergeTree` / `Replicated...`: Real tables that store data.
  - `View`: Virtual tables (saved queries) that take up **0 bytes**.
- **`total_rows`**: The number of records in the table.

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

---

## 2. Time Series Analysis

Before running these queries, check which column represents the event time in your specific table (see **Section 3** for how to check table structure).

:::tip Date Column Names
Check the date column name for your table:

- `default.observations` uses **`start_time`**
- `default.traces` and `default.scores` uses **`timestamp`**

:::

### Data by Month

#### Option 1: Row Count (Fast)

Executes instantly by reading indices only.

```sql
SELECT
    toYYYYMM(start_time) AS month,
    count() AS rows
FROM default.observations
GROUP BY month
ORDER BY month ASC;
```

#### Option 2: With Uncompressed Size (Heavy)

Calculates the **approximate uncompressed size** of text data (JSON).

:::warning Performance Warning
This query physically reads and decompresses data, so it **can be slow**. The result represents raw text size, which is significantly larger than the actual compressed disk usage.
:::

```sql
SELECT
    toYYYYMM(start_time) AS month,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.observations
GROUP BY month
ORDER BY month ASC;
```

### Data by Day

#### Option 1: Row Count (Fast)

Executes instantly by reading indices only.

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

#### Option 2: With Uncompressed Size (Heavy)

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows,
    formatReadableSize(sum(length(toString(input)) + length(toString(output)))) AS approx_size
FROM default.observations
GROUP BY day
ORDER BY day ASC;
```

### Retention Check (Oldest Data)

Shows the oldest available days to verify if TTL is working.

```sql
SELECT
    toDate(start_time) AS day,
    count() AS rows
FROM default.observations
GROUP BY day
ORDER BY day ASC
LIMIT 15;
```

---

## 3. Table Structure

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

## 4. Manual Data Deletion

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

## 5. TTL Monitoring

Check the physical parts to see exactly when ClickHouse schedules data deletion.

```sql
SELECT
    partition,
    name AS part_name,
    -- Earliest time a row in this part will be deleted
    toDateTime(delete_ttl_info_min) AS min_ttl,
    -- Latest time a row in this part will be deleted
    toDateTime(delete_ttl_info_max) AS max_ttl
FROM system.parts
WHERE database = 'default' AND table = 'observations' AND active
ORDER BY min_ttl;
```

### How to Interpret

- **`1970-01-01`**: TTL not calculated yet. It will update after the next background merge.
- **Past Date**: Data is expired. It is waiting for the background process to physically delete it.
- **Future Date**: Data is active. It will be automatically deleted on this specific date.

:::tip Force TTL Update
If you see `1970-01-01` or expired dates and want to force an update/deletion immediately (e.g., for testing), run:

```sql
OPTIMIZE TABLE default.observations FINAL;
```

:::
