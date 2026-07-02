---
id: manual-deployment
title: Manual Deployment
sidebar_label: Manual Deployment
sidebar_position: 6
pagination_prev: admin/deployment/aws/on-vm/deployment/scripted-deployment
pagination_next: admin/deployment/aws/on-vm/deployment/byo
---

# Manual Deployment

This guide provides step-by-step instructions for manually deploying CodeMie On VM infrastructure using Terraform, followed by application provisioning via the BYO mode (`./deploy.sh --byo`).

:::info When to Use Manual Deployment
Manual deployment is suitable when you need fine-grained control over each Terraform phase, want to customize infrastructure configurations, or are integrating with existing infrastructure management workflows.
:::

## Prerequisites

Ensure you have completed all requirements from the [Prerequisites](../../prerequisites) page:

- [ ] **AWS Access**: Programmatic access with IAM permissions
- [ ] **Tools Installed**: Terraform 1.15.x, AWS CLI, jq, openssl, envsubst, session-manager-plugin
- [ ] **AWS Authentication**: Configured AWS credentials
- [ ] **Repository Access**: Cloned [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)
- [ ] **GCP Registry**: `key.json` file available

## Deployment Phases

| Phase                                | Description                                | Directory                              |
| ------------------------------------ | ------------------------------------------ | -------------------------------------- |
| **Phase 1: IAM Deployer Role**       | Creates IAM role with required permissions | `terraform/aws/codemie-on-vm-aws-iam/` |
| **Phase 2: State Backend**           | Creates S3 bucket for Terraform state      | `terraform/aws/remote-backend/`        |
| **Phase 3: Platform Infrastructure** | Provisions VPC, EC2, S3, KMS, ALB          | `terraform/aws/platform/`              |
| **Phase 4: Application**             | Deploys Docker Compose stack via BYO mode  | `./` (repo root)                       |

---

## Phase 1: IAM Deployer Role

:::info One-Time Setup
This phase only needs to run once per AWS account.
:::

1. Navigate to the IAM module:

```bash
cd terraform/aws/codemie-on-vm-aws-iam/
```

2. Create a `terraform.tfvars` file:

```hcl
region             = "eu-north-1"
platform_name      = "codemie"
deployer_role_name = "CodemieOnVmDeployerRole"

# Optional: IAM Permissions Boundary
iam_permissions_boundary_policy_arn = ""

# Optional: Custom tags
tags = {
  "SysName"     = "CodeMie"
  "Environment" = "Development"
  "Project"     = "codemie-on-vm"
}
```

3. Initialize and apply:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

4. Note the deployer role ARN:

```bash
terraform output deployer_iam_role_arn
# Example: arn:aws:iam::123456789012:role/CodemieOnVmDeployerRole
```

---

## Phase 2: Terraform State Backend

1. Navigate to the remote backend directory:

```bash
cd terraform/aws/remote-backend/
```

2. Initialize Terraform:

```bash
terraform init
```

3. Plan and apply with variables:

```bash
terraform plan -out=tfplan \
  -var="region=eu-north-1" \
  -var="role_arn=arn:aws:iam::123456789012:role/CodemieOnVmDeployerRole" \
  -var="bucket_name=codemie-terraform-states"

terraform apply tfplan
```

The S3 bucket is now ready for storing platform state.

---

## Phase 3: Platform Infrastructure

1. Navigate to the platform directory:

```bash
cd terraform/aws/platform/
```

2. Create `backend.tfvars`:

```hcl
bucket       = "codemie-terraform-states"
key          = "codemie/terraform.tfstate"
region       = "eu-north-1"
use_lockfile = true
```

3. Initialize Terraform with backend configuration:

```bash
terraform init -backend-config=backend.tfvars
```

4. Create `terraform.tfvars` with platform configuration:

```hcl
region              = "eu-north-1"
role_arn            = "arn:aws:iam::123456789012:role/CodemieOnVmDeployerRole"
platform_name       = "codemie"
instance_type       = "r5.xlarge"
volume_size         = 100

# Network: set to true for private-only deployment (requires VPN)
private_ip_only     = false

# Domain (optional): enables ALB + ACM certificate + Route 53 record
# Leave empty for IP-only access with self-signed certificate
platform_domain_name = ""

# Access control: prefix list IDs allowed to reach ALB/EC2
access_prefix_list_ids = []
```

5. Plan and apply:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

6. Note the outputs — you will need them for Phase 4:

```bash
terraform output ec2_instance_id
terraform output ec2_public_ip      # Empty if private_ip_only=true
terraform output ec2_private_ip
terraform output s3_bucket_name
terraform output kms_key_id
terraform output ssm_ec2_private_key
```

7. Fetch the SSH key from SSM:

```bash
aws ssm get-parameter \
  --name "$(terraform output -raw ssm_ec2_private_key)" \
  --region eu-north-1 \
  --with-decryption \
  --query "Parameter.Value" \
  --output text > codemie-key.pem

chmod 600 codemie-key.pem
```

---

## Phase 4: Application Provisioning (BYO Mode)

Now that infrastructure is provisioned manually, use the BYO mode to deploy the application stack. The BYO mode skips Terraform and connects directly to the EC2 instance.

1. Navigate to the project root:

2. Place the GCP registry key:

```bash
cp /path/to/key.json ./key.json
```

3. Configure `deployment.conf` with BYO settings.

**`BYO_EC2_HOST`** determines the application URL (`CODEMIE_HOST`). Set it based on your network mode:

| Network Mode | `BYO_EC2_HOST` value                              | Access              |
| ------------ | ------------------------------------------------- | ------------------- |
| Public IP    | `ec2_public_ip` from outputs                      | Direct HTTPS to EIP |
| Private IP   | `ec2_private_ip` from outputs                     | HTTPS via VPN only  |
| Domain + ALB | Any IP (overridden by `BYO_PLATFORM_DOMAIN_NAME`) | HTTPS via ALB       |

**`BYO_EC2_SSH_MODE`** determines how the script connects to the instance:

| SSH Mode | When to use                                        | `BYO_EC2_HOST` used for SSH?  |
| -------- | -------------------------------------------------- | ----------------------------- |
| `ssm`    | Instance created by this Terraform (has SSM agent) | No — connects via instance ID |
| `direct` | Instance with port 22 reachable from your machine  | Yes — SSH target              |

**Example: Public IP mode**

```bash
# ── Shared ───────────────────────────────────────────────────────────
TF_VAR_region="eu-north-1"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"

# ── BYO EC2 ──────────────────────────────────────────────────────────
BYO_EC2_HOST="*.*.*.*"             # ec2_public_ip
BYO_EC2_USER="ubuntu"
BYO_EC2_SSH_KEY="./terraform/platform/codemie-key.pem"
BYO_EC2_SSH_MODE="ssm"
BYO_EC2_INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"
BYO_AWS_S3_BUCKET_NAME="codemie-user-data"
BYO_AWS_KMS_KEY_ID="<kms-key-id>"
BYO_PLATFORM_DOMAIN_NAME=""
```

**Example: Private IP mode** (`private_ip_only=true`)

```bash
BYO_EC2_HOST="10.0.10.104"            # ec2_private_ip (accessible via VPN)
BYO_EC2_USER="ubuntu"
BYO_EC2_SSH_KEY="./terraform/platform/codemie-key.pem"
BYO_EC2_SSH_MODE="ssm"
BYO_EC2_INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"
BYO_AWS_S3_BUCKET_NAME="codemie-user-data"
BYO_AWS_KMS_KEY_ID="<kms-key-id>"
BYO_PLATFORM_DOMAIN_NAME=""
```

**Example: Domain mode** (ALB + ACM configured in Phase 3)

```bash
BYO_EC2_HOST="10.0.10.104"            # Any reachable IP (not used for URL)
BYO_EC2_USER="ubuntu"
BYO_EC2_SSH_KEY="./terraform/platform/codemie-key.pem"
BYO_EC2_SSH_MODE="ssm"
BYO_EC2_INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"
BYO_AWS_S3_BUCKET_NAME="codemie-user-data"
BYO_AWS_KMS_KEY_ID="<kms-key-id>"
BYO_PLATFORM_DOMAIN_NAME="example.com"
```

4. Run the BYO deployment:

```bash
./deploy.sh --byo
```

5. Verify the deployment:

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

## Post-Deployment

### SSH Access

```bash
ssh -i codemie-key.pem \
  -o "ProxyCommand=aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p" \
  ubuntu@<EC2_INSTANCE_ID>
```

### Re-deploying

To update the application (e.g., new version):

1. Edit `deployment.conf` (change `CODEMIE_VERSION`)
2. Run `./deploy.sh --byo` again

Secrets from `deployment_outputs.env` are preserved automatically.

### Modifying Infrastructure

To change infrastructure (e.g., instance type, add domain):

1. Update `terraform.tfvars` in `terraform/platform/`
2. Run `terraform plan -out=tfplan && terraform apply tfplan`
3. Update `deployment.conf` with new outputs if needed
4. Run `./deploy.sh --byo` to re-provision the application

## Next Steps

- [BYO EC2](../byo) — Deploy on a completely external EC2 instance (not managed by this Terraform)
