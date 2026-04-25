---
id: deployment-prerequisites
title: Prerequisites for Deployment
sidebar_label: Deployment Prerequisites
sidebar_position: 3
description: Configuration steps required before deploying Langfuse
pagination_prev: admin/deployment/extensions/assistants-evaluation/assistants-evaluation
pagination_next: null
---

# Prerequisites for Deployment

Before deploying Langfuse, complete the following steps:

## Step 1: Clone the Repository

Clone the `codemie-helm-charts` repository.

## Step 2: Update `langfuse/values.yaml`

Before deployment, you **MUST** update the `langfuse/values.yaml` file with your environment-specific values:

```yaml
# Update the domain in these sections:
langfuse:
  langfuse:
    # Specify Langfuse version
    image:
      tag: "3.129.0"  # Pin to specific version for production stability

  nextauth:
    url: "https://langfuse.%%DOMAIN%%"  # Replace with your domain
  ingress:
    hosts:
     - host: "langfuse.%%DOMAIN%%"   # Replace with your domain

# Adjust storage class if needed:
global:
  defaultStorageClass: "your-storage-class"  # e.g., "gp3", "standard", etc.

# Adjust resource limits based on your requirements:
langfuse:
  web:
    resources:
      limits:
        cpu: "2"      # Adjust as needed
        memory: "4Gi"  # Adjust as needed
  worker:
    resources:
      limits:
        cpu: "2"      # Adjust as needed
        memory: "4Gi"  # Adjust as needed

postgresql:
  deploy: false
  host: some-postgresql.database.example.com # Replace with your database host
  database: postgres_langfuse
  auth:
    username: langfuse_admin
    existingSecret: langfuse-postgresql
    secretKeys:
      userPasswordKey: password

# Enable automatic database and user creation
dbInitJob:
  enabled: true

# Adjust component resources:
clickhouse:
  resources:
    limits:
      cpu: "2"        # Adjust as needed
      memory: "8Gi"     # Adjust as needed
  persistence:
    size: "100Gi"         # Adjust as needed

  # Uncomment this to enable TTL (automatic deletion of old logs) for ClickHouse system logs. Default is 90 days.
  # extraOverrides: |
  #   <clickhouse>
  #       <!--
  #         Standard System Tables:
  #         These settings merge with the default configuration in /etc/clickhouse-server/config.xml.
  #         We simply inject the <ttl> parameter to enable retention, preserving other default settings
  #         (partitioning, flush intervals).
  #       -->
  #       <query_log>
  #         <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </query_log>
  #       <part_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </part_log>
  #       <trace_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </trace_log>
  #       <asynchronous_insert_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </asynchronous_insert_log>
  #       <asynchronous_metric_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </asynchronous_metric_log>
  #       <backup_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </backup_log>
  #       <blob_storage_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </blob_storage_log>
  #       <crash_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </crash_log>
  #       <metric_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </metric_log>
  #       <query_thread_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </query_thread_log>
  #       <query_views_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </query_views_log>
  #       <session_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </session_log>
  #       <zookeeper_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </zookeeper_log>
  #       <processors_profile_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </processors_profile_log>
  #       <text_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </text_log>
  #       <error_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </error_log>
  #       <query_metric_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </query_metric_log>
  #       <latency_log>
  #           <ttl>event_date + INTERVAL 90 DAY DELETE</ttl>
  #       </latency_log>
  #       <!--
  #         OpenTelemetry Span Log:
  #         We must fully redefine this table configuration (using replace="1") instead of merging.
  #         Adding a standalone <ttl> tag fails when <engine> is already defined in the default config.
  #         See bug: https://github.com/ClickHouse/ClickHouse/issues/88366
  #       -->
  #       <opentelemetry_span_log replace="1">
  #           <database>system</database>
  #           <table>opentelemetry_span_log</table>

  #           <engine>ENGINE = MergeTree PARTITION BY toYYYYMM(finish_date) ORDER BY (finish_date, finish_time_us, trace_id) TTL finish_date + INTERVAL 90 DAY DELETE</engine>

  #           <flush_interval_milliseconds>7500</flush_interval_milliseconds>
  #           <max_size_rows>1048576</max_size_rows>
  #           <reserved_size_rows>8192</reserved_size_rows>
  #           <buffer_size_rows_flush_threshold>524288</buffer_size_rows_flush_threshold>
  #           <flush_on_crash>false</flush_on_crash>
  #       </opentelemetry_span_log>
  #   </clickhouse>
redis:
  persistence:
    size: "2Gi"         # Adjust as needed

s3:
  persistence:
    size: "100Gi"         # Adjust as needed

# Configure data retention policies for langfuse (optional):
retention:
  langfuse:
    enabled: false              # Set to 'true' to automatically purge historical data
    observationsDays: 90        # Retain observations for 90 days (table: default.observations)
    tracesDays: 90              # Retain traces for 90 days (table: default.traces)
    blobstoragefilelogDays: 90  # Retain blob storage logs for 90 days (table: default.blob_storage_file_log)
```

## Step 3: Configure PostgreSQL

The `postgres_langfuse` database and user are created automatically during deployment via `db-init-job`. Enable it in `langfuse/values.yaml`:

```yaml
dbInitJob:
  enabled: true
```

The init job uses admin PostgreSQL credentials from the `codemie-postgresql` secret. This secret is created automatically by `deploy-langfuse.sh` when `dbInitJob.enabled: true` — the script will prompt for admin credentials if the secret does not exist.

For manual deployment, create the secret before running Helm:

```bash
kubectl create secret generic codemie-postgresql \
--namespace langfuse \
--from-literal=PG_USER="your_admin_user" \
--from-literal=PG_PASS="your_admin_password" \
--type=Opaque
```

:::info
Admin credentials can be found in `deployment_outputs.env` (`CODEMIE_POSTGRES_DATABASE_USER`, `CODEMIE_POSTGRES_DATABASE_PASSWORD`).
:::

<details>
<summary>Manual PostgreSQL Setup (alternative to dbInitJob)</summary>

Connect to your PostgreSQL instance using your cloud provider's query tools or deploy pgAdmin:

```bash
# Create namespace and secret
kubectl create ns pgadmin

kubectl create secret generic pgadmin4-credentials \
--namespace pgadmin \
--from-literal=password="$(openssl rand -hex 16)" \
--type=Opaque

helm upgrade --install pgadmin pgadmin/. -n pgadmin --values pgadmin/values.yaml --wait --timeout 900s --dependency-update

# port-forward to svc
kubectl -n pgadmin port-forward svc/pgadmin-pgadmin4 8080:80

# access via localhost:8080 with secret from pgadmin namespace

# Default user: "pgadmin4@example.com"
# Retrieve the pgAdmin password from the Kubernetes secret.
kubectl -n pgadmin get secret pgadmin4-credentials -o jsonpath='{.data.password}' | base64 -d; echo
```

Execute the following SQL commands:

```sql
CREATE DATABASE postgres_langfuse;
CREATE USER langfuse_admin WITH PASSWORD 'your_strong_password_here';
GRANT ALL PRIVILEGES ON DATABASE postgres_langfuse TO langfuse_admin;
```

Switch to the `postgres_langfuse` database and grant schema privileges:

```sql
GRANT ALL ON SCHEMA public TO langfuse_admin;
```

If creating the database manually, set `dbInitJob.enabled: false` in `langfuse/values.yaml`.

</details>

## Step 4: Configure Data Retention (Optional)

To prevent disk overflow, configure [TTL](https://clickhouse.com/docs/guides/developer/ttl) policies in `values.yaml` to automatically remove old data. Default retention: 90 days.

### Recommended TTL by Usage

The table below provides recommended TTL values based on usage level, assuming the default **100 GB** ClickHouse disk size.

| Usage Level  | Active Users | Est. Ingestion | Recommended TTL |
| ------------ | ------------ | -------------- | --------------- |
| High usage   | 3,000–4,000  | ~40 GB/day     | 2 days          |
| Medium usage | ~1,500       | ~10 GB/day     | 9 days          |
| Low usage    | < 500        | ~1 GB/day      | 90 days         |

:::note
If your deployment does not fit within the recommended TTL for 100 GB, either lower the TTL or increase the ClickHouse disk size. To measure your actual ingestion rate, see [Data distribution by time period](../../../configuration/extensions/assistants-evaluation/data-volume-maintenance.md#data-distribution-by-time-period).
:::

### Langfuse Tables

Set `retention.langfuse.enabled: true` in `values.yaml`. TTL is configured for the following tables:

- **`default.observations`**
- **`default.traces`**
- **`default.blob_storage_file_log`**

These three tables consume the most disk space. Other Langfuse tables have minimal storage impact and do not require TTL configuration.

### ClickHouse System Tables

Uncomment the `clickhouse.extraOverrides` section in `values.yaml`. TTL is configured for the following tables:

- **`system.query_log`**
- **`system.trace_log`**
- **`system.metric_log`**
- and other system tables

:::warning Existing Deployments: Manual Cleanup Required
If you're enabling TTL on an **existing** Langfuse deployment or **changing retention periods**, TTL does **not** retroactively delete old data. You must manually clean up data that exceeds your new retention policy before redeploying.

**Steps for changing TTL:**

1. Update `values.yaml` with new retention settings (configure desired TTL periods)
2. Connect to ClickHouse - see [how to connect to ClickHouse](../../../configuration/extensions/assistants-evaluation/data-volume-maintenance.md#connect-to-clickhouse)
3. Delete old data manually - see [Manual Data Deletion queries](../../../configuration/extensions/assistants-evaluation/data-volume-maintenance.md#manual-data-deletion)
4. Redeploy Langfuse with `helm upgrade` to apply new TTL configuration

For detailed SQL queries and monitoring, see [Data Volume Maintenance guide](../../../configuration/extensions/assistants-evaluation/data-volume-maintenance.md).
:::
