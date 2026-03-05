---
id: terraform-upgrade
title: Terraform Version Upgrade (1.5.7 → 1.13.5)
sidebar_label: Terraform Upgrade (1.5.7 → 1.13.5)
sidebar_position: 1
pagination_next: null
pagination_prev: admin/update/update-overview
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Terraform Version Upgrade (1.5.7 → 1.13.5)

## What Changed

| Area                               | AWS                                    | Azure                                      | GCP                                                  |
| ---------------------------------- | -------------------------------------- | ------------------------------------------ | ---------------------------------------------------- |
| Terraform                          | 1.5.7 → **1.13.5**                     | 1.5.7 → **1.13.5**                         | 1.5.7 → **1.13.5**                                   |
| Kubernetes (default value changed) | EKS 1.33 → **1.35** (upgrade optional) | AKS 1.33.5 → **1.34.2** (upgrade optional) | GKE 1.33 → **1.34.3** (upgrade optional)             |
| State locking                      | DynamoDB → **S3 native**               | No changes                                 | No changes                                           |
| Provider versions                  | No changes                             | Updated, see below                         | Google 6.46.0 → **7.21.0**, Random 3.7.2 → **3.8.1** |
| Terraform registry modules         | Updated, see below                     | No changes                                 | Updated, see below                                   |

## How to Upgrade

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

:::info EKS upgrade is optional
The default version changed to **1.35**, but you can keep the current version by pinning `cluster_version` in your `platform` config before applying. If upgrading from `1.33`, apply twice — first set `1.34`, then `1.35`.
:::

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

**Migrate platform** to S3 native locking:

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

:::info AKS upgrade is optional
The default version changed to **1.34.2**, but you can keep the current version by pinning `kubernetes_version` in your `platform` config before applying.
:::

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

**Upgrade platform:**

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
  <TabItem value="gcp" label="GCP">

Google provider upgraded from **6.x to 7.x** (major version). All Terraform registry modules were updated for compatibility:

| Module                                              | Old version | New version |
| --------------------------------------------------- | ----------- | ----------- |
| `terraform-google-modules/service-accounts/google`  | 4.5.4       | **4.7.0**   |
| `terraform-google-modules/kms/google`               | 3.2.0       | **4.1.2**   |
| `terraform-google-modules/network/google`           | 10.0.0      | **16.0.1**  |
| `terraform-google-modules/cloud-nat/google`         | 5.3.0       | **7.0.0**   |
| `terraform-google-modules/kubernetes-engine/google` | 35.0.1      | **43.0.0**  |
| `terraform-google-modules/bastion-host/google`      | 8.0.0       | **9.0.0**   |
| `terraform-google-modules/cloud-dns/google`         | 5.3.0       | **7.1.0**   |
| `terraform-google-modules/sql-db/google`            | 25.2.2      | **27.2.0**  |

:::info GKE upgrade is optional
The default version changed to **1.34.3**, but you can keep the current version by pinning `kubernetes_version` in your `platform` config before applying.
:::

:::warning Bastion host will be recreated
Only applies when `private_cluster = true`.

bastion-host v9.0.0 adds `resource_manager_tags` support to the bastion compute instance ([#227](https://github.com/terraform-google-modules/terraform-google-bastion-host/pull/227)). This introduces a `params` block on `google_compute_instance_from_template`, which is marked as `ForceNew` in the Google provider — Terraform must destroy and recreate the VM.

**To preserve files on the bastion disk**, disable auto-delete on the boot disk before applying:

```bash
gcloud compute instances set-disk-auto-delete <BASTION_NAME> \
  --no-auto-delete \
  --disk=<BASTION_NAME> \
  --zone=<ZONE> \
  --project=<PROJECT_ID>
```

For full details see the changelogs: [bastion-host v9.0.0](https://github.com/terraform-google-modules/terraform-google-bastion-host/blob/main/CHANGELOG.md#900-2025-09-23), [terraform-google-vm v13.0.0](https://github.com/terraform-google-modules/terraform-google-vm/blob/main/CHANGELOG.md#1300-2024-12-17).
:::

**Upgrade remote backend:**

```bash
cd codemie-terraform-gcp-remote-backend
terraform init -upgrade
terraform plan
terraform apply
```

**Upgrade platform:**

```bash
cd codemie-terraform-gcp-platform
terraform init -upgrade
```

```bash
terraform plan
```

Review the plan output. You should see:

- **1 resource replaced** — bastion VM (expected, see warning above)
- **1 resource updated** — GKE master authorized networks (cascading from bastion IP change)
- **Drift detection** on Cloud SQL, GKE cluster, and VPC — these are cosmetic (provider 7.x now tracks additional computed fields)

```bash
terraform apply
```

  </TabItem>
  </Tabs>
