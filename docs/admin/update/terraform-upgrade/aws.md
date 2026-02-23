---
id: terraform-upgrade-aws
title: Terraform Upgrade — AWS (1.5.7 → 1.13.5)
sidebar_label: AWS
sidebar_position: 2
pagination_next: null
pagination_prev: admin/update/terraform-upgrade/terraform-upgrade
---

# Terraform Upgrade — AWS (1.5.7 → 1.13.5)

## What Changed

### Terraform Version and State Locking

Terraform 1.13.5 introduces **S3 native state locking**, which replaces the previously required DynamoDB table. After migration:

- DynamoDB table used for state locking is **removed**
- State locking is handled directly by the S3 bucket via `use_lockfile=true`

### Terraform Module Updates

All Terraform registry modules in the `platform` module were updated to their latest stable versions:

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

### Kubernetes Version Update

The default EKS cluster version in `platform/variables.tf` was updated from **1.33** to **1.35**.

:::warning EKS does not allow skipping minor versions

AWS EKS requires upgrading one minor version at a time. If your cluster is currently on **1.33**, you must apply this guide **twice**:

1. Set `cluster_version = "1.34"` in your `deployment.conf` or `terraform.tfvars`, then apply this guide fully.
2. Once the cluster is stable on 1.34, set `cluster_version = "1.35"` and apply this guide again.

Attempting to jump directly from 1.33 to 1.35 will fail.

:::

## Prerequisites

- [tfenv](https://github.com/tfutils/tfenv#installation) installed
- AWS CLI configured (`aws configure`)
- Required IAM permissions to modify S3 and DynamoDB resources

Switch to Terraform 1.13.5:

```bash
tfenv install 1.13.5 && tfenv use 1.13.5
```

## Option 1: Deployment Script (Recommended)

Run the deployment script — it automatically handles the DynamoDB-to-S3 migration:

```bash
bash aws-terraform.sh
```

The script detects the existing state, removes the DynamoDB table, and reconfigures the S3 backend with native locking.

## Option 2: Manual Migration

Use this approach if you need full control over each step.

### Step 0 — Load Configuration

Load your deployment variables (choose one method):

**Method A — Using `deployment.conf`:**

```bash
export AWS_PROFILE="your-aws-profile"
set -a && source deployment.conf && set +a
```

**Method B — Using `terraform.tfvars` files:**

Create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`) with the required variables. See the `variables.tf` for variable reference.

### Step 1 — Migrate Remote Backend (Remove DynamoDB)

Navigate to the `remote-backend` directory and apply the updated configuration. This removes the DynamoDB table and enables S3 native locking on the existing bucket:

```bash
cd remote-backend
terraform init
terraform apply
```

Get the backend bucket name for the next step:

```bash
export BACKEND_BUCKET=$(terraform output -raw terraform_states_s3_bucket_name)
```

### Step 2 — Migrate Platform to S3 Native Locking

Navigate to the `platform` directory and reinitialize the backend with `-reconfigure`. This switches the locking mechanism from DynamoDB to S3:

```bash
cd ../platform
```

```bash
terraform init -reconfigure \
  -backend-config="bucket=${BACKEND_BUCKET}" \
  -backend-config="key=${TF_VAR_region}/codemie/platform_terraform.tfstate" \
  -backend-config="region=${TF_VAR_region}" \
  -backend-config="acl=bucket-owner-full-control" \
  -backend-config="encrypt=true" \
  -backend-config="use_lockfile=true"
```

Verify the migration was successful — the plan should show no infrastructure changes:

```bash
terraform plan
```

:::info Why `-reconfigure`?

The `-reconfigure` flag forces Terraform to update the backend configuration without migrating state. The existing state file remains in the same S3 bucket; only the locking mechanism changes.

:::
