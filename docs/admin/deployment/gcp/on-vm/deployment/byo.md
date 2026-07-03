---
id: byo
title: BYO GCE VM Deployment
sidebar_label: BYO GCE VM
sidebar_position: 7
pagination_prev: admin/deployment/gcp/on-vm/deployment/manual-deployment
pagination_next: null
---

# BYO GCE VM Deployment

Deploy CodeMie on an **existing GCE VM** that is not managed by this project's Terraform. This mode skips all infrastructure provisioning and directly provisions the application stack.

## When to Use

- You already have a GCE VM (provisioned manually or via another Terraform stack)
- You want to avoid creating additional GCP resources via Terraform
- Your organization manages infrastructure separately from application deployment

## VM Requirements

Your existing GCE VM must meet these requirements:

| Requirement         | Details                                                             |
| ------------------- | ------------------------------------------------------------------- |
| **OS**              | Ubuntu 24.04                                                        |
| **Machine type**    | Minimum n2-standard-4 (4 vCPU, 16 GB RAM); recommended n2-highmem-4 |
| **Disk**            | Minimum 50 GB; recommended 100 GB                                   |
| **Internet access** | Outbound HTTPS for pulling Docker images                            |
| **IAP access**      | VM must be in a VPC with IAP firewall rule (if using `iap` mode)    |

## Configuration

Edit `deployment.conf` with BYO-specific variables:

```bash
CLOUD_PROVIDER="gcp"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise

# ── BYO GCE ──────────────────────────────────────────────────────────
BYO_VM_HOST=""                         # Private IP of the VM
BYO_VM_USER="ubuntu"                   # SSH user on the target VM
BYO_VM_SSH_KEY=""                      # Absolute path to SSH private key
BYO_VM_SSH_MODE="iap"                  # iap | direct
BYO_GCP_PROJECT_ID=""                  # GCP project (required for iap mode)
BYO_GCP_ZONE=""                        # e.g. europe-west3-a (required for iap mode)
BYO_GCP_INSTANCE_NAME=""               # GCE instance name (required for iap mode)
BYO_GCS_BUCKET_NAME=""                 # Existing GCS bucket for file storage
BYO_GCP_KMS_KEY_ID=""                  # Cloud KMS crypto key ID (empty = plain encryption)
BYO_PLATFORM_DOMAIN_NAME=""            # Optional: overrides CODEMIE_HOST
```

### SSH Modes

| Mode     | When to Use                                     | Requirements                                                                     |
| -------- | ----------------------------------------------- | -------------------------------------------------------------------------------- |
| `iap`    | VM in private VPC, access via IAP (recommended) | IAP firewall rule, `BYO_GCP_PROJECT_ID`, `BYO_GCP_ZONE`, `BYO_GCP_INSTANCE_NAME` |
| `direct` | VM has a reachable IP and port 22 is open       | SSH private key, network access to port 22                                       |

### BYO_VM_HOST

`BYO_VM_HOST` sets the application URL (`CODEMIE_HOST`):

| Scenario                       | `BYO_VM_HOST` value | Result                                 |
| ------------------------------ | ------------------- | -------------------------------------- |
| VM private IP (access via VPN) | `10.0.1.5`          | `CODEMIE_HOST=https://10.0.1.5`        |
| Custom domain                  | Any IP (overridden) | Set `BYO_PLATFORM_DOMAIN_NAME` instead |

### Encryption

| Setting                    | Behavior                                                     |
| -------------------------- | ------------------------------------------------------------ |
| `BYO_GCP_KMS_KEY_ID` empty | `ENCRYPTION_TYPE=plain` — data stored without envelope key   |
| `BYO_GCP_KMS_KEY_ID` set   | `ENCRYPTION_TYPE=gcp` — storage data protected via Cloud KMS |

## Deployment

### Step 1: Place the GCP Registry Key

This is a GCP service account credentials file used to pull CodeMie container images from Google Artifact Registry.

:::info
For open-source deployments with self-built images, this key is optional.
:::

```bash
cp /path/to/key.json ./key.json
```

### Step 2: Run BYO Deployment

```bash
./deploy.sh --byo
```

The script executes:

| Phase                    | Description                                       |
| ------------------------ | ------------------------------------------------- |
| Loading config           | Validates BYO-specific variables                  |
| Checking prerequisites   | Verifies tools (Terraform not required)           |
| Verifying GCP session    | Only for iap mode — confirms `gcloud` is active   |
| Setting up BYO variables | Maps config to internal variables                 |
| Generating .env          | Creates secrets, renders environment file         |
| Setting up SSH           | Configures SSH transport (IAP tunnel or direct)   |
| Provisioning VM          | Installs Docker, syncs files, starts services     |
| Writing outputs          | Saves deployment info to `deployment_outputs.env` |
| Deployment summary       | Prints URL, SSH command, credentials              |

### Step 3: Verify

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

## Re-deploying

Run `./deploy.sh --byo` again. Secrets from `deployment_outputs.env` are preserved automatically.

## Troubleshooting

### IAP tunnel connection refused

- Verify the IAP firewall rule exists: `gcloud compute firewall-rules list --filter="name~iap"`
- Confirm `BYO_GCP_INSTANCE_NAME` matches the exact GCE instance name
- Check `BYO_GCP_ZONE` is in the format `region-zone` (e.g., `europe-west3-a`)
- Ensure `gcloud auth application-default login` has been run and the account has `roles/iap.tunnelResourceAccessor`

### Docker login fails

The `key.json` must be a valid GCP service account with access to `europe-west3-docker.pkg.dev`. Verify locally:

```bash
cat key.json | docker login -u _json_key --password-stdin https://europe-west3-docker.pkg.dev
```

### Containers unhealthy

SSH into the VM and check logs:

```bash
cd /opt/codemie/compose
docker compose --profile enterprise logs --tail=50
docker compose --profile enterprise ps
```
