---
id: infrastructure-scripted-deployment
title: Infrastructure Scripted Deployment
sidebar_label: Infrastructure Scripted Deployment
sidebar_position: 1
pagination_prev: admin/deployment/aws/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/components-deployment-overview
---

# Scripted Infrastructure Deployment

This guide walks you through deploying AWS infrastructure for AI/Run CodeMie using the automated `aws-terraform.sh` deployment script. The script handles all deployment phases automatically: IAM deployer role, Terraform state backend, and core platform infrastructure.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
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
You must have configured AWS credentials before running the deployment script. Verify with `aws sts get-caller-identity`.
:::

## Deployment Phases

The script automatically deploys infrastructure in sequential phases:

| Phase                                | Description                                                      | Required                              |
| ------------------------------------ | ---------------------------------------------------------------- | ------------------------------------- |
| **Phase 1: IAM Deployer Role**       | Creates IAM role with required permissions for deployment        | Can be skipped if role already exists |
| **Phase 2: State Backend**           | Creates S3 bucket and DynamoDB table for Terraform state files   | Yes                                   |
| **Phase 3: Platform Infrastructure** | Deploys EKS, networking, storage, databases, security components | Yes                                   |

## Quick Start

### Step 1: Clone IAM Repository

Clone the IAM Terraform repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam.git
cd codemie-terraform-aws-iam
```

### Step 2: Configure IAM Deployment

Review input variables in `variables.tf` and create a `terraform.tfvars` file with your AWS-specific configuration:

```hcl
# Required: AWS Configuration
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

### Step 3: Deploy IAM Role

Initialize and apply Terraform to create the IAM deployer role:

```bash
terraform init
terraform plan
terraform apply
```

:::info
The created IAM role contains all required permissions to manage AWS resources for AI/Run CodeMie deployment. This role will be used for all subsequent platform infrastructure deployments and updates.
:::

### Step 4: Clone Platform Repository

Clone the platform Terraform repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform.git
cd codemie-terraform-aws-platform
```

### Step 5: Configure Platform Deployment

Edit the `deployment.conf` file to provide your AWS-specific configuration:

```bash
# Required: AWS Account Information
AWS_PROFILE="My_Profile"

# Required: Basic Configuration
TF_VAR_region="us-east-1"                                           # AWS region for deployment
TF_VAR_role_arn="arn:aws:iam::123456789012:role/AIRunDeployerRole"  # IAM role created in Step 3
TF_VAR_platform_domain_name="codemie.example.com"                   # Domain name for the platform

# Required: EKS Configuration
TF_VAR_cluster_version="1.34"
TF_VAR_demand_instance_types='[{ instance_type = "r5.xlarge" }]'
TF_VAR_demand_max_nodes_count=3
TF_VAR_demand_desired_nodes_count=3
TF_VAR_demand_min_nodes_count=3

# Required: Platform Configuration
TF_VAR_platform_name="codemie"
TF_VAR_subnet_azs='["us-east-1a", "us-east-1b", "us-east-1c"]'
TF_VAR_s3_states_bucket_name="codemie-terraform-states"
TF_VAR_table_name="codemie_terraform_locks"

# Optional: IAM Permissions Boundary
TF_VAR_eks_admin_role_arn=""
TF_VAR_role_permissions_boundary_arn=""

# Optional: Network Access Control
TF_VAR_enable_private_connections=true
TF_VAR_lb_prefix_list_ids='[]'
TF_VAR_lb_specific_ips='[]'
TF_VAR_security_group_ids='[]'
...
```

:::info Complete Variable List
For all available configuration options, refer to the `variables.tf` file in the platform repository.
:::

### Step 6: Run Deployment

Execute the automated deployment script:

```bash
bash ./aws-terraform.sh
```

The script will:

1. **Validate Environment**: Check for required tools and AWS authentication
2. **Verify Configuration**: Validate `deployment.conf` parameters
3. **Deploy Phase 1**: Create IAM deployer role (if not already created)
4. **Deploy Phase 2**: Create Terraform state backend storage
5. **Deploy Phase 3**: Provision core platform infrastructure (EKS, networking, storage, databases)
6. **Generate Outputs**: Create `deployment_outputs.env` with infrastructure details required during next phases

## Deployment Outputs

Upon successful deployment, the script generates a `deployment_outputs.env` file containing essential infrastructure details needed for the next deployment phase:

```bash
# Platform Infrastructure Outputs
AWS_DEFAULT_REGION=us-east-1
EKS_AWS_ROLE_ARN=arn:aws:iam::123456789012:role/codemie-eks-role
AWS_KMS_KEY_ID=12345678-90ab-cdef-1234-567890abcdef
AWS_S3_BUCKET_NAME=codemie-platform-bucket
CODEMIE_DOMAIN_NAME=codemie.example.com

# Database Outputs
CODEMIE_POSTGRES_DATABASE_HOST=codemie-rds.123456789012.us-east-1.rds.amazonaws.com
CODEMIE_POSTGRES_DATABASE_PORT=5432
CODEMIE_POSTGRES_DATABASE_NAME=codemie
CODEMIE_POSTGRES_DATABASE_USER=dbadmin
CODEMIE_POSTGRES_DATABASE_PASSWORD="generated-password"
```

:::tip Save These Outputs
The `deployment_outputs.env` file contains sensitive information. Store it securely, do not commit to version control system and reference it during the Components Deployment phase.
:::

:::warning Security Groups
Ensure that you allowed incoming traffic to the Security Group attached to LoadBalancers from:

- Your VPN or from networks you're planning to work with AI/Run CodeMie
- EKS Cluster NAT Gateway EIP (not required if `enable_private_connections` variable is set to `true`)
  :::

This concludes AWS infrastructure deployment.

## Post-Deployment Validation

After deployment completes, verify that all infrastructure was created successfully:

### Step 1: Verify AWS Resources

Check that all expected resources were created in the AWS Console or via CLI:

```bash
# List all resources in the region
aws resourcegroupstaggingapi get-resources --region <region>

# Verify EKS cluster status
aws eks describe-cluster --name <cluster-name> --region <region> --query "cluster.status"

# Verify RDS instance status
aws rds describe-db-instances --db-instance-identifier <rds-instance-name> --region <region>
```

### Step 2: Check Deployment Logs

Review the deployment logs in the `logs/` directory for any warnings or errors:

```bash
less logs/codemie_aws_deployment_YYYY-MM-DD-HHMMSS.log
```

## Next Steps

After successful infrastructure deployment and validation, proceed to:

**[Components Deployment](../components-deployment/)** - Deploy AI/Run CodeMie application components to your EKS cluster
