---
sidebar_position: 2
title: Manual Deployment
description: Manual AWS infrastructure deployment with Terraform
---

# Manual Infrastructure Deployment

This guide provides step-by-step instructions for manually deploying AWS infrastructure using Terraform, offering more control and customization options.

## Deployment Order

| #   | Resource name      | Repository                                                                                                    |
| --- | ------------------ | ------------------------------------------------------------------------------------------------------------- |
| 1   | Terraform Backend  | [codemie-terraform-aws-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend) |
| 2   | IAM deployer role  | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)                       |
| 3   | Main AWS resources | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform)             |

## Step 1: IAM Deployer Role Creation

The `DeployerRole` AWS IAM role will be used for all subsequent infrastructure deployments.

:::info
The created IAM role contains required permissions to manage AWS resources
:::

1. Clone the repository:

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


## Step 2: Terraform Backend Resources Deployment

This step creates:

- S3 bucket with policy to store terraform states
- DynamoDB to support state locking and consistency checking

1. Clone the repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend.git
cd codemie-terraform-aws-remote-backend
```

2. Review input variables in `codemie-terraform-aws-remote-backend/variables.tf` and create a `terraform.tfvars` file:

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
terraform apply --var-file terraform.tfvars
```

The created S3 bucket will be used for all subsequent infrastructure deployments.

## Step 3: Main AWS Resources Deployment

This step creates the following resources (see [Architecture](../03-architecture.md)):

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
region                        = "your-region"
role_arn                      = "arn:aws:iam::xxx:role/yourRole"
platform_domain_name          = "your.domain"
...
```

:::info
Ensure you have carefully reviewed all variables and replaced mock values with yours
:::

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

This concludes AWS infrastructure deployment.

## Post-Deployment Security Configuration

:::warning Security Groups
Ensure that you allowed incoming traffic to the Security Group attached to LoadBalancers from:

- Your VPN or from networks you're planning to work with AI/Run CodeMie
- EKS Cluster NAT Gateway EIP (not required if `enable_private_connections` variable is set to `true`)
  :::


## Next Steps

After successful deployment, proceed to [Components Deployment](../components-deployment/) to install AI/Run CodeMie application components.
