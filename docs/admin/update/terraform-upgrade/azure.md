---
id: terraform-upgrade-azure
title: Terraform Upgrade — Azure (1.5.7 → 1.13.5)
sidebar_label: Azure
sidebar_position: 3
pagination_next: null
pagination_prev: admin/update/terraform-upgrade/terraform-upgrade
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Terraform Upgrade — Azure (1.5.7 → 1.13.5)

## What Changed

Provider versions updated across all three modules:

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

Default AKS version: **1.33.5** → **1.34.2**.

Switch to Terraform 1.13.5:

```bash
tfenv use 1.13.5
```

<Tabs>
  <TabItem value="script" label="Deployment Script" default>

Run the deployment script — it automatically handles upgrade:

```bash
./azure-terraform.sh
```

  </TabItem>
  <TabItem value="manual" label="Manual">

Load your deployment variables:

```bash
set -a && source deployment.conf && set +a
```

Alternatively, create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`, `ai-models/`).

Upgrade remote backend:

```bash
cd remote-backend
terraform init -upgrade
```

```bash
export BC_RESOURCE_GROUP_NAME=$(terraform output -raw terraform_state_resource_group_name)
export BC_STORAGE_ACCOUNT_NAME=$(terraform output -raw terraform_state_storage_account)
export STORAGE_ACCOUNT_KEY=$(terraform output -raw terraform_state_storage_account_key)
```

Upgrade platform:

```bash
cd ../platform
terraform init -upgrade \
    -backend-config="resource_group_name=${BC_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BC_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=platform.terraform.tfstate"
```

Upgrade ai-models (skip if `DEPLOY_AI_MODELS="false"`):

```bash
cd ../ai-models
terraform init -upgrade \
    -backend-config="resource_group_name=${BC_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BC_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=ai_models.terraform.tfstate"
```

  </TabItem>
</Tabs>
