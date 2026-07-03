---
id: byo
title: BYO Azure VM Deployment
sidebar_label: BYO Azure VM
sidebar_position: 7
pagination_prev: admin/deployment/azure/on-vm/deployment/manual-deployment
pagination_next: null
---

# BYO Azure VM Deployment

Deploy CodeMie on an **existing Azure VM** that is not managed by this project's Terraform. This mode skips all infrastructure provisioning and directly provisions the application stack.

## When to Use

- You already have an Azure VM (provisioned manually or via another Terraform stack)
- You want to avoid creating additional Azure resources via Terraform
- Your organization manages infrastructure separately from application deployment

## VM Requirements

Your existing Azure VM must meet these requirements:

| Requirement          | Details                                                                  |
| -------------------- | ------------------------------------------------------------------------ |
| **OS**               | Ubuntu 24.04                                                             |
| **VM size**          | Minimum Standard_D4s_v5 (4 vCPU, 16 GB RAM); recommended Standard_E4s_v5 |
| **Disk**             | Minimum 50 GB; recommended 100 GB                                        |
| **Internet access**  | Outbound HTTPS for pulling Docker images                                 |
| **Managed Identity** | Permissions for Storage Account and Key Vault access (if used)           |

## Configuration

Edit `deployment.conf` with BYO-specific variables:

```bash
CLOUD_PROVIDER="azure"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise

# ── BYO Azure VM ─────────────────────────────────────────────────────
BYO_VM_HOST=""                          # Private IP of the VM
BYO_VM_USER="azadmin"                   # SSH user
BYO_VM_SSH_KEY=""                       # Absolute path to SSH private key
BYO_VM_SSH_MODE="bastion"               # bastion | direct
BYO_AZURE_BASTION_NAME=""               # Azure Bastion host name
BYO_AZURE_RESOURCE_GROUP=""             # Resource group containing Bastion and VM
BYO_AZURE_VM_RESOURCE_ID=""             # Full VM resource ID (/subscriptions/...)
BYO_AZURE_STORAGE_ACCOUNT_NAME=""       # Storage Account for user data
BYO_AZURE_KEY_VAULT_URL=""              # https://<vault>.vault.azure.net/
BYO_AZURE_KEY_NAME="codemie-key"        # Key name in Key Vault
BYO_PLATFORM_DOMAIN_NAME=""             # Optional: overrides CODEMIE_HOST
```

### SSH Modes

| Mode      | When to Use                                                  | Requirements                               |
| --------- | ------------------------------------------------------------ | ------------------------------------------ |
| `bastion` | VM in private subnet, access via Azure Bastion (recommended) | Azure Bastion deployed, VM resource ID     |
| `direct`  | VM has a reachable IP and port 22 is open                    | SSH private key, network access to port 22 |

### BYO_VM_HOST

`BYO_VM_HOST` sets the application URL (`CODEMIE_HOST`):

| Scenario                       | `BYO_VM_HOST` value | Result                                 |
| ------------------------------ | ------------------- | -------------------------------------- |
| VM private IP (access via VPN) | `10.0.1.5`          | `CODEMIE_HOST=https://10.0.1.5`        |
| Custom domain                  | Any IP (overridden) | Set `BYO_PLATFORM_DOMAIN_NAME` instead |

### Encryption

| Setting                         | Behavior                                                       |
| ------------------------------- | -------------------------------------------------------------- |
| `BYO_AZURE_KEY_VAULT_URL` empty | `ENCRYPTION_TYPE=plain` — data stored without envelope key     |
| `BYO_AZURE_KEY_VAULT_URL` set   | `ENCRYPTION_TYPE=azure` — storage data protected via Key Vault |

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
| Verifying Azure session  | Only for bastion mode                             |
| Setting up BYO variables | Maps config to internal variables                 |
| Generating .env          | Creates secrets, renders environment file         |
| Setting up SSH           | Configures SSH transport (bastion or direct)      |
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

### Bastion connection refused

- Verify Azure Bastion is deployed and associated with the VM's virtual network
- Confirm `BYO_AZURE_VM_RESOURCE_ID` is the full resource ID (`/subscriptions/...`)
- Check the `BYO_AZURE_RESOURCE_GROUP` contains both the Bastion and the VM

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
