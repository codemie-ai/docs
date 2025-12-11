---
id: automated-deployment
title: Automated Deployment (Recommended)
sidebar_label: Automated Deployment
sidebar_position: 4
description: Deploy Langfuse automatically using the deployment script
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
The Langfuse chart version is now managed in `langfuse/Chart.yaml` (dependency version), not via command-line option.
::::

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

### Provide PostgreSQL Password when Asked

The script will prompt for the PostgreSQL password if the required secret is not found.

```
[INFO] PostgreSQL secret not found in namespace 'langfuse'
This secret is required to connect to your managed PostgreSQL database.
Please enter the password for your PostgreSQL user (input hidden)
PostgreSQL password:
```

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

:::note Chart Version
The Langfuse Helm chart version is managed in `langfuse/Chart.yaml` under the `dependencies` section.
:::

## What the Script Does

1. **Validation**: Checks for required tools and cluster connectivity
2. **Namespace Creation**: Creates the specified namespace if it doesn't exist
3. **Helm Repository**: Adds and updates Langfuse Helm repository
4. **PostgreSQL Password creation**: Asks for the database password
5. **Secret Creation**: Creates all required Kubernetes secrets
6. **Helm Dependencies**: Updates Helm chart dependencies from Chart.yaml
7. **Langfuse Deployment**: Deploys Langfuse using local Helm chart with custom templates (including retention TTL job)
8. **Integration Setup**: Creates integration secret for CodeMie
9. **Pod Restart**: Restarts Langfuse web and worker pods
