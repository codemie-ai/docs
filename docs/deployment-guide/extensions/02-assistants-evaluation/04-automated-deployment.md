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

# Deploy with a specific Langfuse chart version
./langfuse/deploy-langfuse.sh -v 1.5.3

# Use a custom values file
./langfuse/deploy-langfuse.sh --values-file custom-values.yaml
```

### Advanced Usage

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
| `-v, --version`   | Langfuse Helm chart version     | `1.5.3`       |
| `-d, --dry-run`   | Perform dry run without changes | `false`       |
| `--skip-secrets`  | Skip secret creation            | `false`       |
| `--skip-deploy`   | Skip Helm deployment            | `false`       |
| `--values-file`   | Path to values.yaml file        | `values.yaml` |

## What the Script Does

1. **Validation**: Checks for required tools and cluster connectivity
2. **Namespace Creation**: Creates the specified namespace if it doesn't exist
3. **Helm Repository**: Adds and updates Langfuse Helm repository
4. **PostgreSQL Password creation**: Asks for the database password
5. **Secret Creation**: Creates all required Kubernetes secrets
6. **Langfuse Deployment**: Deploys Langfuse using Helm
7. **Integration Setup**: Creates integration secret for CodeMie
