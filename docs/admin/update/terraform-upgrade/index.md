---
id: terraform-upgrade
title: Terraform Version Upgrade (1.5.7 → 1.13.5)
sidebar_label: Terraform Upgrade
sidebar_position: 1
pagination_next: null
pagination_prev: admin/update/update-overview
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Terraform Version Upgrade (1.5.7 → 1.13.5)

# What changed

| Area                       | AWS                                                                     | Azure                                                  |
| -------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------ |
| Terraform                  | 1.5.7 → **1.13.5**                                                      | 1.5.7 → **1.13.5**                                     |
| Kubernetes                 | EKS 1.33 → **1.35** (two-step upgrade required)                         | AKS 1.33.5 → **1.34.2**                                |
| State locking              | DynamoDB → **S3 native**                                                | —                                                      |
| Provider versions          | —                                                                       | `azurerm`, `azapi`, `azuread`, `random`, `tls` updated |
| Terraform registry modules | `vpc`, `alb`, `eks`, `iam`, `ecr`, `route53`, `acm`, `key-pair` updated | —                                                      |

Switch to Terraform 1.13.5:

```bash
tfenv use 1.13.5
```

<Tabs groupId="cloud">
  <TabItem value="aws" label="AWS">

Terraform 1.13.5 replaces DynamoDB state locking with **S3 native locking** (`use_lockfile=true`). The DynamoDB table is removed after migration.

Terraform registry modules in `platform` were updated:

| Module                               | Old version | New version |
| ------------------------------------ | ----------- | ----------- |
| `terraform-aws-modules/vpc/aws`      | 5.14.0      | **5.21.0**  |
| `terraform-aws-modules/alb/aws`      | 9.12.0      | **9.17.0**  |
| `terraform-aws-modules/route53/aws`  | 4.1.0       | **5.0.0**   |
| `terraform-aws-modules/acm/aws`      | 5.1.1       | **5.2.0**   |
| `terraform-aws-modules/key-pair/aws` | 2.0.3       | **2.1.1**   |
| `terraform-aws-modules/eks/aws`      | 20.26.0     | **20.37.2** |
| `terraform-aws-modules/iam/aws`      | 5.47.1      | **5.60.0**  |
| `terraform-aws-modules/ecr/aws`      | 2.3.0       | **2.4.0**   |

Default EKS version: **1.33** → **1.35**.

If upgrading from 1.33, apply twice — first set `cluster_version = "1.34"`, then `"1.35"`.

<Tabs>
  <TabItem value="aws-script" label="Deployment Script" default>

Run the deployment script — it automatically handles upgrade:

```bash
bash aws-terraform.sh
```

  </TabItem>
  <TabItem value="aws-manual" label="Manual">

**Load configuration:**

```bash
export AWS_PROFILE="your-aws-profile"
set -a && source deployment.conf && set +a
```

Alternatively, create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`).

**Migrate remote backend** (removes DynamoDB table):

```bash
cd remote-backend
terraform init
terraform apply
```

```bash
export BACKEND_BUCKET=$(terraform output -raw terraform_states_s3_bucket_name)
```

**Migrate platform** to S3 native locking (upgrades EKS to 1.35):

```bash
cd ../platform
terraform init -reconfigure \
  -backend-config="bucket=${BACKEND_BUCKET}" \
  -backend-config="key=${TF_VAR_region}/codemie/platform_terraform.tfstate" \
  -backend-config="region=${TF_VAR_region}" \
  -backend-config="acl=bucket-owner-full-control" \
  -backend-config="encrypt=true" \
  -backend-config="use_lockfile=true"
terraform plan
terraform apply
```

  </TabItem>
  </Tabs>

  </TabItem>
  <TabItem value="azure" label="Azure">

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

<Tabs>
  <TabItem value="azure-script" label="Deployment Script" default>

Run the deployment script — it automatically handles upgrade:

```bash
./azure-terraform.sh
```

  </TabItem>
  <TabItem value="azure-manual" label="Manual">

**Load configuration:**

```bash
set -a && source deployment.conf && set +a
```

Alternatively, create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`, `ai-models/`).

**Upgrade remote backend:**

```bash
cd remote-backend
terraform init -upgrade
```

```bash
export BC_RESOURCE_GROUP_NAME=$(terraform output -raw terraform_state_resource_group_name)
export BC_STORAGE_ACCOUNT_NAME=$(terraform output -raw terraform_state_storage_account)
export STORAGE_ACCOUNT_KEY=$(terraform output -raw terraform_state_storage_account_key)
```

**Upgrade platform** (upgrades AKS from 1.33.5 → 1.34.2):

```bash
cd ../platform
terraform init -upgrade \
    -backend-config="resource_group_name=${BC_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BC_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=platform.terraform.tfstate"
```

```bash
terraform plan
```

```bash
terraform apply
```

**Upgrade ai-models** (skip if `DEPLOY_AI_MODELS="false"`):

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

  </TabItem>
  </Tabs>
