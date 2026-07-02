---
id: scripted-deployment
title: Scripted Deployment
sidebar_label: Scripted Deployment
sidebar_position: 5
pagination_prev: admin/deployment/azure/on-vm/deployment/deployment
pagination_next: admin/deployment/azure/on-vm/deployment/manual-deployment
---

# Scripted Deployment

This guide walks through deploying CodeMie On VM on Azure using the automated `deploy.sh` script. The script handles all phases: Terraform state backend, infrastructure provisioning, optional Azure OpenAI setup, and application deployment.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
:::

## Step 1: Clone the Repository

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-on-vm.git
cd codemie-on-vm
```

## Step 2: Place the GCP Registry Key

Copy your `key.json` file to the repository root:

```bash
cp /path/to/key.json ./key.json
```

## Step 3: Create Deployment Configuration

```bash
cp deployment.conf.azure.example deployment.conf
```

Edit `deployment.conf`:

```bash
CLOUD_PROVIDER="azure"

# ── Azure ────────────────────────────────────────────────────────────
AZURE_SUBSCRIPTION_ID=""          # Your Azure subscription ID
AZURE_TENANT_ID=""                # Your Azure tenant ID

# ── Terraform ────────────────────────────────────────────────────────
TF_VAR_location="westeurope"
TF_VAR_platform_name="codemie"
TF_VAR_vm_size="Standard_E4s_v5"        # 4 vCPU, 32 GB RAM
TF_VAR_vm_os_disk_size=100               # OS disk size in GB
TF_VAR_platform_domain_name=""           # Private DNS zone (e.g. private.lab.com)

# ── CodeMie ──────────────────────────────────────────────────────────
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"             # oss | enterprise

# ── Azure OpenAI / AI models ─────────────────────────────────────────
DEPLOY_AI_MODELS="true"                  # true = provision Azure OpenAI via Terraform
                                         # false = supply existing endpoint below

# Required only when DEPLOY_AI_MODELS=false:
# AZURE_OPENAI_ENDPOINT=""
# AZURE_CLIENT_ID=""
# AZURE_CLIENT_SECRET=""
```

## Step 4: Authenticate with Azure

```bash
az login
az account set --subscription "<AZURE_SUBSCRIPTION_ID>"

# Verify:
az account show
```

## Step 5: Run the Deployment

```bash
./deploy.sh
```

The script executes the following phases:

| Phase                          | Description                                                            |
| ------------------------------ | ---------------------------------------------------------------------- |
| Loading config                 | Validates `deployment.conf` variables                                  |
| Checking prerequisites         | Verifies required tools are installed                                  |
| Verifying Azure credentials    | Confirms valid `az` session and subscription                           |
| Initializing Terraform backend | Creates Azure Storage container for Terraform state                    |
| Running platform Terraform     | Plans and applies VM, Storage Account, Key Vault, DNS, NSG             |
| Running AI models Terraform    | Plans and applies Azure OpenAI accounts (if `DEPLOY_AI_MODELS="true"`) |
| Reading Terraform outputs      | Fetches VM private IP, Storage Account name, Key Vault URL             |
| Generating .env                | Creates secrets and renders Docker Compose environment                 |
| Provisioning VM                | Installs Docker, syncs files, starts services via Azure Bastion        |
| Writing outputs                | Saves credentials to `deployment_outputs.env`                          |
| Deployment summary             | Prints URL, SSH command, credentials                                   |

:::warning Interactive Prompts
The script will pause for approval at each Terraform plan stage. Review the plans carefully before typing `y`.
:::

## Step 6: Verify Deployment

After the script completes:

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

Expected response: `{"status":"ok"}`

## Deployment Outputs

The script creates `deployment_outputs.env` with:

- **CODEMIE_URL** — Application URL
- **VM_PRIVATE_IP** — VM private IP address
- **SSH_COMMAND** — Full SSH command for access via Bastion
- **Credentials** — Keycloak admin or superadmin password
- **Internal secrets** — Preserved across re-runs

:::danger Sensitive File
`deployment_outputs.env` contains passwords and secrets. Do not commit it to version control.
:::

## SSH Access

Connect to the VM via Azure Bastion:

```bash
# The SSH command is provided in the deployment summary and outputs file
az network bastion ssh \
  --name "<BASTION_NAME>" \
  --resource-group "<RESOURCE_GROUP>" \
  --target-resource-id "<VM_RESOURCE_ID>" \
  --auth-type "ssh-key" \
  --username "azadmin" \
  --ssh-key "~/.ssh/codemie-key.pem"
```

## Re-deploying / Updating

To update CodeMie version or configuration:

1. Edit `deployment.conf` (e.g., change `CODEMIE_VERSION`)
2. Run `./deploy.sh` again

The script detects the existing `deployment_outputs.env` and preserves all secrets.

## Next Steps

- [Manual Deployment](../manual-deployment) — Alternative method with full Terraform control
