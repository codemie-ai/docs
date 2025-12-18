---
id: data-layer
sidebar_position: 2
title: Data Layer
sidebar_label: Data Layer
pagination_next: deployment-guide/azure/components-deployment/manual-deployment/security-and-identity
---

# Data Layer Installation

This guide covers the installation of data storage components that provide persistent storage for AI/Run CodeMie application data, logs, and user content.

## Overview

The data layer consists of three components:

- **Elasticsearch** - Document storage and search engine for application logs, embeddings, and search functionality
- **PostgreSQL Operator** - Kubernetes operator for managing PostgreSQL database lifecycle
- **PostgreSQL** - Cloud-managed relational database for Keycloak and application metadata

:::info Installation Order
These components must be installed in the order presented, as PostgreSQL Operator is required before configuring PostgreSQL secrets.
:::

## Elasticsearch Installation

Elasticsearch provides document storage and full-text search capabilities for AI/Run CodeMie. It stores conversation history, embeddings, logs, and provides search functionality.

### Step 1: Create Elasticsearch Namespace

Create a dedicated namespace for Elasticsearch:

```bash
kubectl create namespace elastic
```

:::tip Namespace Verification
Check if the namespace already exists: `kubectl get namespace elastic`
:::

### Step 2: Create Elasticsearch Credentials Secret

Generate and store Elasticsearch authentication credentials:

```bash
kubectl -n elastic create secret generic elasticsearch-master-credentials \
  --from-literal=username=elastic \
  --from-literal=password="$(openssl rand -base64 12)" \
  --type=Opaque \
  --dry-run=client -o yaml | kubectl apply -f -
```

**Command Breakdown**:

- `--from-literal=username=elastic` - Default Elasticsearch superuser
- `--from-literal=password="$(openssl rand -base64 12)"` - Generates random 12-character password
- `--dry-run=client -o yaml` - Creates YAML without applying
- `kubectl apply -f -` - Applies the generated secret (idempotent)

**Secret Structure**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: elasticsearch-master-credentials
  namespace: elastic
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

:::tip Retrieve Password
Save the generated password for troubleshooting: `kubectl get secret elasticsearch-master-credentials -n elastic -o jsonpath='{.data.password}' | base64 -d`
:::

### Step 3: Install Elasticsearch Helm Chart

Deploy Elasticsearch using Helm:

```bash
helm upgrade --install elastic elasticsearch/. \
  -n elastic \
  --values elasticsearch/values-azure.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `upgrade --install elastic` - Installs or upgrades release named "elastic"
- `-n elastic` - Deploys to the elastic namespace
- `--values elasticsearch/values-azure.yaml` - Uses Azure-specific configuration
- `--wait` - Waits for all resources to be ready
- `--timeout 900s` - Maximum wait time (15 minutes)

### Step 4: Verify Elasticsearch Deployment

Check that Elasticsearch is running:

```bash
# Check pod status
kubectl get pods -n elastic

# Check StatefulSet
kubectl get statefulset -n elastic

# Verify persistent volumes
kubectl get pvc -n elastic
```

Expected output:

- Pods should be in `Running` state (typically 3 pods for a cluster)
- StatefulSet should show desired replicas match ready replicas
- PVCs should be in `Bound` state

### Step 5: Test Elasticsearch Health

Verify Elasticsearch cluster health:

```bash
# Port-forward to Elasticsearch
kubectl port-forward -n elastic svc/elasticsearch-master 9200:9200

# Check cluster health (use saved password from Step 2)
curl -u elastic:<password> http://localhost:9200/_cluster/health?pretty

# Stop port-forward when done
```

Expected response should show `"status" : "green"` or `"status" : "yellow"` (yellow is acceptable for single-node clusters).

## PostgreSQL Operator Installation

The PostgreSQL Operator automates the management of PostgreSQL databases in Kubernetes. While CodeMie uses a cloud-managed Azure Database for PostgreSQL, the operator is required for Keycloak database configuration.

### Install PostgreSQL Operator Helm Chart

Deploy the PostgreSQL Operator:

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. \
  -n postgres-operator \
  --create-namespace \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `--create-namespace` - Automatically creates the postgres-operator namespace
- Other parameters function the same as Elasticsearch installation

### Verify PostgreSQL Operator Deployment

Check that the operator is running:

```bash
# Check pod status
kubectl get pods -n postgres-operator

# Check operator logs
kubectl logs -n postgres-operator deployment/postgres-operator --tail=50
```

Expected output:

- Operator pod should be in `Running` state
- Logs should show "controller started" or similar success message

## PostgreSQL Configuration

CodeMie uses Azure Database for PostgreSQL (created during infrastructure deployment) rather than running PostgreSQL in the cluster. This section configures the connection credentials.

### Step 1: Retrieve Database Credentials

Get your Azure PostgreSQL connection details from the infrastructure deployment outputs:

```bash
# From your deployment_outputs.env file, note these values:
# - CODEMIE_POSTGRES_DATABASE_HOST
# - CODEMIE_POSTGRES_DATABASE_NAME
# - CODEMIE_POSTGRES_DATABASE_USER
# - CODEMIE_POSTGRES_DATABASE_PASSWORD
```

:::tip Finding Credentials
Your `deployment_outputs.env` file was created during [Infrastructure Deployment](../../infrastructure-deployment/infrastructure-scripted-deployment). It should be located in your Terraform working directory.
:::

### Step 2: Create PostgreSQL Connection Secret

Create a secret with the cloud-managed PostgreSQL credentials:

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=PG_PASS=<CODEMIE_POSTGRES_DATABASE_PASSWORD> \
  --from-literal=PG_USER=<CODEMIE_POSTGRES_DATABASE_USER> \
  --from-literal=PG_HOST=<CODEMIE_POSTGRES_DATABASE_HOST> \
  --from-literal=PG_NAME=<CODEMIE_POSTGRES_DATABASE_NAME> \
  --namespace codemie
```

:::warning Replace Placeholders
Replace all `<CODEMIE_POSTGRES_DATABASE_*>` placeholders with actual values from your `deployment_outputs.env` file. Do not use angle brackets in the actual command.
:::

**Example with Real Values**:

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=PG_PASS='MySecureP@ssw0rd!' \
  --from-literal=PG_USER='codemie_admin' \
  --from-literal=PG_HOST='codemie-postgres.postgres.database.azure.com' \
  --from-literal=PG_NAME='codemie' \
  --namespace codemie
```

**Secret Structure**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: codemie-postgresql
  namespace: codemie
type: Opaque
data:
  PG_HOST: <base64-encoded-host>
  PG_NAME: <base64-encoded-db-name>
  PG_PASS: <base64-encoded-password>
  PG_USER: <base64-encoded-user>
```

### Step 3: Verify PostgreSQL Secret

Confirm the secret was created correctly:

```bash
# Check secret exists
kubectl get secret codemie-postgresql -n codemie

# Verify secret contents (decode to check values)
kubectl get secret codemie-postgresql -n codemie -o jsonpath='{.data.PG_HOST}' | base64 -d
kubectl get secret codemie-postgresql -n codemie -o jsonpath='{.data.PG_USER}' | base64 -d
```

## Post-Installation Validation

After completing all data layer installations, verify the following:

```bash
# Elasticsearch is running
kubectl get pods -n elastic | grep Running
kubectl get statefulset -n elastic

# PostgreSQL Operator is running
kubectl get pods -n postgres-operator | grep Running

# PostgreSQL secret exists
kubectl get secret codemie-postgresql -n codemie

# Check all PVCs are bound
kubectl get pvc -n elastic
```

All checks should return successful results before proceeding.

## Next Steps

Once the data layer is configured, proceed to **[Security and Identity](./security-and-identity)** installation to deploy Keycloak and OAuth2 Proxy components.
