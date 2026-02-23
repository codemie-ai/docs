---
id: terraform-upgrade-azure
title: Terraform Upgrade — Azure (1.5.7 → 1.13.5)
sidebar_label: Azure
sidebar_position: 3
pagination_next: null
pagination_prev: admin/update/terraform-upgrade/terraform-upgrade
---

# Terraform Upgrade — Azure (1.5.7 → 1.13.5)

## What Changed

This upgrade updates Terraform to **1.13.5**, bumps provider versions across all three modules, and upgrades the default Kubernetes version.

**Provider versions:**

| Module         | Provider  | Old version | New version |
| -------------- | --------- | ----------- | ----------- |
| platform       | `azurerm` | 4.46.0      | `~> 4.60`   |
| platform       | `azapi`   | 2.6.1       | `~> 2.8`    |
| platform       | `azuread` | 3.5.0       | `~> 3.7`    |
| platform       | `random`  | 3.7.2       | `~> 3.8`    |
| platform       | `tls`     | 4.1         | `~> 4.2`    |
| remote-backend | `azurerm` | 4.46.0      | `~> 4.60`   |
| ai-models      | `azurerm` | 3.109.0     | `~> 3.117`  |
| ai-models      | `azapi`   | 1.9.0       | `~> 1.15`   |

### Kubernetes Version Update

The default AKS cluster version in `platform/variables.tf` was updated from **1.33.5** to **1.34.2**.

## Prerequisites

- [tfenv](https://github.com/tfutils/tfenv#installation) installed
- Azure CLI installed and logged in (`az login`)
- Contributor access on the target subscription

Switch to Terraform 1.13.5:

```bash
tfenv install 1.13.5 && tfenv use 1.13.5
```

## Option 1: Deployment Script (Recommended)

Run the deployment script — it automatically handles the provider upgrade across all modules:

```bash
./azure-terraform.sh
```

The script runs `terraform init -upgrade` for each module in the correct order and prompts for approval before applying changes.

## Option 2: Manual Migration

Use this approach if you need full control over each step.

### Step 0 — Load Configuration

Load your deployment variables (choose one method):

**Method A — Using `deployment.conf`:**

```bash
set -a && source deployment.conf && set +a
```

**Method B — Using `terraform.tfvars` files:**

Create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`, `ai-models/`) with the required variables. See the `variables.tf` for variable reference.

### Step 1 — Upgrade Remote Backend

Navigate to `remote-backend` and upgrade providers:

```bash
cd remote-backend
terraform init -upgrade
```

Verify the upgrade was successful:

```bash
terraform plan
```

Export backend configuration for the next steps:

```bash
export BC_RESOURCE_GROUP_NAME=$(terraform output -raw terraform_state_resource_group_name)
export BC_STORAGE_ACCOUNT_NAME=$(terraform output -raw terraform_state_storage_account)
export STORAGE_ACCOUNT_KEY=$(terraform output -raw terraform_state_storage_account_key)
```

### Step 2 — Upgrade Platform

Navigate to `platform` and reinitialize with the upgraded providers:

```bash
cd ../platform
```

```bash
terraform init -upgrade \
    -backend-config="resource_group_name=${BC_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BC_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=platform.terraform.tfstate"
```

Verify the upgrade:

```bash
terraform plan
```

### Step 3 — Upgrade AI Models

:::note Skip AI Models

If `DEPLOY_AI_MODELS="false"` in your configuration `deployment.conf`, skip Step 3.

:::

Navigate to `ai-models` and reinitialize with the upgraded providers:

```bash
cd ../ai-models
```

```bash
terraform init -upgrade \
    -backend-config="resource_group_name=${BC_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BC_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=ai_models.terraform.tfstate"
```

Verify the upgrade:

```bash
terraform plan
```
