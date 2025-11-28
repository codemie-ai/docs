---
id: assistants-evaluation
title: Assistants Evaluation (Langfuse)
sidebar_label: Assistants Evaluation
sidebar_position: 2
description: Install and configure Langfuse for LLM observability and evaluation
---

# Assistants Evaluation (Langfuse)

This comprehensive guide explains how to install and configure Langfuse using Helm, with both automated and manual deployment methods.

## Prerequisites

Before starting any deployment method, ensure you have:

### Required Tools

- `kubectl` configured and connected to your cluster
- `helm` installed (version 3.x)
- `openssl` for generating secure secrets

### Infrastructure Requirements

- Installed and deployed AI/Run CodeMie instance
- PostgreSQL database instance
- Sufficient cluster resources for Langfuse components
- Kubernetes cluster with appropriate permissions

:::warning Minimum CodeMie Version

Minimal supported version of AI/Run CodeMie for evaluation is 1.3.0. Make sure you've updated your CodeMie installation before proceeding.

:::

### Access to the following repositories:

- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

Review Langfuse system requirements before proceeding.

## Langfuse System Requirements

The diagram below depicts the Langfuse LLM Observability Platform deployed on Kubernetes infrastructure within a cloud environment.

![LiteLLM Architecture](./02-assistants-evaluation/images/langfuse-architecture.drawio.png)

### Components and Requirements

| Component               | CPU (Limits/Requests) | Memory (Limits/Requests) | Storage         |
| ----------------------- | --------------------- | ------------------------ | --------------- |
| Langfuse Web            | 2 / 1                 | 4Gi / 2Gi                | —               |
| Langfuse Worker         | 2 / 1                 | 4Gi / 2Gi                | —               |
| PostgreSQL[^1]          | —                     | —                        | —               |
| ClickHouse x 3 Replicas | 2 / 0.3               | 8Gi / 8Gi                | 100Gi PVC       |
| Zookeeper x 3 Replicas  | 2 / 0.1               | 4Gi / 4Gi                | 1Gi             |
| Redis                   | 1 / 0.1               | 1.5Gi / 512Mi            | 2Gi             |
| S3 (Minio)[^2]          | 2 / 0.1               | 4Gi / 512Mi              | 100Gi PVC       |
| **Total**               | **~11 / ~2.6 vCPU**   | **~49.5 / ~33 GiB RAM**  | **~400 Gi PVC** |

[^1]: Reusing main AI/Run CodeMie PostgreSQL instance

[^2]: Can use S3 instead of MinIO

## Prerequisites for Deployment

Before deploying Langfuse, complete the following steps:

1. **Clone the Repository**: Clone the `codemie-helm-charts` repository.

2. **Update `langfuse/values.yaml`**: Before deployment, you **MUST** update the `langfuse/values.yaml` file with your environment-specific values:

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
```

3. **Configure PostgreSQL running in managed cloud**

   a. Connect to PostgreSQL database `codemie` depending on your cloud provider. Choose one of the following options:
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

   b. Execute the following SQL commands to create the database and user:

   ```sql
   CREATE DATABASE postgres_langfuse;
   ```

   ```sql
   CREATE USER langfuse_admin WITH PASSWORD 'your_strong_password_here';
   GRANT ALL PRIVILEGES ON DATABASE postgres_langfuse TO langfuse_admin;
   ```

   c. Switch to the `postgres_langfuse` database and grant schema privileges:

   ```sql
   GRANT ALL ON SCHEMA public TO langfuse_admin;
   ```

## Option A: Automated Deployment (Recommended)

The automated deployment uses the `deploy-langfuse.sh` script to handle the entire Langfuse deployment process.

### Overview

The deployment script automates:

- Kubernetes secret creation
- Helm repository configuration
- Langfuse deployment
- Integration secret creation for CodeMie

### Usage

:::tip Script is Idempotent

The script is designed to be idempotent. Follow the next steps to install.

:::

#### Basic Usage

```bash
# Deploy with default settings
./langfuse/deploy-langfuse.sh

# Deploy to a custom namespace
./langfuse/deploy-langfuse.sh -n my-langfuse-namespace

# Deploy with a specific Langfuse chart version
./langfuse/deploy-langfuse.sh -v 1.5.3

# Use a custom values file
./langfuse/deploy-langfuse.sh --values-file custom-values.yaml
```

#### Advanced Usage

```bash
# Perform a dry run to see what would be executed
./langfuse/deploy-langfuse.sh --dry-run

# Skip secret creation (if secrets already exist)
./langfuse/deploy-langfuse.sh --skip-secrets

# Skip Helm deployment (for testing purposes)
./langfuse/deploy-langfuse.sh --skip-deploy

# Combined options
./langfuse/deploy-langfuse.sh -n production -v 1.5.3 --values-file prod-values.yaml
```

#### Provide PostgreSQL Password when Asked

The script will prompt for the PostgreSQL password if the required secret is not found.

```
[INFO] PostgreSQL secret not found in namespace 'langfuse'
This secret is required to connect to your managed PostgreSQL database.
Please enter the password for your PostgreSQL user (input hidden)
PostgreSQL password:
```

#### Help

```bash
./langfuse/deploy-langfuse.sh --help
```

#### Script Options

| Option            | Description                     | Default       |
| ----------------- | ------------------------------- | ------------- |
| `-h, --help`      | Show help message               | -             |
| `-n, --namespace` | Kubernetes namespace            | `langfuse`    |
| `-v, --version`   | Langfuse Helm chart version     | `1.5.3`       |
| `-d, --dry-run`   | Perform dry run without changes | `false`       |
| `--skip-secrets`  | Skip secret creation            | `false`       |
| `--skip-deploy`   | Skip Helm deployment            | `false`       |
| `--values-file`   | Path to values.yaml file        | `values.yaml` |

### What the Script Does

1. **Validation**: Checks for required tools and cluster connectivity
2. **Namespace Creation**: Creates the specified namespace if it doesn't exist
3. **Helm Repository**: Adds and updates Langfuse Helm repository
4. **PostgreSQL Password creation**: Asks for the database password
5. **Secret Creation**: Creates all required Kubernetes secrets
6. **Langfuse Deployment**: Deploys Langfuse using Helm
7. **Integration Setup**: Creates integration secret for CodeMie

## Option B: Manual Deployment

This option is recommended if you prefer manual control over each step or need to customize the deployment process.

### Step 1: Create Namespace

Create a dedicated namespace for Langfuse:

```bash
kubectl create namespace langfuse
```

### Step 2: Add Helm Repository

```bash
helm repo add langfuse https://langfuse.github.io/langfuse-k8s
helm repo update
```

### Step 3: Create Required Secrets

#### Langfuse Configuration Secret

```bash
kubectl create secret generic langfuse \
--namespace langfuse \
--from-literal=salt="$(openssl rand -base64 32)" \
--from-literal=nextauth-secret="$(openssl rand -hex 32)" \
--type=Opaque
```

#### Langfuse Initialization Secret

```bash
kubectl create secret generic langfuse-init \
--namespace langfuse \
--from-literal=LANGFUSE_INIT_ORG_ID=epam-ai-run \
--from-literal=LANGFUSE_INIT_PROJECT_ID=codemie \
--from-literal=LANGFUSE_INIT_PROJECT_PUBLIC_KEY=pk-lf-$(uuid=$(openssl rand -hex 16) && echo ${uuid:0:8}-${uuid:8:4}-${uuid:12:4}-${uuid:16:4}-${uuid:20:12}) \
--from-literal=LANGFUSE_INIT_PROJECT_SECRET_KEY=sk-lf-$(uuid=$(openssl rand -hex 16) && echo ${uuid:0:8}-${uuid:8:4}-${uuid:12:4}-${uuid:16:4}-${uuid:20:12}) \
--from-literal=LANGFUSE_INIT_USER_EMAIL=codemie_user@codemie.com \
--from-literal=LANGFUSE_INIT_USER_PASSWORD="$(openssl rand -hex 16)" \
--from-literal=LANGFUSE_INIT_ORG_NAME="EPAM AI/Run" \
--from-literal=LANGFUSE_INIT_PROJECT_NAME="CodeMie" \
--from-literal=LANGFUSE_INIT_USER_NAME="CodeMie User"
```

#### Component Secrets

Create secrets for various components:

```bash
# ClickHouse Secret
kubectl create secret generic langfuse-clickhouse \
--namespace langfuse \
--from-literal=admin-password="$(openssl rand -hex 16)" \
--type=Opaque

# MinIO Secret
kubectl create secret generic langfuse-s3 \
--namespace langfuse \
--from-literal=root-user="minio" \
--from-literal=root-password="$(openssl rand -hex 16)" \
--type=Opaque

# Redis (Valkey) Secret
kubectl create secret generic langfuse-redis \
--namespace langfuse \
--from-literal=valkey-password="$(openssl rand -hex 16)" \
--type=Opaque

# Encryption Key Secret
kubectl create secret generic langfuse-encryption-key \
--namespace langfuse \
--from-literal=key="$(openssl rand -hex 32)" \
--type=Opaque

# PostgreSQL Secret
kubectl create secret generic langfuse-postgresql \
--namespace langfuse \
--from-literal=password="your_strong_password_here" \ # use same password for langfuse_admin user
--type=Opaque
```

### Step 4: Deploy Langfuse

Install or upgrade Langfuse using Helm:

```bash
helm upgrade --install langfuse langfuse/langfuse \
--namespace langfuse \
--version 1.5.3 \
--values ./langfuse/values.yaml
```

### Step 5: Configure Integration

Create the Langfuse integration secret in the `codemie` namespace:

```bash
kubectl create secret generic langfuse-integration \
--namespace codemie \
--from-literal=langfuse-public-key="$(kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_PROJECT_PUBLIC_KEY}' | base64 --decode)" \
--from-literal=langfuse-secret-key="$(kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_PROJECT_SECRET_KEY}' | base64 --decode)" \
--type=Opaque
```

## Post-Deployment Configuration

After successful deployment (using either method), you need to configure CodeMie API integration.

### Update CodeMie API Configuration

Add the following environment variables to your CodeMie API `values.yaml`:

```yaml
extraEnv:
  - name: LANGFUSE_TRACES
    value: 'true'
  - name: LANGFUSE_HOST
    value: https://langfuse.%DOMAIN%
  - name: LANGFUSE_SAMPLE_RATE
    value: '1.0'
  - name: LANGFUSE_TRACING_ENVIRONMENT
    value: <your_environment_name>
  - name: LANGFUSE_RELEASE
    value: '1.4.0' # AI/Run CodeMie current version
  - name: LANGFUSE_PUBLIC_KEY
    valueFrom:
      secretKeyRef:
        name: langfuse-integration
        key: langfuse-public-key
  - name: LANGFUSE_SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: langfuse-integration
        key: langfuse-secret-key
```

### Redeploy CodeMie API

```bash title="Example Redeployment Command"
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-<cloud_name>.yaml" \
--wait --timeout 600s
```

### Verify Deployment

```bash
# Check Langfuse pods
kubectl get pods -n langfuse

# Check services
kubectl get svc -n langfuse

# Check ingress
kubectl get ingress -n langfuse
```

### Access Langfuse UI

Access the UI at `https://langfuse.%%DOMAIN%%`. Use the username and password from the `langfuse-init` secret.

```bash
# Retrieve the langfuse email and password from the Kubernetes secret.
kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_USER_EMAIL}' | base64 --decode; echo
kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_USER_PASSWORD}' | base64 --decode; echo
```

## Troubleshooting

### Common Issues

1. **PostgreSQL Connection Failed**
   - Ensure PostgreSQL is running in `codemie` namespace
   - Check PostgreSQL pod name and connectivity
   - Verify PostgreSQL service name

2. **Helm Deployment Failed**
   - Review `values.yaml` configuration
   - Check resource availability in cluster
   - Verify Helm chart version compatibility
   - Ensure domain placeholders are replaced

3. **Errors in LangFuse components**
   - Check that resource limits are appropriate
   - Follow system requirements outlined in this document or in the official [guide](https://langfuse.com/self-hosting/infrastructure/containers)

4. **ClickHouse runs out of resources**
   - Make sure that ClickHouse pods have at least 8 Gb of memory
   - Follow LangFuse [scaling](https://langfuse.com/self-hosting/scaling) recommendations

### Recovery

If deployment fails:

1. **Clean up resources**:

```bash
# Remove namespace
kubectl delete namespace langfuse

# Delete langfuse-integration secret
kubectl -n codemie delete secret langfuse-integration

# Reset postgresql database instance
# Connect to the "postgres" database first, if not already connected
psql -U postgres

# -- Revoke schema and database privileges
REVOKE ALL ON SCHEMA public FROM langfuse_admin;
REVOKE ALL ON DATABASE postgres FROM langfuse_admin;

# -- Drop the user
DROP USER langfuse_admin;

# -- Drop the database
DROP DATABASE IF EXISTS postgres_langfuse;
```

2. **Fix configuration issues**

3. **Re-run deployment**:
   - **Automated**: `./deploy-langfuse.sh`
   - **Manual**: Follow manual steps again
