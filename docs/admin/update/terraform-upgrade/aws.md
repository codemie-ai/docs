---
id: terraform-upgrade-aws
title: Terraform Upgrade — AWS (1.5.7 → 1.13.5)
sidebar_label: AWS
sidebar_position: 2
pagination_next: null
pagination_prev: admin/update/terraform-upgrade/terraform-upgrade
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Terraform Upgrade — AWS (1.5.7 → 1.13.5)

## What Changed

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

Default EKS version: **1.33** → **1.35**. If upgrading from 1.33, apply twice — first set `cluster_version = "1.34"`, then `"1.35"`.

Switch to Terraform 1.13.5:

```bash
tfenv use 1.13.5
```

<Tabs>
  <TabItem value="script" label="Deployment Script" default>

Run the deployment script — it automatically handles upgrade:

```bash
bash aws-terraform.sh
```

  </TabItem>
  <TabItem value="manual" label="Manual">

Load your deployment variables:

```bash
export AWS_PROFILE="your-aws-profile"
set -a && source deployment.conf && set +a
```

Alternatively, create `terraform.tfvars` in each module directory (`remote-backend/`, `platform/`).

Migrate remote backend (removes DynamoDB table):

```bash
cd remote-backend
terraform init
terraform apply
```

```bash
export BACKEND_BUCKET=$(terraform output -raw terraform_states_s3_bucket_name)
```

Migrate platform to S3 native locking:

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

```bash
terraform plan
```

  </TabItem>
</Tabs>
