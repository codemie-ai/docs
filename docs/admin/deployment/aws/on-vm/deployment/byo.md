---
id: byo
title: BYO EC2 Deployment
sidebar_label: BYO EC2
sidebar_position: 7
pagination_prev: admin/deployment/aws/on-vm/deployment/manual-deployment
pagination_next: null
---

# BYO EC2 Deployment

Deploy CodeMie on an **existing EC2 instance** that is not managed by this project's Terraform. This mode skips all infrastructure provisioning and directly provisions the application stack.

## When to Use

- You already have an EC2 instance (provisioned manually, via CloudFormation, or another Terraform stack)
- You want to avoid creating additional VPC/ALB/S3 resources via Terraform
- Your organization manages infrastructure separately from application deployment

## EC2 Requirements

Your existing EC2 instance must meet these requirements:

| Requirement           | Details                                                        |
| --------------------- | -------------------------------------------------------------- |
| **OS**                | Ubuntu 24.04                                                   |
| **Instance type**     | Minimum t3.xlarge (4 vCPU, 16 GB RAM); recommended r5.xlarge   |
| **Disk**              | Minimum 50 GB; recommended 100 GB                              |
| **Internet access**   | Outbound HTTPS for pulling Docker images and accessing Bedrock |
| **IAM Instance Role** | Permissions for S3, KMS (optional), and Bedrock                |

### Required IAM Permissions on EC2

The instance role must include:

```json
{
  "Effect": "Allow",
  "Action": [
    "bedrock:InvokeModel",
    "bedrock:InvokeModelWithResponseStream",
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListBucket"
  ],
  "Resource": "*"
}
```

If using KMS encryption, add:

```json
{
  "Effect": "Allow",
  "Action": ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey"],
  "Resource": "arn:aws:kms:<region>:<account>:key/<key-id>"
}
```

## Configuration

Edit `deployment.conf` with BYO-specific variables:

```bash
# ── Shared (required for both modes) ────────────────────────────────
TF_VAR_region="eu-north-1"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise

# ── BYO EC2 ──────────────────────────────────────────────────────────
BYO_EC2_HOST="1.2.3.4"                 # Public IP, private IP, or hostname
BYO_EC2_USER="ubuntu"                   # SSH user
BYO_EC2_SSH_KEY="/path/to/key.pem"     # Absolute path to SSH private key
BYO_EC2_SSH_MODE="direct"               # direct | ssm
BYO_EC2_INSTANCE_ID=""                  # Required only for ssm mode
BYO_AWS_S3_BUCKET_NAME="my-bucket"     # S3 bucket (must already exist)
BYO_AWS_KMS_KEY_ID=""                   # KMS key ID (empty = plain encryption)
BYO_PLATFORM_DOMAIN_NAME=""             # Optional: overrides CODEMIE_HOST URL
```

### BYO_EC2_HOST

This variable serves two purposes depending on the SSH mode:

| SSH Mode   | Purpose of `BYO_EC2_HOST`                                     |
| ---------- | ------------------------------------------------------------- |
| **direct** | SSH target address AND application URL (`CODEMIE_HOST`)       |
| **ssm**    | Application URL only (SSH connects via `BYO_EC2_INSTANCE_ID`) |

Set it based on how users will access the application:

| Scenario                    | `BYO_EC2_HOST` value            | Result                                 |
| --------------------------- | ------------------------------- | -------------------------------------- |
| EC2 has a public IP         | Public IP (e.g. `1.2.3.4`)      | `CODEMIE_HOST=https://1.2.3.4`         |
| EC2 in private subnet (VPN) | Private IP (e.g. `10.0.10.104`) | `CODEMIE_HOST=https://10.0.10.104`     |
| ALB with domain in front    | Any IP (overridden)             | Set `BYO_PLATFORM_DOMAIN_NAME` instead |

### SSH Modes

| Mode       | When to Use                                                   | Requirements                                                           |
| ---------- | ------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **direct** | EC2 has a reachable IP/hostname and port 22 is open           | SSH private key, network access to port 22                             |
| **ssm**    | EC2 is in a private subnet, or you prefer not to open port 22 | SSM Agent installed on EC2, valid AWS credentials locally, instance ID |

### Encryption

| `BYO_AWS_KMS_KEY_ID`        | Behavior                                                |
| --------------------------- | ------------------------------------------------------- |
| Empty                       | `ENCRYPTION_TYPE=plain` — data stored unencrypted in S3 |
| Set (e.g. `12345-abcde...`) | `ENCRYPTION_TYPE=aws` — S3 data encrypted with KMS      |

### CODEMIE_HOST Resolution

| Configuration                                    | Result                                     |
| ------------------------------------------------ | ------------------------------------------ |
| `BYO_PLATFORM_DOMAIN_NAME` empty                 | `CODEMIE_HOST=https://<BYO_EC2_HOST>`      |
| `BYO_PLATFORM_DOMAIN_NAME="codemie.example.com"` | `CODEMIE_HOST=https://codemie.example.com` |

:::tip Using with ALB
If you have your own ALB with ACM certificate in front of the EC2:

1. Set `BYO_PLATFORM_DOMAIN_NAME` to your domain
2. Point the ALB target group to EC2 port 443
3. The self-signed certificate on nginx works fine as an ALB backend (ALB does not validate backend certs)
   :::

## Deployment

### Step 1: Place the GCP registry key

This is a GCP service account credentials file used to pull CodeMie container images from Google Artifact Registry.

:::info
For open-source deployments with self-built images, this key is optional.
:::

```bash
cp /path/to/key.json ./key.json
```

### Step 2: Run BYO deployment

```bash
./deploy.sh --byo
```

The script executes:

| Phase                     | Description                                          |
| ------------------------- | ---------------------------------------------------- |
| Loading config            | Validates BYO-specific variables                     |
| Checking prerequisites    | Verifies tools (no Terraform needed for direct mode) |
| Verifying AWS credentials | Only if SSM mode                                     |
| Setting up BYO variables  | Maps config to internal variables                    |
| Generating .env           | Creates secrets, renders environment file            |
| Setting up SSH            | Configures SSH transport (direct or SSM)             |
| Provisioning EC2          | Installs Docker, syncs files, starts services        |
| Writing outputs           | Saves deployment info to `deployment_outputs.env`    |
| Deployment summary        | Prints URL, SSH command, credentials                 |

### Step 3: Verify

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

## Re-deploying

Run `./deploy.sh --byo` again. Secrets from `deployment_outputs.env` are preserved automatically.

## Troubleshooting

### SSH connection refused

- **Direct mode**: Verify port 22 is open in the EC2 security group and the SSH key is correct
- **SSM mode**: Verify SSM Agent is running (`systemctl status amazon-ssm-agent`) and your AWS credentials are valid

### Docker login fails

The `key.json` must be a valid GCP service account with access to `europe-west3-docker.pkg.dev`. Verify locally:

```bash
cat key.json | docker login -u _json_key --password-stdin https://europe-west3-docker.pkg.dev
```

### Containers unhealthy

SSH into the instance and check logs:

```bash
cd /opt/codemie/compose
docker compose --profile enterprise logs --tail=50
docker compose --profile enterprise ps
```
