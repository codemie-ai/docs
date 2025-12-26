---
id: manual-deployment
title: Manual Deployment
sidebar_label: Manual Deployment
sidebar_position: 5
description: Deploy Langfuse manually with granular control
---

# Manual Deployment

This option is recommended if you prefer manual control over each step or need to customize the deployment process.

## Step 1: Create Namespace

Create a dedicated namespace for Langfuse:

```bash
kubectl create namespace langfuse
```

## Step 2: Add Helm Repository

```bash
helm repo add langfuse https://langfuse.github.io/langfuse-k8s
helm repo update
```

## Step 3: Create Required Secrets

### Langfuse Configuration Secret

```bash
kubectl create secret generic langfuse \
--namespace langfuse \
--from-literal=salt="$(openssl rand -base64 32)" \
--from-literal=nextauth-secret="$(openssl rand -hex 32)" \
--type=Opaque
```

### Langfuse Initialization Secret

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

### Component Secrets

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

## Step 4: Update Helm Dependencies

Update the local chart dependencies:

```bash
cd langfuse
helm dependency update
cd ..
```

:::info Local Chart
Langfuse deployment now uses a local Helm chart that wraps the official chart. This allows for custom templates (like the retention TTL job) while still using the official upstream chart.
:::

## Step 5: Deploy Langfuse

Install or upgrade Langfuse using the local Helm chart:

```bash
helm upgrade --install langfuse ./langfuse \
--namespace langfuse \
--values ./langfuse/values.yaml \
--wait \
--timeout 10m
```

:::note Version Management

- **Langfuse Application**: Set version in `langfuse/values.yaml` → `langfuse.langfuse.image.tag: "3.129.0"`
- **Helm Chart**: Managed in `langfuse/Chart.yaml` under the `dependencies` section, not via `--version` flag
  :::

## Step 6: Configure Integration

Create the Langfuse integration secret in the `codemie` namespace:

```bash
kubectl create secret generic langfuse-integration \
--namespace codemie \
--from-literal=langfuse-public-key="$(kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_PROJECT_PUBLIC_KEY}' | base64 --decode)" \
--from-literal=langfuse-secret-key="$(kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_PROJECT_SECRET_KEY}' | base64 --decode)" \
--type=Opaque
```
