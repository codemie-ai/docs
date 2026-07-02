---
id: scripted-deployment
title: Scripted Deployment
sidebar_label: Scripted Deployment
sidebar_position: 5
pagination_prev: admin/deployment/aws/on-vm/deployment/deployment
pagination_next: admin/deployment/aws/on-vm/deployment/manual-deployment
---

# Scripted Deployment

This guide walks through deploying CodeMie On VM using the automated `deploy.sh` script. The script handles all phases automatically: IAM role creation, Terraform state backend, infrastructure provisioning, and application deployment.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
:::

## Phase 1: IAM Deployer Role

The IAM deployer role provides scoped permissions for Terraform to create and manage AWS resources.

:::info One-Time Setup
Phase 1 only needs to run once per AWS account. If the role already exists, skip to Phase 2.
:::

### Step 1: Navigate to the IAM module

```bash
cd terraform/aws/codemie-on-vm-aws-iam/
```

### Step 2: Configure variables

Create a `terraform.tfvars` file:

```hcl
region             = "eu-north-1"
platform_name      = "codemie"
deployer_role_name = "CodemieOnVmDeployerRole"

# Optional: IAM permissions boundary (leave empty if not required)
iam_permissions_boundary_policy_arn = ""

# Optional: custom tags
tags = {
  "SysName"     = "CodeMie"
  "Environment" = "Development"
  "Project"     = "codemie-on-vm"
}
```

### Step 3: Deploy the role

```bash
terraform init
terraform plan
terraform apply
```

### Step 4: Note the output

```bash
terraform output deployer_iam_role_arn
# Example: arn:aws:iam::123456789012:role/CodemieOnVmDeployerRole
```

Save this ARN — you will use it as `TF_VAR_role_arn` in the next phase.

---

## Phase 2: Platform Deployment

### Step 1: Navigate to the repo root

### Step 2: Place the GCP registry key

Copy your `key.json` file to the repository root:

```bash
cp /path/to/key.json ./key.json
```

### Step 3: Create deployment configuration

```bash
cp deployment.conf.example deployment.conf
```

Edit `deployment.conf`:

```bash
# ── AWS ──────────────────────────────────────────────────────────────
AWS_PROFILE=""                          # AWS CLI profile (optional)
TF_VAR_region="eu-north-1"
TF_VAR_role_arn="arn:aws:iam::123456789012:role/CodemieOnVmDeployerRole"

# ── Terraform State ──────────────────────────────────────────────────
TF_VAR_s3_states_bucket_name="codemie-terraform-states"

# ── Platform ─────────────────────────────────────────────────────────
TF_VAR_platform_name="codemie"

# ── EC2 ──────────────────────────────────────────────────────────────
TF_VAR_instance_type="r5.xlarge"        # 4 vCPU, 32GB RAM
TF_VAR_volume_size=100                  # Root EBS size in GB
TF_VAR_access_prefix_list_ids='[]'      # Prefix lists for ALB/EC2 SG access

# ── Network mode ─────────────────────────────────────────────────────
TF_VAR_private_ip_only=false            # true = private subnet, no public IP

# ── Domain & TLS (optional) ──────────────────────────────────────────
TF_VAR_platform_domain_name=""          # e.g. codemie.example.com

# ── CodeMie ──────────────────────────────────────────────────────────
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise
```

### Step 4: Authenticate with AWS

```bash
# If using AWS SSO:
aws sso login --profile your-profile
export AWS_PROFILE=your-profile

# Verify credentials:
aws sts get-caller-identity
```

### Step 5: Run the deployment

```bash
./deploy.sh
```

The script executes the following phases:

| Phase                          | Description                                             |
| ------------------------------ | ------------------------------------------------------- |
| Loading config                 | Validates `deployment.conf` variables                   |
| Checking prerequisites         | Verifies required tools are installed                   |
| Verifying AWS credentials      | Confirms valid AWS session                              |
| Initializing S3 remote backend | Creates S3 bucket for Terraform state                   |
| Running terraform              | Plans and applies infrastructure (with approval prompt) |
| Reading terraform outputs      | Fetches EC2 ID, IPs, S3 bucket, KMS key                 |
| Generating .env                | Creates secrets and renders Docker Compose environment  |
| Provisioning EC2               | Installs Docker, syncs files, starts services           |
| Writing outputs                | Saves credentials to `deployment_outputs.env`           |
| Deployment summary             | Prints URL, SSH command, credentials                    |

:::warning Interactive Prompts
The script will pause twice for approval:

1. Remote backend Terraform plan
2. Platform Terraform plan

Review the plans carefully before typing `y`.
:::

### Step 6: Verify deployment

After the script completes, verify the application is running:

```bash
# Check the health endpoint (use the URL from the summary)
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

Expected response: `{"status":"ok"}`

## Deployment Outputs

The script creates `deployment_outputs.env` with:

- **CODEMIE_URL** — Application URL
- **EC2_INSTANCE_ID** — Instance ID for management
- **SSH_COMMAND** — Full SSH command for access
- **Credentials** — Keycloak admin or superadmin password (depending on profile)
- **Internal secrets** — Preserved across re-runs to avoid breaking running databases

:::danger Sensitive File
`deployment_outputs.env` contains passwords and secrets. Do not commit it to version control.
:::

## SSH Access

Connect to the EC2 instance:

```bash
# The SSH command is provided in the deployment summary and outputs file
ssh -i codemie-key.pem \
  -o "ProxyCommand=aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p" \
  ubuntu@<EC2_INSTANCE_ID>
```

:::tip SSH via SSM
SSH access uses AWS Systems Manager Session Manager as a proxy. This means:

- No need to open SSH port (22) in security groups
- All sessions are logged in CloudTrail
- Works even for private-IP-only instances
  :::

## Re-deploying / Updating

To update CodeMie version or configuration:

1. Edit `deployment.conf` (e.g., change `CODEMIE_VERSION`)
2. Run `./deploy.sh` again

The script detects the existing `deployment_outputs.env` and preserves all secrets. Only the Docker Compose services are updated.

## Next Steps

- [Manual Deployment](../manual-deployment) — Alternative method with full Terraform control
