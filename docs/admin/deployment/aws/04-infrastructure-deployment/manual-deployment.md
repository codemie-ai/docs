---
id: infrastructure-manual-deployment
sidebar_position: 2
title: Manual Deployment
description: Manual AWS infrastructure deployment with Terraform
pagination_prev: admin/deployment/aws/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/components-deployment-overview
---

# Manual Infrastructure Deployment

This guide provides step-by-step instructions for manually deploying AWS infrastructure using Terraform, offering more control and customization options.

:::info When to Use Manual Deployment
Manual deployment is suitable when you need fine-grained control over each deployment phase, want to customize Terraform configurations, or are integrating with existing infrastructure management workflows.
:::

## Prerequisites

Before starting the deployment, ensure you have completed all requirements from the [Prerequisites](../prerequisites) page:

### Verification Checklist

- [ ] **AWS Access**: Programmatic access with IAM permissions
- [ ] **Tools Installed**: Terraform 1.5.7, AWS CLI, kubectl, Helm, gcloud CLI, Docker
- [ ] **AWS Authentication**: Configured AWS credentials and region
- [ ] **Repository Access**: Have access to Terraform and Helm repositories
- [ ] **Network Planning**: Prepared list of allowed networks
- [ ] **Domain Configuration**: Route 53 hosted zone ready

:::warning Authentication Required
You must have configured AWS credentials before starting deployment. Verify with `aws sts get-caller-identity`.
:::

## Deployment Phases

Manual deployment involves three sequential phases:

| Phase                                | Description                                                      | Repository                                                                                                    |
| ------------------------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Phase 1: IAM Deployer Role**       | Creates IAM role with required permissions for deployment        | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)                       |
| **Phase 2: State Backend**           | Creates S3 bucket and DynamoDB table for Terraform state files   | [codemie-terraform-aws-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend) |
| **Phase 3: Platform Infrastructure** | Deploys EKS, networking, storage, databases, security components | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform)             |

## Phase 1: IAM Deployer Role Creation

The `DeployerRole` AWS IAM role will be used for all subsequent infrastructure deployments and updates.

:::info
The created IAM role contains all required permissions to manage AWS resources for AI/Run CodeMie deployment.
:::

1. Clone the repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam.git
cd codemie-terraform-aws-iam
```

2. Review input variables in `codemie-terraform-aws-iam/variables.tf` and create a `terraform.tfvars` file:

```hcl
region             = "us-east-1"
platform_name      = "codemie"
deployer_role_name = "AIRunDeployerRole"

# Optional: IAM Permissions Boundary
iam_permissions_boundary_policy_arn = ""

# Optional: Custom tags
tags = {
  "SysName"     = "AI/Run"
  "Environment" = "Production"
  "Project"     = "AI/Run"
}
```

:::tip Review All Variables
Most variables have sensible defaults. Review `variables.tf` for the complete list of available configuration options.
:::

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Phase 2: Terraform Backend Resources Deployment

This phase creates:

- S3 bucket with policy to store terraform states
- DynamoDB to support state locking and consistency checking

1. Clone the repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend.git
cd codemie-terraform-aws-remote-backend
```

2. Review input variables in `codemie-terraform-aws-remote-backend/variables.tf` and create a `terraform.tfvars` file:

```hcl
region                  = "us-east-1"
role_arn                = "arn:aws:iam::123456789012:role/AIRunDeployerRole"  # IAM role created in Phase 1
s3_states_bucket_name   = "codemie-terraform-states"
table_name              = "codemie_terraform_locks"

# Optional: Custom tags
tags = {
  "SysName"     = "CodeMie"
  "Environment" = "Production"
  "Project"     = "CodeMie"
}
```

:::tip Review All Variables
Most variables have sensible defaults. Review `variables.tf` for the complete list of available configuration options.
:::

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply --var-file terraform.tfvars
```

The created S3 bucket will be used for all subsequent infrastructure deployments.

## Phase 3: Main AWS Resources Deployment

This phase creates the following resources (see [Architecture](../architecture)):

- EKS Cluster
- AWS ASGs for the EKS Cluster
- AWS ALB & AWS NLB
- AWS KMS key to encrypt and decrypt sensitive data
- AWS IAM Role to access AWS KMS and Bedrock services
- AWS IAM role ExternalSecretOperator to use AWS Systems Manager
- AWS RDS Postgres
- Optionally: internal AWS ALB and private DNS hosted zone for private network connections

1. Clone the repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform.git
cd codemie-terraform-aws-platform/platform
```

2. Review input variables in `codemie-terraform-aws-platform/platform/variables.tf` and create a `terraform.tfvars` file:

```hcl
# Required: AWS Configuration
region               = "us-east-1"
role_arn             = "arn:aws:iam::123456789012:role/AIRunDeployerRole"  # IAM role created in Phase 1
platform_domain_name = "codemie.example.com"

# Required: Platform Configuration
platform_name = "codemie"
subnet_azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Required: EKS Configuration
cluster_version            = "1.34"
demand_instance_types      = [{ instance_type = "r5.xlarge" }]
demand_max_nodes_count     = 3
demand_desired_nodes_count = 3
demand_min_nodes_count     = 3

# Required: Terraform State Backend (created in Phase 2)
s3_states_bucket_name = "codemie-terraform-states"
table_name            = "codemie_terraform_locks"

# Optional: Network Configuration
platform_cidr  = "10.0.0.0/16"
private_cidrs  = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
public_cidrs   = ["10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]

# Optional: IAM Permissions Boundary
eks_admin_role_arn           = ""
role_permissions_boundary_arn = ""

# Optional: Network Access Control
enable_private_connections = true
lb_prefix_list_ids         = []
lb_specific_ips            = []
security_group_ids         = []
```

:::tip Review All Variables
The configuration file contains many variables. Most have sensible defaults. Review `variables.tf` for the complete list of available configuration options.
:::

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

:::warning Security Groups
Ensure that you allowed incoming traffic to the Security Group attached to LoadBalancers from:

- Your VPN or from networks you're planning to work with AI/Run CodeMie
- EKS Cluster NAT Gateway EIP (not required if `enable_private_connections` variable is set to `true`)
  :::

This concludes AWS infrastructure deployment.

## Next Steps

After successful deployment, proceed to [Components Deployment](../components-deployment/) to install AI/Run CodeMie application components.
