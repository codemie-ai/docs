---
id: automated-deployment
title: Automated Deployment (Recommended)
sidebar_label: Automated Deployment
sidebar_position: 4
description: Deploy Langfuse automatically using the deployment script
pagination_prev: admin/deployment/extensions/assistants-evaluation/deployment/deployment-overview
pagination_next: null
---

# Automated Deployment (Recommended)

The automated deployment uses the `deploy-langfuse.sh` script to handle the entire Langfuse deployment process.

## Overview

The deployment script automates:

- Kubernetes secret creation
- Helm repository configuration
- Langfuse deployment
- Integration secret creation for CodeMie

## Usage

:::tip Script is Idempotent

The script is designed to be idempotent. Follow the next steps to install.

:::

### Basic Usage

```bash
# Deploy with default settings
./langfuse/deploy-langfuse.sh

# Deploy to a custom namespace
./langfuse/deploy-langfuse.sh -n my-langfuse-namespace

# Use a custom values file
./langfuse/deploy-langfuse.sh --values-file custom-values.yaml
```

:::info Version Management
The Langfuse application version is configured in `langfuse/values.yaml` using `langfuse.langfuse.image.tag`. The Helm chart version is managed in `langfuse/Chart.yaml` (dependency version).
:::

### Advanced Usage

```bash
# Perform a dry run to see what would be executed
./langfuse/deploy-langfuse.sh --dry-run

# Skip secret creation (if secrets already exist)
./langfuse/deploy-langfuse.sh --skip-secrets

# Skip Helm deployment (for testing purposes)
./langfuse/deploy-langfuse.sh --skip-deploy

# Combined options
./langfuse/deploy-langfuse.sh -n production --values-file prod-values.yaml
```

### Provide PostgreSQL Passwords when Asked

The script will prompt for passwords if the required secrets are not found:

**1. Langfuse PostgreSQL user password** — used to create the Langfuse PostgreSQL user and for the app to connect:

```
[INFO] PostgreSQL secret 'langfuse-postgresql' not found in namespace 'langfuse'
Please enter the password for the Langfuse PostgreSQL user
PostgreSQL password:
```

**2. PostgreSQL admin credentials** — prompted only if `dbInitJob.enabled: true` in `langfuse/values.yaml`. Used by the init job to create the `postgres_langfuse` database and user:

```
[INFO] PostgreSQL admin secret 'codemie-postgresql' not found in namespace 'langfuse'
This secret is used by the db-init-job to create the Langfuse database and user.
PostgreSQL admin username:
PostgreSQL admin password (input hidden):
```

Admin credentials can be found in `deployment_outputs.env` (`CODEMIE_POSTGRES_DATABASE_USER`, `CODEMIE_POSTGRES_DATABASE_PASSWORD`).

### Help

```bash
./langfuse/deploy-langfuse.sh --help
```

## Script Options

| Option            | Description                     | Default       |
| ----------------- | ------------------------------- | ------------- |
| `-h, --help`      | Show help message               | -             |
| `-n, --namespace` | Kubernetes namespace            | `langfuse`    |
| `-d, --dry-run`   | Perform dry run without changes | `false`       |
| `--skip-secrets`  | Skip secret creation            | `false`       |
| `--skip-deploy`   | Skip Helm deployment            | `false`       |
| `--values-file`   | Path to values.yaml file        | `values.yaml` |

:::note Version Management

- **Langfuse Application**: Set version in `langfuse/values.yaml` → `langfuse.langfuse.image.tag: "3.129.0"`
- **Helm Chart**: Managed in `langfuse/Chart.yaml` under the `dependencies` section
  :::

## What the Script Does

1. **Validation**: Checks for required tools and cluster connectivity
2. **Namespace Creation**: Creates the specified namespace if it doesn't exist
3. **Helm Repository**: Adds and updates Langfuse Helm repository
4. **PostgreSQL Secrets**: Prompts for the Langfuse PostgreSQL user password. If `dbInitJob.enabled: true`, also prompts for PostgreSQL admin credentials to create `codemie-postgresql` secret
5. **Secret Creation**: Creates all required Kubernetes secrets
6. **Helm Dependencies**: Updates Helm chart dependencies from Chart.yaml
7. **Langfuse Deployment**: Deploys Langfuse using local Helm chart with custom templates (including retention TTL job)
8. **Integration Setup**: Creates integration secret for CodeMie
9. **Pod Restart**: Restarts Langfuse web and worker pods
