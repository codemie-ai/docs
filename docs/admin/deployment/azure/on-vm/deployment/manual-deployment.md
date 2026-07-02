---
id: manual-deployment
title: Manual Deployment
sidebar_label: Manual Deployment
sidebar_position: 6
pagination_prev: admin/deployment/azure/on-vm/deployment/scripted-deployment
pagination_next: admin/deployment/azure/on-vm/deployment/byo
---

# Manual Deployment

This guide provides step-by-step instructions for manually deploying CodeMie On VM infrastructure using Terraform on Azure, followed by application provisioning via BYO mode (`./deploy.sh --byo`).

:::info When to Use Manual Deployment
Manual deployment is suitable when you need fine-grained control over each Terraform phase, want to customize infrastructure configurations, or are integrating with existing infrastructure management workflows.
:::

## Prerequisites

Ensure you have completed all requirements from the [Prerequisites](../../prerequisites) page:

- [ ] **Azure Access**: Active subscription with Contributor role
- [ ] **Tools Installed**: Terraform 1.15.x, Azure CLI, jq, openssl, envsubst
- [ ] **Azure Authentication**: `az login` completed, subscription set
- [ ] **Repository Access**: Cloned [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)
- [ ] **GCP Registry**: `key.json` file available

## Deployment Phases

| Phase                                | Description                                         | Directory                         |
| ------------------------------------ | --------------------------------------------------- | --------------------------------- |
| **Phase 1: State Backend**           | Creates Azure Storage container for Terraform state | `terraform/azure/remote-backend/` |
| **Phase 2: Platform Infrastructure** | Provisions VM, Storage Account, Key Vault, DNS, NSG | `terraform/azure/platform/`       |
| **Phase 3: AI Models** (optional)    | Provisions Azure OpenAI cognitive accounts          | `terraform/azure/ai-models/`      |
| **Phase 4: Application**             | Deploys Docker Compose stack via BYO mode           | `./` (repo root)                  |

---

## Phase 1: Terraform State Backend

:::info One-Time Setup
This phase only needs to run once per Azure subscription.
:::

1. Navigate to the remote backend directory:

```bash
cd terraform/azure/remote-backend/
```

2. Initialize Terraform:

```bash
terraform init
```

3. Create `terraform.tfvars`:

```hcl
location       = "westeurope"
platform_name  = "codemie"
```

4. Plan and apply:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

5. Note the outputs:

```bash
terraform output storage_account_name
terraform output container_name
# Example: codemiestate / tfstate
```

---

## Phase 2: Platform Infrastructure

1. Navigate to the platform directory:

```bash
cd terraform/azure/platform/
```

2. Create `backend.tfvars`:

```hcl
resource_group_name  = "codemie-terraform-state"
storage_account_name = "codemiestate"
container_name       = "tfstate"
key                  = "codemie/terraform.tfstate"
```

3. Initialize Terraform with backend configuration:

```bash
terraform init -backend-config=backend.tfvars
```

4. Create `terraform.tfvars`:

```hcl
location              = "westeurope"
platform_name         = "codemie"
vm_size               = "Standard_E4s_v5"
vm_os_disk_size       = 100
platform_domain_name  = ""   # Leave empty for private IP access
```

5. Plan and apply:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

6. Note the outputs:

```bash
terraform output vm_private_ip
terraform output storage_account_name
terraform output key_vault_url
terraform output bastion_name
terraform output resource_group_name
terraform output vm_resource_id
```

---

## Phase 3: AI Models (Optional)

Skip this phase if `DEPLOY_AI_MODELS="false"` or you have an existing Azure OpenAI endpoint.

1. Navigate to the AI models directory:

```bash
cd terraform/azure/ai-models/
```

2. Create `backend.tfvars` (reuse same state backend):

```hcl
resource_group_name  = "codemie-terraform-state"
storage_account_name = "codemiestate"
container_name       = "tfstate"
key                  = "codemie/ai-models.tfstate"
```

3. Initialize and apply:

```bash
terraform init -backend-config=backend.tfvars
terraform plan -out=tfplan
terraform apply tfplan
```

4. Note the AI outputs:

```bash
terraform output azure_openai_endpoint
terraform output azure_client_id
terraform output azure_client_secret
```

---

## Phase 4: Application Provisioning (BYO Mode)

Now that infrastructure is provisioned, use BYO mode to deploy the application stack.

1. Navigate to the project root.

2. Place the GCP registry key:

```bash
cp /path/to/key.json ./key.json
```

3. Configure `deployment.conf` with BYO settings from Phase 2 outputs:

```bash
CLOUD_PROVIDER="azure"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise

# BYO Azure VM settings
BYO_VM_HOST="<vm_private_ip>"           # From terraform output
BYO_VM_USER="azadmin"
BYO_VM_SSH_KEY="/path/to/codemie-key.pem"
BYO_VM_SSH_MODE="bastion"               # bastion | direct
BYO_AZURE_BASTION_NAME="<bastion_name>" # From terraform output
BYO_AZURE_RESOURCE_GROUP="<rg_name>"    # From terraform output
BYO_AZURE_VM_RESOURCE_ID="<vm_id>"      # From terraform output
BYO_AZURE_STORAGE_ACCOUNT_NAME="<sa>"   # From terraform output
BYO_AZURE_KEY_VAULT_URL="<kv_url>"      # From terraform output
BYO_AZURE_KEY_NAME="codemie-key"
BYO_PLATFORM_DOMAIN_NAME=""             # Optional: overrides CODEMIE_HOST

# If DEPLOY_AI_MODELS=false, supply existing endpoint:
# AZURE_OPENAI_ENDPOINT=""
# AZURE_CLIENT_ID=""
# AZURE_CLIENT_SECRET=""
```

4. Run BYO deployment:

```bash
./deploy.sh --byo
```

5. Verify:

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

## Re-deploying

To update CodeMie:

1. Edit `deployment.conf` (change `CODEMIE_VERSION`)
2. Run `./deploy.sh --byo` again — secrets are preserved automatically

## Next Steps

- [BYO VM](../byo) — Deploy on a completely external Azure VM not managed by this Terraform
