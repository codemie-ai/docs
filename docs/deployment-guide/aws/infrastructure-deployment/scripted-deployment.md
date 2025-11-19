---
sidebar_position: 1
title: Scripted Deployment
description: Automated AWS infrastructure deployment using scripts
---

# Scripted Infrastructure Deployment

The `aws-terraform.sh` script automates the deployment of infrastructure for AI/Run CodeMie on AWS.

## Prerequisites

Ensure you have completed all items in the [Prerequisites](../02-prerequisites.md) checklist.

## Deployment Order

The script deploys resources in the following order:

| #   | Resource name      | Repository                                                                                        |
| --- | ------------------ | ------------------------------------------------------------------------------------------------- |
| 1   | IAM deployer role  | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)           |
| 2   | Main AWS resources | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform) |

## Step 1: IAM Deployer Role Creation

This step creates the `DeployerRole` AWS IAM role that will be used for all subsequent infrastructure deployments.

:::info
The created IAM role contains required permissions to manage AWS resources
:::

1. Clone the IAM repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam.git
cd codemie-terraform-aws-iam
```

2. Review input variables in `codemie-terraform-aws-iam/variables.tf` and create a `terraform.tfvars` file:

```hcl
region               = "your-region"
role_arn             = "arn:aws:iam::xxx:role/yourRole"
platform_domain_name = "your.domain"
...
```

:::info
Ensure you have carefully reviewed all variables and replaced mock values with yours.
:::

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

:::warning EPAM Accounts Only
After role creation it's necessary to enable IRSA (IAM Roles for Service Accounts) in EKS. Follow [these instructions](https://kb.epam.com/display/EPMCDME/Enabling+IRSA+%28IAM+Roles+for+Service+Accounts%29+in+EKS) to create a support request.
:::

## Step 2: Run Installation Script

1. Clone the platform repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform.git
cd codemie-terraform-aws-platform
```

2. Fill in configuration details in `deployment.conf`:

```bash
# AI/Run CodeMie deployment variables configuration
AWS_PROFILE="My_Profile"
TF_VAR_region="eu-west-2"
TF_VAR_role_arn="arn:aws:iam::123456789012:role/AIRunDeployerRole"
TF_VAR_platform_domain_name="codemie.example.com"
TF_VAR_eks_admin_role_arn=""
TF_VAR_role_permissions_boundary_arn=""
TF_VAR_cluster_version="1.33"
TF_VAR_demand_instance_types='[{ instance_type = "r5.xlarge" }]'
TF_VAR_demand_max_nodes_count=2
TF_VAR_demand_desired_nodes_count=2
TF_VAR_demand_min_nodes_count=2
TF_VAR_platform_name="codemie"
TF_VAR_subnet_azs='["eu-west-2a", "eu-west-2b", "eu-west-2c"]'
TF_VAR_s3_states_bucket_name="codemie-terraform-states"
TF_VAR_table_name="codemie_terraform_locks"
TF_VAR_enable_private_connections=true
TF_VAR_lb_prefix_list_ids='[]'
TF_VAR_lb_specific_ips='[]'
TF_VAR_security_group_ids='[]'
```

3. Run the installation script:

```bash
bash aws-terraform.sh
```

## What the Script Does

After execution, the script will:

### 1. Validate Environment

- Check for required tools (`tfenv`, `AWS CLI`)
- Verify AWS authentication status
- Validate configuration parameters

### 2. Deploy Infrastructure

- Create Terraform backend storage (S3 bucket and DynamoDB table)
- Deploy core AI/Run CodeMie Platform infrastructure
- Set up necessary AWS resources

### 3. Generate Outputs

The script creates a `deployment_outputs.env` file with essential infrastructure details:

```bash
AWS_DEFAULT_REGION=eu-west-2
EKS_AWS_ROLE_ARN=arn:aws:iam::123456789012:role/...
AWS_KMS_KEY_ID=12345678-90ab-cdef-1234-567890abcdef
AWS_S3_BUCKET_NAME=codemie-platform-bucket
```

### 4. Complete Deployment

- Success message confirms deployment
- Logs available in `logs/codemie_aws_deployment_YYYY-MM-DD-HHMMSS.log`
- Summary of deployed resources displayed

:::warning Security
Keep the `deployment_outputs.env` file secure as it contains sensitive information. Do not commit it to version control.
:::

## Next Steps

After successful deployment, proceed to [Components Deployment](../components-deployment/) to install AI/Run CodeMie application components.
