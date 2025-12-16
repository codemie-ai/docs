---
id: deployment-prerequisites
title: Prerequisites for Deployment
sidebar_label: Deployment Prerequisites
sidebar_position: 3
description: Configuration steps required before deploying Langfuse
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
  auth:
    username: langfuse_admin
    existingSecret: langfuse-postgresql
    secretKeys:
      userPasswordKey: password

# Adjust component resources:
clickhouse:
  resources:
    limits:
      cpu: "2"        # Adjust as needed
      memory: "8Gi"     # Adjust as needed
  persistence:
    size: "100Gi"         # Adjust as needed

redis:
  persistence:
    size: "2Gi"         # Adjust as needed

s3:
  persistence:
    size: "100Gi"         # Adjust as needed

# Configure data retention policies (optional):
retention:
  langfuse:
    enabled: false              # Enable automatic data cleanup
    observationsDays: 60       # Retain observations for 60 days
    tracesDays: 60            # Retain traces for 60 days
    blobstoragefilelogDays: 60 # Retain blob storage logs for 60 days
```

:::tip Data Retention
The retention configuration automatically applies [TTL (Time-To-Live)](https://clickhouse.com/docs/guides/developer/ttl) policies to Langfuse tables in ClickHouse. This helps manage storage costs by automatically removing old data. Adjust the retention periods based on your compliance and storage requirements.
:::

:::info ClickHouse System Tables Retention
The `clickhouse.extraOverrides` section in `values.yaml` contains optional configuration for ClickHouse system tables TTL. By default, it's commented out to avoid modifying ClickHouse's internal logging behavior.

**When to enable:**

- You need to manage storage used by ClickHouse system logs (query_log, trace_log, metric_log, etc.)
- You want to limit retention of internal ClickHouse operational logs

**How to enable:**

1. Uncomment the `extraOverrides` section in `langfuse/values.yaml`
2. Adjust the TTL intervals as needed (default is 90 days)
3. Redeploy Langfuse with `helm upgrade`

This configuration is separate from Langfuse data retention and only affects ClickHouse's internal system tables.
:::

## Step 2.1: Managing ClickHouse Data Retention

When you enable `retention.langfuse.enabled: true` in the configuration above, a Kubernetes Job automatically applies TTL (Time-To-Live) policies to Langfuse tables in ClickHouse. The TTL policies automatically delete data older than the specified retention period.

### Scenario A: New Langfuse Installation

If you're deploying Langfuse for the first time:

1. Simply enable retention in `values.yaml` (as shown above)
2. Deploy Langfuse following the deployment instructions
3. TTL policies will be applied automatically during deployment
4. No manual data cleanup is needed

### Scenario B: Existing Installation or Changing TTL Settings

If you have an existing Langfuse installation with data and want to:

- Enable retention for the first time, OR
- Reduce the retention period (e.g., from 90 days to 30 days)

You **must manually delete old data** before enabling or updating retention settings.

#### Step 1: Connect to ClickHouse

Find the ClickHouse pod name:

```bash
kubectl get pods -n langfuse | grep clickhouse
```

Connect to the ClickHouse pod (replace `X` with your shard number):

```bash
kubectl exec -it langfuse-clickhouse-shard0-X -n langfuse -- /bin/bash
```

#### Step 2: Get ClickHouse Password

Retrieve the admin password from the Kubernetes secret:

```bash
kubectl get secret langfuse-clickhouse -n langfuse -o jsonpath='{.data.admin-password}' | base64 --decode; echo
```

#### Step 3: Connect to ClickHouse Client

Inside the pod, connect to ClickHouse using the password from Step 2:

```bash
clickhouse-client --password <password_from_step_2>
```

#### Step 4: Delete Old Data

Execute the following SQL commands to delete data older than your desired retention date.

**Example:** Delete data older than July 13, 2025:

```sql
-- Delete old observations
ALTER TABLE default.observations DELETE WHERE toDate(start_time) < toDate('2025-07-13');

-- Delete old traces
ALTER TABLE default.traces DELETE WHERE toDate(timestamp) < toDate('2025-07-13');

-- Delete old blob storage logs
ALTER TABLE default.blob_storage_file_log DELETE WHERE toDate(created_at) < toDate('2025-07-13');
```

:::warning
These DELETE operations are irreversible. Make sure you have backups if needed and verify the date before executing.
:::

:::info
After deleting old data manually, you can enable or update the retention configuration in `values.yaml` and redeploy Langfuse. The TTL policies will then automatically manage future data cleanup.
:::

## Step 3: Configure PostgreSQL

Configure PostgreSQL running in managed cloud.

### 3.1. Connect to PostgreSQL Database

Connect to PostgreSQL database `codemie` depending on your cloud provider. Choose one of the following options:

- Some cloud providers have built-in query tools
- Deploy pgadmin inside the cluster to access your private Postgres instance:

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

### 3.2. Create Database and User

Execute the following SQL commands to create the database and user:

```sql
CREATE DATABASE postgres_langfuse;
```

```sql
CREATE USER langfuse_admin WITH PASSWORD 'your_strong_password_here';
GRANT ALL PRIVILEGES ON DATABASE postgres_langfuse TO langfuse_admin;
```

### 3.3. Grant Schema Privileges

Switch to the `postgres_langfuse` database and grant schema privileges:

```sql
GRANT ALL ON SCHEMA public TO langfuse_admin;
```
